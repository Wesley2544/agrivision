import 'package:drift/drift.dart';
import 'local_database.dart';

part 'diagnosis_dao.g.dart';

@DriftAccessor(tables: [Diagnoses, SyncQueue])
class DiagnosisDao extends DatabaseAccessor<LocalDatabase>
    with _$DiagnosisDaoMixin {
  DiagnosisDao(super.db);

  // ── Write ─────────────────────────────────────────────

  Future<int> insertDiagnosis({
    required String crop,
    required String disease,
    required double confidence,
    required bool isHealthy,
    String? imagePath,
    String? location,
    double? latitude,
    double? longitude,
  }) {
    return into(diagnoses).insert(
      DiagnosesCompanion.insert(
        crop:       crop,
        disease:    disease,
        confidence: confidence,
        isHealthy:  Value(isHealthy),
        imagePath:  Value(imagePath),
        location:   Value(location),
        latitude:   Value(latitude),
        longitude:  Value(longitude),
      ),
    );
  }

  Future<int> queueForSync(int diagnosisId) {
    return into(syncQueue).insert(
      SyncQueueCompanion.insert(
        recordId:  diagnosisId,
        tableRef: 'diagnoses',
      ),
    );
  }

  Future<void> markSynced(int syncId) {
    return (update(syncQueue)
          ..where((t) => t.id.equals(syncId)))
        .write(const SyncQueueCompanion(
            status: Value('synced')));
  }

  // ── Read ──────────────────────────────────────────────

  /// All diagnoses ordered newest first — used for one-time reads
  Future<List<Diagnosis>> getAllDiagnoses() {
    return (select(diagnoses)
          ..orderBy(
              [(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  /// Live stream — History screen rebuilds automatically
  /// whenever a new diagnosis is saved
  Stream<List<Diagnosis>> watchAllDiagnoses() {
    return (select(diagnoses)
          ..orderBy(
              [(t) => OrderingTerm.desc(t.timestamp)]))
        .watch();
  }

  /// Diagnoses that have GPS coordinates — used by Map screen
  Future<List<Diagnosis>> getDiagnosesWithGps() async {
    final all = await getAllDiagnoses();
    return all
        .where((d) =>
            d.latitude != null && d.longitude != null)
        .toList();
  }

  /// Records waiting to sync — used by SyncEngine
  Future<List<SyncQueueData>> getPendingSync() {
    return (select(syncQueue)
          ..where((t) => t.status.equals('pending')))
        .get();
  }

  // ── Stats for Home dashboard ──────────────────────────

  Future<int> getTotalCount() async {
    final all = await getAllDiagnoses();
    return all.length;
  }

  Future<int> getDiseaseCount() async {
    final all = await getAllDiagnoses();
    return all.where((d) => !d.isHealthy).length;
  }

  Future<int> getHealthyCount() async {
    final all = await getAllDiagnoses();
    return all.where((d) => d.isHealthy).length;
  }

  Future<double> getAverageConfidence() async {
    final all = await getAllDiagnoses();
    if (all.isEmpty) return 0.0;
    final total =
        all.fold<double>(0, (sum, d) => sum + d.confidence);
    return total / all.length;
  }
}