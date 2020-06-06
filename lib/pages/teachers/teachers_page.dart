import 'package:cheon/widgets/empty_placeholder.dart';
import 'package:cheon/widgets/error_message.dart';
import 'package:cheon/widgets/loading_indicator.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/pages/teachers/teacher_page.dart';
import 'package:cheon/url_launcher.dart';
import 'package:cheon/view_models/teachers_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

/// Creates a page containing a list of teachers and a button to add a teacher
class TeachersPage extends StatelessWidget {
  const TeachersPage({Key key}) : super(key: key);

  static const String routeName = '/teachers';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teachers')),
      body: _TeachersList(),
      floatingActionButton: _FAB(),
    );
  }
}

class _TeachersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Teacher>>(
      stream: context.select<TeachersVM, Stream<List<Teacher>>>(
        (TeachersVM vm) => vm.teacherListStream,
      ),
      builder: (BuildContext context, AsyncSnapshot<List<Teacher>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 84),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) => _TeacherCard(
                teacher: snapshot.data[index],
              ),
            );
          } else {
            return const EmptyPlaceholder(
              svgPath: IMG_TEACHER,
              text: 'No teachers.',
            );
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingIndicator());
        }
        return const ErrorMessage();
      },
    );
  }
}

class _TeacherCard extends StatelessWidget {
  const _TeacherCard({Key key, @required this.teacher})
      : assert(teacher != null),
        super(key: key);

  final Teacher teacher;

  void openTeacherPage(BuildContext context) => Navigator.pushNamed(
        context,
        TeacherPage.routeName,
        arguments: teacher,
      );

  void sendEmail() => teacher.email != null ? launchEmail(teacher.email) : null;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => openTeacherPage(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      teacher.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    teacher.email != null
                        ? Text(
                            teacher.email,
                            style: Theme.of(context).textTheme.subtitle1,
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              teacher.email != null
                  ? IconButton(
                      icon: const Icon(FontAwesomeIcons.at),
                      onPressed: sendEmail,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FAB extends StatelessWidget {
  void addTeacher(BuildContext context) =>
      Navigator.pushNamed(context, TeacherPage.routeName);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(FontAwesomeIcons.plus),
      onPressed: () => addTeacher(context),
    );
  }
}
