import 'package:cheon/components/platform_date_time_picker.dart';
import 'package:cheon/components/primary_action_button.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/models/term.dart';
import 'package:cheon/view_models/year_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AddInsetDayPage extends StatefulWidget {
  /// Creates a page for creating inset days in terms
  const AddInsetDayPage({Key key, @required this.term})
      : assert(term != null),
        super(key: key);

  final Term term;

  static const String routeName = '/add_inset_day';

  @override
  _AddInsetDayPageState createState() => _AddInsetDayPageState();
}

class _AddInsetDayPageState extends State<AddInsetDayPage> {
  DateTime date = DateTime.now();

  Future<void> addInsetDay(BuildContext context) {
    final YearVM yearVM = context.read<YearVM>();
    Navigator.pop(context);
    return yearVM.addInsetDay(widget.term, date: date);
  }

  Future<void> selectDate() async {
    showPlatformDatePicker(context: context, initialDate: date).listen(
      (DateTime date) => date != null ? setState(() => this.date = date) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Inset Day')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                title: const Text('Date'),
                trailing: Text(
                  MaterialLocalizations.of(context).formatMediumDate(date),
                ),
                onTap: selectDate,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SvgPicture.asset(
                  IMG_DEPARTING,
                  alignment: const Alignment(0, -0.4),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: PrimaryActionButton(
                text: 'ADD',
                onTap: () => addInsetDay(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
