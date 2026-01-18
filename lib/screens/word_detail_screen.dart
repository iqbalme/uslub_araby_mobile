import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:uslub_araby/data/database.dart';
import 'package:uslub_araby/providers/uslub_provider.dart';
import 'package:uslub_araby/providers/saved_words_provider.dart';
import 'package:uslub_araby/providers/flashcard_deck_provider.dart';

class WordDetailScreen extends StatefulWidget {
  final String wordId;

  const WordDetailScreen({super.key, required this.wordId});

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  UslubData? _word;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWordDetails();
  }

  Future<void> _fetchWordDetails() async {
    final provider = Provider.of<UslubProvider>(context, listen: false);
    final intId = int.tryParse(widget.wordId);
    if (intId != null) {
      final word = await provider.getWordById(intId);
      if (mounted) {
        // Cek jika widget masih ada di tree
        setState(() {
          _word = word;
          _isLoading = false;
        });
      }
    } else {
      // Handle jika wordId bukan integer yang valid
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _speakWord() async {
    // TODO: Implement text-to-speech functionality
    // For now, just show a snackbar
    if (_word != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mengucapkan: ${_word!.ungkapan ?? ''}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _showAddToDeckDialog(BuildContext context) async {
    final flashcardProvider = Provider.of<FlashcardDeckProvider>(
      context,
      listen: false,
    );
    await flashcardProvider.loadDecks();

    if (!mounted || !context.mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Tambah ke Deck Flashcard'),
          content: SizedBox(
            width: double.maxFinite,
            child: Consumer<FlashcardDeckProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.decks.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada deck flashcard.\nBuat deck terlebih dahulu.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.decks.length,
                  itemBuilder: (context, index) {
                    final deck = provider.decks[index];
                    return ListTile(
                      title: Text(deck.name),
                      subtitle: deck.description != null
                          ? Text(deck.description!)
                          : null,
                      trailing: FutureBuilder<Map<String, int>>(
                        future: provider.getDeckStats(deck.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final stats = snapshot.data!;
                            return Text('${stats['total']} kartu');
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      onTap: () async {
                        Navigator.of(dialogContext).pop();
                        await _addWordToDeck(deck.id, deck.name);
                      },
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addWordToDeck(int deckId, String deckName) async {
    if (_word == null) return;

    final flashcardProvider = Provider.of<FlashcardDeckProvider>(
      context,
      listen: false,
    );
    final success = await flashcardProvider.addCardToDeck(deckId, _word!.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? '"${_word!.makna ?? ''}" berhasil ditambahkan ke deck "$deckName"'
              : '"${_word!.makna ?? ''}" sudah ada di deck "$deckName"',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Detail Kata',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        actions: [
          if (!_isLoading && _word != null) ...[
            // Speaker button for pronunciation
            IconButton(
              icon: const Icon(Icons.volume_up, color: Colors.blueAccent),
              onPressed: () => _speakWord(),
              tooltip: 'Dengarkan Pengucapan',
            ),
            // Favorite button
            Consumer<SavedWordsProvider>(
              builder: (context, savedWordsProvider, child) {
                final bool isSaved = savedWordsProvider.isSaved(_word!);
                return IconButton(
                  icon: Icon(
                    isSaved ? Icons.favorite : Icons.favorite_border,
                    color: isSaved ? Colors.redAccent : Colors.grey,
                  ),
                  onPressed: () {
                    savedWordsProvider.toggleSaved(_word!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          !isSaved
                              ? '"${_word!.makna ?? ''}" disimpan ke favorit.'
                              : '"${_word!.makna ?? ''}" dihapus dari favorit.',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  tooltip: 'Favorit',
                );
              },
            ),
            // Add to flashcard button
            IconButton(
              icon: const Icon(Icons.add_to_photos, color: Colors.green),
              onPressed: () => _showAddToDeckDialog(context),
              tooltip: 'Tambah ke Flashcard',
            ),
          ],
        ],
      ),
      body: _buildBody(),
      backgroundColor: Colors.grey[50],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_word == null) {
      return const Center(
        child: Text(
          'Detail kata tidak ditemukan.',
          style: TextStyle(fontSize: 18, color: Colors.redAccent),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Main content card
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Arabic word - Large and centered
                  Text(
                    _word!.ungkapan ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 48,
                      fontFamily: 'Amiri',
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Separator line
                  Container(height: 2, width: 100, color: Colors.blueAccent),
                  const SizedBox(height: 24),

                  // Meaning/Translation
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Arti: ${_word!.makna ?? ''}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Definition section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Definisi:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _getDefinition(_word!.makna ?? ''),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Example sentence section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Contoh Kalimat:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Display all examples
                  ..._buildExamplesList(_word!.contoh ?? ''),
                  const SizedBox(height: 24),

                  // Copy translation button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _copyTranslation(),
                      icon: const Icon(Icons.copy),
                      label: const Text('Salin Terjemahan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _generateTransliteration(String arabic) {
    // Simple transliteration - in a real app, you'd use a proper library
    if (arabic.isEmpty) return '';

    // This is a very basic transliteration - you might want to use a proper library
    return arabic
        .replaceAll('ا', 'a')
        .replaceAll('ب', 'b')
        .replaceAll('ت', 't')
        .replaceAll('ث', 'th')
        .replaceAll('ج', 'j')
        .replaceAll('ح', 'h')
        .replaceAll('خ', 'kh')
        .replaceAll('د', 'd')
        .replaceAll('ذ', 'dh')
        .replaceAll('ر', 'r')
        .replaceAll('ز', 'z')
        .replaceAll('س', 's')
        .replaceAll('ش', 'sh')
        .replaceAll('ص', 's')
        .replaceAll('ض', 'd')
        .replaceAll('ط', 't')
        .replaceAll('ظ', 'z')
        .replaceAll('ع', '‘')
        .replaceAll('غ', 'gh')
        .replaceAll('ف', 'f')
        .replaceAll('ق', 'q')
        .replaceAll('ك', 'k')
        .replaceAll('ل', 'l')
        .replaceAll('م', 'm')
        .replaceAll('ن', 'n')
        .replaceAll('ه', 'h')
        .replaceAll('و', 'w')
        .replaceAll('ي', 'y')
        .replaceAll('ة', 'h')
        .replaceAll('ى', 'a')
        .replaceAll('ء', '')
        .replaceAll('آ', 'a')
        .replaceAll('إ', 'i')
        .replaceAll('أ', 'a')
        .replaceAll('ؤ', 'u')
        .replaceAll('ئ', 'i')
        .replaceAll('ً', 'an')
        .replaceAll('ٌ', 'un')
        .replaceAll('ٍ', 'in')
        .replaceAll('َ', 'a')
        .replaceAll('ُ', 'u')
        .replaceAll('ِ', 'i')
        .replaceAll('ّ', '')
        .replaceAll('ْ', '');
  }

  String _getDefinition(String meaning) {
    // Generate definition based on the meaning
    final lowerMeaning = meaning.toLowerCase();

    if (lowerMeaning.contains('dengar dengar')) {
      return 'Ungkapan yang digunakan untuk menyampaikan informasi yang didengar dari orang lain, sering kali bersifat gosip atau informasi tidak resmi.';
    }
    if (lowerMeaning.contains('apa yang dikehendaki allah') ||
        lowerMeaning.contains('mashaallah')) {
      return 'Ungkapan yang digunakan untuk mengungkapkan kekaguman, pujian, atau rasa syukur atas sesuatu yang baik atau indah, dengan menyandarkannya pada kehendak Allah.';
    }

    // Generic definition based on word type
    return 'Ungkapan atau kata dalam bahasa Arab yang memiliki makna "${meaning.toLowerCase()}".';
  }

  List<Widget> _buildExamplesList(String examplesText) {
    if (examplesText.trim().isEmpty) {
      return [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: const Text(
            'Tidak ada contoh tersedia',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ];
    }

    final lines = examplesText
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();
    final List<Widget> exampleWidgets = [];

    for (int i = 0; i < lines.length; i += 2) {
      if (i < lines.length) {
        final arabicText = lines[i].trim();
        final translationText = i + 1 < lines.length ? lines[i + 1].trim() : '';

        exampleWidgets.add(
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Arabic text
                Text(
                  arabicText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Amiri',
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                if (translationText.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  // Translation
                  Text(
                    translationText,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }
    }

    return exampleWidgets;
  }

  Future<void> _copyTranslation() async {
    final examplesText = _word!.contoh ?? '';
    final lines = examplesText
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    // Collect all translations
    final translations = <String>[];
    for (int i = 1; i < lines.length; i += 2) {
      if (i < lines.length) {
        translations.add(lines[i].trim());
      }
    }

    final allTranslations = translations.join('\n');
    await Clipboard.setData(ClipboardData(text: allTranslations));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${translations.length} terjemahan berhasil disalin'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
