// lib/ui/templates/timora_scaffold.dart
import 'package:flutter/material.dart';
import 'package:timora/ui/organisms/app_top_bar.dart';
import 'package:timora/ui/molecules/main_bottom_actions.dart';
import 'package:timora/ui/molecules/left_column_actions.dart';
import 'package:timora/ui/molecules/right_column_actions.dart';
import 'package:timora/ui/atoms/icon.dart';
import 'package:timora/ui/utils/logout_helper.dart';
// ⬇️ importe la modale Paramètres
import 'package:timora/ui/organisms/settings_modal.dart';

import '../molecules/app_modal.dart';
import '../organisms/user_profile_modal.dart';

class TimoraScaffold extends StatefulWidget {
  final Widget child;

  // centre
  final VoidCallback? onPrev;
  final VoidCallback? onProfile;
  final VoidCallback? onNext;

  // gauche
  final VoidCallback? onOpenSettings;
  final VoidCallback? onLogout;         // si null => fallback modale
  final VoidCallback? onNotifications;

  // droite
  final VoidCallback? onCreateEvent;
  final VoidCallback? onCreateCalendar;
  final VoidCallback? onManageGroups;
  final VoidCallback? onShare;

  final double bottomBarHeight;

  const TimoraScaffold({
    super.key,
    required this.child,
    this.onPrev,
    this.onProfile,
    this.onNext,
    this.onOpenSettings,
    this.onLogout,
    this.onNotifications,
    this.onCreateEvent,
    this.onCreateCalendar,
    this.onManageGroups,
    this.onShare,
    this.bottomBarHeight = 56,
  });

  @override
  State<TimoraScaffold> createState() => _TimoraScaffoldState();
}

class _TimoraScaffoldState extends State<TimoraScaffold> {
  bool _leftExpanded = true;
  bool _rightExpanded = true;

  void _toggleLeft()  => setState(() => _leftExpanded  = !_leftExpanded);
  void _toggleRight() => setState(() => _rightExpanded = !_rightExpanded);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottomGap = widget.bottomBarHeight + media.padding.bottom + 8;

    // 🔎 Trace quel chemin va être pris
    final hasCustomLogout = widget.onLogout != null;
    debugPrint('[TimoraScaffold] build; hasCustomLogout=$hasCustomLogout');

    // ✅ Wrap du callback pour LOG + garantir la modale en fallback
    final VoidCallback _logoutTap = hasCustomLogout
        ? () {
      debugPrint('[TimoraScaffold] invoking CUSTOM onLogout');
      widget.onLogout!.call();
    }
        : () {
      debugPrint('[TimoraScaffold] fallback logout -> modal');
      performLogout(context); // ouvre la modale
    };

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppTopBar(),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: widget.child),

          // Colonne gauche + toggle
          Positioned(
            left: 12,
            bottom: bottomGap,
            child: SafeArea(
              top: false, bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LeftColumnActions(
                    // ⬇️ ouvre la modale Paramètres si aucun callback custom
                    onOpenSettings: widget.onOpenSettings ?? () => openSettingsModal(context),
                    onLogout: _logoutTap,
                    onNotifications: widget.onNotifications ?? () => debugPrint('open notifications'),
                    expanded: _leftExpanded,
                  ),
                  const SizedBox(height: 10),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    turns: _leftExpanded ? 0.25 : 0,
                    child: AppIcon(
                      assetName: 'assets/icons/more_vert.svg',
                      style: AppIconStyle.alone,
                      size: 28,
                      tooltip: _leftExpanded ? 'Rétracter la colonne gauche' : 'Déployer la colonne gauche',
                      onPressed: _toggleLeft,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Colonne droite + toggle
          Positioned(
            right: 12,
            bottom: bottomGap,
            child: SafeArea(
              top: false, bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RightColumnActions(
                    onCreateEvent: widget.onCreateEvent ?? () => debugPrint('create event'),
                    onCreateCalendar: widget.onCreateCalendar ?? () => debugPrint('create calendar'),
                    onManageGroups: widget.onManageGroups ?? () => debugPrint('manage groups'),
                    // ⬇️ évite de passer null si RightColumnActions attend un callback
                    onShare: widget.onShare ?? () => debugPrint('share'),
                    expanded: _rightExpanded,
                  ),
                  const SizedBox(height: 10),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    turns: _rightExpanded ? 0.25 : 0,
                    child: AppIcon(
                      assetName: 'assets/icons/more_vert.svg',
                      style: AppIconStyle.alone,
                      size: 28,
                      tooltip: _rightExpanded ? 'Rétracter la colonne droite' : 'Déployer la colonne droite',
                      onPressed: _toggleRight,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Barre du bas (centre)
          Positioned(
            left: 0,
            right: 0,
            bottom: media.padding.bottom + 8,
            child: Center(
              child: SizedBox(
                height: widget.bottomBarHeight,
                child: MainBottomActions(
                  onPrev: widget.onPrev,
                  onProfile: widget.onProfile ?? () {
                    showAppModal<void>(
                      context: context,
                      title: 'Mon profil',
                      content: const UserProfileModal(),
                      actions: const [],
                      barrierDismissible: true,
                      useRootNavigator: false,
                    );
                  },
                  onNext: widget.onNext,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
