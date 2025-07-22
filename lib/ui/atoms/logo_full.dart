import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoFull extends StatelessWidget {
  final double height;

  const LogoFull({super.key, this.height = 40});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/logo_timora.svg',
          height: height,
          color: primaryColor,
        ),
        const SizedBox(width: 2),
        Text(
          'TIMORA',
          style: GoogleFonts.spectral(
            fontSize: height * 0.45,
            letterSpacing: 0.8,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}
