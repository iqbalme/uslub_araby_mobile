import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:uslub_araby/data/database.dart';
import 'package:uslub_araby/providers/saved_words_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class WordListWidget extends StatelessWidget {
  final List<UslubData> words;

  const WordListWidget({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedWordsProvider>(
      builder: (context, savedProvider, child) {
        return ListView.builder(
          itemCount: words.length,
          itemBuilder: (context, index) {
            final word = words[index];
            final isSaved = savedProvider.isSaved(word);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => context.go('/word/${word.id}'),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Arabic text
                      Text(
                        word.ungkapan ?? '',
                        style: GoogleFonts.scheherazadeNew(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 8),
                      // Meaning
                      Text(
                        word.makna ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Bookmark button only
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () => savedProvider.toggleSaved(word),
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved ? Colors.amber : Colors.grey,
                          ),
                          tooltip: isSaved
                              ? 'Hapus dari tersimpan'
                              : 'Simpan kata',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
