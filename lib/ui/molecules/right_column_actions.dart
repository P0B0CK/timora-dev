// lib/ui/molecules/right_column_actions.dart
import 'package:flutter/material.dart';
import '../atoms/icon.dart';

class RightColumnActions extends StatefulWidget {
  final VoidCallback onCreateEvent;
  final VoidCallback onCreateCalendar;
  final VoidCallback onManageGroups;
  final VoidCallback? onShare;

  final bool expanded;
  final Duration duration;

  const RightColumnActions({
    super.key,
    required this.onCreateEvent,
    required this.onCreateCalendar,
    required this.onManageGroups,
    this.onShare,
    required this.expanded,
    this.duration = const Duration(milliseconds: 280),
  });

  @override
  State<RightColumnActions> createState() => _RightColumnActionsState();
}

class _RightColumnActionsState extends State<RightColumnActions>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late List<Animation<double>> _opacities;
  late List<Animation<Offset>> _slides;

  int get _count => widget.onShare != null ? 4 : 3;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _buildStaggers();
    if (widget.expanded) _ctrl.value = 1; else _ctrl.value = 0;
  }

  void _buildStaggers() {
    const step = 0.20;
    _opacities = List.generate(_count, (i) {
      final start = (i * step).clamp(0.0, 1.0);
      final end = (start + 0.60).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _ctrl,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      );
    });
    _slides = List.generate(_count, (i) {
      final start = (i * step).clamp(0.0, 1.0);
      final end = (start + 0.60).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
          .animate(CurvedAnimation(
        parent: _ctrl,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ));
    });
  }

  @override
  void didUpdateWidget(covariant RightColumnActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.onShare != null) != (widget.onShare != null)) {
      _buildStaggers();
    }
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
    int idx = 0;

    final children = <Widget>[];
    if (widget.onShare != null) {
      children.addAll([
        _build(idx++, AppIcon(
          assetName: 'assets/icons/share.svg',
          style: AppIconStyle.rounded,
          size: 42,
          tooltip: 'Gestion des partages',
          onPressed: widget.onShare,
        )),
        const SizedBox(height: 12),
      ]);
    }

    children.addAll([
      _build(idx++, AppIcon(
        assetName: 'assets/icons/group.svg',
        style: AppIconStyle.rounded,
        size: 42,
        tooltip: 'Gestion des groupes',
        onPressed: widget.onManageGroups,
      )),
      const SizedBox(height: 12),
      _build(idx++, AppIcon(
        assetName: 'assets/icons/calendar_add.svg',
        style: AppIconStyle.rounded,
        size: 42,
        tooltip: 'Ajouter un agenda',
        onPressed: widget.onCreateCalendar,
      )),
      const SizedBox(height: 12),
      _build(idx++, AppIcon(
        assetName: 'assets/icons/bookmark_add.svg',
        style: AppIconStyle.rounded,
        size: 42,
        tooltip: 'Ajouter un événement',
        onPressed: widget.onCreateEvent,
      )),
    ]);

    return IgnorePointer(
      ignoring: _ctrl.value == 0,
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }

  Widget _build(int i, Widget child) =>
      SlideTransition(position: _slides[i], child: FadeTransition(opacity: _opacities[i], child: child));
}
