import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uslub_araby/models/kamus_model.dart';

class WordListWidget extends StatelessWidget {
  final List<Kamus> words;

  const WordListWidget({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: words.length,
      itemBuilder: (context, index) {
        final kamus = words[index];
        return ListTile(
          title: Text(kamus.makna), // Tampilkan makna sebagai judul
          subtitle: Text(kamus.ungkapan), // Tampilkan ungkapan sebagai subjudul
          onTap: () {
            // Navigasi ke detail dengan id
            context.go('/word/${kamus.id}');
          },
        );
      },
    );
  }
}
