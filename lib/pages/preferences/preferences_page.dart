// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/widgets/day_toggle.dart';
import 'package:cheon/widgets/platform_selection_dialog.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/url_launcher.dart';
import 'package:cheon/view_models/app_info_view_model.dart';
import 'package:cheon/view_models/preferences_view_model.dart';
import 'package:cheon/widgets/platform_date_time_picker.dart';

/// A page used to change app settings
class PreferencesPage extends StatelessWidget {
  const PreferencesPage({Key key, this.inHomePage = true}) : super(key: key);

  static const String routeName = '/preferences';
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
          // _CalendarCard(),
          // _AccountCard(),
          _AboutAppCard(),
        ],
      ),
    );
  }
}

class _AboutAppCard extends StatelessWidget {
  void openWebsite() => launchUrl(URL_WEBSITE);

  void openDiscord() => launchUrl(URL_DISCORD);

  void openPrivacyPolicy() => launchUrl(URL_PRIVACY_POLICY);

  void openTermsAndConditions() => launchUrl(URL_TERMS_AND_CONDITIONS);

  @override
  Widget build(BuildContext context) {
    final AppInfo appInfo = Provider.of<AppInfo>(context);
    final String appVersion = '${appInfo.versionName} | ${appInfo.buildNumber}';

    return _PreferencesCard(
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
            applicationLegalese: 'Copyright © Britannio Jarrett 2020',
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
    final Preferences preferences =
        Provider.of<Preferences>(context, listen: false);

    final TimeOfDay previousTime = preferences.homeworkReminderTime;
    showPlatformTimePicker(context: context, initialTime: previousTime)
        .listen((TimeOfDay time) {
      if (time == null) return;
      preferences.homeworkReminderTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Preferences preferences = Provider.of<Preferences>(context);
    final bool homeworkReminders = preferences.homeworkReminders;

    return _PreferencesCard(
      title: 'Notifications',
      subtitle: 'Configure app notifications',
      separated: false,
      children: <Widget>[
        SwitchListTile.adaptive(
          onChanged: (bool b) => preferences.homeworkReminders = b,
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
                isSelected: (i) => preferences.homeworkReminderDays[i],
                onPressed: preferences.toggleHomeworkReminderDay,
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
                .formatTimeOfDay(preferences.homeworkReminderTime),
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
/* class _CalendarCard extends StatelessWidget {
  Future<void> showSelectCalendarDialog(
    BuildContext context, {
    @required Calendar selectedCalendar,
  }) async {
    final Preferences preferences = Provider.of(context, listen: false);
    final String selectedCalendarId = selectedCalendar?.id;
    final Calendar calendar = await showModal<Calendar>(
      context: context,
      configuration: FadeScaleTransitionConfiguration(),
      builder: (BuildContext context) {
        return FutureBuilder<List<Calendar>>(
          future: preferences.calendarList(),
          initialData: List<Calendar>.from(<Calendar>[]),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Calendar>> snapshot,
          ) {
            final List<Calendar> calendarList = snapshot.data;
            // Sort the list by account name alphabetically
            calendarList.sort((Calendar a, Calendar b) {
              return a.accountName.compareTo(b.accountName);
            });

            final List<List<Calendar>> groupedCalendarList = <List<Calendar>>[];

            if (calendarList.length > 1) {
              Calendar currentAccountCalendar = calendarList.first;
              final List<Calendar> accountCalendarList = <Calendar>[];

              for (Calendar calendar in calendarList) {
                if (calendar.accountName !=
                    currentAccountCalendar.accountName) {
                  // Must be a new list otherwise a reference to the list will
                  // be added that's lost when .clear() is called on the
                  // original list
                  groupedCalendarList.add(<Calendar>[...accountCalendarList]);
                  accountCalendarList.clear();
                  currentAccountCalendar = calendar;
                }

                accountCalendarList.add(calendar);
              }

              groupedCalendarList.add(accountCalendarList);
            } else {
              groupedCalendarList.add(calendarList);
            }

            for (List<Calendar> calendarList in groupedCalendarList) {
              print(calendarList.map((e) => e.accountName).toList());
            }

            return CustomSelectionDialog(
              title: 'Select Calendar',
              items: <Widget>[
                for (List<Calendar> calendarList in groupedCalendarList) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      calendarList.first.accountName.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  ...calendarList
                      .map(
                        (Calendar calendar) => CustomSelectionDialogItem(
                          onTap: () => Navigator.pop(context, calendar),
                          text: calendar.name,
                          selected: calendar.id == selectedCalendarId,
                        ),
                      )
                      .toList(),
                ]
              ],
            );
          },
        );
      },
    );
    if (calendar == null) return;
    preferences.selectedCalendar = calendar;
  }

  @override
  Widget build(BuildContext context) {
    final Preferences preferences = Provider.of<Preferences>(context);
    final bool noSelectedCalendar = preferences.selectedCalendar == null;
    return _PreferencesCard(
      title: 'Calendar',
      subtitle: 'Manage calendar syncronisation',
      separated: true,
      children: <Widget>[
        SwitchListTile.adaptive(
          onChanged: (bool value) => preferences.importCalendarEvents = value,
          value: preferences.importCalendarEvents,
          title: const Text('Import calendar events'),
        ),
        ListTile(
          enabled: preferences.importCalendarEvents,
          title: const Text('Select calendar'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: noSelectedCalendar
                ? const <Widget>[]
                : <Widget>[
                    Text(
                      preferences.selectedCalendar.name,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            color: !preferences.importCalendarEvents
                                ? Colors.grey.shade700
                                : null,
                          ),
                    ),
                    Text(preferences.selectedCalendar.accountName),
                  ],
          ),
          onTap: () => showSelectCalendarDialog(
            context,
            selectedCalendar: preferences.selectedCalendar,
          ),
        ),
      ],
    );
  }
} */

class _PreferencesCard extends StatelessWidget {
  const _PreferencesCard({
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
      selectedItem: Provider.of<Preferences>(context, listen: false).themeMode,
    );

    if (themeMode != null) {
      Provider.of<Preferences>(context, listen: false).themeMode = themeMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Preferences preferences = Provider.of<Preferences>(context);
    final ThemeMode themeMode = preferences.themeMode;
    final bool amoledDark = preferences.amoledDark;
    return _PreferencesCard(
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
              ? (bool b) => preferences.amoledDark = b
              : null,
          value: amoledDark,
        ),
      ],
    );
  }
}
