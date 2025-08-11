// lib/theme/theme_model.dart
import 'package:flutter/foundation.dart';
import 'colors.dart';

@immutable
class ThemeModel {
  final String id;
  final String duoId;      // identifiant partagé entre light/dark
  final String name;
  final bool isDark;
  final bool isPremium;
  final TimoraPalette palette;
  final FeedbackPalette feedback; // on garde feedback configurable

  const ThemeModel({
    required this.id,
    required this.duoId,
    required this.name,
    required this.isDark,
    required this.isPremium,
    required this.palette,
    this.feedback = defaultFeedback,
  });
}

const List<ThemeModel> themeCatalog = [
  ThemeModel(
    id: 'classic-dark',
    duoId: 'classic',
    name: 'Classic Dark',
    isDark: true,
    isPremium: false,
    palette: timoraClassic,
  ),
  ThemeModel(
    id: 'classic-light',
    duoId: 'classic',
    name: 'Classic Light',
    isDark: false,
    isPremium: false,
    palette: timoraClassic,
  ),
  // (exemple si tu veux mixer) : variantes twin BW
  ThemeModel(
    id: 'twinbw-dark',
    duoId: 'twinbw',
    name: 'Twin Black & White Dark',
    isDark: true,
    isPremium: false,
    palette: timoraTwinBW,
  ),
  ThemeModel(
    id: 'twinbw-light',
    duoId: 'twinbw',
    name: 'Twin Black & White Light',
    isDark: false,
    isPremium: false,
    palette: timoraTwinBW,
  ),
];
