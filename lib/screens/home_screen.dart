import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uslub_araby/providers/uslub_provider.dart';
import 'package:uslub_araby/widgets/search_bar_widget.dart';
import 'package:uslub_araby/widgets/word_list_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kamus Uslub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // TODO: Navigasi ke halaman About
            },
          ),
        ],
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
