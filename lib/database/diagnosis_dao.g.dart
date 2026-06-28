// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnosis_dao.dart';

// ignore_for_file: type=lint
mixin _$DiagnosisDaoMixin on DatabaseAccessor<LocalDatabase> {
  $DiagnosesTable get diagnoses => attachedDatabase.diagnoses;
  $GpsLogsTable get gpsLogs => attachedDatabase.gpsLogs;
  $SyncQueueTable get syncQueue => attachedDatabase.syncQueue;
  DiagnosisDaoManager get managers => DiagnosisDaoManager(this);
}

class DiagnosisDaoManager {
  final _$DiagnosisDaoMixin _db;
  DiagnosisDaoManager(this._db);
  $$DiagnosesTableTableManager get diagnoses =>
      $$DiagnosesTableTableManager(_db.attachedDatabase, _db.diagnoses);
  $$GpsLogsTableTableManager get gpsLogs =>
      $$GpsLogsTableTableManager(_db.attachedDatabase, _db.gpsLogs);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db.attachedDatabase, _db.syncQueue);
}
