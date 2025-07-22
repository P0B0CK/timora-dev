import 'package:flutter/material.dart';

class RightColumnActions extends StatelessWidget {
  const RightColumnActions({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.flash_on_rounded),
          color: primaryColor,
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.checklist_rounded),
          color: primaryColor,
          onPressed: () {},
        ),
      ],
    );
  }
}
