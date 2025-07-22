import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // ← nécessaire pour afficher les SVG
import '../atoms/timora_icon.dart';

class MainBottomActions extends StatelessWidget {
  const MainBottomActions({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const TimoraIcon(iconPath: 'assets/icons/arrow_left.svg'),
          iconSize: 42,
          color: primaryColor,
          onPressed: () {},
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const TimoraIcon(
            iconPath: 'assets/icons/account_profile.svg',
          ),
          iconSize: 42,
          color: primaryColor,
          onPressed: () {
            // Action à définir
          },
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const TimoraIcon(iconPath: 'assets/icons/arrow_right.svg'),
          iconSize: 42,
          color: primaryColor,
          onPressed: () {},
        ),
      ],
    );
  }
}
