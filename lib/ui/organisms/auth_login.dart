// lib/ui/organisms/auth_login.dart
import 'package:flutter/material.dart';
import 'package:timora/ui/atoms/logo_full.dart';
import 'package:timora/ui/atoms/button.dart';
import 'package:timora/theme/colors_extension.dart';

class AuthLoginPage extends StatefulWidget {
  const AuthLoginPage({super.key});

  @override
  State<AuthLoginPage> createState() => _AuthLoginPageState();
}

class _AuthLoginPageState extends State<AuthLoginPage> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  double _scale = 0.985;

  @override
  void initState() {
    super.initState();
    // lance l’anim après le premier frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final tokens = theme.extension<AppColors>();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom; // clavier

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            // Rectangle centré, allongé & responsive
            final shortest   = c.biggest.shortestSide;
            final cardWidth  = (shortest * 0.72).clamp(340.0, 520.0).toDouble();
            final cardHeight = (cardWidth * 1.35).clamp(440.0, 740.0).toDouble();

            // Logo auto-dimensionné par rapport à la largeur
            final logoHeight = (cardWidth * 0.15).clamp(52.0, 92.0).toDouble();

            // Spacings
            const double vPad = 38;
            const double hPad = 28;
            const double gapLogoToSlogan  = 24;
            const double gapAboveDivider  = 46;
            const double gapBelowDivider  = 46;
            const double gapBetweenButtons = 16;

            final card = Semantics(
              label: 'Écran d’authentification',
              child: SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: tokens?.surface ?? theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: tokens?.outline ?? theme.dividerColor,
                      width: 1.2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: vPad, horizontal: hPad),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo empilé (icône au-dessus, texte dessous)
                        Semantics(
                          header: true,
                          child: LogoFull(height: logoHeight, stacked: true, spacing: 8),
                        ),
                        const SizedBox(height: gapLogoToSlogan),

                        // Slogan
                        Text(
                          "L’agenda qui respire",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: (tokens?.onSurface ?? theme.colorScheme.onSurface).withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                            letterSpacing: .8,
                          ),
                        ),

                        const SizedBox(height: gapAboveDivider),

                        Divider(
                          color: tokens?.divider ?? theme.dividerColor,
                          height: 1,
                          thickness: 1,
                        ),

                        const SizedBox(height: gapBelowDivider),

                        // CTA Connexion
                        AppButton(
                          label: 'Se connecter',
                          type: ButtonType.primary,
                          onPressed: () => Navigator.of(context).pushNamed('/login'),
                        ),

                        const SizedBox(height: gapBetweenButtons),

                        // CTA Inscription
                        AppButton(
                          label: 'S’enregistrer',
                          type: ButtonType.outlined,
                          onPressed: () => Navigator.of(context).pushNamed('/register'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );

            // Scroll-safe + centrage, avec padding bas quand le clavier est ouvert
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset + 16 : 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: c.maxHeight - 24),
                child: Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    opacity: _opacity,
                    child: AnimatedScale(
                      scale: _scale,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      child: card,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
