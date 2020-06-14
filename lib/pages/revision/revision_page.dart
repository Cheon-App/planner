// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:animations/animations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:cheon/app.dart';
import 'package:cheon/widgets/empty_placeholder.dart';
import 'package:cheon/widgets/error_message.dart';
import 'package:cheon/widgets/linear_progress_bar.dart';
import 'package:cheon/widgets/menu_button.dart';
import 'package:cheon/widgets/number_dialog.dart';
import 'package:cheon/widgets/platform_date_time_picker.dart';
import 'package:cheon/widgets/platform_loading_indicator.dart';
import 'package:cheon/widgets/primary_action_button.dart';
import 'package:cheon/widgets/tappable_text_span.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/repositories/study_repository.dart';
import 'package:cheon/url_launcher.dart';
import 'package:cheon/view_models/revision_view_model.dart';

/// Creates a page containing a list of revision plans.
class RevisonPage extends StatefulWidget {
  const RevisonPage({Key key, this.inHomePage = true}) : super(key: key);

  static const String routeName = '/revision';
  final bool inHomePage;

  @override
  _RevisonPageState createState() => _RevisonPageState();
}

class _RevisonPageState extends State<RevisonPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final RevisionVM revisionVM = RevisionVM.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Revision'),
        leading: MenuButton(),
        centerTitle: false,
      ),
      resizeToAvoidBottomInset: false,
      body: PageTransitionSwitcher(
        reverse: revisionVM.revisionSetup,
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            child: child,
          );
        },
        child: revisionVM.revisionSetup //
            ? _RevisionDashboard()
            : _RevisionSetup(),
      ),
    );
  }
}

class _RevisionDashboard extends StatelessWidget {
  Future<void> enableRevision(BuildContext context, bool enable) async {
    final RevisionVM revisionVM = RevisionVM.of(context, listen: false);
    if (enable) {
      final GeneratedRevisionResult result =
          await revisionVM.generateRevisionBlocks(artificialDelay: false);
      print(result);
    } else {
      await revisionVM.deleteFutureStudySessions();
    }
    revisionVM.revisionEnabled = enable;
  }

  @override
  Widget build(BuildContext context) {
    final RevisionVM revisionVM = RevisionVM.of(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: <Widget>[
              Card(
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(App.borderRadius),
                ),
                child: SwitchListTile.adaptive(
                  value: revisionVM.revisionEnabled,
                  onChanged: (bool enabled) => enableRevision(context, enabled),
                  title: Text.rich(
                    TextSpan(text: 'Smart', children: <InlineSpan>[
                      TextSpan(
                        text: ' Revision',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      )
                    ]),
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.75),
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
              EmptyPlaceholder(svgPath: IMG_SMART_REVISION),

              /* Text(
                'Today\'s Progress',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 4),
              LinearProgressBar(
                color: Theme.of(context).colorScheme.secondary,
                fraction: revisionVM.progressToday,
              ),
              const SizedBox(height: 4),
              const Divider(),
              // _SubjectProgressSection(),
              _StatsSection() ,*/
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
          child: PrimaryActionButton(
            text: 'FINE TUNE',
            onTap: () => revisionVM.revisionSetup = false,
          ),
        ),
      ],
    );
  }
}

class _SubjectProgressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Subject Progress',
          style: Theme.of(context).textTheme.headline6,
        ),
        GridView.builder(
          shrinkWrap: true,
          primary: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4,
            crossAxisSpacing: 8,
          ),
          padding: EdgeInsets.zero,
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  index == 0
                      ? 'Maths'
                      : index == 1
                          ? 'Physics'
                          : index == 2 ? 'Computer Science' : 'Further Maths',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                LinearProgressBar(
                  color: Theme.of(context).colorScheme.secondary,
                  fraction: (index + 1) / 4,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RevisionVM revisionVM = RevisionVM.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Stats',
          style: Theme.of(context).textTheme.headline6,
        ),
        IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Expanded(
                child: _StatCard(
                  heading: 'Sessions completed',
                  largeText: '${revisionVM.sessionsCompleted}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  heading: 'Completion rate',
                  largeText: '${revisionVM.completionRate}%',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  heading: 'Daily Streak',
                  largeText: '${revisionVM.dailyStreak}',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    Key key,
    @required this.largeText,
    @required this.heading,
  }) : super(key: key);

  final String largeText;
  final String heading;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(App.borderRadius),
      ),
      child: Column(
        children: <Widget>[
          Text(
            largeText,
            style: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          Text(
            heading,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _RevisionSetup extends StatefulWidget {
  @override
  __RevisionSetupState createState() => __RevisionSetupState();
}

class __RevisionSetupState extends State<_RevisionSetup>
    with AutomaticKeepAliveClientMixin {
  bool firstPage = true;

  @override
  bool get wantKeepAlive => true;

  void startSetup() {
    setState(() {
      firstPage = false;
    });
  }

  void cancelSetup() {
    setState(() {
      firstPage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: MergeSemantics(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                children: <InlineSpan>[
                  TextSpan(
                    text: 'Smart',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.75),
                    ),
                  ),
                  TextSpan(
                    text: ' Revision',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: PageTransitionSwitcher(
            reverse: firstPage,
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.scaled,
                child: child,
              );
            },
            child: Material(
              key: ValueKey<bool>(firstPage),
              color: Theme.of(context).colorScheme.background,
              child: firstPage
                  ? _RevisionSetupDescription(startSetup: startSetup)
                  : _RevisionSetupConfiguration(cancelSetup: cancelSetup),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// # Learns your habits
/// As you use and provide feedback to the system, it will improve

const String _smartRevisionMessage = '''
# Smart system
The algorithm combines your study preferences with your prioritised exams and tests to create study blocks that suit you the most.
''';
/* # Automatic optimisation
As you add new exams and tests, the system automatically updates your study blocks to reflect the new changes.
'''; */

class _RevisionSetupDescription extends StatelessWidget {
  const _RevisionSetupDescription({Key key, @required this.startSetup})
      : super(key: key);

  final VoidCallback startSetup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: <Widget>[
          Markdown(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            data: _smartRevisionMessage,
            padding: EdgeInsets.zero,
            onTapLink: launchUrl,
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              horizontalRuleDecoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 5.0,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: EmptyPlaceholder(svgPath: IMG_SMART_REVISION)),
          PrimaryActionButton(onTap: startSetup, text: 'GET STARTED'),
        ],
      ),
    );
  }
}

enum _RevisionSetupStage { SESSION_LENGTH, BOUNDS }

class _RevisionSetupConfiguration extends StatefulWidget {
  const _RevisionSetupConfiguration({
    Key key,
    @required this.cancelSetup,
  }) : super(key: key);

  final VoidCallback cancelSetup;

  @override
  __RevisionSetupConfigurationState createState() =>
      __RevisionSetupConfigurationState();
}

class __RevisionSetupConfigurationState
    extends State<_RevisionSetupConfiguration> {
  int index = 0;
  bool reverse = false;
  bool loading = false;

  void next() {
    if (index + 1 < _RevisionSetupStage.values.length) {
      setState(() {
        index++;
        reverse = false;
      });
    } else {
      //
    }
  }

  void previous() {
    if (index > 0) {
      setState(() {
        index--;
        reverse = true;
      });
    } else {
      widget.cancelSetup();
    }
  }

  Future<void> complete() async {
    final RevisionVM revisionVM = RevisionVM.of(context, listen: false);

    final SnackBar snackbar = SnackBar(
      duration: const Duration(seconds: 30),
      content: Row(
        children: const <Widget>[
          Expanded(child: Text('Generating Revision Blocks...')),
          SizedBox(
            height: 16,
            width: 16,
            child: Center(child: PlatformLoadingIndicator(small: true)),
          ),
        ],
      ),
    );

    Scaffold.of(context).showSnackBar(snackbar);
    setState(() {
      loading = true;
    });

    final GeneratedRevisionResult result =
        await revisionVM.generateRevisionBlocks(artificialDelay: true);
    print(result);
    setState(() {
      loading = false;
    });
    Scaffold.of(context).hideCurrentSnackBar();

    revisionVM.revisionSetup = true;
    revisionVM.revisionEnabled = true;
  }

  void setStartEndTime(bool start) {
    final RevisionVM revisionVM = RevisionVM.of(context, listen: false);
    showPlatformTimePicker(
            context: context,
            initialTime: start ? revisionVM.startTime : revisionVM.endTime)
        .listen((TimeOfDay time) {
      if (time == null) return;
      if (start) {
        if (time.isAfterOrSameAs(revisionVM.endTime)) {
          // The start time is at or after the end time
          Scaffold.of(context).showSnackBar(
            const SnackBar(
              content: Text('Start Time cannot be after End Time'),
            ),
          );
          return null;
        }
        revisionVM.startTime = time;
      } else {
        if (time.isBeforeOrSameAs(revisionVM.startTime)) {
          // The end time is at or before the start time
          Scaffold.of(context).showSnackBar(
            const SnackBar(
              content: Text('End Time cannot be before Start Time'),
            ),
          );
          return null;
        }
        revisionVM.endTime = time;
      }
    });
  }

  Future<void> setRevisionLength() async {
    final RevisionVM revisionVM = RevisionVM.of(context, listen: false);
    final int length = await showModal(
      configuration: FadeScaleTransitionConfiguration(),
      context: context,
      builder: (BuildContext context) {
        return NumberDialog(
          maximum: 60,
          minimum: 10,
          title: 'Revision block length',
          initialValue: revisionVM.revisionLength,
          suffixText: 'Minutes',
        );
      },
    );
    if (length != null) revisionVM.revisionLength = length;
  }

  Future<void> setBreakLength() async {
    final RevisionVM revisionVM = RevisionVM.of(context, listen: false);
    final int length = await showModal(
      configuration: FadeScaleTransitionConfiguration(),
      context: context,
      builder: (BuildContext context) {
        return NumberDialog(
          maximum: 15,
          minimum: 5,
          title: 'Break block length',
          initialValue: revisionVM.breakLength,
          suffixText: 'Minutes',
        );
      },
    );
    if (length != null) revisionVM.breakLength = length;
  }

  Future<void> setExtendedBreakLength() async {
    final RevisionVM revisionVM = RevisionVM.of(context, listen: false);
    final int length = await showModal(
      configuration: FadeScaleTransitionConfiguration(),
      context: context,
      builder: (BuildContext context) {
        return NumberDialog(
          minimum: 15,
          maximum: 30,
          title: 'Extended break block length',
          initialValue: revisionVM.extendedBreakLength,
          suffixText: 'Minutes',
        );
      },
    );
    if (length != null) revisionVM.extendedBreakLength = length;
  }

  Future<void> setExtendedBreakFrequency() async {
    final RevisionVM revisionVM = RevisionVM.of(context, listen: false);
    final int frequency = await showModal(
      configuration: FadeScaleTransitionConfiguration(),
      context: context,
      builder: (BuildContext context) {
        return NumberDialog(
          minimum: 2,
          maximum: 6,
          title: 'Extended break block frequency',
          initialValue: revisionVM.extendedBreakFrequency,
        );
      },
    );
    if (frequency != null) revisionVM.extendedBreakFrequency = frequency;
  }

  Future<void> setSessionTarget() async {
    final RevisionVM revisionVM = RevisionVM.of(context, listen: false);
    final int target = await showModal(
      configuration: FadeScaleTransitionConfiguration(),
      context: context,
      builder: (BuildContext context) {
        return NumberDialog(
          minimum: 1,
          maximum: 12,
          title: 'Daily Session Target',
          initialValue: revisionVM.sessionTarget,
        );
      },
    );
    if (target != null) revisionVM.sessionTarget = target;
  }

  Widget form() {
    final RevisionVM revisionVM = RevisionVM.of(context);
    switch (_RevisionSetupStage.values[index]) {
      case _RevisionSetupStage.SESSION_LENGTH:
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          primary: false,
          key: ValueKey<int>(index),
          children: <Widget>[
            const SizedBox(height: 8),
            Text(
              'Study Session Preferences',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text.rich(
              TextSpan(
                text: 'Here you can configure how revision sessions and breaks'
                    ' are structured. The default settings are based on the ',
                children: <InlineSpan>[
                  tappableTextSpan(
                    context,
                    onTap: () => launchUrl(URL_POMODORO_TECHNIQUE),
                    text: 'Pomodoro Technique.',
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ],
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
            const Divider(height: 16),
            Card(
              child: ListTile(
                onTap: setRevisionLength,
                title: const Text('Revision block length'),
                subtitle: const Text(
                  'How much time should be spent studying before a break '
                  'is taken.',
                ),
                trailing: Text('${revisionVM.revisionLength}m'),
              ),
            ),
            Card(
              child: ListTile(
                onTap: setBreakLength,
                title: const Text('Break block length'),
                subtitle: const Text(
                  'How long breaks between studying should last.',
                ),
                trailing: Text('${revisionVM.breakLength}m'),
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: setExtendedBreakLength,
                    title: const Text('Extended break block length'),
                    subtitle: const Text(
                      'How long extended breaks should last.',
                    ),
                    trailing: Text('${revisionVM.extendedBreakLength}m'),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    onTap: setExtendedBreakFrequency,
                    title: const Text('Extended break block frequency'),
                    subtitle: const Text(
                      'How many study blocks elapse before an extended break '
                      'occurs.',
                    ),
                    trailing: Text('${revisionVM.extendedBreakFrequency}'),
                  ),
                ],
              ),
            ),
          ],
        );
        break;

      case _RevisionSetupStage.BOUNDS:
        return ListView(
          key: ValueKey<int>(index),
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: <Widget>[
            const SizedBox(height: 8),
            Text(
              'Revision bounds',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              'Almost there... Here you can set bounds on the amount of '
              'revision created every day and set a study goal.',
              // ' and add variety to your revision.',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
            ),
            const Divider(height: 16),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () => setStartEndTime(true),
                    title: const Text('Start Time'),
                    subtitle: const Text(
                      'The time you would like to start studying at.',
                    ),
                    trailing: Text(
                      MaterialLocalizations.of(context)
                          .formatTimeOfDay(revisionVM.startTime),
                    ),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    onTap: () => setStartEndTime(false),
                    title: const Text('End time'),
                    subtitle: const Text(
                      'The time you would like to finish studying at.',
                    ),
                    trailing: Text(
                      MaterialLocalizations.of(context)
                          .formatTimeOfDay(revisionVM.endTime),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: setSessionTarget,
                    title: const Text('Daily Session Target'),
                    subtitle: const Text(
                      'The number of study sessions you\'re aiming for every '
                      'day.',
                    ),
                    trailing: Text('${revisionVM.sessionTarget}'),
                  ),
                ],
              ),
            ),
            /* Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('Variety'),
                    subtitle: const Text(
                      'How mixed study sessions should be.\nHigher variety = '
                      'less repetiveness',
                    ),
                    trailing: Text('${revisionVM.variety}/5'),
                  ),
                  SizedBox(
                    height: 24,
                    child: Slider.adaptive(
                      value: revisionVM.variety.toDouble(),
                      onChanged: (double val) =>
                          revisionVM.variety = val.toInt(),
                      divisions: 4,
                      min: 1,
                      max: 5,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ), */
          ],
        );
        break;
    }
    return const ErrorMessage();
  }

  @override
  Widget build(BuildContext context) {
    final bool lastForm = index == _RevisionSetupStage.values.length - 1;
    return AbsorbPointer(
      absorbing: loading,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: LinearProgressBar(
                    fraction: (index + 1) / _RevisionSetupStage.values.length,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Expanded(
                  child: PageTransitionSwitcher(
                    reverse: reverse,
                    child: form(),
                    duration: DURATION_MEDIUM,
                    transitionBuilder: (
                      Widget child,
                      Animation<double> primaryAnimation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return SharedAxisTransition(
                        animation: primaryAnimation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        child: Material(
                          color: Theme.of(context).colorScheme.background,
                          child: child,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 56,
                  child: PrimaryActionButton(
                    onTap: !loading ? previous : null,
                    child: FaIcon(
                      FontAwesomeIcons.chevronLeft,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PrimaryActionButton(
                    onTap: lastForm ? !loading ? complete : null : next,
                    text: lastForm ? 'COMPLETE' : 'NEXT',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
