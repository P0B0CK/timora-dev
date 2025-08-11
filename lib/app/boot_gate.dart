// lib/app/boot_gate.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timora/ui/molecules/loader.dart';

// Si tu utilises FlutterFire CLI, décommente et importe tes options :
// import 'package:timora/firebase_options.dart';

class BootGate extends StatefulWidget {
  const BootGate({super.key, required this.appBuilder, this.minSplashMs = 600});

  /// Construit le "vrai" root (ex: TimoraApp) une fois l'init terminée.
  final WidgetBuilder appBuilder;

  /// Durée minimale d’affichage du loader (pour éviter le flash).
  final int minSplashMs;

  @override
  State<BootGate> createState() => _BootGateState();
}

class _BootGateState extends State<BootGate> {
  late final Future<void> _init;

  @override
  void initState() {
    super.initState();
    _init = _initialize();
  }

  Future<void> _initialize() async {
    // 1) Initialisations nécessaires au lancement
    //    (Firebase, Remote Config, prefs, services…)
    try {
      // Avec FlutterFire CLI :
      // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      // Sinon basique :
      await Firebase.initializeApp();
    } catch (_) {
      // log/ignore si déjà initialisé ou env sans Firebase (tests)
    }

    // 2) Durée minimale du splash (sensation de fluidité)
    await Future.delayed(Duration(milliseconds: widget.minSplashMs));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _init,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          // ⬇️ Loader fullscreen (ton composant)
          return const AppLoader(
            logoHeight: 72,
            inkDropSize: 38,
            gapBetweenLogoAndLoader: 48,
            loaderTopGap: 24,
            fullscreen: true,
          );
        }
        // Prêt → on affiche l’app
        return widget.appBuilder(context);
      },
    );
  }
}
