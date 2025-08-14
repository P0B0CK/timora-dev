// lib/ui/molecules/left_column_actions.dart
import 'package:flutter/material.dart';
import '../atoms/icon.dart';

class LeftColumnActions extends StatefulWidget {
  final VoidCallback onOpenSettings;
  final VoidCallback onLogout;
  final VoidCallback onNotifications;
  final bool expanded;
  final Duration duration;

  const LeftColumnActions({
    super.key,
    required this.onOpenSettings,
    required this.onLogout,
    required this.onNotifications,
    required this.expanded,
    this.duration = const Duration(milliseconds: 280),
  });

  @override
  State<LeftColumnActions> createState() => _LeftColumnActionsState();
}

class _LeftColumnActionsState extends State<LeftColumnActions>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _opacities;
  late final List<Animation<Offset>> _slides;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    // Important : rebuild
    _ctrl.addListener(() => setState(() {}));

    const step = 0.20; // 20% de la durée
    _opacities = List.generate(3, (i) {
      final start = (i * step).clamp(0.0, 1.0);
      final end = (start + 0.60).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _ctrl,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      );
    });

    _slides = List.generate(3, (i) {
      final start = (i * step).clamp(0.0, 1.0);
      final end = (start + 0.60).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
          .animate(CurvedAnimation(
        parent: _ctrl,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ));
    });

    _ctrl.value = widget.expanded ? 1.0 : 0.0;
  }

  @override
  void didUpdateWidget(covariant LeftColumnActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expanded != widget.expanded) {
      if (widget.expanded) {
        _ctrl.forward();
      } else {
        _ctrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      _buildStaggerItem(
        index: 0,
        child: AppIcon(
          assetName: 'assets/icons/notifications.svg',
          style: AppIconStyle.rounded,
          size: 42,
          tooltip: 'Notifications',
          onPressed: widget.onNotifications,
        ),
      ),
      const SizedBox(height: 12),
      _buildStaggerItem(
        index: 1,
        child: AppIcon(
          assetName: 'assets/icons/logout.svg',
          style: AppIconStyle.rounded,
          size: 42,
          tooltip: 'Se déconnecter',
          onPressed: () {
            debugPrint('[LeftColumnActions] tap logout');
            widget.onLogout();
          },
        ),
      ),
      const SizedBox(height: 12),
      _buildStaggerItem(
        index: 2,
        child: AppIcon(
          assetName: 'assets/icons/settings.svg',
          style: AppIconStyle.rounded,
          size: 42,
          tooltip: 'Paramètres',
          onPressed: widget.onOpenSettings,
        ),
      ),
    ];

    return IgnorePointer(
      ignoring: _ctrl.isDismissed,
      child: Column(mainAxisSize: MainAxisSize.min, children: items),
    );
  }

  Widget _buildStaggerItem({required int index, required Widget child}) {
    return SlideTransition(
      position: _slides[index],
      child: FadeTransition(opacity: _opacities[index], child: child),
    );
  }
}
