
import 'package:flutter/material.dart';
import 'package:uslub_araby/data/database.dart';

class FlashcardSessionScreen extends StatelessWidget {
  final List<UslubData> deck;
  const FlashcardSessionScreen({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Flashcard Session')));
  }
}
