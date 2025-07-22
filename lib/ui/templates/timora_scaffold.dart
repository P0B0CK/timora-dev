import 'package:flutter/material.dart';
import '../organisms/app_top_bar.dart';
import '../organisms/app_bottom_bar.dart';

class TimoraScaffold extends StatelessWidget {
  final Widget child;

  const TimoraScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppTopBar(),
      ),
      body: child,
      bottomNavigationBar: const BottomAppBar(),
    );
  }
}
