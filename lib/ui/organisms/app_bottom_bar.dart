// lib/ui/organisms/app_bottom_bar.dart
import 'package:flutter/material.dart';
import '../molecules/main_bottom_actions.dart';
import '../molecules/left_column_actions.dart';
import '../molecules/right_column_actions.dart';

class AppBottomBar extends StatefulWidget {
  final VoidCallback? onPrev;
  final VoidCallback? onProfile;
  final VoidCallback? onNext;

  final VoidCallback? onOpenSettings;
  final VoidCallback? onNotifications;
  final VoidCallback? onLogout;

  final VoidCallback? onCreateCalendar;
  final VoidCallback? onCreateEvent;
  final VoidCallback? onManageGroups;
  final VoidCallback? onShare;

  const AppBottomBar({
    super.key,
    this.onPrev,
    this.onProfile,
    this.onNext,
    this.onOpenSettings,
    this.onNotifications,
    this.onLogout,
    this.onCreateCalendar,
    this.onCreateEvent,
    this.onManageGroups,
    this.onShare,
  });

  @override
  State<AppBottomBar> createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar> {
  bool _expanded = true; // démarrage déployé (ajustez si besoin)

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    // Pas d’ombre ni box : on s’appuie uniquement sur la couleur de fond de l’app.
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end, // aligner les colonnes en bas
          children: [
            // Colonne gauche (flottante, animée)
            LeftColumnActions(
              onOpenSettings: widget.onOpenSettings ?? () => debugPrint('open settings'),
              onNotifications: widget.onNotifications ?? () => debugPrint('open notifications'),
              onLogout: widget.onLogout ?? () => debugPrint('logout'),
              expanded: _expanded,
            ),

            // Bloc central : prev / profile / next / more (toggle)
            MainBottomActions(
              onPrev: widget.onPrev ?? () => debugPrint('prev'),
              onProfile: widget.onProfile ?? () => debugPrint('profile'),
              onNext: widget.onNext ?? () => debugPrint('next'),
              isExpanded: _expanded,
              onToggle: _toggle,
            ),

            // Colonne droite (flottante, animée)
            RightColumnActions(
              onCreateCalendar: widget.onCreateCalendar ?? () => debugPrint('create calendar'),
              onCreateEvent: widget.onCreateEvent ?? () => debugPrint('create event'),
              onManageGroups: widget.onManageGroups ?? () => debugPrint('manage groups'),
              onShare: widget.onShare ?? () => debugPrint('share'),
              expanded: _expanded,
            ),
          ],
        ),
      ),
    );
  }
}
