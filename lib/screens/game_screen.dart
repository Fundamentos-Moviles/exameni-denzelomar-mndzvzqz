import 'package:flutter/material.dart';
import 'dart:math';

class GameScreen extends StatefulWidget{
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int rows = 4;
  int columns = 5;

  late List<Color> colors; // Lista de colores para los cuadros
  late List<bool> revealed; // Indica si un cuadro está visible
  List<int> selectedIndices = []; // Guarda los índices seleccionados

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame(){
    colors = _generateColors();
    revealed = List.generate(rows * columns, (_) => false);
    selectedIndices.clear();
  }
  // Generar 10 colores aleatorios y duplicar cada uno para formar pares
  List<Color> _generateColors(){
  Random random = Random();
  int totalTiles = rows * columns;

  // Asegurar que sea un número par de cuadros
  if(totalTiles % 2 != 0){
    throw Exception("La cuadrícula debe tener un número par de cuadros.");
  }

  int numPairs = totalTiles ~/ 2;

  List<Color> baseColors = List.generate(numPairs, (_){
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

  void _onTileTap(int index){
    if (revealed[index] || selectedIndices.contains(index) || selectedIndices.length == 2) return;

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
            _showWinDialog();
          }
        });
      });
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¡Juego Terminado!'),
        content: const Text ('Has encontrado todos los pares'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState((){
                _startNewGame();
              });
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  void _changeBoardSize(int newRows, int newColumns) {
    setState((){
      rows = newRows;
      columns = newColumns;
      _startNewGame();
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nombre: Denzel Omar Mendoza Vázquez'),
        actions: [
          IconButton(
            onPressed: () {
    setState(() {
    _startNewGame();
    });
    },

    icon: const Icon(Icons.refresh),
    tooltip: 'Reiniciar',

    ),

    PopupMenuButton<String>(
    onSelected: (value) {
    if (value == "4x5") _changeBoardSize(4, 5);
    if (value == "4x6") _changeBoardSize(4, 6);
    if (value == "5x8") _changeBoardSize(5, 8);
    },
    itemBuilder: (context) => [
    const PopupMenuItem(value: "4x5", child: Text("Tablero 4x5")),
    const PopupMenuItem(value: "4x6", child: Text("Tablero 4x6")),
    const PopupMenuItem(value: "5x8", child: Text("Tablero 5x8")),
    ],
    ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: List.generate(rows * columns, (index){
            return GestureDetector(
              onTap: () => _onTileTap(index),
              child: MemoryTile(
                color: revealed[index] ? colors[index] : Colors.grey,
                // actualColor: colors[index],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class MemoryTile extends StatelessWidget {
  final Color color;
  // final Color actualColor;

  const MemoryTile({super.key, required this.color/*, required this.actualColor*/});

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