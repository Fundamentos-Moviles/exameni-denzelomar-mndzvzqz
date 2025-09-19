import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const MemoryApp());
}

class MemoryApp extends StatelessWidget {
  const MemoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FDM E1 - Memorama',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameScreen(),
    );
  }
}
