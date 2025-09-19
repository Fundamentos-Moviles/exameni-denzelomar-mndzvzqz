import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  // Número de filas y columnas
  final int rows = 4;
  final int columns = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorama Flutter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: List.generate(rows * columns, (index) {
            return MemoryTile(
              color: Colors.grey, // Todos los cuadros empiezan en gris
            );
          }),
        ),
      ),
    );
  }
}

class MemoryTile extends StatelessWidget {
  final Color color;

  const MemoryTile({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
