// lib/ui/atoms/breadcrumb/breadcrumb_atom.dart
import 'package:flutter/material.dart';
import 'breadcrumb_item.dart';

class Breadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;
  const Breadcrumb({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: 'Fil d’ariane',
      child: Wrap(
        spacing: 8, crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: items[i].onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  items[i].label,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: items[i].isCurrent ? FontWeight.w600 : FontWeight.w400,
                    decoration: items[i].isCurrent ? TextDecoration.underline : TextDecoration.none,
                  ),
                ),
              ),
            ),
            if (i < items.length - 1)
              Icon(Icons.chevron_right, size: 18, color: theme.colorScheme.onSurface.withOpacity(.6)),
          ],
        ],
      ),
    );
  }
}
