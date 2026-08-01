import 'package:flutter/material.dart';

/// Minimal placeholder screen so the app boots.
/// Replace with your real screens under `presentation/screens/`.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trucky')),
      body: const Center(child: Text('Welcome')),
    );
  }
}
