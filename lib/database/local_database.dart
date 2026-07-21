import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'diagnosis_dao.dart';
import 'treatment_dao.dart';

part 'local_database.g.dart';

// ══════════════════════════════════════════════════════════
// TABLE DEFINITIONS
// ══════════════════════════════════════════════════════════

/// Stores every crop diagnosis result
@DataClassName('Diagnosis')
class Diagnoses extends Table {
  IntColumn get id         => integer().autoIncrement()();
  TextColumn get crop      => text()();
  TextColumn get disease   => text()();
  RealColumn get confidence => real()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get location  => text().nullable()();
  RealColumn get latitude  => real().nullable()();
  RealColumn get longitude => real().nullable()();
  BoolColumn get isHealthy => boolean().withDefault(const Constant(false))();
  BoolColumn get isSynced  => boolean().withDefault(const Constant(false))();
  DateTimeColumn get timestamp =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Stores treatment advice per disease name
class Treatments extends Table {
  IntColumn get id          => integer().autoIncrement()();
  TextColumn get diseaseName => text()();
  TextColumn get type        => text()(); // organic | chemical | cultural
  TextColumn get description => text()();
}

/// Queue of records waiting to sync to the cloud backend
class SyncQueue extends Table {
  IntColumn get id        => integer().autoIncrement()();
  IntColumn get recordId  => integer()();
  TextColumn get tableRef => text()();
  TextColumn get status   =>
      text().withDefault(const Constant('pending'))();
  IntColumn get retries   => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ══════════════════════════════════════════════════════════
// DATABASE
// ══════════════════════════════════════════════════════════

@DriftDatabase(
  tables:  [Diagnoses, Treatments, SyncQueue],
  daos:    [DiagnosisDao, TreatmentDao],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() =>
    driftDatabase(name: 'agivision_db');