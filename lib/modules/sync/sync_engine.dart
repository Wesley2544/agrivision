import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../config/app_constants.dart';
import '../../database/db_provider.dart';

// ── Result returned after every sync attempt ──────────────
class SyncResult {
  final bool   success;
  final String message;
  final int    synced;
  final int    failed;
  final int    pending;

  const SyncResult({
    required this.success,
    required this.message,
    required this.synced,
    required this.failed,
    required this.pending,
  });

  bool get hadActivity => synced > 0 || failed > 0;

  @override
  String toString() =>
      'SyncResult(success: $success, message: $message, '
      'synced: $synced, failed: $failed, pending: $pending)';
}

// ── Sync Engine ───────────────────────────────────────────
class SyncEngine {
  SyncEngine._();
  static final SyncEngine instance = SyncEngine._();

  String?  _authToken;
  bool     _isSyncing = false;
  DateTime? _tokenExpiry;

  bool get isSyncing => _isSyncing;

  // ── Public: attempt a sync ─────────────────────────────
  Future<SyncResult> syncNow() async {
    if (_isSyncing) {
      return const SyncResult(
        success: false,
        message: 'Sync already in progress',
        synced:  0,
        failed:  0,
        pending: 0,
      );
    }

    _isSyncing = true;

    try {
      // 1. Quick connectivity check
      final reachable = await _isBackendReachable();
      if (!reachable) {
        return const SyncResult(
          success: false,
          message: 'Backend not reachable',
          synced:  0,
          failed:  0,
          pending: 0,
        );
      }

      // 2. Authenticate
      final token = await _getValidToken();
      if (token == null) {
        return const SyncResult(
          success: false,
          message: 'Authentication failed',
          synced:  0,
          failed:  0,
          pending: 0,
        );
      }

      // 3. Get pending queue
      final pending =
          await DBProvider.db.diagnosisDao.getPendingSync();

      if (pending.isEmpty) {
        return const SyncResult(
          success: true,
          message: 'Everything is up to date',
          synced:  0,
          failed:  0,
          pending: 0,
        );
      }

      print('📡 SyncEngine: '
          '${pending.length} record(s) pending');

      // 4. Load actual diagnosis data
      final allDiagnoses =
          await DBProvider.db.diagnosisDao.getAllDiagnoses();
      final diagMap = {for (var d in allDiagnoses) d.id: d};

      // 5. Build the batch payload (max 50 at a time)
      final toSync = pending
          .take(AppConstants.maxBatchSize)
          .toList();

      final payload  = <Map<String, dynamic>>[];
      final syncIds  = <int>[];

      for (final q in toSync) {
        final diag = diagMap[q.recordId];
        if (diag == null) {
          // Record deleted locally — mark as synced to clear queue
          await DBProvider.db.diagnosisDao
              .markSynced(q.id);
          continue;
        }

        payload.add({
          'local_id':   diag.id,
          'crop':       diag.crop,
          'disease':    diag.disease,
          'confidence': diag.confidence,
          'is_healthy': diag.isHealthy,
          'location':   diag.location,
          'latitude':   diag.latitude,
          'longitude':  diag.longitude,
          'device_id':  'android-device',
        });
        syncIds.add(q.id);
      }

      if (payload.isEmpty) {
        return SyncResult(
          success: true,
          message: 'Queue cleared',
          synced:  0,
          failed:  0,
          pending: 0,
        );
      }

      // 6. POST batch to backend
      final response = await http
          .post(
            Uri.parse(
                '${AppConstants.backendUrl}'
                '/api/v1/diagnoses/batch'),
            headers: {
              'Content-Type':  'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'records': payload}),
          )
          .timeout(AppConstants.syncTimeout);

      // 7. Handle response
      if (response.statusCode == 200) {
        final data        = jsonDecode(response.body);
        final syncedCount = (data['synced'] as int?) ?? 0;
        final failedCount = (data['failed'] as int?) ?? 0;

        // Mark synced records in local DB
        for (final id in syncIds) {
          await DBProvider.db.diagnosisDao.markSynced(id);
        }

        final remainingPending =
            pending.length - syncIds.length;

        print('✅ SyncEngine: '
            '$syncedCount synced, '
            '$failedCount failed');

        return SyncResult(
          success: true,
          message:
              '$syncedCount record'
              '${syncedCount != 1 ? "s" : ""} '
              'synced to cloud',
          synced:  syncedCount,
          failed:  failedCount,
          pending: remainingPending,
        );
      } else if (response.statusCode == 401) {
        // Token may have expired — clear it and retry next time
        _authToken   = null;
        _tokenExpiry = null;
        return const SyncResult(
          success: false,
          message: 'Auth expired — will retry',
          synced:  0,
          failed:  0,
          pending: 0,
        );
      } else {
        print('❌ SyncEngine: '
            'HTTP ${response.statusCode}');
        return SyncResult(
          success: false,
          message: 'Server error: ${response.statusCode}',
          synced:  0,
          failed:  payload.length,
          pending: pending.length,
        );
      }
    } on SocketException {
      return const SyncResult(
        success: false,
        message: 'No internet connection',
        synced:  0,
        failed:  0,
        pending: 0,
      );
    } on TimeoutException {
      return const SyncResult(
        success: false,
        message: 'Server not responding — will retry',
        synced:  0,
        failed:  0,
        pending: 0,
      );
    } catch (e) {
      print('❌ SyncEngine error: $e');
      return SyncResult(
        success: false,
        message: 'Sync error: ${e.toString()}',
        synced:  0,
        failed:  0,
        pending: 0,
      );
    } finally {
      _isSyncing = false;
    }
  }

  // ── Quick backend reachability check ──────────────────
  Future<bool> _isBackendReachable() async {
    try {
      final response = await http
          .get(
            Uri.parse(
                '${AppConstants.backendUrl}/health'),
          )
          .timeout(AppConstants.connectTimeout);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ── Get a valid JWT token ──────────────────────────────
  Future<String?> _getValidToken() async {
    // Return cached token if still valid
    if (_authToken != null && _tokenExpiry != null) {
      final stillValid = _tokenExpiry!
          .isAfter(DateTime.now().add(
              const Duration(minutes: 5)));
      if (stillValid) return _authToken;
    }

    try {
      final response = await http
          .post(
            Uri.parse(
                '${AppConstants.backendUrl}'
                '/api/v1/auth/token'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(
                {'api_key': AppConstants.apiKey}),
          )
          .timeout(AppConstants.connectTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['access_token'] as String;

        // Token is valid for 24 hours — cache expiry
        _tokenExpiry = DateTime.now().add(
            const Duration(hours: 23));

        return _authToken;
      }
    } catch (_) {}
    return null;
  }

  // ── Get pending count (for UI indicators) ─────────────
  Future<int> getPendingCount() async {
    final pending =
        await DBProvider.db.diagnosisDao.getPendingSync();
    return pending.length;
  }

  // ── Clear cached auth token ────────────────────────────
  void clearToken() {
    _authToken   = null;
    _tokenExpiry = null;
  }
}