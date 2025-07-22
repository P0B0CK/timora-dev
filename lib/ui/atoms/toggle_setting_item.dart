import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ToggleSettingItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ToggleSettingItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: SvgPicture.asset(
        iconPath,
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(
          theme.colorScheme.primary,
          BlendMode.srcIn,
        ),
      ),
      title: Text(label, style: theme.textTheme.bodyLarge),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
