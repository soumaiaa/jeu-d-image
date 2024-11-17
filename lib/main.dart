import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jeu des images',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Liste des images à afficher (12 images, avec des paires)
  final List<String> _imagePaths = [
    'assets/images/image1.webp',
    'assets/images/image2.webp',
    'assets/images/image3.webp',
    'assets/images/image4.webp',
    'assets/images/image5.jpg',
    'assets/images/image6.jpg',
    'assets/images/image1.webp',
    'assets/images/image2.webp',
    'assets/images/image3.webp',
    'assets/images/image4.webp',
    'assets/images/image5.jpg',
    'assets/images/image6.jpg',
  ];

  // Mélange des images
  late List<String> _shuffledImages;
  // Liste pour vérifier quelles cases sont retournées
  List<bool> _revealed = List.generate(12, (index) => false); // 12 images
  // Garde une trace des indices sélectionnés
  List<int> _selectedIndices = [];
  // Indique si le jeu est terminé
  bool _gameWon = false;

  @override
  void initState() {
    super.initState();
    _shuffledImages = List.from(_imagePaths);
    _shuffledImages.shuffle(Random());
  }

  // Fonction pour gérer les touches sur une case
  void _onImageTapped(int index) {
    if (_revealed[index] || _selectedIndices.length == 2 || _gameWon) return;

    setState(() {
      _revealed[index] = true;
      _selectedIndices.add(index);

      // Vérifie si deux images ont été sélectionnées
      if (_selectedIndices.length == 2) {
        if (_shuffledImages[_selectedIndices[0]] ==
            _shuffledImages[_selectedIndices[1]]) {
          // Si les images sont identiques, elles restent visibles
          _selectedIndices.clear();

          // Vérifie si toutes les images ont été révélées
          if (_revealed.every((element) => element)) {
            _gameWon = true;
          }
        } else {
          // Si les images ne sont pas identiques, elles sont cachées après un délai
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _revealed[_selectedIndices[0]] = false;
              _revealed[_selectedIndices[1]] = false;
            });
            _selectedIndices.clear();
          });
        }
      }
    });
  }

  // Fonction pour réinitialiser le jeu
  void _resetGame() {
    setState(() {
      _shuffledImages.shuffle(Random());
      _revealed =
          List.generate(12, (index) => false); // Réinitialiser pour 12 images
      _selectedIndices.clear();
      _gameWon = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jeu des images'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (_gameWon)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.party_mode,
                        color: Colors.yellow, size: 30), // Icône de fête
                    SizedBox(width: 8), // Espace entre l'icône et le texte
                    Text(
                      'Félicitations, vous avez gagné ! 🎉',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 217, 30, 220),
                      ),
                    ),
                  ],
                ),
              ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    4, // 4 colonnes pour mieux afficher les 12 images
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 12, // 12 images au total
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onImageTapped(index),
                  child: Container(
                    color: Colors.grey,
                    child: _revealed[index]
                        ? Image.asset(_shuffledImages[index])
                        : Container(),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: _resetGame,
              child: Text('Réinitialiser'),
            ),
          ],
        ),
      ),
    );
  }
}
