import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uslub_araby/providers/uslub_provider.dart';
import 'package:uslub_araby/widgets/search_bar_widget.dart';
import 'package:uslub_araby/widgets/word_list_widget.dart';

class UslubScreen extends StatelessWidget {
  const UslubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kamus Uslub'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          const SearchBarWidget(),
          Expanded(
            child: Consumer<UslubProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.words.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada data atau hasil tidak ditemukan.'),
                  );
                }
                return WordListWidget(words: provider.words);
              },
            ),
          ),
        ],
      ),
    );
  }
}
