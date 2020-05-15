import 'package:cheon/database/database.dart';
import 'package:cheon/models/year.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Teacher extends Equatable {
  /// Represents a teacher
  const Teacher({
    @required this.id,
    @required this.name,
    @required this.year,
    this.email,
  })  : assert(id != null),
        assert(name != null),
        assert(year != null);

  factory Teacher.fromDBModel({
    @required TeacherModel teacherModel,
    @required Year year,
  }) {
    return Teacher(
      id: teacherModel.id,
      name: teacherModel.name,
      email: teacherModel?.email,
      year: year,
    );
  }

  /// A UUID identifier for the teacher
  final String id;

  /// The teacher's name
  final String name;

  /// The teacher's email
  final String email;

  /// The year the teacher belongs to
  final Year year;

  @override
  List<Object> get props => <Object>[id];
}
