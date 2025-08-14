// lib/ui/organisms/app_top_bar.dart
import 'package:flutter/material.dart';
import '../atoms/logo_full.dart';
import '../../env.dart';
import 'package:timora/theme/colors_extension.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  Color _autoOn(Color bg) =>
      bg.computeLuminance() > 0.5 ? const Color(0xDD000000) : Colors.white;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final tokens = theme.extension<AppColors>();
    final env    = AppConfig.instance.env;
    final Color bg = tokens?.background ?? theme.colorScheme.background;
    final Color fg = tokens?.onBackground ?? theme.colorScheme.onBackground;

    // BADGES ENVIRONMENTS
    final Color badgeBg = switch (env) {
      AppEnvironment.dev     => const Color(0xFF79BD7D),
      AppEnvironment.staging => const Color(0xFFDC944B),
      AppEnvironment.prod    => Colors.transparent,
    };
    final Color badgeFg = _autoOn(badgeBg);

    return AppBar(
      titleSpacing: 0,
      backgroundColor: bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: fg,
      iconTheme: IconThemeData(color: fg),
      titleTextStyle: theme.textTheme.titleLarge?.copyWith(color: fg),
      title: const Padding(
        padding: EdgeInsets.only(left: 12),
        child: LogoFull(height: 34),
      ),
      actions: [
        if (env != AppEnvironment.prod)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Chip(
              label: Text(
                env == AppEnvironment.dev ? 'DEV' : 'STAGING',
                style: theme.textTheme.labelLarge?.copyWith(color: badgeFg),
              ),
              backgroundColor: badgeBg,
              side: BorderSide.none,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
