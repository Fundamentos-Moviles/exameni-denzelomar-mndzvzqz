import 'package:flutter/material.dart';
import 'dart:math';

class GameScreen extends StatefulWidget{
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>{
  final int rows = 4;
  final int columns = 5;
  late List<Color> colors; // Lista de colores para los cuadros

  @override
  void initState() {
    super.initState();
    colors = generateColors();
  }

  // Generar 10 colores aleatorios y duplicar cada uno para formar pares
List<Color> generateColors(){
  Random random = Random();
  List<Color> baseColors = List.generate(10, (_){
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  });

  // Duplicar los colores para tener pares
  List<Color> pairedColors = [...baseColors, ...baseColors];

  // Mezclar la lista
  pairedColors.shuffle();
  return pairedColors;
}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nombre: Denzel Omar Mendoza Vázquez')
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 8,
          crossAxisSpacing: 8,
          children: List.generate(rows * columns, (index){
            return MemoryTile(
                color: Colors.grey,
                actualColor: colors[index],
            );
          }),
        ),
      ),
    );
  }
}

class MemoryTile extends StatelessWidget {
  final Color color;
  final Color actualColor;

  const MemoryTile({super.key, required this.color, required this.actualColor});

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