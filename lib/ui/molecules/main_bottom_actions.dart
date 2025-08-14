// lib/ui/molecules/main_bottom_actions.dart
import 'package:flutter/material.dart';
import '../atoms/icon.dart';

class MainBottomActions extends StatelessWidget {
  final VoidCallback? onPrev;
  final VoidCallback? onProfile;
  final VoidCallback? onNext;
  final bool isExpanded;
  final VoidCallback? onToggle;

  const MainBottomActions({
    super.key,
    this.onPrev,
    this.onProfile,
    this.onNext,
    this.isExpanded = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final row = <Widget>[
      AppIcon(
        assetName: 'assets/icons/arrow_left.svg',
        style: AppIconStyle.alone,
        size: 42,
        tooltip: 'Précédent',
        onPressed: onPrev,
      ),
      const SizedBox(width: 16),
      AppIcon(
        assetName: 'assets/icons/account_profile.svg',
        style: AppIconStyle.alone,
        size: 52,
        tooltip: 'Profil',
        onPressed: onProfile,
      ),
      const SizedBox(width: 16),
      AppIcon(
        assetName: 'assets/icons/arrow_right.svg',
        style: AppIconStyle.alone,
        size: 42,
        tooltip: 'Suivant',
        onPressed: onNext,
      ),
    ];

    if (onToggle != null) {
      row.addAll([
        const SizedBox(width: 18),
        AnimatedRotation(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          turns: isExpanded ? 0.25 : 0,
          child: AppIcon(
            assetName: 'assets/icons/more_vert.svg',
            style: AppIconStyle.alone,
            size: 36,
            tooltip: isExpanded ? 'Rétracter' : 'Déployer',
            onPressed: onToggle,
          ),
        ),
      ]);
    }

    return Row(mainAxisSize: MainAxisSize.min, children: row);
  }
}
