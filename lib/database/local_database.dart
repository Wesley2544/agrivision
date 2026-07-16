import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'diagnosis_dao.dart';
import 'treatment_dao.dart';

part 'local_database.g.dart';

// ══════════════════════════════════════════════════════════
// TABLES
// ══════════════════════════════════════════════════════════

@DataClassName('Diagnosis')
class Diagnoses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get crop => text()();
  TextColumn get disease => text()();
  RealColumn get confidence => real()();
  TextColumn get imagePath => text().nullable()();
  DateTimeColumn get timestamp =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();
}

class Treatments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get diseaseName => text()();
  TextColumn get type => text()();
  TextColumn get description => text()();
}

class GpsLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get diagnosisId => integer().references(Diagnoses, #id)();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get timestamp =>
      dateTime().withDefault(currentDateAndTime)();
}

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recordId => integer()();
  TextColumn get table_name => text()();
  TextColumn get status =>
      text().withDefault(const Constant('pending'))();
  IntColumn get retries => integer().withDefault(const Constant(0))();
}

class TileCache extends Table {
  IntColumn get z => integer()();
  IntColumn get x => integer()();
  IntColumn get y => integer()();
  BlobColumn get tileData => blob()();

  @override
  Set<Column> get primaryKey => {z, x, y};
}

// ══════════════════════════════════════════════════════════
// DATABASE
// ══════════════════════════════════════════════════════════

@DriftDatabase(
  tables: [Diagnoses, Treatments, GpsLogs, SyncQueue, TileCache],
  daos: [DiagnosisDao, TreatmentDao],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'agivision_db');
}