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
  late List<bool> revealed; // Indica si un cuadro está visible
  List<int> selectedIndices = []; // Guarda los índices seleccionados

  @override
  void initState() {
    super.initState();
    colors = generateColors();
    revealed = List.generate(rows * columns, (_) => false);
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

  void onTileTap(int index){
    if(revealed[index] || selectedIndices.length == 2) return;

    setState(() {
      revealed[index] = true;
      selectedIndices.add(index);
    });

    if(selectedIndices.length == 2){
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          int first = selectedIndices[0];
          int second = selectedIndices[1];

          if (colors[first] != colors[second]) {
            revealed[first] = false;
            revealed[second] = false;
          }
          selectedIndices.clear();

          // Verificar si el juego terminó
          if(revealed.every((e) => e)){
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('¡Juego Terminado!'),
                content: const Text('Todos los pares encontrados'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      resetGame();
                    },
                    child: const Text('Reiniciar'),
                  ),
                ],
              ),
            );
          }
        });
      });
    }
  }

  void resetGame(){
    setState(() {
      colors = generateColors();
      revealed = List.generate(rows * columns, (_) => false);
      selectedIndices.clear();
    });
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