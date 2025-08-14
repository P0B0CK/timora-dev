// lib/ui/atoms/breadcrumb/breadcrumb_item.dart
import 'package:flutter/material.dart';

class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;
  final bool isCurrent;
  const BreadcrumbItem({required this.label, this.onTap, this.isCurrent = false});
}
