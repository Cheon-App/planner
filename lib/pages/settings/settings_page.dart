// Flutter imports:
// Project imports:
import 'package:cheon/constants.dart';
import 'package:cheon/pages/manage_calendars/manage_calendars_page.dart';
import 'package:cheon/url_launcher.dart';
import 'package:cheon/view_models/app_info_view_model.dart';
import 'package:cheon/view_models/settings_view_model.dart';
import 'package:cheon/widgets/day_toggle.dart';
import 'package:cheon/widgets/platform_date_time_picker.dart';
import 'package:cheon/widgets/platform_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';

/// A page used to change app settings
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key, this.inHomePage = true}) : super(key: key);

  static const String routeName = '/settings';
  final bool inHomePage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 4),
        children: <Widget>[
          _ThemeCard(),
          _NotificationsCard(),
          _CalendarCard(),
          _AboutAppCard(),
        ],
      ),
    );
  }
}

class _AboutAppCard extends StatelessWidget {
  void openWebsite() => launchUrl(URL_WEBSITE);

  void openDiscord() => launchUrl(URL_DISCORD, openInBrowser: true);

  void openPrivacyPolicy() => launchUrl(URL_PRIVACY_POLICY);

  void openTermsAndConditions() => launchUrl(URL_TERMS_AND_CONDITIONS);

  void _leaveReview() {
    final inAppReview = InAppReview.instance;
    inAppReview.openStoreListing(appStoreId: APP_STORE_ID);
  }

  @override
  Widget build(BuildContext context) {
    final AppInfo appInfo = Provider.of<AppInfo>(context);
    final String commitHash = bool.hasEnvironment('BUILD_COMMIT')
        ? const String.fromEnvironment('BUILD_COMMIT').substring(0, 7)
        : '---';

    final String appVersion =
        'Version ${appInfo.versionName}(${appInfo.buildNumber}) | $commitHash';

    final year = DateTime.now().year;

    return _SettingsCard(
      title: 'About This App',
      subtitle: 'App information',
      separated: true,
      children: <Widget>[
        const ListTile(
          title: Text(
            'Designed and developed with ❤️ by Britannio Jarrett using the '
            'Flutter framework',
          ),
        ),
        ListTile(
          title: const Text('Discord'),
          subtitle: const Text(
            'Join the community, contribute ideas and get assistance.',
          ),
          leading: Icon(FontAwesomeIcons.discord,
              color: Theme.of(context).iconTheme.color),
          isThreeLine: true,
          onTap: openDiscord,
        ),
        ListTile(
          title: const Text('Leave a review!'),
          onTap: _leaveReview,
        ),
        ListTile(
          title: const Text('Website'),
          trailing: const Text('https://cheon.app'),
          onTap: openWebsite,
        ),
        /* ListTile(
          title: const Text('Changelog'),
          onTap: () => openChangelog(context),
        ), */
        ListTile(
          title: const Text('Open-Source Licenses'),
          onTap: () => showLicensePage(
            context: context,
            applicationName: 'Cheon',
            applicationIcon: Image.asset(IMG_LOGO, width: 40, height: 40),
            applicationVersion: appVersion,
            applicationLegalese: 'Copyright © Britannio Jarrett $year',
          ),
        ),
        ListTile(
          title: const Text('Terms and Conditions'),
          onTap: openTermsAndConditions,
        ),
        ListTile(
          title: const Text('Privacy Policy'),
          onTap: openPrivacyPolicy,
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Text(appVersion),
        ),
      ],
    );
  }
}

/// Creates a card for managing app notifications
class _NotificationsCard extends StatelessWidget {
  void setHomeworkReminderTime(
    BuildContext context,
  ) {
    final SettingsVM settings = Provider.of<SettingsVM>(context, listen: false);

    final TimeOfDay previousTime = settings.homeworkReminderTime;
    showPlatformTimePicker(context: context, initialTime: previousTime)
        .listen((TimeOfDay time) {
      if (time == null) return;
      settings.homeworkReminderTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SettingsVM settings = Provider.of<SettingsVM>(context);
    final bool homeworkReminders = settings.homeworkReminders;

    return _SettingsCard(
      title: 'Notifications',
      subtitle: 'Configure app notifications',
      separated: false,
      children: <Widget>[
        SwitchListTile.adaptive(
          onChanged: (bool b) => settings.homeworkReminders = b,
          value: homeworkReminders,
          title: const Text('Homework reminders'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: AbsorbPointer(
            absorbing: !homeworkReminders,
            child: AnimatedOpacity(
              duration: DURATION_MEDIUM,
              opacity: homeworkReminders ? 1 : 0.75,
              child: DayToggle(
                isSelected: (i) => settings.homeworkReminderDays[i],
                onPressed: settings.toggleHomeworkReminderDay,
              ),
            ),
          ),
        ),
        ListTile(
          onTap:
              homeworkReminders ? () => setHomeworkReminderTime(context) : null,
          title: const Text('Reminder Time'),
          trailing: Text(
            MaterialLocalizations.of(context)
                .formatTimeOfDay(settings.homeworkReminderTime),
            style: TextStyle(
              color: homeworkReminders
                  ? Theme.of(context).colorScheme.onBackground
                  : Colors.grey,
            ),
          ),
          enabled: homeworkReminders,
        ),
      ],
    );
  }
}

/// Creates a card for syncronising a local calendar
class _CalendarCard extends StatelessWidget {
  void _openManageCalendars(BuildContext context) =>
      Navigator.pushNamed(context, ManageCalendarsPage.routeName);

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      title: 'Calendar',
      subtitle: 'Manage calendar syncronisation',
      separated: true,
      children: <Widget>[
        ListTile(
          title: Text('Manage Calendars'),
          onTap: () => _openManageCalendars(context),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    Key key,
    @required this.title,
    @required this.children,
    this.subtitle,
    this.separated = false,
  })  : assert(title != null),
        assert(children != null),
        assert(separated != null),
        super(key: key);

  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool separated;
  @override
  Widget build(BuildContext context) {
    // Wrap each option in a sematic container so screen readers can distinguish
    // between options
    children.asMap().forEach((int key, Widget value) {
      children[key] = Semantics(container: true, child: value);
    });

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle != null
                    ? Text(
                        subtitle,
                        style: Theme.of(context).textTheme.overline,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          ...separated
              ? ListTile.divideTiles(context: context, tiles: children)
              : children
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  String themeModeToString(ThemeMode themeMode) {
    String theme;
    switch (themeMode) {
      case ThemeMode.light:
        theme = 'Light';
        break;
      case ThemeMode.dark:
        theme = 'Dark';
        break;
      case ThemeMode.system:
        theme = 'System';
        break;
    }
    return theme;
  }

  Future<void> selectTheme(BuildContext context) async {
    final ThemeMode themeMode = await showPlatformSelectionDialog<ThemeMode>(
      context: context,
      isAction: true,
      items: ThemeMode.values
          .map(
            (ThemeMode t) => SelectionDialogItem<ThemeMode>(
              name: themeModeToString(t),
              value: t,
            ),
          )
          .toList(),
      selectedItem: Provider.of<SettingsVM>(context, listen: false).themeMode,
    );

    if (themeMode != null) {
      Provider.of<SettingsVM>(context, listen: false).themeMode = themeMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final SettingsVM settings = Provider.of<SettingsVM>(context);
    final ThemeMode themeMode = settings.themeMode;
    final bool amoledDark = settings.amoledDark;
    return _SettingsCard(
      title: 'Theme',
      subtitle: 'Configure the appearance of the app',
      separated: true,
      children: <Widget>[
        ListTile(
          title: const Text('App Theme'),
          trailing: Text(themeModeToString(themeMode)),
          onTap: () => selectTheme(context),
        ),
        SwitchListTile.adaptive(
          title: const Text('AMOLED Dark Mode'),
          onChanged: Theme.of(context).brightness == Brightness.dark
              ? (bool b) => settings.amoledDark = b
              : null,
          value: amoledDark,
        ),
      ],
    );
  }
}
