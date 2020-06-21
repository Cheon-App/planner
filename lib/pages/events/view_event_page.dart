// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_html/flutter_html.dart';

// Project imports:
import 'package:cheon/app.dart';
import 'package:cheon/url_launcher.dart';
import 'package:cheon/widgets/status_bar_theme.dart';
import 'package:cheon/models/calendar_event.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/widgets/raised_body.dart';
import 'package:cheon/core/dates/date_utils.dart';

class ViewEventPage extends StatelessWidget {
  const ViewEventPage({Key key, @required this.event}) : super(key: key);
  static const String routeName = '/event';
  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return StatusBarTheme(
      brightness: Brightness.dark,
      child: Material(
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          children: [
            _Background(event: event),
            Expanded(
              child: RaisedBody(
                child: ListView(
                  primary: false,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  children: [
                    _Description(description: event.description),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: _Location(
                        location: event.location,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({Key key, @required this.event}) : super(key: key);

  final CalendarEvent event;

  void _openURL() => launchUrl(event.uri.toString());

  @override
  Widget build(BuildContext context) {
    final dateString =
        MaterialLocalizations.of(context).formatShortDate(event.start);
    final timeString =
        MaterialLocalizations.of(context).formatTimeOfDay(event.start.time);
    final bool hasUrl = event.uri != null;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 30,
                      color: context.colorScheme.onSecondary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: Icon(
                    Icons.close,
                    color: context.colorScheme.onSecondary,
                  ),
                  tooltip: 'Close',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  color: context.colorScheme.secondaryVariant,
                  borderRadius: BorderRadius.circular(App.borderRadius),
                  elevation: 8,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      '$dateString, $timeString',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: context.colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.link),
                  tooltip: 'Link',
                  color: context.colorScheme.onSecondary,
                  onPressed: hasUrl ? _openURL : null,
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    Key key,
    @required this.description,
  }) : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Description',
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: context.colorScheme.secondary),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Html(
            data: description,
            onLinkTap: launchUrl,
          ),
        ),
      ],
    );
  }
}

class _Location extends StatelessWidget {
  const _Location({Key key, @required this.location}) : super(key: key);
  final String location;

  @override
  Widget build(BuildContext context) {
    final bool hasLocation = location?.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Location',
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: context.colorScheme.secondary),
        ),
        if (hasLocation)
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FaIcon(
                      FontAwesomeIcons.mapMarkerAlt,
                      size: 16,
                    ),
                  ),
                ),
                TextSpan(text: location),
              ],
            ),
          )
        else
          Text('No Location.'),
      ],
    );
  }
}
