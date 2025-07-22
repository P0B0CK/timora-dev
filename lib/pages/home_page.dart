import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          "Bienvenue sur Timora, construction en cours!...",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}