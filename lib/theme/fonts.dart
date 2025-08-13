// lib/theme/fonnts.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimoraTextStyles {
  // GROS TITRES
  // Titres en couleur primary selon le theme choisi
  static final displayLarge = GoogleFonts.spectral(
    fontSize: 80,
    fontWeight: FontWeight.bold,
  );

  // REFERENCE LOGO
  // Titres en couleur primary selon le theme choisi
  static final headlineMedium = GoogleFonts.spectral(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  // TITRES CLASSIQUES
  // Titres en couleur primary selon le theme choisi
  static final titleMedium = GoogleFonts.quicksand(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  // H3, H4 ... Lis
  // Titres en couleur primary selon le theme choisi
  static final bodyLarge = GoogleFonts.rubik(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  // Titres en couleur noir ou blanc selon le theme choisi
  static final labelLarge = GoogleFonts.quicksand(
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );


  static final labelBold = GoogleFonts.quicksand(
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );
}
