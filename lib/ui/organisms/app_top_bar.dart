import 'package:flutter/material.dart';
import '../atoms/logo_full.dart';
import '../../env.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  Color _autoOn(Color bg) =>
      bg.computeLuminance() > 0.5 ? const Color(0xDD000000) : Colors.white;

  @override
  Widget build(BuildContext context) {
    final env = AppConfig.instance.env;

    // Couleurs du badge env
    final Color badgeBg = switch (env) {
      AppEnvironment.dev => const Color(0xFF2E7D32),    // green 800
      AppEnvironment.staging => const Color(0xFFEF6C00),// orange 800
      AppEnvironment.prod => Colors.transparent,
    };
    final Color badgeFg = _autoOn(badgeBg);

    return AppBar(
      titleSpacing: 0,
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
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: badgeFg),
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
