import 'package:drift/drift.dart';
import 'local_database.dart';

part 'diagnosis_dao.g.dart';

@DriftAccessor(tables: [Diagnoses, GpsLogs, SyncQueue])
class DiagnosisDao extends DatabaseAccessor<LocalDatabase>
    with _$DiagnosisDaoMixin {
  DiagnosisDao(LocalDatabase db) : super(db);

  /// Saves a new diagnosis and returns its generated ID.
  Future<int> insertDiagnosis({
    required String crop,
    required String disease,
    required double confidence,
    String? imagePath,
  }) {
    return into(diagnoses).insert(
      DiagnosesCompanion.insert(
        crop: crop,
        disease: disease,
        confidence: confidence,
        imagePath: Value(imagePath),
      ),
    );
  }

  /// Returns all diagnoses, most recent first.
  Future<List<Diagnosis>> getAllDiagnoses() {
    return (select(diagnoses)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }
  Stream<List<Diagnosis>> watchAllDiagnoses() {
    return (select(diagnoses)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .watch();
  }
  /// Attaches a GPS location to a diagnosis record.
  Future<int> insertGpsLog({
    required int diagnosisId,
    required double latitude,
    required double longitude,
  }) {
    return into(gpsLogs).insert(
      GpsLogsCompanion.insert(
        diagnosisId: diagnosisId,
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  /// Adds a record to the sync queue (called whenever offline).
  Future<int> queueForSync(int diagnosisId) {
  return into(syncQueue).insert(
    SyncQueueCompanion.insert(
      recordId: diagnosisId,
      table_name: 'diagnoses',
      ),
    );
  }

  /// Returns records still waiting to be synced to the cloud.
  Future<List<SyncQueueData>> getPendingSync() {
    return (select(syncQueue)..where((t) => t.status.equals('pending')))
        .get();
  }

  /// Marks a queued record as successfully synced.
  Future<void> markSynced(int syncId) {
    return (update(syncQueue)..where((t) => t.id.equals(syncId)))
        .write(const SyncQueueCompanion(status: Value('synced')));
  }
}