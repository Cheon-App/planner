import 'dart:async';

import 'package:cheon/app.dart';
import 'package:cheon/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

/// The default height of popups in IOS's cupertino design language
const double _cupertinoPopupHeight = 216;

/// Displays a material or cupertino themed date picker dialog.
Stream<DateTime> showPlatformDatePicker({
  @required BuildContext context,
  DateTime minimunDate,
  DateTime maximumDate,
  @required DateTime initialDate,
}) async* {
  minimunDate ??= DateTime.now().subtract(const Duration(days: 365));
  maximumDate ??= DateTime.now().add(const Duration(days: 365));
  assert(initialDate != null);

  if (isMaterial(context)) {
    // Shows the material design date picker dialog
    yield await showDatePicker(
      context: context,
      firstDate: minimunDate,
      initialDate: initialDate,
      lastDate: maximumDate,
    );
  } else {
    final StreamController<DateTime> controller =
        StreamController<DateTime>.broadcast();

    // Shows the cupertino date picker
    // ignore: unawaited_futures
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: _cupertinoPopupHeight,
          child: CupertinoDatePicker(
            backgroundColor:
                CupertinoColors.systemBackground.resolveFrom(context),
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime dateTime) => controller.add(dateTime),
            minimumDate: minimunDate,
            initialDateTime: initialDate,
            maximumDate: maximumDate,
          ),
        );
      },
    ).then((_) async {
      await controller.close();
    });
    await for (DateTime dateTime in controller.stream) {
      yield dateTime;
    }
  }
}

/// Displays a material design or cupertino themed time picker.
/// Returns a stream instead of a Future as the cupertino dialog has a
/// callback.
Stream<TimeOfDay> showPlatformTimePicker({
  @required BuildContext context,
  @required TimeOfDay initialTime,
}) async* {
  assert(initialTime != null);

  if (isMaterial(context)) {
    yield await showRoundedTimePicker(
      context: context,
      initialTime: initialTime,
      theme: Theme.of(context),
      borderRadius: App.borderRadius,
    );
  } else {
    final StreamController<TimeOfDay> controller =
        StreamController<TimeOfDay>.broadcast();
    final DateTime initialDateTime = DateTime(
      0,
      0,
      0,
      initialTime.hour,
      initialTime.minute,
    );
    // ignore: unawaited_futures
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: _cupertinoPopupHeight,
          child: CupertinoDatePicker(
            backgroundColor:
                CupertinoColors.systemBackground.resolveFrom(context),
            mode: CupertinoDatePickerMode.time,
            initialDateTime: initialDateTime,
            onDateTimeChanged: (DateTime dateTime) => controller.add(
              TimeOfDay.fromDateTime(dateTime),
            ),
          ),
        );
      },
    ).then((_) async {
      await controller.close();
    });
    await for (TimeOfDay timeOfDay in controller.stream) {
      yield timeOfDay;
    }
  }
}
