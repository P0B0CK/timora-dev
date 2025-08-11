// lib/ui/molecules/loader.dart
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:timora/theme/colors_extension.dart';
import 'package:timora/ui/atoms/logo_full.dart';

/// Molécule de chargement Timora (par défaut plein écran).
/// - Logo centré (icône au-dessus, texte dessous)
/// - InkDrop dans le tiers inférieur de l'écran
class AppLoader extends StatelessWidget {
  /// Taille du logo (SVG). Le texte s’adapte (≈ 0.45x).
  final double logoHeight;

  /// Taille du loader InkDrop.
  final double inkDropSize;

  /// Espace entre le bloc logo (centre) et la zone basse.
  final double gapBetweenLogoAndLoader;

  /// Espace immédiat au-dessus du loader (affine la position).
  final double loaderTopGap;

  /// Plein écran (Scaffold) ou contenu embarqué.
  final bool fullscreen;

  const AppLoader({
    super.key,
    this.logoHeight = 64,
    this.inkDropSize = 38,
    this.gapBetweenLogoAndLoader = 48,
    this.loaderTopGap = 24,
    this.fullscreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme    = Theme.of(context);
    final tokens   = theme.extension<AppColors>();
    final primary  = tokens?.primary ?? theme.colorScheme.primary;

    final logoBlock = LogoFull(
      height: logoHeight,
      stacked: true,   // icône au-dessus, texte “TIMORA” dessous
      spacing: 10,
    );

    final loaderBlock = LoadingAnimationWidget.inkDrop(
      color: primary,
      size: inkDropSize,
    );

    final content = SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Spacer(flex: 2),         // pousse le logo vers le centre
            Center(child: logoBlock),
            SizedBox(height: gapBetweenLogoAndLoader),
            const Spacer(flex: 1),         // garde le loader dans le tiers inférieur
            SizedBox(height: loaderTopGap),
            Center(child: loaderBlock),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );

    if (fullscreen) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: content,
      );
    }
    return content;
  }
}
