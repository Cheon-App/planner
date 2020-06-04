import 'dart:convert';

import 'package:cheon/components/cheon_icons.dart';
import 'package:cheon/components/page_switcher.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/pages/add_event_page.dart';
import 'package:cheon/pages/tasks_page.dart';
import 'package:cheon/pages/exams_page.dart';
import 'package:cheon/pages/preferences_page.dart';
import 'package:cheon/pages/revision_page.dart';
import 'package:cheon/pages/subjects_page.dart';
import 'package:cheon/pages/teachers_page.dart';
import 'package:cheon/pages/timeline_page.dart';
import 'package:cheon/pages/timetable_page.dart';
import 'package:cheon/routes.dart';
import 'package:cheon/url_launcher.dart';
import 'package:cheon/view_models/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:share/share.dart';

/// All pages shown on the home page, changing the order changes the order
/// of the items in the bottom and side navigation bar
enum _Page { EXAMS, TASKS, TIMELINE, REVISION, TIMETABLE }

const String _ADD_TASK_QUICK_ACTION = 'add_task';
const String _ADD_EXAM_QUICK_ACTION = 'add_exam';
// const String _ADD_EVENT_QUICK_ACTION = 'add_event';

/// The first page shown after the splash screen ends
/// It contains a [Scaffold] responsible for displaying the current sub-page,
/// the navigation bar and a floating action button when necessary
class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  static const String routeName = '/home';

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// A list of pages shown in the home page
  final List<Widget> _pages = <Widget>[];

  /// Individual fab keys prevent FABs performing the same action from
  /// transitioning
  final List<Key> _fabKeys = <Key>[];

  /// Navigation icons shown on the bottom or side navigation bar
  final List<IconData> _navigationIcons = <IconData>[];

  /// A list of page names for the bottom navigation bar if four or less items
  /// Are being shown
  final List<String> _pageNames = <String>[];

  /// Represents the page being displayed
  _Page _currentPage = _Page.TIMELINE;

  @override
  void initState() {
    super.initState();

    // If the app is opend using a notification then it is dealt with here
    _initNotifications();

    // If the app is opened using a shortcut then it is dealt with here
    _initializeQuickActions();

    /// Type safe way of generating a list of pages, fab keys, navigation icons,
    /// and page names for various components in the home page that relies on
    /// indexing of the [_Page] enum
    for (_Page page in _Page.values) {
      switch (page) {
        case _Page.TIMELINE:
          _fabKeys.add(const ValueKey<String>('add'));
          _pages.add(TimelinePage());
          _navigationIcons.add(FontAwesomeIcons.stream);
          _pageNames.add('Timeline');
          break;
        case _Page.TASKS:
          _fabKeys.add(const ValueKey<String>('add'));
          _pages.add(
            VMProvider<TaskVM>(
              child: const TasksPage(),
              viewModel: (_) => TaskVM(),
            ),
          );
          _navigationIcons.add(FontAwesomeIcons.tasks);
          _pageNames.add('Tasks');
          break;
        case _Page.EXAMS:
          _fabKeys.add(const ValueKey<String>('add'));
          _pages.add(const ExamsPage());
          _navigationIcons.add(FontAwesomeIcons.brain);
          _pageNames.add('Assessments');
          break;
        case _Page.REVISION:
          _fabKeys.add(null);
          _pages.add(const RevisonPage());
          _navigationIcons.add(FontAwesomeIcons.bookReader);
          _pageNames.add('Revision');
          break;
        case _Page.TIMETABLE:
          _fabKeys.add(null);
          _pages.add(TimetablePage());
          _navigationIcons.add(CheonIcons.timetable);
          _pageNames.add('Timetable');
          break;
      }
    }
  }

  /// Changes the [_currentPage] then rebuilds the page for new one to be shown
  void onPageChanged(_Page page) {
    if (_currentPage != page) setState(() => _currentPage = page);
  }

  void _initializeQuickActions() {
    final QuickActions quickActions = QuickActions();
    quickActions.initialize(
      (String shortcutType) {
        print('Shortcut Type: $shortcutType');

        /* if (shortcutType == _ADD_EVENT_QUICK_ACTION) {
          Navigator.pushNamed(
            context,
            AddEventPage.routeName,
            arguments: EventType.EVENT,
          );
        } */
        if (shortcutType == _ADD_TASK_QUICK_ACTION) {
          Navigator.pushNamed(
            context,
            AddEventPage.routeName,
            arguments: EventType.TASK,
          );
        }
        if (shortcutType == _ADD_EXAM_QUICK_ACTION) {
          Navigator.pushNamed(
            context,
            AddEventPage.routeName,
            arguments: EventType.EXAM,
          );
        }
      },
    );
    quickActions.setShortcutItems(
      <ShortcutItem>[
        const ShortcutItem(
          type: _ADD_EXAM_QUICK_ACTION,
          localizedTitle: 'Add Exam',
          icon: 'action_exam',
        ),
        const ShortcutItem(
          type: _ADD_TASK_QUICK_ACTION,
          localizedTitle: 'Add Task',
          // TODO rename this and it's correspondng files
          icon: 'action_homework',
        ),
      ],
    );
  }

  Future<void> _initNotifications() async {
    // Initializes flutter_local_notifications. app_icon needs to be a added
    // as a drawable resource to the Android head project
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo_transparent');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      // Set to false to prevent permissions from being requested until the user
      // attempts to enable notifications
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null && payload.isNotEmpty) {
          print('notification payload: ' + payload);
          try {
            final Map<String, dynamic> json = jsonDecode(payload);
            print(json);
            if (json['route'] != null) {
              await Navigator.pushNamed(context, json['route']);
            }
          } catch (e) {
            print(e);
          }
        }
      },
    );
  }

  void openDrawer() => _scaffoldKey.currentState.openDrawer();

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.shortestSide < 600;
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        final bool isPortrait = orientation == Orientation.portrait;
        return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          drawer: _Drawer(),
          // Displays the current page and also the side navigation bar if
          // the device is large(tablet) or it's in the landscape orientation
          body: _ResponsiveBody(
            navigationRailEnabled: !isMobile || !isPortrait,
            navigationRail: _NavigationRail(
              onPageChanged: onPageChanged,
              page: _currentPage,
              isMobile: isMobile,
              icons: _navigationIcons,
            ),
            body: PageSwitcher(pageIndex: _currentPage.index, children: _pages),
          ),
          // High level button positioned above content and at the bottom right
          // of the screen
          floatingActionButton: _FAB(
            key: _fabKeys[_currentPage.index],
            page: _currentPage,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          // Bottom navigation bar for navigating between primary app pages
          bottomNavigationBar: isMobile && isPortrait
              ? _BottomNav(
                  page: _currentPage,
                  onPageChanged: onPageChanged,
                  pageIcons: _navigationIcons,
                  pageNames: _pageNames,
                )
              : null,
        );
      },
    );
  }
}

class _Drawer extends StatelessWidget {
  void _openSubjectsPage(BuildContext context) =>
      Navigator.pushNamed(context, SubjectsPage.routeName);

  void _openTeachersPage(BuildContext context) =>
      Navigator.pushNamed(context, TeachersPage.routeName);

  void _openPreferencesPage(BuildContext context) =>
      Navigator.pushNamed(context, PreferencesPage.routeName);

  /// Opens an invite url to the community Discord(messaging platform) group
  Future<void> _openDiscord(BuildContext context) async {
    try {
      await launchUrl(URL_DISCORD);
    } catch (e) {
      print(e);
    }
  }

  /// Opens the systems app sharing popup to let users share the following text
  /// with friends
  void _shareApp() {
    Share.share(
      'Check out Cheon! The latest smart planner and revision app for Android '
      'and IOS: https://get.cheon.app',
    );
  }

  Future<void> _openInstagram(BuildContext context) async {
    try {
      await launchUrl(URL_INSTAGRAM);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _openRoadmap(BuildContext context) async {
    try {
      await launchUrl(URL_ROADMAP);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Spacer(),
            Text(
              'CHEON.APP',
              style: TextStyle(
                fontFamily: 'Orbitron',
                color: Theme.of(context).colorScheme.primary,
                fontSize: 24,
              ),
            ),
            Spacer(),
            _DrawerTab(
              onTap: () => _openSubjectsPage(context),
              text: 'Subjects',
              icon: CheonIcons.books,
            ),
            _DrawerTab(
              onTap: () => _openTeachersPage(context),
              text: 'Teachers',
              icon: FontAwesomeIcons.chalkboardTeacher,
            ),
            _DrawerTab(
              onTap: () => _openPreferencesPage(context),
              text: 'Settings',
              icon: FontAwesomeIcons.slidersH,
            ),
            Divider(),
            _DrawerTab(
              onTap: () => _openDiscord(context),
              icon: FontAwesomeIcons.discord,
              text: 'Discord',
              iconColor: const Color(0xFF7289DA),
            ),
            _DrawerTab(
              onTap: () => _openInstagram(context),
              text: 'Instagram',
              icon: FontAwesomeIcons.instagram,
            ),
            _DrawerTab(
              onTap: () => _openRoadmap(context),
              text: 'Roadmap',
              icon: FontAwesomeIcons.clipboardList,
            ),
            _DrawerTab(
              onTap: _shareApp,
              text: 'Share',
              icon: FontAwesomeIcons.shareAlt,
            ),
            Spacer(flex: 6),
          ],
        ),
      ),
    );
  }
}

class _DrawerTab extends StatelessWidget {
  const _DrawerTab({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.onTap,
    this.iconColor,
    this.closeDrawer = true,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color iconColor;
  final bool closeDrawer;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () {
          if (closeDrawer) Navigator.pop(context);
          onTap();
        },
        leading: FaIcon(
          icon,
          color: iconColor ?? Theme.of(context).colorScheme.onSurface,
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  /// A Material themed bottom navigation bar for lateral navigation between
  /// pages
  const _BottomNav({
    Key key,
    @required this.onPageChanged,
    @required this.page,
    @required this.pageNames,
    @required this.pageIcons,
  }) : super(key: key);

  final Function(_Page) onPageChanged;
  final _Page page;
  final List<String> pageNames;
  final List<IconData> pageIcons;

  BottomNavigationBarItem bottomNavItem(
    BuildContext context, {
    @required IconData icon,
    @required String title,
  }) {
    return BottomNavigationBarItem(title: Text(title), icon: Icon(icon));
  }

  List<BottomNavigationBarItem> items(BuildContext context) {
    final List<BottomNavigationBarItem> itemList = <BottomNavigationBarItem>[];

    /// Type safe method for generating a list of bottom navigation items based
    /// on the indexing of the [_Page] enum
    for (_Page page in _Page.values) {
      itemList.add(
        bottomNavItem(
          context,
          icon: pageIcons[page.index],
          title: pageNames[page.index],
        ),
      );
    }
    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      iconSize: 22,
      unselectedFontSize: 12,
      selectedFontSize: 12,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: Theme.of(context).bottomAppBarColor,
      selectedItemColor: Theme.of(context).accentColor,
      unselectedItemColor: Theme.of(context).colorScheme.onSurface,
      currentIndex: page.index,
      items: items(context),
      onTap: (int index) => onPageChanged(_Page.values[index]),
    );
  }
}

class _FAB extends StatelessWidget {
  /// Creates a Material Design [FloatingActionButton] for every page. Some
  /// pages share a button so the same [Key] is provided to the constructor to
  /// let the framework know that it shouldn't create a transition.
  const _FAB({
    Key key,
    @required this.page,
  }) : super(key: key);

  final _Page page;

  void openAddEvent(BuildContext context, EventType eventType) =>
      Navigator.pushNamed(
        context,
        AddEventPage.routeName,
        arguments: eventType,
      );

  @override
  Widget build(BuildContext context) {
    Widget widget;

    /// Type safe method for providing a floating action button based on the
    /// indexing of the [_Page] enum
    switch (page) {
      case _Page.TIMETABLE:
        break;
      case _Page.TASKS:
        widget = FloatingActionButton(
          child: const Icon(FontAwesomeIcons.plus),
          onPressed: () => openAddEvent(context, EventType.TASK),
          tooltip: 'Add task',
        );
        break;
      case _Page.TIMELINE:
        widget = FloatingActionButton(
          child: const Icon(FontAwesomeIcons.plus),
          onPressed: () => openAddEvent(context, EventType.TASK),
          tooltip: 'Add task',
        );
        break;
      case _Page.REVISION:
        /* widget = FloatingActionButton(
          child: const Icon(FontAwesomeIcons.plus),
          onPressed: () => openAddEvent(context, EventType.REVISION),
          tooltip: 'Add revision',
        ); */
        break;
      case _Page.EXAMS:
        widget = FloatingActionButton(
          child: const Icon(FontAwesomeIcons.plus),
          onPressed: () => openAddEvent(context, EventType.EXAM),
          tooltip: 'Add exam',
        );
        break;
    }

    return widget ?? const SizedBox.shrink();
  }
}

class _ResponsiveBody extends StatelessWidget {
  /// Creates a widget that either shows or hides a side navigation bar
  const _ResponsiveBody(
      {Key key, this.navigationRailEnabled, this.navigationRail, this.body})
      : super(key: key);

  final bool navigationRailEnabled;
  final Widget navigationRail;
  final Widget body;

  @override
  Widget build(BuildContext context) => navigationRailEnabled
      ? SafeArea(
          child: Row(
            children: <Widget>[
              navigationRail,
              const VerticalDivider(width: 0),
              Expanded(child: body),
            ],
          ),
        )
      : body;
}

class _NavigationRail extends StatelessWidget {
  /// Creates a side navigation bar for lateral navigation between pages. Useful
  /// for landscape/tablet layouts.
  const _NavigationRail({
    Key key,
    @required this.page,
    @required this.onPageChanged,
    @required this.isMobile,
    @required this.icons,
  }) : super(key: key);

  final _Page page;
  final Function(_Page) onPageChanged;
  final bool isMobile;
  final List<IconData> icons;

  List<Widget> buttons() {
    final List<Widget> itemList = <Widget>[];

    /// Type safe method for generating a list of icons based on the indexing of
    /// the [_Page] enum
    for (_Page page in _Page.values) {
      itemList.add(
        _SideNavItem(
          icon: icons[page.index],
          page: page,
          onTap: onPageChanged,
          selected: this.page == page,
        ),
      );
    }
    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      child: Material(
        color: Theme.of(context).bottomAppBarColor,
        child: Column(
          mainAxisAlignment: isMobile
              ? MainAxisAlignment.spaceEvenly
              : MainAxisAlignment.start,
          children: buttons(),
        ),
      ),
    );
  }
}

class _SideNavItem extends StatelessWidget {
  const _SideNavItem({
    Key key,
    @required this.page,
    @required this.icon,
    @required this.onTap,
    @required this.selected,
  }) : super(key: key);

  final _Page page;
  final IconData icon;
  final Function(_Page) onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: selected
            ? Theme.of(context).accentColor
            : Theme.of(context).colorScheme.onSurface,
      ),
      onPressed: () => onTap(page),
    );
  }
}
