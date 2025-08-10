// FRONTEND
// lib/settings/widgets/setting_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timora/theme/theme_manager.dart';
import 'package:timora/theme/theme_tokens.dart';

/// Élément de réglage avec icône, label et toggle switch
class SettingItem extends StatelessWidget {
  final String iconPath;               // 🖼️ Icône SVG
  final String label;                  // 📝 Texte
  final bool value;                    // ✅ État actuel
  final ValueChanged<bool>? onChanged; // 🔄 Callback (nullable => désactivable)

  // Options UX
  final String? subtitle;              // texte sous le label
  final bool enabled;                  // état visuel/interaction
  final EdgeInsetsGeometry padding;    // padding du row
  final VoidCallback? onTapRow;        // toggle en tapant la ligne entière

  const SettingItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.enabled = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.onTapRow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<TimoraTokens>();

    final Color accent = tokens?.primary ?? theme.colorScheme.primary;
    final Color accentMuted = (tokens?.tertiary ?? theme.colorScheme.secondary).withOpacity(0.3);
    final Color textOn = theme.colorScheme.onSurface;

    // Désactivé si pas d’onChanged ou enabled = false
    final bool isInteractive = enabled && onChanged != null;

    return MergeSemantics(
      child: Opacity(
        opacity: isInteractive ? 1 : 0.5,
        child: InkWell(
          onTap: isInteractive
              ? () {
            // tap sur la ligne entière → toggle
            onTapRow?.call();
            onChanged?.call(!value);
          }
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: padding,
            child: Row(
              children: [
                // 🎨 Icône SVG colorée dynamiquement
                SvgPicture.asset(
                  iconPath,
                  width: 28,
                  height: 28,
                  colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
                ),
                const SizedBox(width: 16),

                // 📝 Label (+ sous-titre optionnel)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: (theme.textTheme.bodyLarge ?? const TextStyle())
                            .copyWith(color: textOn, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: (theme.textTheme.bodyMedium ?? const TextStyle())
                              .copyWith(color: textOn.withOpacity(0.75)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // 🎚️ Switch avec couleurs thématiques
                IgnorePointer(
                  ignoring: !isInteractive, // bloque l'interaction si désactivé
                  child: Switch.adaptive(
                    value: value,
                    onChanged: onChanged, // peut être null
                    trackColor: MaterialStateProperty.resolveWith((states) {
                      final selected = states.contains(MaterialState.selected);
                      return selected ? accent.withOpacity(0.5) : accentMuted;
                    }),
                    thumbColor: MaterialStateProperty.resolveWith((states) {
                      final selected = states.contains(MaterialState.selected);
                      return selected ? accent : (tokens?.tertiary ?? theme.colorScheme.secondary);
                    }),
                    trackOutlineColor: MaterialStateProperty.resolveWith((states) {
                      final selected = states.contains(MaterialState.selected);
                      return selected ? null : (tokens?.tertiary ?? theme.colorScheme.secondary);
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
