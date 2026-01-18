import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uslub_araby/data/database.dart';
import 'package:uslub_araby/providers/uslub_provider.dart';
import 'package:uslub_araby/providers/saved_words_provider.dart';
import 'package:uslub_araby/providers/flashcard_deck_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordDetailScreen extends StatefulWidget {
  final String wordId;

  const WordDetailScreen({super.key, required this.wordId});

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  UslubData? _word;
  bool _isLoading = true;
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    _initTts();
    _fetchWordDetails();
  }

  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage('ar');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(
      0.5,
    ); // Lebih lambat untuk pengucapan Arab yang jelas
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
    if (_word != null && _word!.ungkapan != null) {
      try {
        final isAvailable = await flutterTts.isLanguageAvailable('ar');
        if (isAvailable) {
          await flutterTts.speak(_word!.ungkapan!);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Bahasa Arab tidak didukung. Pergi ke Pengaturan > Aksesibilitas > Output teks-ke-suara > Engine, dan pilih engine yang mendukung Arab (misalnya Google TTS).',
                ),
                duration: Duration(seconds: 6),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error TTS: $e. Periksa pengaturan suara perangkat.',
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  Future<void> _showAddToDeckDialog(BuildContext context) async {
    final flashcardProvider = Provider.of<FlashcardDeckProvider>(
      context,
      listen: false,
    );
    await flashcardProvider.loadDecks();

    if (!mounted || !context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.add, color: Colors.blue),
                  const SizedBox(width: 12),
                  const Text(
                    'Tambah ke Deck Flashcard',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(bottomSheetContext).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Content
              Expanded(
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
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
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
                              Navigator.of(bottomSheetContext).pop();
                              await _addWordToDeck(deck.id, deck.name);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
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
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[850]
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black54
                      : Colors.black12,
                  blurRadius: Theme.of(context).brightness == Brightness.dark
                      ? 8
                      : 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Theme.of(context).brightness == Brightness.dark
                  ? Border.all(color: Colors.grey[700]!, width: 1)
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Arabic word - Large and centered
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.blue[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[600]!
                            : Colors.blue[200]!,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      _word!.ungkapan ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Separator line
                  Container(height: 2, width: 100, color: Colors.blueAccent),
                  const SizedBox(height: 24),

                  // Meaning section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        const [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.orangeAccent,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                        ] +
                        [
                          Expanded(
                            child: Text(
                              _word!.makna ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                  ),
                  const SizedBox(height: 32), // Increased spacing
                  Row(
                    children: const [
                      Icon(
                        Icons.format_quote,
                        color: Colors.blueAccent,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Contoh Kalimat:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Display all examples
                  ..._buildExamplesList(_word!.contoh ?? ''),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExamplesList(String examplesText) {
    if (examplesText.trim().isEmpty) {
      return [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[600]!
                  : Colors.grey[200]!,
            ),
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
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[600]!
                    : Colors.grey[200]!,
              ),
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
}
