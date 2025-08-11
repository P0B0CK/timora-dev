import 'package:flutter/material.dart';

/// ================================
///  PALETTE DE COULEURS DES THÈMES
/// ================================
@immutable
class TimoraPalette {
  final Color backgroundColor;  // Fond principal
  final Color primaryColor;     // Couleur principale
  final Color secondaryColor;   // Couleur secondaire
  final Color tertiaryColor;    // Accent ou surlignage
  final Color textColorWhite;   // Couleur de texte principale
  final Color textColorBlack;   // Couleur de texte secondaire

  const TimoraPalette({
    required this.backgroundColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.textColorWhite,
    required this.textColorBlack,
  });
}

/// Palette principale "Timora Classic"
const timoraClassic = TimoraPalette(
  backgroundColor: Color(0xFF22112A),       // violetNight
  primaryColor: Color(0xFF00FFAA),          // greenLight
  secondaryColor: Color(0xFF73246B),        // violetMyth
  tertiaryColor: Color(0xFF61C9A8),         // greenMint
  textColorWhite: Color(0xFFFFFFFF),        // whitePure
  textColorBlack: Color(0xFF000000),        // blackPure
);

/// Palette alternative noir & blanc
const timoraTwinBW = TimoraPalette(
  backgroundColor: Color(0xFF000000), // blackBasic
  primaryColor: Color(0xFFCCCCCC),    // greySilver
  secondaryColor: Color(0xFF888888),  // greyTitane
  tertiaryColor: Color(0xFF444444),   // greyGraphite
  textColorWhite: Color(0xFFFFFFFF),       // whitePure
  textColorBlack: Color(0xFF000000),        // blackPure
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
  success: Color(0xA863FF6A), // vert
  error: Color(0xDAFF4545),   // rouge
  warning: Color(0xFFEAA54C), // orange
  info: Color(0xFF60819A),    // bleu
);
