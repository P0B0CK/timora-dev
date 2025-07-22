import 'package:flutter/material.dart';
import '../molecules/main_bottom_actions.dart';
import '../molecules/left_column_actions.dart';
import '../molecules/right_column_actions.dart';

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            LeftColumnActions(),
            MainBottomActions(),
            RightColumnActions(),
          ],
        ),
      ),
    );
  }
}
