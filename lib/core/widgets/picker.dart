import 'package:flutter/material.dart';

class Picker {
  static Future<DateTime?> pickDate(
    BuildContext context, {
    DateTime? minTime,
    DateTime? maxTime,
    bool showTitleActions = true,
    DateTime? currentTime,
    Locale? locale = const Locale('id', 'ID'),
    bool Function(DateTime)? selectableDayPredicate,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
  }) async {
    final currentTimeDefault = DateTime.now();
    final minTimeDefault = DateTime(1900);
    final maxTimeDefault = currentTimeDefault;
    final firstDate = minTime ?? minTimeDefault;
    final lastDate = maxTime ?? maxTimeDefault;

    DateTime initialDate = currentTime ?? currentTimeDefault;
    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    } else if (initialDate.isAfter(lastDate)) {
      initialDate = lastDate;
    }

    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: locale,
      selectableDayPredicate: selectableDayPredicate,
      initialDatePickerMode: initialDatePickerMode,
    );
  }

  static Future<TimeOfDay> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return picked ?? TimeOfDay.now();
  }
}
