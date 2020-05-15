import 'package:cheon/components/platform_date_time_picker.dart';
import 'package:cheon/components/primary_action_button.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/view_models/year_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddYearPage extends StatelessWidget {
  static const String routeName = '/add_year';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Year')),
      body: _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  DateTime start = DateTime.now();
  DateTime end = DateTime.now().add(const Duration(days: 365));
  bool createTerms = true;

  void setStartDate() {
    showPlatformDatePicker(
      context: context,
      initialDate: start,
    ).listen(
      (DateTime date) {
        if (date != null) {
          setState(() => start = date);
        }
      },
    );
  }

  void setEndDate() {
    showPlatformDatePicker(
            context: context,
            initialDate: end,
            maximumDate: DateTime.now().add(const Duration(days: 365 * 5)))
        .listen(
      (DateTime date) {
        if (date != null) {
          setState(() => end = date);
        }
      },
    );
  }

  void setCreateTerms(bool value) {
    if (value == null) return;
    setState(() {
      createTerms = value;
    });
  }

  Future<void> addYear() {
    final YearVM yearVM = context.read<YearVM>();
    Navigator.pop(context);
    return yearVM.addYear(
      start: start,
      end: end,
      createTerms: createTerms,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Column(
        children: <Widget>[
          // Start/End selection
          Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: const Text('Start'),
                  trailing: Text(
                    MaterialLocalizations.of(context).formatFullDate(start),
                  ),
                  onTap: setStartDate,
                ),
                const Divider(height: 0),
                ListTile(
                  title: const Text('End'),
                  trailing: Text(
                    MaterialLocalizations.of(context).formatFullDate(end),
                  ),
                  onTap: setEndDate,
                ),
              ],
            ),
          ),
          // Auto create terms switch
          Card(
            child: SwitchListTile.adaptive(
              title: const Text('Automatically create terms'),
              value: createTerms,
              onChanged: setCreateTerms,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SvgPicture.asset(
                IMG_TERMS,
                alignment: const Alignment(0, -0.4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryActionButton(
              text: 'ADD',
              onTap: addYear,
            ),
          ),
        ],
      ),
    );
  }
}
