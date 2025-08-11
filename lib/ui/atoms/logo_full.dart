// lib/ui/atoms/logo_full.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timora/theme/theme_tokens.dart';

class LogoFull extends StatelessWidget {
  final double height;

  const LogoFull({super.key, this.height = 40});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<TimoraTokens>();

    // 🎯 Couleur = couleur primaire de la palette (gérée par le ThemeManager)
    final Color logoColor = tokens?.primary ?? theme.colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/logo_timora.svg',
          height: height,
          colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
        ),
        const SizedBox(width: 2),
        Text(
          'TIMORA',
          style: GoogleFonts.spectral(
            fontSize: height * 0.45,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w600,
            color: logoColor,
          ),
        ),
      ],
    );
  }
}
