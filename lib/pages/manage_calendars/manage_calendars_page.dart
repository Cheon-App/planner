import 'package:cheon/constants.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/calendar.dart';
import 'package:cheon/models/calendar_group.dart';
import 'package:cheon/services/calendar_service/calendar_service.dart';
import 'package:cheon/view_models/calendar_view_model.dart';
import 'package:cheon/view_models/settings_view_model.dart';
import 'package:cheon/widgets/empty_placeholder.dart';
import 'package:cheon/widgets/top_of_scrollable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageCalendarsPage extends StatefulWidget {
  static const String routeName = '/manage_calendars';

  @override
  _ManageCalendarsPageState createState() => _ManageCalendarsPageState();
}

class _ManageCalendarsPageState extends State<ManageCalendarsPage> {
  final _calendarService = container<CalendarService>();
  bool _showElevation = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasPermission = await _calendarService.handlePermissions();
      if (hasPermission ?? false) {
        final calendarVM = context.read<CalendarVM>();
        calendarVM.fetchCalendars();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TopOfScrollable(
      atTop: () => setState(() => _showElevation = false),
      notAtTop: () => setState(() => _showElevation = true),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Calendars'),
          bottom: _ImportCalendarToggle(),
          elevation: _showElevation ? 8 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
        ),
        body: _SelectCalendars(),
      ),
    );
  }
}

class _ImportCalendarToggle extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final settingsVM = context.watch<SettingsVM>();
    return SwitchListTile.adaptive(
      onChanged: (bool value) => settingsVM.importCalendarEvents = value,
      value: settingsVM.importCalendarEvents,
      title: const Text('Import calendar events'),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}

class _SelectCalendars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final calendarVM = context.watch<CalendarVM>();
    return calendarVM.calendarGroups.when(
      loading: () => _Loading(),
      data: (groups) => _CalendarGroupList(groups: groups),
      noPermission: () => _NoPermission(),
    );
  }
}

class _CalendarGroupList extends StatelessWidget {
  const _CalendarGroupList({Key key, @required this.groups}) : super(key: key);
  final List<CalendarGroup> groups;

  @override
  Widget build(BuildContext context) {
    final settingsVM = context.watch<SettingsVM>();
    if (settingsVM.importCalendarEvents) {
      return ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return _CalendarGroup(group: group);
        },
      );
    } else {
      return EmptyPlaceholder(
        svgPath: IMG_CALENDAR,
        text: '',
      );
    }
  }
}

class _CalendarGroup extends StatelessWidget {
  const _CalendarGroup({Key key, @required this.group}) : super(key: key);
  final CalendarGroup group;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            group.name.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        ...group.calendars.map((c) => _CalendarToggle(calendar: c))
      ],
    );
  }
}

class _CalendarToggle extends StatelessWidget {
  const _CalendarToggle({Key key, @required this.calendar}) : super(key: key);
  final Calendar calendar;

  void _onChanged(BuildContext context, bool selected) {
    final calendarVM = context.read<CalendarVM>();
    if (selected) {
      calendarVM.selectCalendar(calendar);
    } else {
      calendarVM.deselectCalendar(calendar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final calendarVM = context.watch<CalendarVM>();
    return CheckboxListTile(
      value: calendarVM.calendarIsSelected(calendar),
      title: Text(calendar.name),
      onChanged: (selected) => _onChanged(context, selected),
    );
  }
}

class _NoPermission extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyPlaceholder(
      svgPath: IMG_CALENDAR,
      text: 'Calendar Permission Required.',
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) => EmptyPlaceholder(
        svgPath: IMG_CALENDAR,
        text: '',
      );
}
