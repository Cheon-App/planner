// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this, always_specify_types, implicit_dynamic_parameter, sort_constructors_first, implicit_dynamic_map_literal, avoid_renaming_method_parameters, sort_constructors_first, lines_longer_than_80_chars
class SubjectModel extends DataClass implements Insertable<SubjectModel> {
  final String id;
  final String yearId;
  final String teacherId;
  final String name;
  final String room;
  final String iconId;
  final Color color;
  final DateTime lastUpdated;
  SubjectModel(
      {@required this.id,
      @required this.yearId,
      this.teacherId,
      @required this.name,
      this.room,
      @required this.iconId,
      @required this.color,
      @required this.lastUpdated});
  factory SubjectModel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return SubjectModel(
      id: $SubjectsTable.$converter0.mapToDart(
          uint8ListType.mapFromDatabaseResponse(data['${effectivePrefix}id'])),
      yearId: $SubjectsTable.$converter1.mapToDart(uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}year_id'])),
      teacherId: $SubjectsTable.$converter2.mapToDart(uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}teacher_id'])),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      room: stringType.mapFromDatabaseResponse(data['${effectivePrefix}room']),
      iconId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}icon_id']),
      color: $SubjectsTable.$converter3.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}color'])),
      lastUpdated: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_updated']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      final converter = $SubjectsTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id));
    }
    if (!nullToAbsent || yearId != null) {
      final converter = $SubjectsTable.$converter1;
      map['year_id'] = Variable<Uint8List>(converter.mapToSql(yearId));
    }
    if (!nullToAbsent || teacherId != null) {
      final converter = $SubjectsTable.$converter2;
      map['teacher_id'] = Variable<Uint8List>(converter.mapToSql(teacherId));
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || room != null) {
      map['room'] = Variable<String>(room);
    }
    if (!nullToAbsent || iconId != null) {
      map['icon_id'] = Variable<String>(iconId);
    }
    if (!nullToAbsent || color != null) {
      final converter = $SubjectsTable.$converter3;
      map['color'] = Variable<int>(converter.mapToSql(color));
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      yearId:
          yearId == null && nullToAbsent ? const Value.absent() : Value(yearId),
      teacherId: teacherId == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      room: room == null && nullToAbsent ? const Value.absent() : Value(room),
      iconId:
          iconId == null && nullToAbsent ? const Value.absent() : Value(iconId),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory SubjectModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SubjectModel(
      id: serializer.fromJson<String>(json['id']),
      yearId: serializer.fromJson<String>(json['yearId']),
      teacherId: serializer.fromJson<String>(json['teacherId']),
      name: serializer.fromJson<String>(json['name']),
      room: serializer.fromJson<String>(json['room']),
      iconId: serializer.fromJson<String>(json['iconId']),
      color: serializer.fromJson<Color>(json['color']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'yearId': serializer.toJson<String>(yearId),
      'teacherId': serializer.toJson<String>(teacherId),
      'name': serializer.toJson<String>(name),
      'room': serializer.toJson<String>(room),
      'iconId': serializer.toJson<String>(iconId),
      'color': serializer.toJson<Color>(color),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  SubjectModel copyWith(
          {String id,
          String yearId,
          String teacherId,
          String name,
          String room,
          String iconId,
          Color color,
          DateTime lastUpdated}) =>
      SubjectModel(
        id: id ?? this.id,
        yearId: yearId ?? this.yearId,
        teacherId: teacherId ?? this.teacherId,
        name: name ?? this.name,
        room: room ?? this.room,
        iconId: iconId ?? this.iconId,
        color: color ?? this.color,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('SubjectModel(')
          ..write('id: $id, ')
          ..write('yearId: $yearId, ')
          ..write('teacherId: $teacherId, ')
          ..write('name: $name, ')
          ..write('room: $room, ')
          ..write('iconId: $iconId, ')
          ..write('color: $color, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          yearId.hashCode,
          $mrjc(
              teacherId.hashCode,
              $mrjc(
                  name.hashCode,
                  $mrjc(
                      room.hashCode,
                      $mrjc(iconId.hashCode,
                          $mrjc(color.hashCode, lastUpdated.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is SubjectModel &&
          other.id == this.id &&
          other.yearId == this.yearId &&
          other.teacherId == this.teacherId &&
          other.name == this.name &&
          other.room == this.room &&
          other.iconId == this.iconId &&
          other.color == this.color &&
          other.lastUpdated == this.lastUpdated);
}

class SubjectsCompanion extends UpdateCompanion<SubjectModel> {
  final Value<String> id;
  final Value<String> yearId;
  final Value<String> teacherId;
  final Value<String> name;
  final Value<String> room;
  final Value<String> iconId;
  final Value<Color> color;
  final Value<DateTime> lastUpdated;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.yearId = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.name = const Value.absent(),
    this.room = const Value.absent(),
    this.iconId = const Value.absent(),
    this.color = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  SubjectsCompanion.insert({
    @required String id,
    @required String yearId,
    this.teacherId = const Value.absent(),
    @required String name,
    this.room = const Value.absent(),
    @required String iconId,
    @required Color color,
    @required DateTime lastUpdated,
  })  : id = Value(id),
        yearId = Value(yearId),
        name = Value(name),
        iconId = Value(iconId),
        color = Value(color),
        lastUpdated = Value(lastUpdated);
  static Insertable<SubjectModel> custom({
    Expression<Uint8List> id,
    Expression<Uint8List> yearId,
    Expression<Uint8List> teacherId,
    Expression<String> name,
    Expression<String> room,
    Expression<String> iconId,
    Expression<int> color,
    Expression<DateTime> lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (yearId != null) 'year_id': yearId,
      if (teacherId != null) 'teacher_id': teacherId,
      if (name != null) 'name': name,
      if (room != null) 'room': room,
      if (iconId != null) 'icon_id': iconId,
      if (color != null) 'color': color,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  SubjectsCompanion copyWith(
      {Value<String> id,
      Value<String> yearId,
      Value<String> teacherId,
      Value<String> name,
      Value<String> room,
      Value<String> iconId,
      Value<Color> color,
      Value<DateTime> lastUpdated}) {
    return SubjectsCompanion(
      id: id ?? this.id,
      yearId: yearId ?? this.yearId,
      teacherId: teacherId ?? this.teacherId,
      name: name ?? this.name,
      room: room ?? this.room,
      iconId: iconId ?? this.iconId,
      color: color ?? this.color,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $SubjectsTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id.value));
    }
    if (yearId.present) {
      final converter = $SubjectsTable.$converter1;
      map['year_id'] = Variable<Uint8List>(converter.mapToSql(yearId.value));
    }
    if (teacherId.present) {
      final converter = $SubjectsTable.$converter2;
      map['teacher_id'] =
          Variable<Uint8List>(converter.mapToSql(teacherId.value));
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (room.present) {
      map['room'] = Variable<String>(room.value);
    }
    if (iconId.present) {
      map['icon_id'] = Variable<String>(iconId.value);
    }
    if (color.present) {
      final converter = $SubjectsTable.$converter3;
      map['color'] = Variable<int>(converter.mapToSql(color.value));
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('yearId: $yearId, ')
          ..write('teacherId: $teacherId, ')
          ..write('name: $name, ')
          ..write('room: $room, ')
          ..write('iconId: $iconId, ')
          ..write('color: $color, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $SubjectsTable extends Subjects
    with TableInfo<$SubjectsTable, SubjectModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $SubjectsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedBlobColumn _id;
  @override
  GeneratedBlobColumn get id => _id ??= _constructId();
  GeneratedBlobColumn _constructId() {
    return GeneratedBlobColumn('id', $tableName, false,
        $customConstraints: 'UNIQUE NOT NULL');
  }

  final VerificationMeta _yearIdMeta = const VerificationMeta('yearId');
  GeneratedBlobColumn _yearId;
  @override
  GeneratedBlobColumn get yearId => _yearId ??= _constructYearId();
  GeneratedBlobColumn _constructYearId() {
    return GeneratedBlobColumn(
      'year_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _teacherIdMeta = const VerificationMeta('teacherId');
  GeneratedBlobColumn _teacherId;
  @override
  GeneratedBlobColumn get teacherId => _teacherId ??= _constructTeacherId();
  GeneratedBlobColumn _constructTeacherId() {
    return GeneratedBlobColumn(
      'teacher_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 70);
  }

  final VerificationMeta _roomMeta = const VerificationMeta('room');
  GeneratedTextColumn _room;
  @override
  GeneratedTextColumn get room => _room ??= _constructRoom();
  GeneratedTextColumn _constructRoom() {
    return GeneratedTextColumn(
      'room',
      $tableName,
      true,
    );
  }

  final VerificationMeta _iconIdMeta = const VerificationMeta('iconId');
  GeneratedTextColumn _iconId;
  @override
  GeneratedTextColumn get iconId => _iconId ??= _constructIconId();
  GeneratedTextColumn _constructIconId() {
    return GeneratedTextColumn(
      'icon_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _colorMeta = const VerificationMeta('color');
  GeneratedIntColumn _color;
  @override
  GeneratedIntColumn get color => _color ??= _constructColor();
  GeneratedIntColumn _constructColor() {
    return GeneratedIntColumn(
      'color',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  GeneratedDateTimeColumn _lastUpdated;
  @override
  GeneratedDateTimeColumn get lastUpdated =>
      _lastUpdated ??= _constructLastUpdated();
  GeneratedDateTimeColumn _constructLastUpdated() {
    return GeneratedDateTimeColumn(
      'last_updated',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, yearId, teacherId, name, room, iconId, color, lastUpdated];
  @override
  $SubjectsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'subjects';
  @override
  final String actualTableName = 'subjects';
  @override
  VerificationContext validateIntegrity(Insertable<SubjectModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_yearIdMeta, const VerificationResult.success());
    context.handle(_teacherIdMeta, const VerificationResult.success());
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('room')) {
      context.handle(
          _roomMeta, room.isAcceptableOrUnknown(data['room'], _roomMeta));
    }
    if (data.containsKey('icon_id')) {
      context.handle(_iconIdMeta,
          iconId.isAcceptableOrUnknown(data['icon_id'], _iconIdMeta));
    } else if (isInserting) {
      context.missing(_iconIdMeta);
    }
    context.handle(_colorMeta, const VerificationResult.success());
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated'], _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubjectModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SubjectModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(_db, alias);
  }

  static TypeConverter<String, Uint8List> $converter0 = const UUIDConverter();
  static TypeConverter<String, Uint8List> $converter1 = const UUIDConverter();
  static TypeConverter<String, Uint8List> $converter2 = const UUIDConverter();
  static TypeConverter<Color, int> $converter3 = const ColorConverter();
}

class TeacherModel extends DataClass implements Insertable<TeacherModel> {
  final String id;
  final String yearId;
  final String name;
  final String email;
  final DateTime lastUpdated;
  TeacherModel(
      {@required this.id,
      @required this.yearId,
      @required this.name,
      this.email,
      @required this.lastUpdated});
  factory TeacherModel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return TeacherModel(
      id: $TeachersTable.$converter0.mapToDart(
          uint8ListType.mapFromDatabaseResponse(data['${effectivePrefix}id'])),
      yearId: $TeachersTable.$converter1.mapToDart(uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}year_id'])),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      email:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}email']),
      lastUpdated: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_updated']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      final converter = $TeachersTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id));
    }
    if (!nullToAbsent || yearId != null) {
      final converter = $TeachersTable.$converter1;
      map['year_id'] = Variable<Uint8List>(converter.mapToSql(yearId));
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  TeachersCompanion toCompanion(bool nullToAbsent) {
    return TeachersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      yearId:
          yearId == null && nullToAbsent ? const Value.absent() : Value(yearId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory TeacherModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TeacherModel(
      id: serializer.fromJson<String>(json['id']),
      yearId: serializer.fromJson<String>(json['yearId']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'yearId': serializer.toJson<String>(yearId),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  TeacherModel copyWith(
          {String id,
          String yearId,
          String name,
          String email,
          DateTime lastUpdated}) =>
      TeacherModel(
        id: id ?? this.id,
        yearId: yearId ?? this.yearId,
        name: name ?? this.name,
        email: email ?? this.email,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('TeacherModel(')
          ..write('id: $id, ')
          ..write('yearId: $yearId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(yearId.hashCode,
          $mrjc(name.hashCode, $mrjc(email.hashCode, lastUpdated.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is TeacherModel &&
          other.id == this.id &&
          other.yearId == this.yearId &&
          other.name == this.name &&
          other.email == this.email &&
          other.lastUpdated == this.lastUpdated);
}

class TeachersCompanion extends UpdateCompanion<TeacherModel> {
  final Value<String> id;
  final Value<String> yearId;
  final Value<String> name;
  final Value<String> email;
  final Value<DateTime> lastUpdated;
  const TeachersCompanion({
    this.id = const Value.absent(),
    this.yearId = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  TeachersCompanion.insert({
    @required String id,
    @required String yearId,
    @required String name,
    this.email = const Value.absent(),
    @required DateTime lastUpdated,
  })  : id = Value(id),
        yearId = Value(yearId),
        name = Value(name),
        lastUpdated = Value(lastUpdated);
  static Insertable<TeacherModel> custom({
    Expression<Uint8List> id,
    Expression<Uint8List> yearId,
    Expression<String> name,
    Expression<String> email,
    Expression<DateTime> lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (yearId != null) 'year_id': yearId,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  TeachersCompanion copyWith(
      {Value<String> id,
      Value<String> yearId,
      Value<String> name,
      Value<String> email,
      Value<DateTime> lastUpdated}) {
    return TeachersCompanion(
      id: id ?? this.id,
      yearId: yearId ?? this.yearId,
      name: name ?? this.name,
      email: email ?? this.email,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $TeachersTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id.value));
    }
    if (yearId.present) {
      final converter = $TeachersTable.$converter1;
      map['year_id'] = Variable<Uint8List>(converter.mapToSql(yearId.value));
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeachersCompanion(')
          ..write('id: $id, ')
          ..write('yearId: $yearId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $TeachersTable extends Teachers
    with TableInfo<$TeachersTable, TeacherModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $TeachersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedBlobColumn _id;
  @override
  GeneratedBlobColumn get id => _id ??= _constructId();
  GeneratedBlobColumn _constructId() {
    return GeneratedBlobColumn('id', $tableName, false,
        $customConstraints: 'UNIQUE NOT NULL');
  }

  final VerificationMeta _yearIdMeta = const VerificationMeta('yearId');
  GeneratedBlobColumn _yearId;
  @override
  GeneratedBlobColumn get yearId => _yearId ??= _constructYearId();
  GeneratedBlobColumn _constructYearId() {
    return GeneratedBlobColumn(
      'year_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _emailMeta = const VerificationMeta('email');
  GeneratedTextColumn _email;
  @override
  GeneratedTextColumn get email => _email ??= _constructEmail();
  GeneratedTextColumn _constructEmail() {
    return GeneratedTextColumn(
      'email',
      $tableName,
      true,
    );
  }

  final VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  GeneratedDateTimeColumn _lastUpdated;
  @override
  GeneratedDateTimeColumn get lastUpdated =>
      _lastUpdated ??= _constructLastUpdated();
  GeneratedDateTimeColumn _constructLastUpdated() {
    return GeneratedDateTimeColumn(
      'last_updated',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, yearId, name, email, lastUpdated];
  @override
  $TeachersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'teachers';
  @override
  final String actualTableName = 'teachers';
  @override
  VerificationContext validateIntegrity(Insertable<TeacherModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_yearIdMeta, const VerificationResult.success());
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email'], _emailMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated'], _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TeacherModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return TeacherModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TeachersTable createAlias(String alias) {
    return $TeachersTable(_db, alias);
  }

  static TypeConverter<String, Uint8List> $converter0 = const UUIDConverter();
  static TypeConverter<String, Uint8List> $converter1 = const UUIDConverter();
}

class ExamModel extends DataClass implements Insertable<ExamModel> {
  final String id;
  final String subjectId;
  final String title;
  final String location;
  final String seat;
  final DateTime start;
  final DateTime end;
  final int priority;
  final DateTime lastUpdated;
  ExamModel(
      {@required this.id,
      @required this.subjectId,
      @required this.title,
      this.location,
      this.seat,
      @required this.start,
      @required this.end,
      @required this.priority,
      @required this.lastUpdated});
  factory ExamModel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final intType = db.typeSystem.forDartType<int>();
    return ExamModel(
      id: $ExamsTable.$converter0.mapToDart(
          uint8ListType.mapFromDatabaseResponse(data['${effectivePrefix}id'])),
      subjectId: $ExamsTable.$converter1.mapToDart(uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}subject_id'])),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      location: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}location']),
      seat: stringType.mapFromDatabaseResponse(data['${effectivePrefix}seat']),
      start:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}start']),
      end: dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}end']),
      priority:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}priority']),
      lastUpdated: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_updated']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      final converter = $ExamsTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id));
    }
    if (!nullToAbsent || subjectId != null) {
      final converter = $ExamsTable.$converter1;
      map['subject_id'] = Variable<Uint8List>(converter.mapToSql(subjectId));
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || seat != null) {
      map['seat'] = Variable<String>(seat);
    }
    if (!nullToAbsent || start != null) {
      map['start'] = Variable<DateTime>(start);
    }
    if (!nullToAbsent || end != null) {
      map['end'] = Variable<DateTime>(end);
    }
    if (!nullToAbsent || priority != null) {
      map['priority'] = Variable<int>(priority);
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  ExamsCompanion toCompanion(bool nullToAbsent) {
    return ExamsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      seat: seat == null && nullToAbsent ? const Value.absent() : Value(seat),
      start:
          start == null && nullToAbsent ? const Value.absent() : Value(start),
      end: end == null && nullToAbsent ? const Value.absent() : Value(end),
      priority: priority == null && nullToAbsent
          ? const Value.absent()
          : Value(priority),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory ExamModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ExamModel(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      title: serializer.fromJson<String>(json['title']),
      location: serializer.fromJson<String>(json['location']),
      seat: serializer.fromJson<String>(json['seat']),
      start: serializer.fromJson<DateTime>(json['start']),
      end: serializer.fromJson<DateTime>(json['end']),
      priority: serializer.fromJson<int>(json['priority']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'title': serializer.toJson<String>(title),
      'location': serializer.toJson<String>(location),
      'seat': serializer.toJson<String>(seat),
      'start': serializer.toJson<DateTime>(start),
      'end': serializer.toJson<DateTime>(end),
      'priority': serializer.toJson<int>(priority),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  ExamModel copyWith(
          {String id,
          String subjectId,
          String title,
          String location,
          String seat,
          DateTime start,
          DateTime end,
          int priority,
          DateTime lastUpdated}) =>
      ExamModel(
        id: id ?? this.id,
        subjectId: subjectId ?? this.subjectId,
        title: title ?? this.title,
        location: location ?? this.location,
        seat: seat ?? this.seat,
        start: start ?? this.start,
        end: end ?? this.end,
        priority: priority ?? this.priority,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('ExamModel(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('location: $location, ')
          ..write('seat: $seat, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('priority: $priority, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          subjectId.hashCode,
          $mrjc(
              title.hashCode,
              $mrjc(
                  location.hashCode,
                  $mrjc(
                      seat.hashCode,
                      $mrjc(
                          start.hashCode,
                          $mrjc(
                              end.hashCode,
                              $mrjc(priority.hashCode,
                                  lastUpdated.hashCode)))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ExamModel &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.title == this.title &&
          other.location == this.location &&
          other.seat == this.seat &&
          other.start == this.start &&
          other.end == this.end &&
          other.priority == this.priority &&
          other.lastUpdated == this.lastUpdated);
}

class ExamsCompanion extends UpdateCompanion<ExamModel> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String> title;
  final Value<String> location;
  final Value<String> seat;
  final Value<DateTime> start;
  final Value<DateTime> end;
  final Value<int> priority;
  final Value<DateTime> lastUpdated;
  const ExamsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.title = const Value.absent(),
    this.location = const Value.absent(),
    this.seat = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.priority = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  ExamsCompanion.insert({
    @required String id,
    @required String subjectId,
    @required String title,
    this.location = const Value.absent(),
    this.seat = const Value.absent(),
    @required DateTime start,
    @required DateTime end,
    this.priority = const Value.absent(),
    @required DateTime lastUpdated,
  })  : id = Value(id),
        subjectId = Value(subjectId),
        title = Value(title),
        start = Value(start),
        end = Value(end),
        lastUpdated = Value(lastUpdated);
  static Insertable<ExamModel> custom({
    Expression<Uint8List> id,
    Expression<Uint8List> subjectId,
    Expression<String> title,
    Expression<String> location,
    Expression<String> seat,
    Expression<DateTime> start,
    Expression<DateTime> end,
    Expression<int> priority,
    Expression<DateTime> lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (title != null) 'title': title,
      if (location != null) 'location': location,
      if (seat != null) 'seat': seat,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (priority != null) 'priority': priority,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  ExamsCompanion copyWith(
      {Value<String> id,
      Value<String> subjectId,
      Value<String> title,
      Value<String> location,
      Value<String> seat,
      Value<DateTime> start,
      Value<DateTime> end,
      Value<int> priority,
      Value<DateTime> lastUpdated}) {
    return ExamsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      location: location ?? this.location,
      seat: seat ?? this.seat,
      start: start ?? this.start,
      end: end ?? this.end,
      priority: priority ?? this.priority,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $ExamsTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id.value));
    }
    if (subjectId.present) {
      final converter = $ExamsTable.$converter1;
      map['subject_id'] =
          Variable<Uint8List>(converter.mapToSql(subjectId.value));
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (seat.present) {
      map['seat'] = Variable<String>(seat.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('location: $location, ')
          ..write('seat: $seat, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('priority: $priority, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $ExamsTable extends Exams with TableInfo<$ExamsTable, ExamModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $ExamsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedBlobColumn _id;
  @override
  GeneratedBlobColumn get id => _id ??= _constructId();
  GeneratedBlobColumn _constructId() {
    return GeneratedBlobColumn('id', $tableName, false,
        $customConstraints: 'UNIQUE NOT NULL');
  }

  final VerificationMeta _subjectIdMeta = const VerificationMeta('subjectId');
  GeneratedBlobColumn _subjectId;
  @override
  GeneratedBlobColumn get subjectId => _subjectId ??= _constructSubjectId();
  GeneratedBlobColumn _constructSubjectId() {
    return GeneratedBlobColumn(
      'subject_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _locationMeta = const VerificationMeta('location');
  GeneratedTextColumn _location;
  @override
  GeneratedTextColumn get location => _location ??= _constructLocation();
  GeneratedTextColumn _constructLocation() {
    return GeneratedTextColumn(
      'location',
      $tableName,
      true,
    );
  }

  final VerificationMeta _seatMeta = const VerificationMeta('seat');
  GeneratedTextColumn _seat;
  @override
  GeneratedTextColumn get seat => _seat ??= _constructSeat();
  GeneratedTextColumn _constructSeat() {
    return GeneratedTextColumn(
      'seat',
      $tableName,
      true,
    );
  }

  final VerificationMeta _startMeta = const VerificationMeta('start');
  GeneratedDateTimeColumn _start;
  @override
  GeneratedDateTimeColumn get start => _start ??= _constructStart();
  GeneratedDateTimeColumn _constructStart() {
    return GeneratedDateTimeColumn(
      'start',
      $tableName,
      false,
    );
  }

  final VerificationMeta _endMeta = const VerificationMeta('end');
  GeneratedDateTimeColumn _end;
  @override
  GeneratedDateTimeColumn get end => _end ??= _constructEnd();
  GeneratedDateTimeColumn _constructEnd() {
    return GeneratedDateTimeColumn(
      'end',
      $tableName,
      false,
    );
  }

  final VerificationMeta _priorityMeta = const VerificationMeta('priority');
  GeneratedIntColumn _priority;
  @override
  GeneratedIntColumn get priority => _priority ??= _constructPriority();
  GeneratedIntColumn _constructPriority() {
    return GeneratedIntColumn('priority', $tableName, false,
        defaultValue: const Constant<int>(3));
  }

  final VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  GeneratedDateTimeColumn _lastUpdated;
  @override
  GeneratedDateTimeColumn get lastUpdated =>
      _lastUpdated ??= _constructLastUpdated();
  GeneratedDateTimeColumn _constructLastUpdated() {
    return GeneratedDateTimeColumn(
      'last_updated',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, subjectId, title, location, seat, start, end, priority, lastUpdated];
  @override
  $ExamsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'exams';
  @override
  final String actualTableName = 'exams';
  @override
  VerificationContext validateIntegrity(Insertable<ExamModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_subjectIdMeta, const VerificationResult.success());
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location'], _locationMeta));
    }
    if (data.containsKey('seat')) {
      context.handle(
          _seatMeta, seat.isAcceptableOrUnknown(data['seat'], _seatMeta));
    }
    if (data.containsKey('start')) {
      context.handle(
          _startMeta, start.isAcceptableOrUnknown(data['start'], _startMeta));
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
          _endMeta, end.isAcceptableOrUnknown(data['end'], _endMeta));
    } else if (isInserting) {
      context.missing(_endMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority'], _priorityMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated'], _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ExamModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ExamsTable createAlias(String alias) {
    return $ExamsTable(_db, alias);
  }

  static TypeConverter<String, Uint8List> $converter0 = const UUIDConverter();
  static TypeConverter<String, Uint8List> $converter1 = const UUIDConverter();
}

class LessonModel extends DataClass implements Insertable<LessonModel> {
  final String id;
  final String subjectId;
  final String teacherId;
  final String timetableId;
  final int period;
  final String room;
  final int weekday;
  final String note;
  final DateTime lastUpdated;
  LessonModel(
      {@required this.id,
      @required this.subjectId,
      this.teacherId,
      @required this.timetableId,
      @required this.period,
      this.room,
      @required this.weekday,
      this.note,
      @required this.lastUpdated});
  factory LessonModel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return LessonModel(
      id: $LessonsTable.$converter0.mapToDart(
          uint8ListType.mapFromDatabaseResponse(data['${effectivePrefix}id'])),
      subjectId: $LessonsTable.$converter1.mapToDart(uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}subject_id'])),
      teacherId: $LessonsTable.$converter2.mapToDart(uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}teacher_id'])),
      timetableId: $LessonsTable.$converter3.mapToDart(uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}timetable_id'])),
      period: intType.mapFromDatabaseResponse(data['${effectivePrefix}period']),
      room: stringType.mapFromDatabaseResponse(data['${effectivePrefix}room']),
      weekday:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}weekday']),
      note: stringType.mapFromDatabaseResponse(data['${effectivePrefix}note']),
      lastUpdated: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_updated']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      final converter = $LessonsTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id));
    }
    if (!nullToAbsent || subjectId != null) {
      final converter = $LessonsTable.$converter1;
      map['subject_id'] = Variable<Uint8List>(converter.mapToSql(subjectId));
    }
    if (!nullToAbsent || teacherId != null) {
      final converter = $LessonsTable.$converter2;
      map['teacher_id'] = Variable<Uint8List>(converter.mapToSql(teacherId));
    }
    if (!nullToAbsent || timetableId != null) {
      final converter = $LessonsTable.$converter3;
      map['timetable_id'] =
          Variable<Uint8List>(converter.mapToSql(timetableId));
    }
    if (!nullToAbsent || period != null) {
      map['period'] = Variable<int>(period);
    }
    if (!nullToAbsent || room != null) {
      map['room'] = Variable<String>(room);
    }
    if (!nullToAbsent || weekday != null) {
      map['weekday'] = Variable<int>(weekday);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      teacherId: teacherId == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherId),
      timetableId: timetableId == null && nullToAbsent
          ? const Value.absent()
          : Value(timetableId),
      period:
          period == null && nullToAbsent ? const Value.absent() : Value(period),
      room: room == null && nullToAbsent ? const Value.absent() : Value(room),
      weekday: weekday == null && nullToAbsent
          ? const Value.absent()
          : Value(weekday),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory LessonModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LessonModel(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      teacherId: serializer.fromJson<String>(json['teacherId']),
      timetableId: serializer.fromJson<String>(json['timetableId']),
      period: serializer.fromJson<int>(json['period']),
      room: serializer.fromJson<String>(json['room']),
      weekday: serializer.fromJson<int>(json['weekday']),
      note: serializer.fromJson<String>(json['note']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'teacherId': serializer.toJson<String>(teacherId),
      'timetableId': serializer.toJson<String>(timetableId),
      'period': serializer.toJson<int>(period),
      'room': serializer.toJson<String>(room),
      'weekday': serializer.toJson<int>(weekday),
      'note': serializer.toJson<String>(note),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  LessonModel copyWith(
          {String id,
          String subjectId,
          String teacherId,
          String timetableId,
          int period,
          String room,
          int weekday,
          String note,
          DateTime lastUpdated}) =>
      LessonModel(
        id: id ?? this.id,
        subjectId: subjectId ?? this.subjectId,
        teacherId: teacherId ?? this.teacherId,
        timetableId: timetableId ?? this.timetableId,
        period: period ?? this.period,
        room: room ?? this.room,
        weekday: weekday ?? this.weekday,
        note: note ?? this.note,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('LessonModel(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('teacherId: $teacherId, ')
          ..write('timetableId: $timetableId, ')
          ..write('period: $period, ')
          ..write('room: $room, ')
          ..write('weekday: $weekday, ')
          ..write('note: $note, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          subjectId.hashCode,
          $mrjc(
              teacherId.hashCode,
              $mrjc(
                  timetableId.hashCode,
                  $mrjc(
                      period.hashCode,
                      $mrjc(
                          room.hashCode,
                          $mrjc(
                              weekday.hashCode,
                              $mrjc(
                                  note.hashCode, lastUpdated.hashCode)))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is LessonModel &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.teacherId == this.teacherId &&
          other.timetableId == this.timetableId &&
          other.period == this.period &&
          other.room == this.room &&
          other.weekday == this.weekday &&
          other.note == this.note &&
          other.lastUpdated == this.lastUpdated);
}

class LessonsCompanion extends UpdateCompanion<LessonModel> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String> teacherId;
  final Value<String> timetableId;
  final Value<int> period;
  final Value<String> room;
  final Value<int> weekday;
  final Value<String> note;
  final Value<DateTime> lastUpdated;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.timetableId = const Value.absent(),
    this.period = const Value.absent(),
    this.room = const Value.absent(),
    this.weekday = const Value.absent(),
    this.note = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  LessonsCompanion.insert({
    @required String id,
    @required String subjectId,
    this.teacherId = const Value.absent(),
    @required String timetableId,
    @required int period,
    this.room = const Value.absent(),
    @required int weekday,
    this.note = const Value.absent(),
    @required DateTime lastUpdated,
  })  : id = Value(id),
        subjectId = Value(subjectId),
        timetableId = Value(timetableId),
        period = Value(period),
        weekday = Value(weekday),
        lastUpdated = Value(lastUpdated);
  static Insertable<LessonModel> custom({
    Expression<Uint8List> id,
    Expression<Uint8List> subjectId,
    Expression<Uint8List> teacherId,
    Expression<Uint8List> timetableId,
    Expression<int> period,
    Expression<String> room,
    Expression<int> weekday,
    Expression<String> note,
    Expression<DateTime> lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (teacherId != null) 'teacher_id': teacherId,
      if (timetableId != null) 'timetable_id': timetableId,
      if (period != null) 'period': period,
      if (room != null) 'room': room,
      if (weekday != null) 'weekday': weekday,
      if (note != null) 'note': note,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  LessonsCompanion copyWith(
      {Value<String> id,
      Value<String> subjectId,
      Value<String> teacherId,
      Value<String> timetableId,
      Value<int> period,
      Value<String> room,
      Value<int> weekday,
      Value<String> note,
      Value<DateTime> lastUpdated}) {
    return LessonsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId ?? this.teacherId,
      timetableId: timetableId ?? this.timetableId,
      period: period ?? this.period,
      room: room ?? this.room,
      weekday: weekday ?? this.weekday,
      note: note ?? this.note,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $LessonsTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id.value));
    }
    if (subjectId.present) {
      final converter = $LessonsTable.$converter1;
      map['subject_id'] =
          Variable<Uint8List>(converter.mapToSql(subjectId.value));
    }
    if (teacherId.present) {
      final converter = $LessonsTable.$converter2;
      map['teacher_id'] =
          Variable<Uint8List>(converter.mapToSql(teacherId.value));
    }
    if (timetableId.present) {
      final converter = $LessonsTable.$converter3;
      map['timetable_id'] =
          Variable<Uint8List>(converter.mapToSql(timetableId.value));
    }
    if (period.present) {
      map['period'] = Variable<int>(period.value);
    }
    if (room.present) {
      map['room'] = Variable<String>(room.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('teacherId: $teacherId, ')
          ..write('timetableId: $timetableId, ')
          ..write('period: $period, ')
          ..write('room: $room, ')
          ..write('weekday: $weekday, ')
          ..write('note: $note, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $LessonsTable extends Lessons with TableInfo<$LessonsTable, LessonModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $LessonsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedBlobColumn _id;
  @override
  GeneratedBlobColumn get id => _id ??= _constructId();
  GeneratedBlobColumn _constructId() {
    return GeneratedBlobColumn('id', $tableName, false,
        $customConstraints: 'UNIQUE NOT NULL');
  }

  final VerificationMeta _subjectIdMeta = const VerificationMeta('subjectId');
  GeneratedBlobColumn _subjectId;
  @override
  GeneratedBlobColumn get subjectId => _subjectId ??= _constructSubjectId();
  GeneratedBlobColumn _constructSubjectId() {
    return GeneratedBlobColumn(
      'subject_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _teacherIdMeta = const VerificationMeta('teacherId');
  GeneratedBlobColumn _teacherId;
  @override
  GeneratedBlobColumn get teacherId => _teacherId ??= _constructTeacherId();
  GeneratedBlobColumn _constructTeacherId() {
    return GeneratedBlobColumn(
      'teacher_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _timetableIdMeta =
      const VerificationMeta('timetableId');
  GeneratedBlobColumn _timetableId;
  @override
  GeneratedBlobColumn get timetableId =>
      _timetableId ??= _constructTimetableId();
  GeneratedBlobColumn _constructTimetableId() {
    return GeneratedBlobColumn(
      'timetable_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _periodMeta = const VerificationMeta('period');
  GeneratedIntColumn _period;
  @override
  GeneratedIntColumn get period => _period ??= _constructPeriod();
  GeneratedIntColumn _constructPeriod() {
    return GeneratedIntColumn(
      'period',
      $tableName,
      false,
    );
  }

  final VerificationMeta _roomMeta = const VerificationMeta('room');
  GeneratedTextColumn _room;
  @override
  GeneratedTextColumn get room => _room ??= _constructRoom();
  GeneratedTextColumn _constructRoom() {
    return GeneratedTextColumn(
      'room',
      $tableName,
      true,
    );
  }

  final VerificationMeta _weekdayMeta = const VerificationMeta('weekday');
  GeneratedIntColumn _weekday;
  @override
  GeneratedIntColumn get weekday => _weekday ??= _constructWeekday();
  GeneratedIntColumn _constructWeekday() {
    return GeneratedIntColumn(
      'weekday',
      $tableName,
      false,
    );
  }

  final VerificationMeta _noteMeta = const VerificationMeta('note');
  GeneratedTextColumn _note;
  @override
  GeneratedTextColumn get note => _note ??= _constructNote();
  GeneratedTextColumn _constructNote() {
    return GeneratedTextColumn(
      'note',
      $tableName,
      true,
    );
  }

  final VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  GeneratedDateTimeColumn _lastUpdated;
  @override
  GeneratedDateTimeColumn get lastUpdated =>
      _lastUpdated ??= _constructLastUpdated();
  GeneratedDateTimeColumn _constructLastUpdated() {
    return GeneratedDateTimeColumn(
      'last_updated',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        subjectId,
        teacherId,
        timetableId,
        period,
        room,
        weekday,
        note,
        lastUpdated
      ];
  @override
  $LessonsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'lessons';
  @override
  final String actualTableName = 'lessons';
  @override
  VerificationContext validateIntegrity(Insertable<LessonModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_subjectIdMeta, const VerificationResult.success());
    context.handle(_teacherIdMeta, const VerificationResult.success());
    context.handle(_timetableIdMeta, const VerificationResult.success());
    if (data.containsKey('period')) {
      context.handle(_periodMeta,
          period.isAcceptableOrUnknown(data['period'], _periodMeta));
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('room')) {
      context.handle(
          _roomMeta, room.isAcceptableOrUnknown(data['room'], _roomMeta));
    }
    if (data.containsKey('weekday')) {
      context.handle(_weekdayMeta,
          weekday.isAcceptableOrUnknown(data['weekday'], _weekdayMeta));
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note'], _noteMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated'], _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LessonModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(_db, alias);
  }

  static TypeConverter<String, Uint8List> $converter0 = const UUIDConverter();
  static TypeConverter<String, Uint8List> $converter1 = const UUIDConverter();
  static TypeConverter<String, Uint8List> $converter2 = const UUIDConverter();
  static TypeConverter<String, Uint8List> $converter3 = const UUIDConverter();
}

class TimetableModel extends DataClass implements Insertable<TimetableModel> {
  final String id;
  final String yearId;
  final int week;
  final bool saturday;
  final bool sunday;
  final DateTime lastSelected;
  final DateTime lastUpdated;
  TimetableModel(
      {@required this.id,
      @required this.yearId,
      @required this.week,
      @required this.saturday,
      @required this.sunday,
      @required this.lastSelected,
      @required this.lastUpdated});
  factory TimetableModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    final intType = db.typeSystem.forDartType<int>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return TimetableModel(
      id: $TimetablesTable.$converter0.mapToDart(
          uint8ListType.mapFromDatabaseResponse(data['${effectivePrefix}id'])),
      yearId: $TimetablesTable.$converter1.mapToDart(uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}year_id'])),
      week: intType.mapFromDatabaseResponse(data['${effectivePrefix}week']),
      saturday:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}saturday']),
      sunday:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}sunday']),
      lastSelected: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_selected']),
      lastUpdated: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_updated']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      final converter = $TimetablesTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id));
    }
    if (!nullToAbsent || yearId != null) {
      final converter = $TimetablesTable.$converter1;
      map['year_id'] = Variable<Uint8List>(converter.mapToSql(yearId));
    }
    if (!nullToAbsent || week != null) {
      map['week'] = Variable<int>(week);
    }
    if (!nullToAbsent || saturday != null) {
      map['saturday'] = Variable<bool>(saturday);
    }
    if (!nullToAbsent || sunday != null) {
      map['sunday'] = Variable<bool>(sunday);
    }
    if (!nullToAbsent || lastSelected != null) {
      map['last_selected'] = Variable<DateTime>(lastSelected);
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  TimetablesCompanion toCompanion(bool nullToAbsent) {
    return TimetablesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      yearId:
          yearId == null && nullToAbsent ? const Value.absent() : Value(yearId),
      week: week == null && nullToAbsent ? const Value.absent() : Value(week),
      saturday: saturday == null && nullToAbsent
          ? const Value.absent()
          : Value(saturday),
      sunday:
          sunday == null && nullToAbsent ? const Value.absent() : Value(sunday),
      lastSelected: lastSelected == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSelected),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory TimetableModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TimetableModel(
      id: serializer.fromJson<String>(json['id']),
      yearId: serializer.fromJson<String>(json['yearId']),
      week: serializer.fromJson<int>(json['week']),
      saturday: serializer.fromJson<bool>(json['saturday']),
      sunday: serializer.fromJson<bool>(json['sunday']),
      lastSelected: serializer.fromJson<DateTime>(json['lastSelected']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'yearId': serializer.toJson<String>(yearId),
      'week': serializer.toJson<int>(week),
      'saturday': serializer.toJson<bool>(saturday),
      'sunday': serializer.toJson<bool>(sunday),
      'lastSelected': serializer.toJson<DateTime>(lastSelected),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  TimetableModel copyWith(
          {String id,
          String yearId,
          int week,
          bool saturday,
          bool sunday,
          DateTime lastSelected,
          DateTime lastUpdated}) =>
      TimetableModel(
        id: id ?? this.id,
        yearId: yearId ?? this.yearId,
        week: week ?? this.week,
        saturday: saturday ?? this.saturday,
        sunday: sunday ?? this.sunday,
        lastSelected: lastSelected ?? this.lastSelected,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('TimetableModel(')
          ..write('id: $id, ')
          ..write('yearId: $yearId, ')
          ..write('week: $week, ')
          ..write('saturday: $saturday, ')
          ..write('sunday: $sunday, ')
          ..write('lastSelected: $lastSelected, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          yearId.hashCode,
          $mrjc(
              week.hashCode,
              $mrjc(
                  saturday.hashCode,
                  $mrjc(sunday.hashCode,
                      $mrjc(lastSelected.hashCode, lastUpdated.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is TimetableModel &&
          other.id == this.id &&
          other.yearId == this.yearId &&
          other.week == this.week &&
          other.saturday == this.saturday &&
          other.sunday == this.sunday &&
          other.lastSelected == this.lastSelected &&
          other.lastUpdated == this.lastUpdated);
}

class TimetablesCompanion extends UpdateCompanion<TimetableModel> {
  final Value<String> id;
  final Value<String> yearId;
  final Value<int> week;
  final Value<bool> saturday;
  final Value<bool> sunday;
  final Value<DateTime> lastSelected;
  final Value<DateTime> lastUpdated;
  const TimetablesCompanion({
    this.id = const Value.absent(),
    this.yearId = const Value.absent(),
    this.week = const Value.absent(),
    this.saturday = const Value.absent(),
    this.sunday = const Value.absent(),
    this.lastSelected = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  TimetablesCompanion.insert({
    @required String id,
    @required String yearId,
    @required int week,
    @required bool saturday,
    @required bool sunday,
    @required DateTime lastSelected,
    @required DateTime lastUpdated,
  })  : id = Value(id),
        yearId = Value(yearId),
        week = Value(week),
        saturday = Value(saturday),
        sunday = Value(sunday),
        lastSelected = Value(lastSelected),
        lastUpdated = Value(lastUpdated);
  static Insertable<TimetableModel> custom({
    Expression<Uint8List> id,
    Expression<Uint8List> yearId,
    Expression<int> week,
    Expression<bool> saturday,
    Expression<bool> sunday,
    Expression<DateTime> lastSelected,
    Expression<DateTime> lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (yearId != null) 'year_id': yearId,
      if (week != null) 'week': week,
      if (saturday != null) 'saturday': saturday,
      if (sunday != null) 'sunday': sunday,
      if (lastSelected != null) 'last_selected': lastSelected,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  TimetablesCompanion copyWith(
      {Value<String> id,
      Value<String> yearId,
      Value<int> week,
      Value<bool> saturday,
      Value<bool> sunday,
      Value<DateTime> lastSelected,
      Value<DateTime> lastUpdated}) {
    return TimetablesCompanion(
      id: id ?? this.id,
      yearId: yearId ?? this.yearId,
      week: week ?? this.week,
      saturday: saturday ?? this.saturday,
      sunday: sunday ?? this.sunday,
      lastSelected: lastSelected ?? this.lastSelected,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $TimetablesTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id.value));
    }
    if (yearId.present) {
      final converter = $TimetablesTable.$converter1;
      map['year_id'] = Variable<Uint8List>(converter.mapToSql(yearId.value));
    }
    if (week.present) {
      map['week'] = Variable<int>(week.value);
    }
    if (saturday.present) {
      map['saturday'] = Variable<bool>(saturday.value);
    }
    if (sunday.present) {
      map['sunday'] = Variable<bool>(sunday.value);
    }
    if (lastSelected.present) {
      map['last_selected'] = Variable<DateTime>(lastSelected.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimetablesCompanion(')
          ..write('id: $id, ')
          ..write('yearId: $yearId, ')
          ..write('week: $week, ')
          ..write('saturday: $saturday, ')
          ..write('sunday: $sunday, ')
          ..write('lastSelected: $lastSelected, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $TimetablesTable extends Timetables
    with TableInfo<$TimetablesTable, TimetableModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $TimetablesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedBlobColumn _id;
  @override
  GeneratedBlobColumn get id => _id ??= _constructId();
  GeneratedBlobColumn _constructId() {
    return GeneratedBlobColumn('id', $tableName, false,
        $customConstraints: 'UNIQUE NOT NULL');
  }

  final VerificationMeta _yearIdMeta = const VerificationMeta('yearId');
  GeneratedBlobColumn _yearId;
  @override
  GeneratedBlobColumn get yearId => _yearId ??= _constructYearId();
  GeneratedBlobColumn _constructYearId() {
    return GeneratedBlobColumn(
      'year_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _weekMeta = const VerificationMeta('week');
  GeneratedIntColumn _week;
  @override
  GeneratedIntColumn get week => _week ??= _constructWeek();
  GeneratedIntColumn _constructWeek() {
    return GeneratedIntColumn(
      'week',
      $tableName,
      false,
    );
  }

  final VerificationMeta _saturdayMeta = const VerificationMeta('saturday');
  GeneratedBoolColumn _saturday;
  @override
  GeneratedBoolColumn get saturday => _saturday ??= _constructSaturday();
  GeneratedBoolColumn _constructSaturday() {
    return GeneratedBoolColumn(
      'saturday',
      $tableName,
      false,
    );
  }

  final VerificationMeta _sundayMeta = const VerificationMeta('sunday');
  GeneratedBoolColumn _sunday;
  @override
  GeneratedBoolColumn get sunday => _sunday ??= _constructSunday();
  GeneratedBoolColumn _constructSunday() {
    return GeneratedBoolColumn(
      'sunday',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastSelectedMeta =
      const VerificationMeta('lastSelected');
  GeneratedDateTimeColumn _lastSelected;
  @override
  GeneratedDateTimeColumn get lastSelected =>
      _lastSelected ??= _constructLastSelected();
  GeneratedDateTimeColumn _constructLastSelected() {
    return GeneratedDateTimeColumn(
      'last_selected',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  GeneratedDateTimeColumn _lastUpdated;
  @override
  GeneratedDateTimeColumn get lastUpdated =>
      _lastUpdated ??= _constructLastUpdated();
  GeneratedDateTimeColumn _constructLastUpdated() {
    return GeneratedDateTimeColumn(
      'last_updated',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, yearId, week, saturday, sunday, lastSelected, lastUpdated];
  @override
  $TimetablesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'timetables';
  @override
  final String actualTableName = 'timetables';
  @override
  VerificationContext validateIntegrity(Insertable<TimetableModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_yearIdMeta, const VerificationResult.success());
    if (data.containsKey('week')) {
      context.handle(
          _weekMeta, week.isAcceptableOrUnknown(data['week'], _weekMeta));
    } else if (isInserting) {
      context.missing(_weekMeta);
    }
    if (data.containsKey('saturday')) {
      context.handle(_saturdayMeta,
          saturday.isAcceptableOrUnknown(data['saturday'], _saturdayMeta));
    } else if (isInserting) {
      context.missing(_saturdayMeta);
    }
    if (data.containsKey('sunday')) {
      context.handle(_sundayMeta,
          sunday.isAcceptableOrUnknown(data['sunday'], _sundayMeta));
    } else if (isInserting) {
      context.missing(_sundayMeta);
    }
    if (data.containsKey('last_selected')) {
      context.handle(
          _lastSelectedMeta,
          lastSelected.isAcceptableOrUnknown(
              data['last_selected'], _lastSelectedMeta));
    } else if (isInserting) {
      context.missing(_lastSelectedMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated'], _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimetableModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return TimetableModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TimetablesTable createAlias(String alias) {
    return $TimetablesTable(_db, alias);
  }

  static TypeConverter<String, Uint8List> $converter0 = const UUIDConverter();
  static TypeConverter<String, Uint8List> $converter1 = const UUIDConverter();
}

class TestModel extends DataClass implements Insertable<TestModel> {
  final String id;
  final String subjectId;
  final String lessonId;
  final String title;
  final String content;
  final DateTime date;
  final int priority;
  final DateTime lastUpdated;
  TestModel(
      {@required this.id,
      @required this.subjectId,
      this.lessonId,
      @required this.title,
      @required this.content,
      @required this.date,
      @required this.priority,
      @required this.lastUpdated});
  factory TestModel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final intType = db.typeSystem.forDartType<int>();
    return TestModel(
      id: $TestsTable.$converter0.mapToDart(
          uint8ListType.mapFromDatabaseResponse(data['${effectivePrefix}id'])),
      subjectId: $TestsTable.$converter1.mapToDart(uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}subject_id'])),
      lessonId: $TestsTable.$converter2.mapToDart(uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}lesson_id'])),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      content:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}content']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      priority:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}priority']),
      lastUpdated: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_updated']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      final converter = $TestsTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id));
    }
    if (!nullToAbsent || subjectId != null) {
      final converter = $TestsTable.$converter1;
      map['subject_id'] = Variable<Uint8List>(converter.mapToSql(subjectId));
    }
    if (!nullToAbsent || lessonId != null) {
      final converter = $TestsTable.$converter2;
      map['lesson_id'] = Variable<Uint8List>(converter.mapToSql(lessonId));
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || priority != null) {
      map['priority'] = Variable<int>(priority);
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  TestsCompanion toCompanion(bool nullToAbsent) {
    return TestsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      lessonId: lessonId == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      priority: priority == null && nullToAbsent
          ? const Value.absent()
          : Value(priority),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory TestModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TestModel(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      date: serializer.fromJson<DateTime>(json['date']),
      priority: serializer.fromJson<int>(json['priority']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'lessonId': serializer.toJson<String>(lessonId),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'date': serializer.toJson<DateTime>(date),
      'priority': serializer.toJson<int>(priority),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  TestModel copyWith(
          {String id,
          String subjectId,
          String lessonId,
          String title,
          String content,
          DateTime date,
          int priority,
          DateTime lastUpdated}) =>
      TestModel(
        id: id ?? this.id,
        subjectId: subjectId ?? this.subjectId,
        lessonId: lessonId ?? this.lessonId,
        title: title ?? this.title,
        content: content ?? this.content,
        date: date ?? this.date,
        priority: priority ?? this.priority,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('TestModel(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('lessonId: $lessonId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('date: $date, ')
          ..write('priority: $priority, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          subjectId.hashCode,
          $mrjc(
              lessonId.hashCode,
              $mrjc(
                  title.hashCode,
                  $mrjc(
                      content.hashCode,
                      $mrjc(date.hashCode,
                          $mrjc(priority.hashCode, lastUpdated.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is TestModel &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.lessonId == this.lessonId &&
          other.title == this.title &&
          other.content == this.content &&
          other.date == this.date &&
          other.priority == this.priority &&
          other.lastUpdated == this.lastUpdated);
}

class TestsCompanion extends UpdateCompanion<TestModel> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String> lessonId;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime> date;
  final Value<int> priority;
  final Value<DateTime> lastUpdated;
  const TestsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.date = const Value.absent(),
    this.priority = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  TestsCompanion.insert({
    @required String id,
    @required String subjectId,
    this.lessonId = const Value.absent(),
    @required String title,
    @required String content,
    @required DateTime date,
    this.priority = const Value.absent(),
    @required DateTime lastUpdated,
  })  : id = Value(id),
        subjectId = Value(subjectId),
        title = Value(title),
        content = Value(content),
        date = Value(date),
        lastUpdated = Value(lastUpdated);
  static Insertable<TestModel> custom({
    Expression<Uint8List> id,
    Expression<Uint8List> subjectId,
    Expression<Uint8List> lessonId,
    Expression<String> title,
    Expression<String> content,
    Expression<DateTime> date,
    Expression<int> priority,
    Expression<DateTime> lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (date != null) 'date': date,
      if (priority != null) 'priority': priority,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  TestsCompanion copyWith(
      {Value<String> id,
      Value<String> subjectId,
      Value<String> lessonId,
      Value<String> title,
      Value<String> content,
      Value<DateTime> date,
      Value<int> priority,
      Value<DateTime> lastUpdated}) {
    return TestsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      lessonId: lessonId ?? this.lessonId,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $TestsTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id.value));
    }
    if (subjectId.present) {
      final converter = $TestsTable.$converter1;
      map['subject_id'] =
          Variable<Uint8List>(converter.mapToSql(subjectId.value));
    }
    if (lessonId.present) {
      final converter = $TestsTable.$converter2;
      map['lesson_id'] =
          Variable<Uint8List>(converter.mapToSql(lessonId.value));
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('lessonId: $lessonId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('date: $date, ')
          ..write('priority: $priority, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $TestsTable extends Tests with TableInfo<$TestsTable, TestModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $TestsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedBlobColumn _id;
  @override
  GeneratedBlobColumn get id => _id ??= _constructId();
  GeneratedBlobColumn _constructId() {
    return GeneratedBlobColumn('id', $tableName, false,
        $customConstraints: 'UNIQUE NOT NULL');
  }

  final VerificationMeta _subjectIdMeta = const VerificationMeta('subjectId');
  GeneratedBlobColumn _subjectId;
  @override
  GeneratedBlobColumn get subjectId => _subjectId ??= _constructSubjectId();
  GeneratedBlobColumn _constructSubjectId() {
    return GeneratedBlobColumn(
      'subject_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lessonIdMeta = const VerificationMeta('lessonId');
  GeneratedBlobColumn _lessonId;
  @override
  GeneratedBlobColumn get lessonId => _lessonId ??= _constructLessonId();
  GeneratedBlobColumn _constructLessonId() {
    return GeneratedBlobColumn(
      'lesson_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contentMeta = const VerificationMeta('content');
  GeneratedTextColumn _content;
  @override
  GeneratedTextColumn get content => _content ??= _constructContent();
  GeneratedTextColumn _constructContent() {
    return GeneratedTextColumn(
      'content',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _priorityMeta = const VerificationMeta('priority');
  GeneratedIntColumn _priority;
  @override
  GeneratedIntColumn get priority => _priority ??= _constructPriority();
  GeneratedIntColumn _constructPriority() {
    return GeneratedIntColumn('priority', $tableName, false,
        defaultValue: const Constant<int>(3));
  }

  final VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  GeneratedDateTimeColumn _lastUpdated;
  @override
  GeneratedDateTimeColumn get lastUpdated =>
      _lastUpdated ??= _constructLastUpdated();
  GeneratedDateTimeColumn _constructLastUpdated() {
    return GeneratedDateTimeColumn(
      'last_updated',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, subjectId, lessonId, title, content, date, priority, lastUpdated];
  @override
  $TestsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'tests';
  @override
  final String actualTableName = 'tests';
  @override
  VerificationContext validateIntegrity(Insertable<TestModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_subjectIdMeta, const VerificationResult.success());
    context.handle(_lessonIdMeta, const VerificationResult.success());
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content'], _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority'], _priorityMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated'], _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TestModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return TestModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TestsTable createAlias(String alias) {
    return $TestsTable(_db, alias);
  }

  static TypeConverter<String, Uint8List> $converter0 = const UUIDConverter();
  static TypeConverter<String, Uint8List> $converter1 = const UUIDConverter();
  static TypeConverter<String, Uint8List> $converter2 = const UUIDConverter();
}

class StudyModel extends DataClass implements Insertable<StudyModel> {
  final String id;
  final String examId;
  final String testId;
  final String title;
  final DateTime start;
  final DateTime end;
  final bool completed;
  final DateTime lastUpdated;
  StudyModel(
      {@required this.id,
      this.examId,
      this.testId,
      @required this.title,
      @required this.start,
      @required this.end,
      @required this.completed,
      @required this.lastUpdated});
  factory StudyModel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return StudyModel(
      id: $StudyingTable.$converter0.mapToDart(
          uint8ListType.mapFromDatabaseResponse(data['${effectivePrefix}id'])),
      examId: $StudyingTable.$converter1.mapToDart(uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}exam_id'])),
      testId: $StudyingTable.$converter2.mapToDart(uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}test_id'])),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      start:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}start']),
      end: dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}end']),
      completed:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}completed']),
      lastUpdated: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_updated']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      final converter = $StudyingTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id));
    }
    if (!nullToAbsent || examId != null) {
      final converter = $StudyingTable.$converter1;
      map['exam_id'] = Variable<Uint8List>(converter.mapToSql(examId));
    }
    if (!nullToAbsent || testId != null) {
      final converter = $StudyingTable.$converter2;
      map['test_id'] = Variable<Uint8List>(converter.mapToSql(testId));
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || start != null) {
      map['start'] = Variable<DateTime>(start);
    }
    if (!nullToAbsent || end != null) {
      map['end'] = Variable<DateTime>(end);
    }
    if (!nullToAbsent || completed != null) {
      map['completed'] = Variable<bool>(completed);
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  StudyingCompanion toCompanion(bool nullToAbsent) {
    return StudyingCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      examId:
          examId == null && nullToAbsent ? const Value.absent() : Value(examId),
      testId:
          testId == null && nullToAbsent ? const Value.absent() : Value(testId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      start:
          start == null && nullToAbsent ? const Value.absent() : Value(start),
      end: end == null && nullToAbsent ? const Value.absent() : Value(end),
      completed: completed == null && nullToAbsent
          ? const Value.absent()
          : Value(completed),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory StudyModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return StudyModel(
      id: serializer.fromJson<String>(json['id']),
      examId: serializer.fromJson<String>(json['examId']),
      testId: serializer.fromJson<String>(json['testId']),
      title: serializer.fromJson<String>(json['title']),
      start: serializer.fromJson<DateTime>(json['start']),
      end: serializer.fromJson<DateTime>(json['end']),
      completed: serializer.fromJson<bool>(json['completed']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'examId': serializer.toJson<String>(examId),
      'testId': serializer.toJson<String>(testId),
      'title': serializer.toJson<String>(title),
      'start': serializer.toJson<DateTime>(start),
      'end': serializer.toJson<DateTime>(end),
      'completed': serializer.toJson<bool>(completed),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  StudyModel copyWith(
          {String id,
          String examId,
          String testId,
          String title,
          DateTime start,
          DateTime end,
          bool completed,
          DateTime lastUpdated}) =>
      StudyModel(
        id: id ?? this.id,
        examId: examId ?? this.examId,
        testId: testId ?? this.testId,
        title: title ?? this.title,
        start: start ?? this.start,
        end: end ?? this.end,
        completed: completed ?? this.completed,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('StudyModel(')
          ..write('id: $id, ')
          ..write('examId: $examId, ')
          ..write('testId: $testId, ')
          ..write('title: $title, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('completed: $completed, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          examId.hashCode,
          $mrjc(
              testId.hashCode,
              $mrjc(
                  title.hashCode,
                  $mrjc(
                      start.hashCode,
                      $mrjc(
                          end.hashCode,
                          $mrjc(
                              completed.hashCode, lastUpdated.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is StudyModel &&
          other.id == this.id &&
          other.examId == this.examId &&
          other.testId == this.testId &&
          other.title == this.title &&
          other.start == this.start &&
          other.end == this.end &&
          other.completed == this.completed &&
          other.lastUpdated == this.lastUpdated);
}

class StudyingCompanion extends UpdateCompanion<StudyModel> {
  final Value<String> id;
  final Value<String> examId;
  final Value<String> testId;
  final Value<String> title;
  final Value<DateTime> start;
  final Value<DateTime> end;
  final Value<bool> completed;
  final Value<DateTime> lastUpdated;
  const StudyingCompanion({
    this.id = const Value.absent(),
    this.examId = const Value.absent(),
    this.testId = const Value.absent(),
    this.title = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.completed = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  StudyingCompanion.insert({
    @required String id,
    this.examId = const Value.absent(),
    this.testId = const Value.absent(),
    @required String title,
    @required DateTime start,
    @required DateTime end,
    this.completed = const Value.absent(),
    @required DateTime lastUpdated,
  })  : id = Value(id),
        title = Value(title),
        start = Value(start),
        end = Value(end),
        lastUpdated = Value(lastUpdated);
  static Insertable<StudyModel> custom({
    Expression<Uint8List> id,
    Expression<Uint8List> examId,
    Expression<Uint8List> testId,
    Expression<String> title,
    Expression<DateTime> start,
    Expression<DateTime> end,
    Expression<bool> completed,
    Expression<DateTime> lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examId != null) 'exam_id': examId,
      if (testId != null) 'test_id': testId,
      if (title != null) 'title': title,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (completed != null) 'completed': completed,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  StudyingCompanion copyWith(
      {Value<String> id,
      Value<String> examId,
      Value<String> testId,
      Value<String> title,
      Value<DateTime> start,
      Value<DateTime> end,
      Value<bool> completed,
      Value<DateTime> lastUpdated}) {
    return StudyingCompanion(
      id: id ?? this.id,
      examId: examId ?? this.examId,
      testId: testId ?? this.testId,
      title: title ?? this.title,
      start: start ?? this.start,
      end: end ?? this.end,
      completed: completed ?? this.completed,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $StudyingTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id.value));
    }
    if (examId.present) {
      final converter = $StudyingTable.$converter1;
      map['exam_id'] = Variable<Uint8List>(converter.mapToSql(examId.value));
    }
    if (testId.present) {
      final converter = $StudyingTable.$converter2;
      map['test_id'] = Variable<Uint8List>(converter.mapToSql(testId.value));
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyingCompanion(')
          ..write('id: $id, ')
          ..write('examId: $examId, ')
          ..write('testId: $testId, ')
          ..write('title: $title, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('completed: $completed, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $StudyingTable extends Studying
    with TableInfo<$StudyingTable, StudyModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $StudyingTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedBlobColumn _id;
  @override
  GeneratedBlobColumn get id => _id ??= _constructId();
  GeneratedBlobColumn _constructId() {
    return GeneratedBlobColumn('id', $tableName, false,
        $customConstraints: 'UNIQUE NOT NULL');
  }

  final VerificationMeta _examIdMeta = const VerificationMeta('examId');
  GeneratedBlobColumn _examId;
  @override
  GeneratedBlobColumn get examId => _examId ??= _constructExamId();
  GeneratedBlobColumn _constructExamId() {
    return GeneratedBlobColumn(
      'exam_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _testIdMeta = const VerificationMeta('testId');
  GeneratedBlobColumn _testId;
  @override
  GeneratedBlobColumn get testId => _testId ??= _constructTestId();
  GeneratedBlobColumn _constructTestId() {
    return GeneratedBlobColumn(
      'test_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _startMeta = const VerificationMeta('start');
  GeneratedDateTimeColumn _start;
  @override
  GeneratedDateTimeColumn get start => _start ??= _constructStart();
  GeneratedDateTimeColumn _constructStart() {
    return GeneratedDateTimeColumn(
      'start',
      $tableName,
      false,
    );
  }

  final VerificationMeta _endMeta = const VerificationMeta('end');
  GeneratedDateTimeColumn _end;
  @override
  GeneratedDateTimeColumn get end => _end ??= _constructEnd();
  GeneratedDateTimeColumn _constructEnd() {
    return GeneratedDateTimeColumn(
      'end',
      $tableName,
      false,
    );
  }

  final VerificationMeta _completedMeta = const VerificationMeta('completed');
  GeneratedBoolColumn _completed;
  @override
  GeneratedBoolColumn get completed => _completed ??= _constructCompleted();
  GeneratedBoolColumn _constructCompleted() {
    return GeneratedBoolColumn('completed', $tableName, false,
        defaultValue: const Constant<bool>(false));
  }

  final VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  GeneratedDateTimeColumn _lastUpdated;
  @override
  GeneratedDateTimeColumn get lastUpdated =>
      _lastUpdated ??= _constructLastUpdated();
  GeneratedDateTimeColumn _constructLastUpdated() {
    return GeneratedDateTimeColumn(
      'last_updated',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, examId, testId, title, start, end, completed, lastUpdated];
  @override
  $StudyingTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'studying';
  @override
  final String actualTableName = 'studying';
  @override
  VerificationContext validateIntegrity(Insertable<StudyModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_examIdMeta, const VerificationResult.success());
    context.handle(_testIdMeta, const VerificationResult.success());
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start')) {
      context.handle(
          _startMeta, start.isAcceptableOrUnknown(data['start'], _startMeta));
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
          _endMeta, end.isAcceptableOrUnknown(data['end'], _endMeta));
    } else if (isInserting) {
      context.missing(_endMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed'], _completedMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated'], _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return StudyModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $StudyingTable createAlias(String alias) {
    return $StudyingTable(_db, alias);
  }

  static TypeConverter<String, Uint8List> $converter0 = const UUIDConverter();
  static TypeConverter<String, Uint8List> $converter1 = const UUIDConverter();
  static TypeConverter<String, Uint8List> $converter2 = const UUIDConverter();
}

class LessonTimeModel extends DataClass implements Insertable<LessonTimeModel> {
  final int period;
  final DateTime startTime;
  final DateTime lastUpdated;
  LessonTimeModel(
      {@required this.period,
      @required this.startTime,
      @required this.lastUpdated});
  factory LessonTimeModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return LessonTimeModel(
      period: intType.mapFromDatabaseResponse(data['${effectivePrefix}period']),
      startTime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}start_time']),
      lastUpdated: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_updated']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || period != null) {
      map['period'] = Variable<int>(period);
    }
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<DateTime>(startTime);
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  LessonTimesCompanion toCompanion(bool nullToAbsent) {
    return LessonTimesCompanion(
      period:
          period == null && nullToAbsent ? const Value.absent() : Value(period),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory LessonTimeModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LessonTimeModel(
      period: serializer.fromJson<int>(json['period']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'period': serializer.toJson<int>(period),
      'startTime': serializer.toJson<DateTime>(startTime),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  LessonTimeModel copyWith(
          {int period, DateTime startTime, DateTime lastUpdated}) =>
      LessonTimeModel(
        period: period ?? this.period,
        startTime: startTime ?? this.startTime,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('LessonTimeModel(')
          ..write('period: $period, ')
          ..write('startTime: $startTime, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(
      $mrjc(period.hashCode, $mrjc(startTime.hashCode, lastUpdated.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is LessonTimeModel &&
          other.period == this.period &&
          other.startTime == this.startTime &&
          other.lastUpdated == this.lastUpdated);
}

class LessonTimesCompanion extends UpdateCompanion<LessonTimeModel> {
  final Value<int> period;
  final Value<DateTime> startTime;
  final Value<DateTime> lastUpdated;
  const LessonTimesCompanion({
    this.period = const Value.absent(),
    this.startTime = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  LessonTimesCompanion.insert({
    this.period = const Value.absent(),
    @required DateTime startTime,
    @required DateTime lastUpdated,
  })  : startTime = Value(startTime),
        lastUpdated = Value(lastUpdated);
  static Insertable<LessonTimeModel> custom({
    Expression<int> period,
    Expression<DateTime> startTime,
    Expression<DateTime> lastUpdated,
  }) {
    return RawValuesInsertable({
      if (period != null) 'period': period,
      if (startTime != null) 'start_time': startTime,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  LessonTimesCompanion copyWith(
      {Value<int> period,
      Value<DateTime> startTime,
      Value<DateTime> lastUpdated}) {
    return LessonTimesCompanion(
      period: period ?? this.period,
      startTime: startTime ?? this.startTime,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (period.present) {
      map['period'] = Variable<int>(period.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonTimesCompanion(')
          ..write('period: $period, ')
          ..write('startTime: $startTime, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $LessonTimesTable extends LessonTimes
    with TableInfo<$LessonTimesTable, LessonTimeModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $LessonTimesTable(this._db, [this._alias]);
  final VerificationMeta _periodMeta = const VerificationMeta('period');
  GeneratedIntColumn _period;
  @override
  GeneratedIntColumn get period => _period ??= _constructPeriod();
  GeneratedIntColumn _constructPeriod() {
    return GeneratedIntColumn('period', $tableName, false,
        $customConstraints: 'UNIQUE NOT NULL');
  }

  final VerificationMeta _startTimeMeta = const VerificationMeta('startTime');
  GeneratedDateTimeColumn _startTime;
  @override
  GeneratedDateTimeColumn get startTime => _startTime ??= _constructStartTime();
  GeneratedDateTimeColumn _constructStartTime() {
    return GeneratedDateTimeColumn(
      'start_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  GeneratedDateTimeColumn _lastUpdated;
  @override
  GeneratedDateTimeColumn get lastUpdated =>
      _lastUpdated ??= _constructLastUpdated();
  GeneratedDateTimeColumn _constructLastUpdated() {
    return GeneratedDateTimeColumn(
      'last_updated',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [period, startTime, lastUpdated];
  @override
  $LessonTimesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'lesson_times';
  @override
  final String actualTableName = 'lesson_times';
  @override
  VerificationContext validateIntegrity(Insertable<LessonTimeModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('period')) {
      context.handle(_periodMeta,
          period.isAcceptableOrUnknown(data['period'], _periodMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time'], _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated'], _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {period};
  @override
  LessonTimeModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LessonTimeModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $LessonTimesTable createAlias(String alias) {
    return $LessonTimesTable(_db, alias);
  }
}

class TaskModel extends DataClass implements Insertable<TaskModel> {
  final String id;
  final String subjectId;
  final String title;
  final String description;
  final DateTime due;
  final bool completed;
  final DateTime lastUpdated;
  TaskModel(
      {@required this.id,
      this.subjectId,
      @required this.title,
      @required this.description,
      @required this.due,
      @required this.completed,
      @required this.lastUpdated});
  factory TaskModel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return TaskModel(
      id: $TasksTable.$converter0.mapToDart(
          uint8ListType.mapFromDatabaseResponse(data['${effectivePrefix}id'])),
      subjectId: $TasksTable.$converter1.mapToDart(uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}subject_id'])),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      due: dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}due']),
      completed:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}completed']),
      lastUpdated: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_updated']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      final converter = $TasksTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id));
    }
    if (!nullToAbsent || subjectId != null) {
      final converter = $TasksTable.$converter1;
      map['subject_id'] = Variable<Uint8List>(converter.mapToSql(subjectId));
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || due != null) {
      map['due'] = Variable<DateTime>(due);
    }
    if (!nullToAbsent || completed != null) {
      map['completed'] = Variable<bool>(completed);
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      due: due == null && nullToAbsent ? const Value.absent() : Value(due),
      completed: completed == null && nullToAbsent
          ? const Value.absent()
          : Value(completed),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TaskModel(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      due: serializer.fromJson<DateTime>(json['due']),
      completed: serializer.fromJson<bool>(json['completed']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'due': serializer.toJson<DateTime>(due),
      'completed': serializer.toJson<bool>(completed),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  TaskModel copyWith(
          {String id,
          String subjectId,
          String title,
          String description,
          DateTime due,
          bool completed,
          DateTime lastUpdated}) =>
      TaskModel(
        id: id ?? this.id,
        subjectId: subjectId ?? this.subjectId,
        title: title ?? this.title,
        description: description ?? this.description,
        due: due ?? this.due,
        completed: completed ?? this.completed,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('TaskModel(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('due: $due, ')
          ..write('completed: $completed, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          subjectId.hashCode,
          $mrjc(
              title.hashCode,
              $mrjc(
                  description.hashCode,
                  $mrjc(due.hashCode,
                      $mrjc(completed.hashCode, lastUpdated.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is TaskModel &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.title == this.title &&
          other.description == this.description &&
          other.due == this.due &&
          other.completed == this.completed &&
          other.lastUpdated == this.lastUpdated);
}

class TasksCompanion extends UpdateCompanion<TaskModel> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String> title;
  final Value<String> description;
  final Value<DateTime> due;
  final Value<bool> completed;
  final Value<DateTime> lastUpdated;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.due = const Value.absent(),
    this.completed = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  TasksCompanion.insert({
    @required String id,
    this.subjectId = const Value.absent(),
    @required String title,
    @required String description,
    @required DateTime due,
    @required bool completed,
    @required DateTime lastUpdated,
  })  : id = Value(id),
        title = Value(title),
        description = Value(description),
        due = Value(due),
        completed = Value(completed),
        lastUpdated = Value(lastUpdated);
  static Insertable<TaskModel> custom({
    Expression<Uint8List> id,
    Expression<Uint8List> subjectId,
    Expression<String> title,
    Expression<String> description,
    Expression<DateTime> due,
    Expression<bool> completed,
    Expression<DateTime> lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (due != null) 'due': due,
      if (completed != null) 'completed': completed,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  TasksCompanion copyWith(
      {Value<String> id,
      Value<String> subjectId,
      Value<String> title,
      Value<String> description,
      Value<DateTime> due,
      Value<bool> completed,
      Value<DateTime> lastUpdated}) {
    return TasksCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      description: description ?? this.description,
      due: due ?? this.due,
      completed: completed ?? this.completed,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $TasksTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id.value));
    }
    if (subjectId.present) {
      final converter = $TasksTable.$converter1;
      map['subject_id'] =
          Variable<Uint8List>(converter.mapToSql(subjectId.value));
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (due.present) {
      map['due'] = Variable<DateTime>(due.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('due: $due, ')
          ..write('completed: $completed, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $TasksTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedBlobColumn _id;
  @override
  GeneratedBlobColumn get id => _id ??= _constructId();
  GeneratedBlobColumn _constructId() {
    return GeneratedBlobColumn('id', $tableName, false,
        $customConstraints: 'UNIQUE NOT NULL');
  }

  final VerificationMeta _subjectIdMeta = const VerificationMeta('subjectId');
  GeneratedBlobColumn _subjectId;
  @override
  GeneratedBlobColumn get subjectId => _subjectId ??= _constructSubjectId();
  GeneratedBlobColumn _constructSubjectId() {
    return GeneratedBlobColumn(
      'subject_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dueMeta = const VerificationMeta('due');
  GeneratedDateTimeColumn _due;
  @override
  GeneratedDateTimeColumn get due => _due ??= _constructDue();
  GeneratedDateTimeColumn _constructDue() {
    return GeneratedDateTimeColumn(
      'due',
      $tableName,
      false,
    );
  }

  final VerificationMeta _completedMeta = const VerificationMeta('completed');
  GeneratedBoolColumn _completed;
  @override
  GeneratedBoolColumn get completed => _completed ??= _constructCompleted();
  GeneratedBoolColumn _constructCompleted() {
    return GeneratedBoolColumn(
      'completed',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  GeneratedDateTimeColumn _lastUpdated;
  @override
  GeneratedDateTimeColumn get lastUpdated =>
      _lastUpdated ??= _constructLastUpdated();
  GeneratedDateTimeColumn _constructLastUpdated() {
    return GeneratedDateTimeColumn(
      'last_updated',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, subjectId, title, description, due, completed, lastUpdated];
  @override
  $TasksTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'tasks';
  @override
  final String actualTableName = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<TaskModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_subjectIdMeta, const VerificationResult.success());
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description'], _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('due')) {
      context.handle(
          _dueMeta, due.isAcceptableOrUnknown(data['due'], _dueMeta));
    } else if (isInserting) {
      context.missing(_dueMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed'], _completedMeta));
    } else if (isInserting) {
      context.missing(_completedMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated'], _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return TaskModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(_db, alias);
  }

  static TypeConverter<String, Uint8List> $converter0 = const UUIDConverter();
  static TypeConverter<String, Uint8List> $converter1 = const UUIDConverter();
}

class SubTaskModel extends DataClass implements Insertable<SubTaskModel> {
  final String id;
  final String taskId;
  final String title;
  final bool completed;
  final DateTime lastUpdated;
  SubTaskModel(
      {@required this.id,
      @required this.taskId,
      @required this.title,
      @required this.completed,
      @required this.lastUpdated});
  factory SubTaskModel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return SubTaskModel(
      id: $SubTasksTable.$converter0.mapToDart(
          uint8ListType.mapFromDatabaseResponse(data['${effectivePrefix}id'])),
      taskId: $SubTasksTable.$converter1.mapToDart(uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}task_id'])),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      completed:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}completed']),
      lastUpdated: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_updated']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      final converter = $SubTasksTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id));
    }
    if (!nullToAbsent || taskId != null) {
      final converter = $SubTasksTable.$converter1;
      map['task_id'] = Variable<Uint8List>(converter.mapToSql(taskId));
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || completed != null) {
      map['completed'] = Variable<bool>(completed);
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  SubTasksCompanion toCompanion(bool nullToAbsent) {
    return SubTasksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      taskId:
          taskId == null && nullToAbsent ? const Value.absent() : Value(taskId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      completed: completed == null && nullToAbsent
          ? const Value.absent()
          : Value(completed),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory SubTaskModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SubTaskModel(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      title: serializer.fromJson<String>(json['title']),
      completed: serializer.fromJson<bool>(json['completed']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'title': serializer.toJson<String>(title),
      'completed': serializer.toJson<bool>(completed),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  SubTaskModel copyWith(
          {String id,
          String taskId,
          String title,
          bool completed,
          DateTime lastUpdated}) =>
      SubTaskModel(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        title: title ?? this.title,
        completed: completed ?? this.completed,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('SubTaskModel(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('completed: $completed, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          taskId.hashCode,
          $mrjc(title.hashCode,
              $mrjc(completed.hashCode, lastUpdated.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is SubTaskModel &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.title == this.title &&
          other.completed == this.completed &&
          other.lastUpdated == this.lastUpdated);
}

class SubTasksCompanion extends UpdateCompanion<SubTaskModel> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> title;
  final Value<bool> completed;
  final Value<DateTime> lastUpdated;
  const SubTasksCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.title = const Value.absent(),
    this.completed = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  SubTasksCompanion.insert({
    @required String id,
    @required String taskId,
    @required String title,
    @required bool completed,
    @required DateTime lastUpdated,
  })  : id = Value(id),
        taskId = Value(taskId),
        title = Value(title),
        completed = Value(completed),
        lastUpdated = Value(lastUpdated);
  static Insertable<SubTaskModel> custom({
    Expression<Uint8List> id,
    Expression<Uint8List> taskId,
    Expression<String> title,
    Expression<bool> completed,
    Expression<DateTime> lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (title != null) 'title': title,
      if (completed != null) 'completed': completed,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  SubTasksCompanion copyWith(
      {Value<String> id,
      Value<String> taskId,
      Value<String> title,
      Value<bool> completed,
      Value<DateTime> lastUpdated}) {
    return SubTasksCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $SubTasksTable.$converter0;
      map['id'] = Variable<Uint8List>(converter.mapToSql(id.value));
    }
    if (taskId.present) {
      final converter = $SubTasksTable.$converter1;
      map['task_id'] = Variable<Uint8List>(converter.mapToSql(taskId.value));
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubTasksCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('completed: $completed, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $SubTasksTable extends SubTasks
    with TableInfo<$SubTasksTable, SubTaskModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $SubTasksTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedBlobColumn _id;
  @override
  GeneratedBlobColumn get id => _id ??= _constructId();
  GeneratedBlobColumn _constructId() {
    return GeneratedBlobColumn('id', $tableName, false,
        $customConstraints: 'UNIQUE NOT NULL');
  }

  final VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  GeneratedBlobColumn _taskId;
  @override
  GeneratedBlobColumn get taskId => _taskId ??= _constructTaskId();
  GeneratedBlobColumn _constructTaskId() {
    return GeneratedBlobColumn(
      'task_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _completedMeta = const VerificationMeta('completed');
  GeneratedBoolColumn _completed;
  @override
  GeneratedBoolColumn get completed => _completed ??= _constructCompleted();
  GeneratedBoolColumn _constructCompleted() {
    return GeneratedBoolColumn(
      'completed',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  GeneratedDateTimeColumn _lastUpdated;
  @override
  GeneratedDateTimeColumn get lastUpdated =>
      _lastUpdated ??= _constructLastUpdated();
  GeneratedDateTimeColumn _constructLastUpdated() {
    return GeneratedDateTimeColumn(
      'last_updated',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, taskId, title, completed, lastUpdated];
  @override
  $SubTasksTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'sub_tasks';
  @override
  final String actualTableName = 'sub_tasks';
  @override
  VerificationContext validateIntegrity(Insertable<SubTaskModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_taskIdMeta, const VerificationResult.success());
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed'], _completedMeta));
    } else if (isInserting) {
      context.missing(_completedMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated'], _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubTaskModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SubTaskModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SubTasksTable createAlias(String alias) {
    return $SubTasksTable(_db, alias);
  }

  static TypeConverter<String, Uint8List> $converter0 = const UUIDConverter();
  static TypeConverter<String, Uint8List> $converter1 = const UUIDConverter();
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  _$Database.connect(DatabaseConnection c) : super.connect(c);
  $SubjectsTable _subjects;
  $SubjectsTable get subjects => _subjects ??= $SubjectsTable(this);
  $TeachersTable _teachers;
  $TeachersTable get teachers => _teachers ??= $TeachersTable(this);
  $ExamsTable _exams;
  $ExamsTable get exams => _exams ??= $ExamsTable(this);
  $LessonsTable _lessons;
  $LessonsTable get lessons => _lessons ??= $LessonsTable(this);
  $TimetablesTable _timetables;
  $TimetablesTable get timetables => _timetables ??= $TimetablesTable(this);
  $TestsTable _tests;
  $TestsTable get tests => _tests ??= $TestsTable(this);
  $StudyingTable _studying;
  $StudyingTable get studying => _studying ??= $StudyingTable(this);
  $LessonTimesTable _lessonTimes;
  $LessonTimesTable get lessonTimes => _lessonTimes ??= $LessonTimesTable(this);
  $TasksTable _tasks;
  $TasksTable get tasks => _tasks ??= $TasksTable(this);
  $SubTasksTable _subTasks;
  $SubTasksTable get subTasks => _subTasks ??= $SubTasksTable(this);
  ExamDao _examDao;
  ExamDao get examDao => _examDao ??= ExamDao(this as Database);
  LessonDao _lessonDao;
  LessonDao get lessonDao => _lessonDao ??= LessonDao(this as Database);
  SubjectDao _subjectDao;
  SubjectDao get subjectDao => _subjectDao ??= SubjectDao(this as Database);
  TeacherDao _teacherDao;
  TeacherDao get teacherDao => _teacherDao ??= TeacherDao(this as Database);
  TestDao _testDao;
  TestDao get testDao => _testDao ??= TestDao(this as Database);
  TimetableDao _timetableDao;
  TimetableDao get timetableDao =>
      _timetableDao ??= TimetableDao(this as Database);
  StudyDao _studyDao;
  StudyDao get studyDao => _studyDao ??= StudyDao(this as Database);
  TaskDao _taskDao;
  TaskDao get taskDao => _taskDao ??= TaskDao(this as Database);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        subjects,
        teachers,
        exams,
        lessons,
        timetables,
        tests,
        studying,
        lessonTimes,
        tasks,
        subTasks
      ];
}
