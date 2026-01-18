
import 'package:flutter/material.dart';

class SearchResultScreen extends StatelessWidget {
  final String word;
  const SearchResultScreen({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Search: $word')));
  }
}
