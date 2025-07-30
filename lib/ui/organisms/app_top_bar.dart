import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_manager.dart';
import '../atoms/logo_full.dart';
import '../../env.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = context.watch<ThemeManager>();
    final currentTheme = themeManager.currentTheme;
    final env = AppConfig.instance.env;

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
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: env == AppEnvironment.dev
                  ? Colors.green
                  : Colors.orange,
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
