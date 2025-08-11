import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timora/theme/colors_extension.dart';
import 'package:timora/theme/fonts.dart';

class LogoFull extends StatelessWidget {
  final double height;
  /// Si true, affiche le logo en colonne : icône au-dessus, texte dessous.
  final bool stacked;
  final double spacing;

  const LogoFull({
    super.key,
    this.height = 40,
    this.stacked = false,
    this.spacing = 6,
  });

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final tokens = theme.extension<AppColors>();
    final Color logoColor = tokens?.primary ?? theme.colorScheme.primary;

    final icon = SvgPicture.asset(
      'assets/logo_timora.svg',
      height: height,
      colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
    );

    final text = Text(
      'TIMORA',
      textAlign: TextAlign.center,
      style: TimoraTextStyles.headlineMedium.copyWith(
        fontSize: height * 0.45,
        letterSpacing: 0.8,
        fontWeight: FontWeight.w600,
        color: logoColor,
      ),
    );

    if (stacked) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(height: spacing),
          text,
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: spacing),
        text,
      ],
    );
  }
}
