// lib/app/boot_gate.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timora/ui/molecules/loader.dart';

class BootGate extends StatefulWidget {
  const BootGate({super.key, required this.appBuilder, this.minSplashMs = 600});

  final WidgetBuilder appBuilder;
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
    try {
      await Firebase.initializeApp();
    } catch (_) {
    }
    await Future.delayed(Duration(milliseconds: widget.minSplashMs));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _init,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const AppLoader(
            logoHeight: 72,
            inkDropSize: 38,
            gapBetweenLogoAndLoader: 48,
            loaderTopGap: 24,
            fullscreen: true,
          );
        }
        return widget.appBuilder(context);
      },
    );
  }
}
