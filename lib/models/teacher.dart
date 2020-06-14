// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:cheon/database/database.dart';

@immutable
class Teacher extends Equatable {
  /// Represents a teacher
  const Teacher({
    @required this.id,
    @required this.name,
    this.email,
  })  : assert(id != null),
        assert(name != null);

  factory Teacher.fromDBModel(TeacherModel teacherModel) {
    return Teacher(
      id: teacherModel.id,
      name: teacherModel.name,
      email: teacherModel?.email,
    );
  }

  /// A UUID identifier for the teacher
  final String id;

  /// The teacher's name
  final String name;

  /// The teacher's email
  final String email;

  @override
  List<Object> get props => <Object>[id];
}
