import 'package:flutter/material.dart';

/// =======================
///  PALETTE DE BASE THÈME
/// =======================
@immutable
class TimoraPalette {
  final Color backgroundColor; // Fond principal
  final Color primaryColor;    // Couleur principale
  final Color secondaryColor;  // Couleur secondaire
  final Color tertiaryColor;   // Accent ou surlignage
  final Color textColor;       // Couleur de texte par défaut

  const TimoraPalette({
    required this.backgroundColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.textColor,
  });
}

/// Exemple : palette principale "Timora Classic"
const timoraClassic = TimoraPalette(
  backgroundColor: Color(0xFF22112A), // violetNight
  primaryColor: Color(0xFF00FFAA),    // greenLight
  secondaryColor: Color(0xFF73246B),  // violetMyth
  tertiaryColor: Color(0xFF61C9A8),   // greenMint
  textColor: Color(0xFFFFFFFF),       // whitePure
);

/// Exemple : palette alternative noir & blanc
const timoraTwinBW = TimoraPalette(
  backgroundColor: Color(0xFF000000), // blackBasic
  primaryColor: Color(0xFFCCCCCC),    // greySilver
  secondaryColor: Color(0xFF888888),  // greyTitane
  tertiaryColor: Color(0xFF444444),   // greyGraphite
  textColor: Color(0xFFFFFFFF),       // whitePure
);

/// =======================
///  PALETTE DE FEEDBACK
/// =======================
@immutable
class FeedbackPalette {
  final Color success;
  final Color error;
  final Color warning;
  final Color info;

  const FeedbackPalette({
    required this.success,
    required this.error,
    required this.warning,
    required this.info,
  });
}

const defaultFeedback = FeedbackPalette(
  success: Color(0xFF4CAF50), // vert
  error: Color(0xFFF44336),   // rouge
  warning: Color(0xFFFF9800), // orange
  info: Color(0xFF2196F3),    // bleu
);

/// =======================
///  COULEURS ACCENT
/// =======================
/// Liste de couleurs interchangeables (personnalisation)
const accentChoices = [
  Color(0xFF00FFAA), // greenLight
  Color(0xFF73246B), // violetMyth
  Color(0xFFFF4081), // pinkFlash
  Color(0xFF2196F3), // blueOcean
  Color(0xFFFFC107), // amberSun
];
