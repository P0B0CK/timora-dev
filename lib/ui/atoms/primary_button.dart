// lib/atoms/buttons/primary_button.dart
/// A SUPPRIMER :: OLD
import 'package:flutter/material.dart';
import '../../theme/colors_extension.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return colors.disabled;
          return colors.primary;
        }),
        foregroundColor: WidgetStateProperty.all(colors.onPrimary),
      ),
      child: loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : Text(label),
    );
  }
}
