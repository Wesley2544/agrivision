// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatment_dao.dart';

// ignore_for_file: type=lint
mixin _$TreatmentDaoMixin on DatabaseAccessor<LocalDatabase> {
  $TreatmentsTable get treatments => attachedDatabase.treatments;
  TreatmentDaoManager get managers => TreatmentDaoManager(this);
}

class TreatmentDaoManager {
  final _$TreatmentDaoMixin _db;
  TreatmentDaoManager(this._db);
  $$TreatmentsTableTableManager get treatments =>
      $$TreatmentsTableTableManager(_db.attachedDatabase, _db.treatments);
}
