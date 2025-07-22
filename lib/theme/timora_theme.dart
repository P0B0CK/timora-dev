import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'timora_colors.dart';

class TimoraTheme {
  // 🎨 Thème sombre (par défaut)
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF22112A), // fond sombre
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00FFAA), // titres
        onPrimary: Colors.white,
        surface: Color(0xFF22112A),
        onSurface: Colors.white, // textes
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spectral(
          fontSize: 80,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00FFAA),
        ),
        headlineMedium: GoogleFonts.spectral(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Color(0xFF00FFAA),
        ),
        titleMedium: GoogleFonts.quicksand(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        labelLarge: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      extensions: const [
        TimoraColors(
            roundedBackground: Color(0xFF00FFAA),
            iconColor: Color(0xFF22112A),
            toggleTrackActive: Color(0xFF00FFAA),       // pour mode sombre actif
            toggleThumbActive: Color(0xFF73246B),       // cercle actif
            toggleTrackInactive: Color(0xFF61C9A8),     // fond mint mode clair
            toggleThumbInactive: Color(0xFF73246B),     // cercle violet clair mode clair
            toggleOutlineInactive: Color(0xFF73246B),
        ),
      ],
    );
  }

  // ☀️ Thème clair corrigé
  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFF61C9A8), // fond clair
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF73246B), // titres
        onPrimary: Colors.white,
        surface: Color(0xFF61C9A8),
        onSurface: Colors.black, // ✅ textes noirs sur fond clair
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spectral(
          fontSize: 60,
          fontWeight: FontWeight.bold,
          color: Color(0xFF73246B),
        ),
        headlineMedium: GoogleFonts.spectral(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Color(0xFF73246B),
        ),
        titleMedium: GoogleFonts.quicksand(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black, // ✅ titres lisibles sur clair
        ),
        bodyLarge: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black, // ✅ texte lisible sur clair
        ),
        labelLarge: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black, // ✅ labels lisibles sur clair
        ),
      ),
      extensions: const [
        TimoraColors(
            roundedBackground: Color(0xFF73246B),
            iconColor: Color(0xFF61C9A8),
            toggleTrackActive: Color(0xFF00FFAA),       // pour mode sombre actif
            toggleThumbActive: Color(0xFF73246B),       // cercle actif
            toggleTrackInactive: Color(0xFF61C9A8),     // fond mint mode clair
            toggleThumbInactive: Color(0xFF73246B),
            toggleOutlineInactive: Color(0xFF73246B),
        ),
      ],
    );
  }

  // 🖤 Thème Black Twin
  static ThemeData get blacktwin {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      // fond noir
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white, // titres en blanc
        onPrimary: Colors.black, // texte sur élément primaire
        surface: Colors.black, // surface noire
        onSurface: Colors.white, // textes
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spectral(
          fontSize: 80,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.spectral(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.quicksand(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        labelLarge: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      extensions: const [
        TimoraColors(
          roundedBackground: Colors.white,
          iconColor: Colors.black,
          toggleTrackActive: Color(0xFF00FFAA),
          toggleThumbActive: Colors.white,
          toggleTrackInactive: Colors.white,
          toggleThumbInactive: Colors.white,
          toggleOutlineInactive: Colors.white,
        ),
      ],
    );
  }

    // 🤍 Thème White Twin
    static ThemeData get whitetwin {
      return ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white, // fond blanc
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Colors.black,    // titres en noir
          onPrimary: Colors.white,  // texte sur élément primaire
          surface: Colors.white,    // surface blanche
          onSurface: Colors.black,  // textes en noir
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.spectral(
            fontSize: 80,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headlineMedium: GoogleFonts.spectral(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          titleMedium: GoogleFonts.quicksand(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          bodyLarge: GoogleFonts.rubik(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          labelLarge: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        extensions: const [
          TimoraColors(
            roundedBackground: Colors.black, // cercle foncé
            iconColor: Colors.white,
            toggleTrackActive: Color(0xFF00FFAA),
            toggleThumbActive: Colors.black,
            toggleTrackInactive: Colors.black,
            toggleThumbInactive: Colors.black,
            toggleOutlineInactive: Colors.black,
          ),
        ],
      );
    }
}
