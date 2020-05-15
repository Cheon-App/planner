import 'package:cheon/components/cheon_icons.dart';
import 'package:cheon/components/cheon_page.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/pages/lessons_page.dart';
import 'package:cheon/pages/preferences_page.dart';
import 'package:cheon/pages/subjects_page.dart';
import 'package:cheon/pages/teachers_page.dart';
import 'package:cheon/pages/terms_page.dart';
import 'package:cheon/pages/timetable_page.dart';
import 'package:cheon/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

/// Creates a page containing user details, a list of planner related pages
/// and additional buttons for performing low level actions
class MenuPage extends StatelessWidget {
  void openPreferencesPage(BuildContext context) =>
      Navigator.pushNamed(context, PreferencesPage.routeName);

  void openTimetablePage(BuildContext context) =>
      Navigator.pushNamed(context, TimetablePage.routeName);

  void openExamsPage(BuildContext context) =>
      Navigator.pushNamed(context, TimetablePage.routeName);

  void openRevisionPage(BuildContext context) =>
      Navigator.pushNamed(context, TimetablePage.routeName);

  void openSubjectsPage(BuildContext context) =>
      Navigator.pushNamed(context, SubjectsPage.routeName);

  void openLessonsPage(BuildContext context) =>
      Navigator.pushNamed(context, LessonsPage.routeName);

  void openTermsPage(BuildContext context) =>
      Navigator.pushNamed(context, TermsPage.routeName);

  void openTeachersPage(BuildContext context) =>
      Navigator.pushNamed(context, TeachersPage.routeName);

  /// Opens the systems app sharing popup to let users share the following text
  /// with friends
  void shareApp() {
    Share.share(
      'Check out Cheon! The latest smart planner and revision app for Android '
      'and IOS: https://get.cheon.app',
    );
  }

  /// Opens an invite url to the community Discord(messaging platform) group
  Future<void> openDiscord(BuildContext context) async {
    try {
      await launchUrl(URL_DISCORD);
    } catch (e) {
      print(e);
    }
  }

  Future<void> openInstagram(BuildContext context) async {
    try {
      await launchUrl(URL_INSTAGRAM);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CheonPage(
      actions: <Widget>[
        IconButton(
          icon: const Icon(FontAwesomeIcons.slidersH),
          onPressed: () => openPreferencesPage(context),
          tooltip: 'Settings',
        ),
      ],
      child: ListView(
        primary: false,
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          _MenuRow(
            icon: CheonIcons.timetable,
            title: 'Timetable',
            onTap: () => openTimetablePage(context),
          ),
          _MenuRow(
            icon: CheonIcons.books,
            title: 'Subjects',
            onTap: () => openSubjectsPage(context),
          ),
          /* _MenuRow(
            icon: CheonIcons.users_class,
            title: 'Lessons',
            onTap: () => openLessonsPage(context),
          ), */
          /* _MenuRow(
            icon: FontAwesomeIcons.school,
            title: 'Terms',
            onTap: () => openTermsPage(context),
          ), */
          _MenuRow(
            icon: FontAwesomeIcons.chalkboardTeacher,
            title: 'Teachers',
            onTap: () => openTeachersPage(context),
          ),
          const Divider(thickness: 0),
          IntrinsicHeight(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _MenuRow(
                    icon: FontAwesomeIcons.discord,
                    title: 'Discord',
                    onTap: () => openDiscord(context),
                    iconColor: const Color(0xFF7289DA),
                  ),
                ),
                const VerticalDivider(endIndent: 8, indent: 8),
                Expanded(
                  child: _MenuRow(
                    icon: FontAwesomeIcons.instagram,
                    title: 'Instagram',
                    onTap: () => openInstagram(context),
                  ),
                ),
              ],
            ),
          ),
          _MenuRow(
            icon: FontAwesomeIcons.shareAlt,
            title: 'Share',
            onTap: shareApp,
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  /// Creates a tappable box containing an icon and a title

  const _MenuRow({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.onTap,
    this.iconColor,
  })  : assert(title != null),
        assert(icon != null),
        assert(onTap != null),
        super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    // Spacing
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      // Creates an ink splash when tapped
      child: InkWell(
        // Rounds the edge of the ink splash
        borderRadius: BorderRadius.circular(8),
        // invokes the onTap callback when tapped
        onTap: onTap,
        // Spacing
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: <Widget>[
              // Icon specified in the constructor
              Icon(
                icon,
                color: iconColor ?? Theme.of(context).colorScheme.onBackground,
              ),
              const SizedBox(width: 32),
              // Title specified in the constructor
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
