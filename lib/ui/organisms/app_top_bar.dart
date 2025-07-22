import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_manager.dart';
import '../atoms/logo_full.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = context.watch<ThemeManager>();
    final currentTheme = themeManager.currentTheme;

    return AppBar(
      titleSpacing: 0,
      title: const Padding(
        padding: EdgeInsets.only(left: 12),
        child: LogoFull(height: 34),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
