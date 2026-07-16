// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $DiagnosesTable extends Diagnoses
    with TableInfo<$DiagnosesTable, Diagnosis> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiagnosesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cropMeta = const VerificationMeta('crop');
  @override
  late final GeneratedColumn<String> crop = GeneratedColumn<String>(
    'crop',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diseaseMeta = const VerificationMeta(
    'disease',
  );
  @override
  late final GeneratedColumn<String> disease = GeneratedColumn<String>(
    'disease',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    crop,
    disease,
    confidence,
    imagePath,
    timestamp,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diagnoses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Diagnosis> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('crop')) {
      context.handle(
        _cropMeta,
        crop.isAcceptableOrUnknown(data['crop']!, _cropMeta),
      );
    } else if (isInserting) {
      context.missing(_cropMeta);
    }
    if (data.containsKey('disease')) {
      context.handle(
        _diseaseMeta,
        disease.isAcceptableOrUnknown(data['disease']!, _diseaseMeta),
      );
    } else if (isInserting) {
      context.missing(_diseaseMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Diagnosis map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Diagnosis(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      crop: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop'],
      )!,
      disease: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}disease'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $DiagnosesTable createAlias(String alias) {
    return $DiagnosesTable(attachedDatabase, alias);
  }
}

class Diagnosis extends DataClass implements Insertable<Diagnosis> {
  final int id;
  final String crop;
  final String disease;
  final double confidence;
  final String? imagePath;
  final DateTime timestamp;
  final bool isSynced;
  const Diagnosis({
    required this.id,
    required this.crop,
    required this.disease,
    required this.confidence,
    this.imagePath,
    required this.timestamp,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['crop'] = Variable<String>(crop);
    map['disease'] = Variable<String>(disease);
    map['confidence'] = Variable<double>(confidence);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  DiagnosesCompanion toCompanion(bool nullToAbsent) {
    return DiagnosesCompanion(
      id: Value(id),
      crop: Value(crop),
      disease: Value(disease),
      confidence: Value(confidence),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      timestamp: Value(timestamp),
      isSynced: Value(isSynced),
    );
  }

  factory Diagnosis.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Diagnosis(
      id: serializer.fromJson<int>(json['id']),
      crop: serializer.fromJson<String>(json['crop']),
      disease: serializer.fromJson<String>(json['disease']),
      confidence: serializer.fromJson<double>(json['confidence']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'crop': serializer.toJson<String>(crop),
      'disease': serializer.toJson<String>(disease),
      'confidence': serializer.toJson<double>(confidence),
      'imagePath': serializer.toJson<String?>(imagePath),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  Diagnosis copyWith({
    int? id,
    String? crop,
    String? disease,
    double? confidence,
    Value<String?> imagePath = const Value.absent(),
    DateTime? timestamp,
    bool? isSynced,
  }) => Diagnosis(
    id: id ?? this.id,
    crop: crop ?? this.crop,
    disease: disease ?? this.disease,
    confidence: confidence ?? this.confidence,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    timestamp: timestamp ?? this.timestamp,
    isSynced: isSynced ?? this.isSynced,
  );
  Diagnosis copyWithCompanion(DiagnosesCompanion data) {
    return Diagnosis(
      id: data.id.present ? data.id.value : this.id,
      crop: data.crop.present ? data.crop.value : this.crop,
      disease: data.disease.present ? data.disease.value : this.disease,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Diagnosis(')
          ..write('id: $id, ')
          ..write('crop: $crop, ')
          ..write('disease: $disease, ')
          ..write('confidence: $confidence, ')
          ..write('imagePath: $imagePath, ')
          ..write('timestamp: $timestamp, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    crop,
    disease,
    confidence,
    imagePath,
    timestamp,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Diagnosis &&
          other.id == this.id &&
          other.crop == this.crop &&
          other.disease == this.disease &&
          other.confidence == this.confidence &&
          other.imagePath == this.imagePath &&
          other.timestamp == this.timestamp &&
          other.isSynced == this.isSynced);
}

class DiagnosesCompanion extends UpdateCompanion<Diagnosis> {
  final Value<int> id;
  final Value<String> crop;
  final Value<String> disease;
  final Value<double> confidence;
  final Value<String?> imagePath;
  final Value<DateTime> timestamp;
  final Value<bool> isSynced;
  const DiagnosesCompanion({
    this.id = const Value.absent(),
    this.crop = const Value.absent(),
    this.disease = const Value.absent(),
    this.confidence = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  DiagnosesCompanion.insert({
    this.id = const Value.absent(),
    required String crop,
    required String disease,
    required double confidence,
    this.imagePath = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.isSynced = const Value.absent(),
  }) : crop = Value(crop),
       disease = Value(disease),
       confidence = Value(confidence);
  static Insertable<Diagnosis> custom({
    Expression<int>? id,
    Expression<String>? crop,
    Expression<String>? disease,
    Expression<double>? confidence,
    Expression<String>? imagePath,
    Expression<DateTime>? timestamp,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (crop != null) 'crop': crop,
      if (disease != null) 'disease': disease,
      if (confidence != null) 'confidence': confidence,
      if (imagePath != null) 'image_path': imagePath,
      if (timestamp != null) 'timestamp': timestamp,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  DiagnosesCompanion copyWith({
    Value<int>? id,
    Value<String>? crop,
    Value<String>? disease,
    Value<double>? confidence,
    Value<String?>? imagePath,
    Value<DateTime>? timestamp,
    Value<bool>? isSynced,
  }) {
    return DiagnosesCompanion(
      id: id ?? this.id,
      crop: crop ?? this.crop,
      disease: disease ?? this.disease,
      confidence: confidence ?? this.confidence,
      imagePath: imagePath ?? this.imagePath,
      timestamp: timestamp ?? this.timestamp,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (crop.present) {
      map['crop'] = Variable<String>(crop.value);
    }
    if (disease.present) {
      map['disease'] = Variable<String>(disease.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiagnosesCompanion(')
          ..write('id: $id, ')
          ..write('crop: $crop, ')
          ..write('disease: $disease, ')
          ..write('confidence: $confidence, ')
          ..write('imagePath: $imagePath, ')
          ..write('timestamp: $timestamp, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $TreatmentsTable extends Treatments
    with TableInfo<$TreatmentsTable, Treatment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreatmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _diseaseNameMeta = const VerificationMeta(
    'diseaseName',
  );
  @override
  late final GeneratedColumn<String> diseaseName = GeneratedColumn<String>(
    'disease_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, diseaseName, type, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'treatments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Treatment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('disease_name')) {
      context.handle(
        _diseaseNameMeta,
        diseaseName.isAcceptableOrUnknown(
          data['disease_name']!,
          _diseaseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diseaseNameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Treatment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Treatment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      diseaseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}disease_name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $TreatmentsTable createAlias(String alias) {
    return $TreatmentsTable(attachedDatabase, alias);
  }
}

class Treatment extends DataClass implements Insertable<Treatment> {
  final int id;
  final String diseaseName;
  final String type;
  final String description;
  const Treatment({
    required this.id,
    required this.diseaseName,
    required this.type,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['disease_name'] = Variable<String>(diseaseName);
    map['type'] = Variable<String>(type);
    map['description'] = Variable<String>(description);
    return map;
  }

  TreatmentsCompanion toCompanion(bool nullToAbsent) {
    return TreatmentsCompanion(
      id: Value(id),
      diseaseName: Value(diseaseName),
      type: Value(type),
      description: Value(description),
    );
  }

  factory Treatment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Treatment(
      id: serializer.fromJson<int>(json['id']),
      diseaseName: serializer.fromJson<String>(json['diseaseName']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'diseaseName': serializer.toJson<String>(diseaseName),
      'type': serializer.toJson<String>(type),
      'description': serializer.toJson<String>(description),
    };
  }

  Treatment copyWith({
    int? id,
    String? diseaseName,
    String? type,
    String? description,
  }) => Treatment(
    id: id ?? this.id,
    diseaseName: diseaseName ?? this.diseaseName,
    type: type ?? this.type,
    description: description ?? this.description,
  );
  Treatment copyWithCompanion(TreatmentsCompanion data) {
    return Treatment(
      id: data.id.present ? data.id.value : this.id,
      diseaseName: data.diseaseName.present
          ? data.diseaseName.value
          : this.diseaseName,
      type: data.type.present ? data.type.value : this.type,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Treatment(')
          ..write('id: $id, ')
          ..write('diseaseName: $diseaseName, ')
          ..write('type: $type, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, diseaseName, type, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Treatment &&
          other.id == this.id &&
          other.diseaseName == this.diseaseName &&
          other.type == this.type &&
          other.description == this.description);
}

class TreatmentsCompanion extends UpdateCompanion<Treatment> {
  final Value<int> id;
  final Value<String> diseaseName;
  final Value<String> type;
  final Value<String> description;
  const TreatmentsCompanion({
    this.id = const Value.absent(),
    this.diseaseName = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
  });
  TreatmentsCompanion.insert({
    this.id = const Value.absent(),
    required String diseaseName,
    required String type,
    required String description,
  }) : diseaseName = Value(diseaseName),
       type = Value(type),
       description = Value(description);
  static Insertable<Treatment> custom({
    Expression<int>? id,
    Expression<String>? diseaseName,
    Expression<String>? type,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diseaseName != null) 'disease_name': diseaseName,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
    });
  }

  TreatmentsCompanion copyWith({
    Value<int>? id,
    Value<String>? diseaseName,
    Value<String>? type,
    Value<String>? description,
  }) {
    return TreatmentsCompanion(
      id: id ?? this.id,
      diseaseName: diseaseName ?? this.diseaseName,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (diseaseName.present) {
      map['disease_name'] = Variable<String>(diseaseName.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TreatmentsCompanion(')
          ..write('id: $id, ')
          ..write('diseaseName: $diseaseName, ')
          ..write('type: $type, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $GpsLogsTable extends GpsLogs with TableInfo<$GpsLogsTable, GpsLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GpsLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _diagnosisIdMeta = const VerificationMeta(
    'diagnosisId',
  );
  @override
  late final GeneratedColumn<int> diagnosisId = GeneratedColumn<int>(
    'diagnosis_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES diagnoses (id)',
    ),
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    diagnosisId,
    latitude,
    longitude,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gps_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<GpsLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('diagnosis_id')) {
      context.handle(
        _diagnosisIdMeta,
        diagnosisId.isAcceptableOrUnknown(
          data['diagnosis_id']!,
          _diagnosisIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diagnosisIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GpsLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GpsLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      diagnosisId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diagnosis_id'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $GpsLogsTable createAlias(String alias) {
    return $GpsLogsTable(attachedDatabase, alias);
  }
}

class GpsLog extends DataClass implements Insertable<GpsLog> {
  final int id;
  final int diagnosisId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  const GpsLog({
    required this.id,
    required this.diagnosisId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['diagnosis_id'] = Variable<int>(diagnosisId);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  GpsLogsCompanion toCompanion(bool nullToAbsent) {
    return GpsLogsCompanion(
      id: Value(id),
      diagnosisId: Value(diagnosisId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      timestamp: Value(timestamp),
    );
  }

  factory GpsLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GpsLog(
      id: serializer.fromJson<int>(json['id']),
      diagnosisId: serializer.fromJson<int>(json['diagnosisId']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'diagnosisId': serializer.toJson<int>(diagnosisId),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  GpsLog copyWith({
    int? id,
    int? diagnosisId,
    double? latitude,
    double? longitude,
    DateTime? timestamp,
  }) => GpsLog(
    id: id ?? this.id,
    diagnosisId: diagnosisId ?? this.diagnosisId,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    timestamp: timestamp ?? this.timestamp,
  );
  GpsLog copyWithCompanion(GpsLogsCompanion data) {
    return GpsLog(
      id: data.id.present ? data.id.value : this.id,
      diagnosisId: data.diagnosisId.present
          ? data.diagnosisId.value
          : this.diagnosisId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GpsLog(')
          ..write('id: $id, ')
          ..write('diagnosisId: $diagnosisId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, diagnosisId, latitude, longitude, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GpsLog &&
          other.id == this.id &&
          other.diagnosisId == this.diagnosisId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.timestamp == this.timestamp);
}

class GpsLogsCompanion extends UpdateCompanion<GpsLog> {
  final Value<int> id;
  final Value<int> diagnosisId;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<DateTime> timestamp;
  const GpsLogsCompanion({
    this.id = const Value.absent(),
    this.diagnosisId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  GpsLogsCompanion.insert({
    this.id = const Value.absent(),
    required int diagnosisId,
    required double latitude,
    required double longitude,
    this.timestamp = const Value.absent(),
  }) : diagnosisId = Value(diagnosisId),
       latitude = Value(latitude),
       longitude = Value(longitude);
  static Insertable<GpsLog> custom({
    Expression<int>? id,
    Expression<int>? diagnosisId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diagnosisId != null) 'diagnosis_id': diagnosisId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  GpsLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? diagnosisId,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<DateTime>? timestamp,
  }) {
    return GpsLogsCompanion(
      id: id ?? this.id,
      diagnosisId: diagnosisId ?? this.diagnosisId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (diagnosisId.present) {
      map['diagnosis_id'] = Variable<int>(diagnosisId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GpsLogsCompanion(')
          ..write('id: $id, ')
          ..write('diagnosisId: $diagnosisId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _table_nameMeta = const VerificationMeta(
    'table_name',
  );
  @override
  late final GeneratedColumn<String> table_name = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _retriesMeta = const VerificationMeta(
    'retries',
  );
  @override
  late final GeneratedColumn<int> retries = GeneratedColumn<int>(
    'retries',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recordId,
    table_name,
    status,
    retries,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _table_nameMeta,
        table_name.isAcceptableOrUnknown(data['table_name']!, _table_nameMeta),
      );
    } else if (isInserting) {
      context.missing(_table_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('retries')) {
      context.handle(
        _retriesMeta,
        retries.isAcceptableOrUnknown(data['retries']!, _retriesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_id'],
      )!,
      table_name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retries: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retries'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final int recordId;
  final String table_name;
  final String status;
  final int retries;
  const SyncQueueData({
    required this.id,
    required this.recordId,
    required this.table_name,
    required this.status,
    required this.retries,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_id'] = Variable<int>(recordId);
    map['table_name'] = Variable<String>(table_name);
    map['status'] = Variable<String>(status);
    map['retries'] = Variable<int>(retries);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      recordId: Value(recordId),
      table_name: Value(table_name),
      status: Value(status),
      retries: Value(retries),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      recordId: serializer.fromJson<int>(json['recordId']),
      table_name: serializer.fromJson<String>(json['table_name']),
      status: serializer.fromJson<String>(json['status']),
      retries: serializer.fromJson<int>(json['retries']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordId': serializer.toJson<int>(recordId),
      'table_name': serializer.toJson<String>(table_name),
      'status': serializer.toJson<String>(status),
      'retries': serializer.toJson<int>(retries),
    };
  }

  SyncQueueData copyWith({
    int? id,
    int? recordId,
    String? table_name,
    String? status,
    int? retries,
  }) => SyncQueueData(
    id: id ?? this.id,
    recordId: recordId ?? this.recordId,
    table_name: table_name ?? this.table_name,
    status: status ?? this.status,
    retries: retries ?? this.retries,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      table_name: data.table_name.present
          ? data.table_name.value
          : this.table_name,
      status: data.status.present ? data.status.value : this.status,
      retries: data.retries.present ? data.retries.value : this.retries,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('table_name: $table_name, ')
          ..write('status: $status, ')
          ..write('retries: $retries')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recordId, table_name, status, retries);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.table_name == this.table_name &&
          other.status == this.status &&
          other.retries == this.retries);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<int> recordId;
  final Value<String> table_name;
  final Value<String> status;
  final Value<int> retries;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.table_name = const Value.absent(),
    this.status = const Value.absent(),
    this.retries = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required int recordId,
    required String table_name,
    this.status = const Value.absent(),
    this.retries = const Value.absent(),
  }) : recordId = Value(recordId),
       table_name = Value(table_name);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<int>? recordId,
    Expression<String>? table_name,
    Expression<String>? status,
    Expression<int>? retries,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (table_name != null) 'table_name': table_name,
      if (status != null) 'status': status,
      if (retries != null) 'retries': retries,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<int>? recordId,
    Value<String>? table_name,
    Value<String>? status,
    Value<int>? retries,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      table_name: table_name ?? this.table_name,
      status: status ?? this.status,
      retries: retries ?? this.retries,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (table_name.present) {
      map['table_name'] = Variable<String>(table_name.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retries.present) {
      map['retries'] = Variable<int>(retries.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('table_name: $table_name, ')
          ..write('status: $status, ')
          ..write('retries: $retries')
          ..write(')'))
        .toString();
  }
}

class $TileCacheTable extends TileCache
    with TableInfo<$TileCacheTable, TileCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TileCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _zMeta = const VerificationMeta('z');
  @override
  late final GeneratedColumn<int> z = GeneratedColumn<int>(
    'z',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<int> x = GeneratedColumn<int>(
    'x',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<int> y = GeneratedColumn<int>(
    'y',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tileDataMeta = const VerificationMeta(
    'tileData',
  );
  @override
  late final GeneratedColumn<Uint8List> tileData = GeneratedColumn<Uint8List>(
    'tile_data',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [z, x, y, tileData];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tile_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<TileCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('z')) {
      context.handle(_zMeta, z.isAcceptableOrUnknown(data['z']!, _zMeta));
    } else if (isInserting) {
      context.missing(_zMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    if (data.containsKey('tile_data')) {
      context.handle(
        _tileDataMeta,
        tileData.isAcceptableOrUnknown(data['tile_data']!, _tileDataMeta),
      );
    } else if (isInserting) {
      context.missing(_tileDataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {z, x, y};
  @override
  TileCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TileCacheData(
      z: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}z'],
      )!,
      x: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}x'],
      )!,
      y: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}y'],
      )!,
      tileData: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}tile_data'],
      )!,
    );
  }

  @override
  $TileCacheTable createAlias(String alias) {
    return $TileCacheTable(attachedDatabase, alias);
  }
}

class TileCacheData extends DataClass implements Insertable<TileCacheData> {
  final int z;
  final int x;
  final int y;
  final Uint8List tileData;
  const TileCacheData({
    required this.z,
    required this.x,
    required this.y,
    required this.tileData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['z'] = Variable<int>(z);
    map['x'] = Variable<int>(x);
    map['y'] = Variable<int>(y);
    map['tile_data'] = Variable<Uint8List>(tileData);
    return map;
  }

  TileCacheCompanion toCompanion(bool nullToAbsent) {
    return TileCacheCompanion(
      z: Value(z),
      x: Value(x),
      y: Value(y),
      tileData: Value(tileData),
    );
  }

  factory TileCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TileCacheData(
      z: serializer.fromJson<int>(json['z']),
      x: serializer.fromJson<int>(json['x']),
      y: serializer.fromJson<int>(json['y']),
      tileData: serializer.fromJson<Uint8List>(json['tileData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'z': serializer.toJson<int>(z),
      'x': serializer.toJson<int>(x),
      'y': serializer.toJson<int>(y),
      'tileData': serializer.toJson<Uint8List>(tileData),
    };
  }

  TileCacheData copyWith({int? z, int? x, int? y, Uint8List? tileData}) =>
      TileCacheData(
        z: z ?? this.z,
        x: x ?? this.x,
        y: y ?? this.y,
        tileData: tileData ?? this.tileData,
      );
  TileCacheData copyWithCompanion(TileCacheCompanion data) {
    return TileCacheData(
      z: data.z.present ? data.z.value : this.z,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
      tileData: data.tileData.present ? data.tileData.value : this.tileData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TileCacheData(')
          ..write('z: $z, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('tileData: $tileData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(z, x, y, $driftBlobEquality.hash(tileData));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TileCacheData &&
          other.z == this.z &&
          other.x == this.x &&
          other.y == this.y &&
          $driftBlobEquality.equals(other.tileData, this.tileData));
}

class TileCacheCompanion extends UpdateCompanion<TileCacheData> {
  final Value<int> z;
  final Value<int> x;
  final Value<int> y;
  final Value<Uint8List> tileData;
  final Value<int> rowid;
  const TileCacheCompanion({
    this.z = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.tileData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TileCacheCompanion.insert({
    required int z,
    required int x,
    required int y,
    required Uint8List tileData,
    this.rowid = const Value.absent(),
  }) : z = Value(z),
       x = Value(x),
       y = Value(y),
       tileData = Value(tileData);
  static Insertable<TileCacheData> custom({
    Expression<int>? z,
    Expression<int>? x,
    Expression<int>? y,
    Expression<Uint8List>? tileData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (z != null) 'z': z,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (tileData != null) 'tile_data': tileData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TileCacheCompanion copyWith({
    Value<int>? z,
    Value<int>? x,
    Value<int>? y,
    Value<Uint8List>? tileData,
    Value<int>? rowid,
  }) {
    return TileCacheCompanion(
      z: z ?? this.z,
      x: x ?? this.x,
      y: y ?? this.y,
      tileData: tileData ?? this.tileData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (z.present) {
      map['z'] = Variable<int>(z.value);
    }
    if (x.present) {
      map['x'] = Variable<int>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<int>(y.value);
    }
    if (tileData.present) {
      map['tile_data'] = Variable<Uint8List>(tileData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TileCacheCompanion(')
          ..write('z: $z, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('tileData: $tileData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $DiagnosesTable diagnoses = $DiagnosesTable(this);
  late final $TreatmentsTable treatments = $TreatmentsTable(this);
  late final $GpsLogsTable gpsLogs = $GpsLogsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $TileCacheTable tileCache = $TileCacheTable(this);
  late final DiagnosisDao diagnosisDao = DiagnosisDao(this as LocalDatabase);
  late final TreatmentDao treatmentDao = TreatmentDao(this as LocalDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    diagnoses,
    treatments,
    gpsLogs,
    syncQueue,
    tileCache,
  ];
}

typedef $$DiagnosesTableCreateCompanionBuilder =
    DiagnosesCompanion Function({
      Value<int> id,
      required String crop,
      required String disease,
      required double confidence,
      Value<String?> imagePath,
      Value<DateTime> timestamp,
      Value<bool> isSynced,
    });
typedef $$DiagnosesTableUpdateCompanionBuilder =
    DiagnosesCompanion Function({
      Value<int> id,
      Value<String> crop,
      Value<String> disease,
      Value<double> confidence,
      Value<String?> imagePath,
      Value<DateTime> timestamp,
      Value<bool> isSynced,
    });

final class $$DiagnosesTableReferences
    extends BaseReferences<_$LocalDatabase, $DiagnosesTable, Diagnosis> {
  $$DiagnosesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GpsLogsTable, List<GpsLog>> _gpsLogsRefsTable(
    _$LocalDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.gpsLogs,
    aliasName: 'diagnoses__id__gps_logs__diagnosis_id',
  );

  $$GpsLogsTableProcessedTableManager get gpsLogsRefs {
    final manager = $$GpsLogsTableTableManager(
      $_db,
      $_db.gpsLogs,
    ).filter((f) => f.diagnosisId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gpsLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DiagnosesTableFilterComposer
    extends Composer<_$LocalDatabase, $DiagnosesTable> {
  $$DiagnosesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get crop => $composableBuilder(
    column: $table.crop,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get disease => $composableBuilder(
    column: $table.disease,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gpsLogsRefs(
    Expression<bool> Function($$GpsLogsTableFilterComposer f) f,
  ) {
    final $$GpsLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gpsLogs,
      getReferencedColumn: (t) => t.diagnosisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GpsLogsTableFilterComposer(
            $db: $db,
            $table: $db.gpsLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiagnosesTableOrderingComposer
    extends Composer<_$LocalDatabase, $DiagnosesTable> {
  $$DiagnosesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get crop => $composableBuilder(
    column: $table.crop,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get disease => $composableBuilder(
    column: $table.disease,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiagnosesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DiagnosesTable> {
  $$DiagnosesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get crop =>
      $composableBuilder(column: $table.crop, builder: (column) => column);

  GeneratedColumn<String> get disease =>
      $composableBuilder(column: $table.disease, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  Expression<T> gpsLogsRefs<T extends Object>(
    Expression<T> Function($$GpsLogsTableAnnotationComposer a) f,
  ) {
    final $$GpsLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gpsLogs,
      getReferencedColumn: (t) => t.diagnosisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GpsLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.gpsLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiagnosesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DiagnosesTable,
          Diagnosis,
          $$DiagnosesTableFilterComposer,
          $$DiagnosesTableOrderingComposer,
          $$DiagnosesTableAnnotationComposer,
          $$DiagnosesTableCreateCompanionBuilder,
          $$DiagnosesTableUpdateCompanionBuilder,
          (Diagnosis, $$DiagnosesTableReferences),
          Diagnosis,
          PrefetchHooks Function({bool gpsLogsRefs})
        > {
  $$DiagnosesTableTableManager(_$LocalDatabase db, $DiagnosesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiagnosesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiagnosesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiagnosesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> crop = const Value.absent(),
                Value<String> disease = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => DiagnosesCompanion(
                id: id,
                crop: crop,
                disease: disease,
                confidence: confidence,
                imagePath: imagePath,
                timestamp: timestamp,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String crop,
                required String disease,
                required double confidence,
                Value<String?> imagePath = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => DiagnosesCompanion.insert(
                id: id,
                crop: crop,
                disease: disease,
                confidence: confidence,
                imagePath: imagePath,
                timestamp: timestamp,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiagnosesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gpsLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (gpsLogsRefs) db.gpsLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (gpsLogsRefs)
                    await $_getPrefetchedData<
                      Diagnosis,
                      $DiagnosesTable,
                      GpsLog
                    >(
                      currentTable: table,
                      referencedTable: $$DiagnosesTableReferences
                          ._gpsLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DiagnosesTableReferences(db, table, p0).gpsLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.diagnosisId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DiagnosesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DiagnosesTable,
      Diagnosis,
      $$DiagnosesTableFilterComposer,
      $$DiagnosesTableOrderingComposer,
      $$DiagnosesTableAnnotationComposer,
      $$DiagnosesTableCreateCompanionBuilder,
      $$DiagnosesTableUpdateCompanionBuilder,
      (Diagnosis, $$DiagnosesTableReferences),
      Diagnosis,
      PrefetchHooks Function({bool gpsLogsRefs})
    >;
typedef $$TreatmentsTableCreateCompanionBuilder =
    TreatmentsCompanion Function({
      Value<int> id,
      required String diseaseName,
      required String type,
      required String description,
    });
typedef $$TreatmentsTableUpdateCompanionBuilder =
    TreatmentsCompanion Function({
      Value<int> id,
      Value<String> diseaseName,
      Value<String> type,
      Value<String> description,
    });

class $$TreatmentsTableFilterComposer
    extends Composer<_$LocalDatabase, $TreatmentsTable> {
  $$TreatmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diseaseName => $composableBuilder(
    column: $table.diseaseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TreatmentsTableOrderingComposer
    extends Composer<_$LocalDatabase, $TreatmentsTable> {
  $$TreatmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diseaseName => $composableBuilder(
    column: $table.diseaseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TreatmentsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $TreatmentsTable> {
  $$TreatmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get diseaseName => $composableBuilder(
    column: $table.diseaseName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$TreatmentsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $TreatmentsTable,
          Treatment,
          $$TreatmentsTableFilterComposer,
          $$TreatmentsTableOrderingComposer,
          $$TreatmentsTableAnnotationComposer,
          $$TreatmentsTableCreateCompanionBuilder,
          $$TreatmentsTableUpdateCompanionBuilder,
          (
            Treatment,
            BaseReferences<_$LocalDatabase, $TreatmentsTable, Treatment>,
          ),
          Treatment,
          PrefetchHooks Function()
        > {
  $$TreatmentsTableTableManager(_$LocalDatabase db, $TreatmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TreatmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TreatmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TreatmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> diseaseName = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> description = const Value.absent(),
              }) => TreatmentsCompanion(
                id: id,
                diseaseName: diseaseName,
                type: type,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String diseaseName,
                required String type,
                required String description,
              }) => TreatmentsCompanion.insert(
                id: id,
                diseaseName: diseaseName,
                type: type,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TreatmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $TreatmentsTable,
      Treatment,
      $$TreatmentsTableFilterComposer,
      $$TreatmentsTableOrderingComposer,
      $$TreatmentsTableAnnotationComposer,
      $$TreatmentsTableCreateCompanionBuilder,
      $$TreatmentsTableUpdateCompanionBuilder,
      (Treatment, BaseReferences<_$LocalDatabase, $TreatmentsTable, Treatment>),
      Treatment,
      PrefetchHooks Function()
    >;
typedef $$GpsLogsTableCreateCompanionBuilder =
    GpsLogsCompanion Function({
      Value<int> id,
      required int diagnosisId,
      required double latitude,
      required double longitude,
      Value<DateTime> timestamp,
    });
typedef $$GpsLogsTableUpdateCompanionBuilder =
    GpsLogsCompanion Function({
      Value<int> id,
      Value<int> diagnosisId,
      Value<double> latitude,
      Value<double> longitude,
      Value<DateTime> timestamp,
    });

final class $$GpsLogsTableReferences
    extends BaseReferences<_$LocalDatabase, $GpsLogsTable, GpsLog> {
  $$GpsLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DiagnosesTable _diagnosisIdTable(_$LocalDatabase db) =>
      db.diagnoses.createAlias('gps_logs__diagnosis_id__diagnoses__id');

  $$DiagnosesTableProcessedTableManager get diagnosisId {
    final $_column = $_itemColumn<int>('diagnosis_id')!;

    final manager = $$DiagnosesTableTableManager(
      $_db,
      $_db.diagnoses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diagnosisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GpsLogsTableFilterComposer
    extends Composer<_$LocalDatabase, $GpsLogsTable> {
  $$GpsLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$DiagnosesTableFilterComposer get diagnosisId {
    final $$DiagnosesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagnosisId,
      referencedTable: $db.diagnoses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableFilterComposer(
            $db: $db,
            $table: $db.diagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GpsLogsTableOrderingComposer
    extends Composer<_$LocalDatabase, $GpsLogsTable> {
  $$GpsLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$DiagnosesTableOrderingComposer get diagnosisId {
    final $$DiagnosesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagnosisId,
      referencedTable: $db.diagnoses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableOrderingComposer(
            $db: $db,
            $table: $db.diagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GpsLogsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $GpsLogsTable> {
  $$GpsLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$DiagnosesTableAnnotationComposer get diagnosisId {
    final $$DiagnosesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagnosisId,
      referencedTable: $db.diagnoses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableAnnotationComposer(
            $db: $db,
            $table: $db.diagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GpsLogsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $GpsLogsTable,
          GpsLog,
          $$GpsLogsTableFilterComposer,
          $$GpsLogsTableOrderingComposer,
          $$GpsLogsTableAnnotationComposer,
          $$GpsLogsTableCreateCompanionBuilder,
          $$GpsLogsTableUpdateCompanionBuilder,
          (GpsLog, $$GpsLogsTableReferences),
          GpsLog,
          PrefetchHooks Function({bool diagnosisId})
        > {
  $$GpsLogsTableTableManager(_$LocalDatabase db, $GpsLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GpsLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GpsLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GpsLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> diagnosisId = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => GpsLogsCompanion(
                id: id,
                diagnosisId: diagnosisId,
                latitude: latitude,
                longitude: longitude,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int diagnosisId,
                required double latitude,
                required double longitude,
                Value<DateTime> timestamp = const Value.absent(),
              }) => GpsLogsCompanion.insert(
                id: id,
                diagnosisId: diagnosisId,
                latitude: latitude,
                longitude: longitude,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GpsLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({diagnosisId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (diagnosisId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.diagnosisId,
                                referencedTable: $$GpsLogsTableReferences
                                    ._diagnosisIdTable(db),
                                referencedColumn: $$GpsLogsTableReferences
                                    ._diagnosisIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GpsLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $GpsLogsTable,
      GpsLog,
      $$GpsLogsTableFilterComposer,
      $$GpsLogsTableOrderingComposer,
      $$GpsLogsTableAnnotationComposer,
      $$GpsLogsTableCreateCompanionBuilder,
      $$GpsLogsTableUpdateCompanionBuilder,
      (GpsLog, $$GpsLogsTableReferences),
      GpsLog,
      PrefetchHooks Function({bool diagnosisId})
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required int recordId,
      required String table_name,
      Value<String> status,
      Value<int> retries,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<int> recordId,
      Value<String> table_name,
      Value<String> status,
      Value<int> retries,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$LocalDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get table_name => $composableBuilder(
    column: $table.table_name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retries => $composableBuilder(
    column: $table.retries,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$LocalDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get table_name => $composableBuilder(
    column: $table.table_name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retries => $composableBuilder(
    column: $table.retries,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$LocalDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get table_name => $composableBuilder(
    column: $table.table_name,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retries =>
      $composableBuilder(column: $table.retries, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$LocalDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$LocalDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> recordId = const Value.absent(),
                Value<String> table_name = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retries = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                recordId: recordId,
                table_name: table_name,
                status: status,
                retries: retries,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recordId,
                required String table_name,
                Value<String> status = const Value.absent(),
                Value<int> retries = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                recordId: recordId,
                table_name: table_name,
                status: status,
                retries: retries,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$LocalDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$TileCacheTableCreateCompanionBuilder =
    TileCacheCompanion Function({
      required int z,
      required int x,
      required int y,
      required Uint8List tileData,
      Value<int> rowid,
    });
typedef $$TileCacheTableUpdateCompanionBuilder =
    TileCacheCompanion Function({
      Value<int> z,
      Value<int> x,
      Value<int> y,
      Value<Uint8List> tileData,
      Value<int> rowid,
    });

class $$TileCacheTableFilterComposer
    extends Composer<_$LocalDatabase, $TileCacheTable> {
  $$TileCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get z => $composableBuilder(
    column: $table.z,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get tileData => $composableBuilder(
    column: $table.tileData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TileCacheTableOrderingComposer
    extends Composer<_$LocalDatabase, $TileCacheTable> {
  $$TileCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get z => $composableBuilder(
    column: $table.z,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get tileData => $composableBuilder(
    column: $table.tileData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TileCacheTableAnnotationComposer
    extends Composer<_$LocalDatabase, $TileCacheTable> {
  $$TileCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get z =>
      $composableBuilder(column: $table.z, builder: (column) => column);

  GeneratedColumn<int> get x =>
      $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<int> get y =>
      $composableBuilder(column: $table.y, builder: (column) => column);

  GeneratedColumn<Uint8List> get tileData =>
      $composableBuilder(column: $table.tileData, builder: (column) => column);
}

class $$TileCacheTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $TileCacheTable,
          TileCacheData,
          $$TileCacheTableFilterComposer,
          $$TileCacheTableOrderingComposer,
          $$TileCacheTableAnnotationComposer,
          $$TileCacheTableCreateCompanionBuilder,
          $$TileCacheTableUpdateCompanionBuilder,
          (
            TileCacheData,
            BaseReferences<_$LocalDatabase, $TileCacheTable, TileCacheData>,
          ),
          TileCacheData,
          PrefetchHooks Function()
        > {
  $$TileCacheTableTableManager(_$LocalDatabase db, $TileCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TileCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TileCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TileCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> z = const Value.absent(),
                Value<int> x = const Value.absent(),
                Value<int> y = const Value.absent(),
                Value<Uint8List> tileData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TileCacheCompanion(
                z: z,
                x: x,
                y: y,
                tileData: tileData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int z,
                required int x,
                required int y,
                required Uint8List tileData,
                Value<int> rowid = const Value.absent(),
              }) => TileCacheCompanion.insert(
                z: z,
                x: x,
                y: y,
                tileData: tileData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TileCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $TileCacheTable,
      TileCacheData,
      $$TileCacheTableFilterComposer,
      $$TileCacheTableOrderingComposer,
      $$TileCacheTableAnnotationComposer,
      $$TileCacheTableCreateCompanionBuilder,
      $$TileCacheTableUpdateCompanionBuilder,
      (
        TileCacheData,
        BaseReferences<_$LocalDatabase, $TileCacheTable, TileCacheData>,
      ),
      TileCacheData,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$DiagnosesTableTableManager get diagnoses =>
      $$DiagnosesTableTableManager(_db, _db.diagnoses);
  $$TreatmentsTableTableManager get treatments =>
      $$TreatmentsTableTableManager(_db, _db.treatments);
  $$GpsLogsTableTableManager get gpsLogs =>
      $$GpsLogsTableTableManager(_db, _db.gpsLogs);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$TileCacheTableTableManager get tileCache =>
      $$TileCacheTableTableManager(_db, _db.tileCache);
}
