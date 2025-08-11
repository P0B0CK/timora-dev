// lib/ui/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:timora/ui/atoms/icon_toggle.dart';
import 'package:timora/ui/molecules/loader.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timora Theme Demo', style: Theme.of(context).textTheme.titleMedium),
        actions: const [ThemeToggleButton()],
      ),
      // On embarque le loader en mode non-fullscreen pour éviter le double Scaffold
      body: const Padding(
        padding: EdgeInsets.all(50),
        child: AppLoader(
          fullscreen: false,
          logoHeight: 64,
          inkDropSize: 38,
        ),
      ),
    );
  }
}
