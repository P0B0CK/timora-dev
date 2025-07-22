import 'package:flutter/material.dart';
import '../atoms/timora_icon.dart';
import '../organisms/settings_modal.dart';

class LeftColumnActions extends StatelessWidget {
  const LeftColumnActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const TimoraIcon.rounded(
            iconPath: 'assets/icons/settings.svg',
          ),
          onPressed: () {
          showDialog(
          context: context,
          builder: (_) => const SettingsModal(),
          );
          },
        ),
      ],
    );
  }
}
