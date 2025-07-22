import 'package:flutter/material.dart';

class AppTheme {
  final String id;
  final String name;
  final ThemeData themeData;
  final bool isDark;
  final String? hasBrother;
  final bool isPremium;

  AppTheme({
    required this.id,
    required this.name,
    required this.themeData,
    required this.isDark,
    required this.hasBrother,
    this.isPremium = false,
  });
}