import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_switcher.dart';
import 'setting_item.dart';

class ToggleThemeSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final switcher = context.watch<ThemeSwitcher>();

    return SettingItem(
      iconPath: 'assets/icons/contrast_switch.svg',
      label: switcher.isDark ? 'Mode sombre' : 'Mode clair',
      value: switcher.isDark,
      onChanged: (_) => switcher.toggleThemeMode(),
    );
  }
}
