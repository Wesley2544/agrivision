// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $DiagnosesTable extends Diagnoses
    with TableInfo<$DiagnosesTable, Diagnose> {
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
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isHealthyMeta = const VerificationMeta(
    'isHealthy',
  );
  @override
  late final GeneratedColumn<bool> isHealthy = GeneratedColumn<bool>(
    'is_healthy',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_healthy" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    crop,
    disease,
    confidence,
    imagePath,
    location,
    latitude,
    longitude,
    isHealthy,
    isSynced,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diagnoses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Diagnose> instance, {
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
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('is_healthy')) {
      context.handle(
        _isHealthyMeta,
        isHealthy.isAcceptableOrUnknown(data['is_healthy']!, _isHealthyMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
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
  Diagnose map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Diagnose(
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
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      isHealthy: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_healthy'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $DiagnosesTable createAlias(String alias) {
    return $DiagnosesTable(attachedDatabase, alias);
  }
}

class Diagnose extends DataClass implements Insertable<Diagnose> {
  final int id;
  final String crop;
  final String disease;
  final double confidence;
  final String? imagePath;
  final String? location;
  final double? latitude;
  final double? longitude;
  final bool isHealthy;
  final bool isSynced;
  final DateTime timestamp;
  const Diagnose({
    required this.id,
    required this.crop,
    required this.disease,
    required this.confidence,
    this.imagePath,
    this.location,
    this.latitude,
    this.longitude,
    required this.isHealthy,
    required this.isSynced,
    required this.timestamp,
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
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['is_healthy'] = Variable<bool>(isHealthy);
    map['is_synced'] = Variable<bool>(isSynced);
    map['timestamp'] = Variable<DateTime>(timestamp);
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
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      isHealthy: Value(isHealthy),
      isSynced: Value(isSynced),
      timestamp: Value(timestamp),
    );
  }

  factory Diagnose.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Diagnose(
      id: serializer.fromJson<int>(json['id']),
      crop: serializer.fromJson<String>(json['crop']),
      disease: serializer.fromJson<String>(json['disease']),
      confidence: serializer.fromJson<double>(json['confidence']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      location: serializer.fromJson<String?>(json['location']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      isHealthy: serializer.fromJson<bool>(json['isHealthy']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
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
      'location': serializer.toJson<String?>(location),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'isHealthy': serializer.toJson<bool>(isHealthy),
      'isSynced': serializer.toJson<bool>(isSynced),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  Diagnose copyWith({
    int? id,
    String? crop,
    String? disease,
    double? confidence,
    Value<String?> imagePath = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    bool? isHealthy,
    bool? isSynced,
    DateTime? timestamp,
  }) => Diagnose(
    id: id ?? this.id,
    crop: crop ?? this.crop,
    disease: disease ?? this.disease,
    confidence: confidence ?? this.confidence,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    location: location.present ? location.value : this.location,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    isHealthy: isHealthy ?? this.isHealthy,
    isSynced: isSynced ?? this.isSynced,
    timestamp: timestamp ?? this.timestamp,
  );
  Diagnose copyWithCompanion(DiagnosesCompanion data) {
    return Diagnose(
      id: data.id.present ? data.id.value : this.id,
      crop: data.crop.present ? data.crop.value : this.crop,
      disease: data.disease.present ? data.disease.value : this.disease,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      location: data.location.present ? data.location.value : this.location,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      isHealthy: data.isHealthy.present ? data.isHealthy.value : this.isHealthy,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Diagnose(')
          ..write('id: $id, ')
          ..write('crop: $crop, ')
          ..write('disease: $disease, ')
          ..write('confidence: $confidence, ')
          ..write('imagePath: $imagePath, ')
          ..write('location: $location, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isHealthy: $isHealthy, ')
          ..write('isSynced: $isSynced, ')
          ..write('timestamp: $timestamp')
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
    location,
    latitude,
    longitude,
    isHealthy,
    isSynced,
    timestamp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Diagnose &&
          other.id == this.id &&
          other.crop == this.crop &&
          other.disease == this.disease &&
          other.confidence == this.confidence &&
          other.imagePath == this.imagePath &&
          other.location == this.location &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.isHealthy == this.isHealthy &&
          other.isSynced == this.isSynced &&
          other.timestamp == this.timestamp);
}

class DiagnosesCompanion extends UpdateCompanion<Diagnose> {
  final Value<int> id;
  final Value<String> crop;
  final Value<String> disease;
  final Value<double> confidence;
  final Value<String?> imagePath;
  final Value<String?> location;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<bool> isHealthy;
  final Value<bool> isSynced;
  final Value<DateTime> timestamp;
  const DiagnosesCompanion({
    this.id = const Value.absent(),
    this.crop = const Value.absent(),
    this.disease = const Value.absent(),
    this.confidence = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.location = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.isHealthy = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  DiagnosesCompanion.insert({
    this.id = const Value.absent(),
    required String crop,
    required String disease,
    required double confidence,
    this.imagePath = const Value.absent(),
    this.location = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.isHealthy = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.timestamp = const Value.absent(),
  }) : crop = Value(crop),
       disease = Value(disease),
       confidence = Value(confidence);
  static Insertable<Diagnose> custom({
    Expression<int>? id,
    Expression<String>? crop,
    Expression<String>? disease,
    Expression<double>? confidence,
    Expression<String>? imagePath,
    Expression<String>? location,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<bool>? isHealthy,
    Expression<bool>? isSynced,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (crop != null) 'crop': crop,
      if (disease != null) 'disease': disease,
      if (confidence != null) 'confidence': confidence,
      if (imagePath != null) 'image_path': imagePath,
      if (location != null) 'location': location,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (isHealthy != null) 'is_healthy': isHealthy,
      if (isSynced != null) 'is_synced': isSynced,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  DiagnosesCompanion copyWith({
    Value<int>? id,
    Value<String>? crop,
    Value<String>? disease,
    Value<double>? confidence,
    Value<String?>? imagePath,
    Value<String?>? location,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<bool>? isHealthy,
    Value<bool>? isSynced,
    Value<DateTime>? timestamp,
  }) {
    return DiagnosesCompanion(
      id: id ?? this.id,
      crop: crop ?? this.crop,
      disease: disease ?? this.disease,
      confidence: confidence ?? this.confidence,
      imagePath: imagePath ?? this.imagePath,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isHealthy: isHealthy ?? this.isHealthy,
      isSynced: isSynced ?? this.isSynced,
      timestamp: timestamp ?? this.timestamp,
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
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (isHealthy.present) {
      map['is_healthy'] = Variable<bool>(isHealthy.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
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
          ..write('location: $location, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isHealthy: $isHealthy, ')
          ..write('isSynced: $isSynced, ')
          ..write('timestamp: $timestamp')
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
  static const VerificationMeta _tableNameMeta = const VerificationMeta(
    'tableName',
  );
  @override
  late final GeneratedColumn<String> tableName = GeneratedColumn<String>(
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recordId,
    tableName,
    status,
    retries,
    createdAt,
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
        _tableNameMeta,
        tableName.isAcceptableOrUnknown(data['table_name']!, _tableNameMeta),
      );
    } else if (isInserting) {
      context.missing(_tableNameMeta);
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
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
      tableName: attachedDatabase.typeMapping.read(
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
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
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
  final String tableName;
  final String status;
  final int retries;
  final DateTime createdAt;
  const SyncQueueData({
    required this.id,
    required this.recordId,
    required this.tableName,
    required this.status,
    required this.retries,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_id'] = Variable<int>(recordId);
    map['table_name'] = Variable<String>(tableName);
    map['status'] = Variable<String>(status);
    map['retries'] = Variable<int>(retries);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      recordId: Value(recordId),
      tableName: Value(tableName),
      status: Value(status),
      retries: Value(retries),
      createdAt: Value(createdAt),
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
      tableName: serializer.fromJson<String>(json['tableName']),
      status: serializer.fromJson<String>(json['status']),
      retries: serializer.fromJson<int>(json['retries']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordId': serializer.toJson<int>(recordId),
      'tableName': serializer.toJson<String>(tableName),
      'status': serializer.toJson<String>(status),
      'retries': serializer.toJson<int>(retries),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueData copyWith({
    int? id,
    int? recordId,
    String? tableName,
    String? status,
    int? retries,
    DateTime? createdAt,
  }) => SyncQueueData(
    id: id ?? this.id,
    recordId: recordId ?? this.recordId,
    tableName: tableName ?? this.tableName,
    status: status ?? this.status,
    retries: retries ?? this.retries,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      tableName: data.tableName.present ? data.tableName.value : this.tableName,
      status: data.status.present ? data.status.value : this.status,
      retries: data.retries.present ? data.retries.value : this.retries,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('tableName: $tableName, ')
          ..write('status: $status, ')
          ..write('retries: $retries, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recordId, tableName, status, retries, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.tableName == this.tableName &&
          other.status == this.status &&
          other.retries == this.retries &&
          other.createdAt == this.createdAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<int> recordId;
  final Value<String> tableName;
  final Value<String> status;
  final Value<int> retries;
  final Value<DateTime> createdAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.tableName = const Value.absent(),
    this.status = const Value.absent(),
    this.retries = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required int recordId,
    required String tableName,
    this.status = const Value.absent(),
    this.retries = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : recordId = Value(recordId),
       tableName = Value(tableName);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<int>? recordId,
    Expression<String>? tableName,
    Expression<String>? status,
    Expression<int>? retries,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (tableName != null) 'table_name': tableName,
      if (status != null) 'status': status,
      if (retries != null) 'retries': retries,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<int>? recordId,
    Value<String>? tableName,
    Value<String>? status,
    Value<int>? retries,
    Value<DateTime>? createdAt,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      tableName: tableName ?? this.tableName,
      status: status ?? this.status,
      retries: retries ?? this.retries,
      createdAt: createdAt ?? this.createdAt,
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
    if (tableName.present) {
      map['table_name'] = Variable<String>(tableName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retries.present) {
      map['retries'] = Variable<int>(retries.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('tableName: $tableName, ')
          ..write('status: $status, ')
          ..write('retries: $retries, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $DiagnosesTable diagnoses = $DiagnosesTable(this);
  late final $TreatmentsTable treatments = $TreatmentsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final DiagnosisDao diagnosisDao = DiagnosisDao(this as LocalDatabase);
  late final TreatmentDao treatmentDao = TreatmentDao(this as LocalDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    diagnoses,
    treatments,
    syncQueue,
  ];
}

typedef $$DiagnosesTableCreateCompanionBuilder =
    DiagnosesCompanion Function({
      Value<int> id,
      required String crop,
      required String disease,
      required double confidence,
      Value<String?> imagePath,
      Value<String?> location,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<bool> isHealthy,
      Value<bool> isSynced,
      Value<DateTime> timestamp,
    });
typedef $$DiagnosesTableUpdateCompanionBuilder =
    DiagnosesCompanion Function({
      Value<int> id,
      Value<String> crop,
      Value<String> disease,
      Value<double> confidence,
      Value<String?> imagePath,
      Value<String?> location,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<bool> isHealthy,
      Value<bool> isSynced,
      Value<DateTime> timestamp,
    });

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

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
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

  ColumnFilters<bool> get isHealthy => $composableBuilder(
    column: $table.isHealthy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
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

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
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

  ColumnOrderings<bool> get isHealthy => $composableBuilder(
    column: $table.isHealthy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
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

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<bool> get isHealthy =>
      $composableBuilder(column: $table.isHealthy, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$DiagnosesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DiagnosesTable,
          Diagnose,
          $$DiagnosesTableFilterComposer,
          $$DiagnosesTableOrderingComposer,
          $$DiagnosesTableAnnotationComposer,
          $$DiagnosesTableCreateCompanionBuilder,
          $$DiagnosesTableUpdateCompanionBuilder,
          (
            Diagnose,
            BaseReferences<_$LocalDatabase, $DiagnosesTable, Diagnose>,
          ),
          Diagnose,
          PrefetchHooks Function()
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
                Value<String?> location = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<bool> isHealthy = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => DiagnosesCompanion(
                id: id,
                crop: crop,
                disease: disease,
                confidence: confidence,
                imagePath: imagePath,
                location: location,
                latitude: latitude,
                longitude: longitude,
                isHealthy: isHealthy,
                isSynced: isSynced,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String crop,
                required String disease,
                required double confidence,
                Value<String?> imagePath = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<bool> isHealthy = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => DiagnosesCompanion.insert(
                id: id,
                crop: crop,
                disease: disease,
                confidence: confidence,
                imagePath: imagePath,
                location: location,
                latitude: latitude,
                longitude: longitude,
                isHealthy: isHealthy,
                isSynced: isSynced,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiagnosesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DiagnosesTable,
      Diagnose,
      $$DiagnosesTableFilterComposer,
      $$DiagnosesTableOrderingComposer,
      $$DiagnosesTableAnnotationComposer,
      $$DiagnosesTableCreateCompanionBuilder,
      $$DiagnosesTableUpdateCompanionBuilder,
      (Diagnose, BaseReferences<_$LocalDatabase, $DiagnosesTable, Diagnose>),
      Diagnose,
      PrefetchHooks Function()
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
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required int recordId,
      required String tableName,
      Value<String> status,
      Value<int> retries,
      Value<DateTime> createdAt,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<int> recordId,
      Value<String> tableName,
      Value<String> status,
      Value<int> retries,
      Value<DateTime> createdAt,
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

  ColumnFilters<String> get tableName => $composableBuilder(
    column: $table.tableName,
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  ColumnOrderings<String> get tableName => $composableBuilder(
    column: $table.tableName,
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  GeneratedColumn<String> get tableName =>
      $composableBuilder(column: $table.tableName, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retries =>
      $composableBuilder(column: $table.retries, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
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
                Value<String> tableName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retries = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                recordId: recordId,
                tableName: tableName,
                status: status,
                retries: retries,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recordId,
                required String tableName,
                Value<String> status = const Value.absent(),
                Value<int> retries = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                recordId: recordId,
                tableName: tableName,
                status: status,
                retries: retries,
                createdAt: createdAt,
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

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$DiagnosesTableTableManager get diagnoses =>
      $$DiagnosesTableTableManager(_db, _db.diagnoses);
  $$TreatmentsTableTableManager get treatments =>
      $$TreatmentsTableTableManager(_db, _db.treatments);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
