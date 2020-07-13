// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/constants.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/pages/subjects/add_subject_page.dart';
import 'package:cheon/pages/subjects/view_subject_page.dart';
import 'package:cheon/view_models/subjects_view_model.dart';
import 'package:cheon/widgets/empty_placeholder.dart';
import 'package:cheon/widgets/error_message.dart';
import 'package:cheon/widgets/loading_indicator.dart';
import 'package:cheon/widgets/subject_card.dart';

/// Creates a page containing a list of subjects.
class SubjectsPage extends StatelessWidget {
  static const String routeName = '/subjects';

  void addSubject(BuildContext context) {
    Navigator.pushNamed(context, AddSubjectPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subjects')),
      body: _SubjectList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(FontAwesomeIcons.plus),
        onPressed: () => addSubject(context),
      ),
    );
  }
}

class _SubjectList extends StatelessWidget {
  void openSubject(BuildContext context, {@required Subject subject}) {
    Navigator.pushNamed(context, ViewSubjectPage.routeName, arguments: subject);
  }

  @override
  Widget build(BuildContext context) {
    final Stream<List<Subject>> subjectsStream =
        context.select<SubjectsVM, Stream<List<Subject>>>(
      (SubjectsVM vm) => vm.subjectsStream,
    );
    return StreamBuilder<List<Subject>>(
      stream: subjectsStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Subject>> snapshot,
      ) {
        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (BuildContext context, int index) {
                final Subject subject = snapshot.data[index];
                return SubjectCard(
                  color: subject.color,
                  title: subject.name,
                  trailingWidget: Icon(subject.icon, size: 16),
                  subtitle: subject.teacher?.name,
                  trailingSubtitle:
                      subject.room != null ? Text(subject.room) : null,
                  onTap: () => openSubject(context, subject: subject),
                );
              },
            );
          } else {
            return const EmptyPlaceholder(
              svgPath: IMG_SUBJECTS,
              text: 'No subjects.',
            );
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }
        return ErrorMessage();
      },
    );
  }
}
