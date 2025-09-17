// lib/utils/date_utils.dart
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String formatMonthName(BuildContext context, DateTime date) {
  final loc = Localizations.localeOf(context).toString();
  String name = DateFormat.MMMM(loc).format(date);
  name = '${name[0].toUpperCase()}${name.substring(1)}';

  if (name.length > 5) {
    return '${name.substring(0, 3)}.';
  }
  return name;
}
