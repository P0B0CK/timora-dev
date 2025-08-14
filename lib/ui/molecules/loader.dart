// lib/ui/molecules/loader.dart
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:timora/theme/colors_extension.dart';
import 'package:timora/ui/atoms/logo_full.dart';


class AppLoader extends StatelessWidget {
  final double logoHeight;
  final double inkDropSize;
  final double gapBetweenLogoAndLoader;
  final double loaderTopGap;
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
            const Spacer(flex: 2),
            Center(child: logoBlock),
            SizedBox(height: gapBetweenLogoAndLoader),
            const Spacer(flex: 1),
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
