import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/timora_colors.dart';

class SettingItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<TimoraColors>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Icône SVG
          SvgPicture.asset(
            iconPath,
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 16),

          // Texte
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Toggle avec couleurs dynamiques
          Switch(
            value: value,
            onChanged: onChanged,
            trackColor: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.selected)
                  ? colors?.toggleTrackActive
                  : colors?.toggleTrackInactive;
            }),
            thumbColor: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.selected)
                  ? colors?.toggleThumbActive
                  : colors?.toggleThumbInactive;
            }),
            trackOutlineColor: WidgetStateProperty.resolveWith((states) {
              if (!states.contains(WidgetState.selected)) {
                return colors?.toggleOutlineInactive;
              }
              return null;
            }),
          ),
        ],
      ),
    );
  }
}
