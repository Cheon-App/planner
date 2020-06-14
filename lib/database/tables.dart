// Package imports:
import 'package:moor/moor.dart';

// Project imports:
import 'package:cheon/database/converters/color_converter.dart';
import 'package:cheon/database/converters/uuid_converter.dart';

@DataClassName('SubjectModel')
class Subjects extends Table {
  @override
  bool get withoutRowId => true;

  @override
  Set<Column> get primaryKey => <Column>{id};

  // Primary Key
  BlobColumn get id =>
      blob().map(const UUIDConverter()).customConstraint('UNIQUE NOT NULL')();
  // Foreign Key
  BlobColumn get yearId => blob().map(const UUIDConverter())();
  // Optional Foreign Key
  BlobColumn get teacherId => blob().map(const UUIDConverter()).nullable()();
  TextColumn get name => text().withLength(min: 1, max: 70)();
  TextColumn get room => text().nullable()();
  TextColumn get iconId => text()();
  IntColumn get color => integer().map(const ColorConverter())();
  DateTimeColumn get lastUpdated => dateTime()();
}

@DataClassName('TeacherModel')
class Teachers extends Table {
  @override
  bool get withoutRowId => true;

  @override
  Set<Column> get primaryKey => <Column>{id};

  // Primary Key
  BlobColumn get id =>
      blob().map(const UUIDConverter()).customConstraint('UNIQUE NOT NULL')();
  // Foreign Key
  BlobColumn get yearId => blob().map(const UUIDConverter())();
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  DateTimeColumn get lastUpdated => dateTime()();
}

@DataClassName('TaskModel')
class Tasks extends Table {
  @override
  bool get withoutRowId => true;

  @override
  Set<Column> get primaryKey => <Column>{id};

  // Primary Key
  BlobColumn get id =>
      blob().map(const UUIDConverter()).customConstraint('UNIQUE NOT NULL')();
  // Optional Foreign key
  BlobColumn get subjectId => blob().map(const UUIDConverter()).nullable()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  DateTimeColumn get due => dateTime()();
  BoolColumn get completed => boolean()();
  DateTimeColumn get lastUpdated => dateTime()();
}

@DataClassName('SubTaskModel')
class SubTasks extends Table {
  @override
  bool get withoutRowId => true;

  @override
  Set<Column> get primaryKey => <Column>{id};

  // Primary Key
  BlobColumn get id =>
      blob().map(const UUIDConverter()).customConstraint('UNIQUE NOT NULL')();
  // Foreign key
  BlobColumn get taskId => blob().map(const UUIDConverter())();
  TextColumn get title => text()();
  BoolColumn get completed => boolean()();
  DateTimeColumn get lastUpdated => dateTime()();
}

@DataClassName('StudyModel')
class Studying extends Table {
  @override
  bool get withoutRowId => true;

  @override
  Set<Column> get primaryKey => <Column>{id};

  // Primary Key
  BlobColumn get id =>
      blob().map(const UUIDConverter()).customConstraint('UNIQUE NOT NULL')();
  // Optional Foreign Key
  BlobColumn get examId => blob().map(const UUIDConverter()).nullable()();
  // Optional Foreign Key
  BlobColumn get testId => blob().map(const UUIDConverter()).nullable()();
  TextColumn get title => text()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime()();
  BoolColumn get completed =>
      boolean().withDefault(const Constant<bool>(false))();
  DateTimeColumn get lastUpdated => dateTime()();
}

@DataClassName('ExamModel')
class Exams extends Table {
  @override
  bool get withoutRowId => true;

  @override
  Set<Column> get primaryKey => <Column>{id};

  // Primary Key
  BlobColumn get id =>
      blob().map(const UUIDConverter()).customConstraint('UNIQUE NOT NULL')();
  // Foreign Key
  BlobColumn get subjectId => blob().map(const UUIDConverter())();
  TextColumn get title => text()();
  TextColumn get location => text().nullable()();
  TextColumn get seat => text().nullable()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime()();
  IntColumn get priority => integer().withDefault(const Constant<int>(3))();
  DateTimeColumn get lastUpdated => dateTime()();
}

@DataClassName('TestModel')
class Tests extends Table {
  @override
  bool get withoutRowId => true;

  @override
  Set<Column> get primaryKey => <Column>{id};

  // Primary Key
  BlobColumn get id =>
      blob().map(const UUIDConverter()).customConstraint('UNIQUE NOT NULL')();
  // Foreign Key
  BlobColumn get subjectId => blob().map(const UUIDConverter())();
  // Foreign Key
  BlobColumn get lessonId => blob().map(const UUIDConverter()).nullable()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get priority => integer().withDefault(const Constant<int>(3))();
  DateTimeColumn get lastUpdated => dateTime()();
}

@DataClassName('TimetableModel')
class Timetables extends Table {
  @override
  bool get withoutRowId => true;

  @override
  Set<Column> get primaryKey => <Column>{id};

  // Primary Key
  BlobColumn get id =>
      blob().map(const UUIDConverter()).customConstraint('UNIQUE NOT NULL')();
  BlobColumn get yearId => blob().map(const UUIDConverter())();
  // Week 1, 2, ...
  IntColumn get week => integer()();
  BoolColumn get saturday => boolean()();
  BoolColumn get sunday => boolean()();
  DateTimeColumn get lastSelected => dateTime()();
  DateTimeColumn get lastUpdated => dateTime()();
}

@DataClassName('LessonModel')
class Lessons extends Table {
  @override
  bool get withoutRowId => true;

  @override
  Set<Column> get primaryKey => <Column>{id};

  // Primary Key
  BlobColumn get id =>
      blob().map(const UUIDConverter()).customConstraint('UNIQUE NOT NULL')();
  // Foreign Key
  BlobColumn get subjectId => blob().map(const UUIDConverter())();
  // Foreign Key
  BlobColumn get teacherId => blob().map(const UUIDConverter()).nullable()();
  // Foreign Key
  BlobColumn get timetableId => blob().map(const UUIDConverter())();
  // Foreign Key
  IntColumn get period => integer()();
  TextColumn get room => text().nullable()();
  IntColumn get weekday => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get lastUpdated => dateTime()();
}

@DataClassName('LessonTimeModel')
class LessonTimes extends Table {
  @override
  Set<Column> get primaryKey => <Column>{period};

  // Primary Key
  IntColumn get period => integer().customConstraint('UNIQUE NOT NULL')();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get lastUpdated => dateTime()();
}
