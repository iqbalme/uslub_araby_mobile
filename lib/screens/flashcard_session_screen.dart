import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uslub_araby/providers/flashcard_deck_provider.dart';
import 'package:uslub_araby/providers/uslub_provider.dart';
import 'package:uslub_araby/data/database.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';

class FlashcardSessionScreen extends StatefulWidget {
  final String deckId;
  const FlashcardSessionScreen({super.key, required this.deckId});

  @override
  State<FlashcardSessionScreen> createState() => _FlashcardSessionScreenState();
}

class _FlashcardSessionScreenState extends State<FlashcardSessionScreen> {
  List<FlashcardCard> _cards = [];
  Map<int, UslubData> _wordData = {}; // Map wordId to word data
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _isLoading = true;
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _loadCards();
  }

  Future<void> _initializeTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage('ar');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(Platform.isIOS ? 0.5 : 0.5);
  }

  Future<void> _loadCards() async {
    final flashcardProvider = Provider.of<FlashcardDeckProvider>(
      context,
      listen: false,
    );
    final uslubProvider = Provider.of<UslubProvider>(context, listen: false);

    final cards = await flashcardProvider.getCardsByDeckId(
      int.parse(widget.deckId),
    );

    // Load word data for each card
    final Map<int, UslubData> wordData = {};
    for (final card in cards) {
      final word = await uslubProvider.getWordById(card.wordId);
      if (word != null) {
        wordData[card.wordId] = word;
      }
    }

    if (mounted) {
      setState(() {
        _cards = cards;
        _wordData = wordData;
        _isLoading = false;
      });
    }
  }

  Future<void> _speakQuestion() async {
    if (_cards.isNotEmpty && !_showAnswer) {
      final card = _cards[_currentIndex];
      final word = _wordData[card.wordId];

      if (word != null && word.ungkapan != null) {
        try {
          final isAvailable = await flutterTts.isLanguageAvailable('ar');
          if (isAvailable) {
            await flutterTts.speak(word.ungkapan!);
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
  }

  void _nextCard() {
    if (_currentIndex < _cards.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showAnswer = false;
      });
    }
  }

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  Future<void> _markAsLearned() async {
    if (_cards.isEmpty) return;

    final card = _cards[_currentIndex];
    final flashcardProvider = Provider.of<FlashcardDeckProvider>(
      context,
      listen: false,
    );

    final success = await flashcardProvider.updateCardProgress(
      card.id,
      true, // isLearned
      card.isMastered, // keep current mastered status
    );

    if (success && mounted) {
      setState(() {
        // Update local card data
        _cards[_currentIndex] = card.copyWith(isLearned: true);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kartu ditandai sebagai dipelajari'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _markAsMastered() async {
    if (_cards.isEmpty) return;

    final card = _cards[_currentIndex];
    final flashcardProvider = Provider.of<FlashcardDeckProvider>(
      context,
      listen: false,
    );

    final success = await flashcardProvider.updateCardProgress(
      card.id,
      true, // isLearned
      true, // isMastered
    );

    if (success && mounted) {
      setState(() {
        // Update local card data
        _cards[_currentIndex] = card.copyWith(
          isLearned: true,
          isMastered: true,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kartu ditandai sebagai dikuasai'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Session'),
        actions: [
          if (_cards.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_currentIndex + 1}/${_cards.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cards.isEmpty
          ? _buildEmptyState()
          : _buildFlashcard(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.style_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Deck ini belum memiliki kartu',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan kata ke deck terlebih dahulu',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcard() {
    final card = _cards[_currentIndex];
    final word = _wordData[card.wordId];

    // If word data is not available, show placeholder
    if (word == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _cards.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text(
                  'Data kata tidak ditemukan',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _cards.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),

          // Flashcard
          Expanded(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: _toggleAnswer,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _showAnswer ? 'Jawaban' : 'Pertanyaan',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _showAnswer
                                ? (word.makna ?? 'Tidak ada makna')
                                : (word.ungkapan ?? 'Tidak ada ungkapan'),
                            style: TextStyle(
                              fontSize: _showAnswer ? 20 : 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: _showAnswer ? null : 'Amiri',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      if (!_showAnswer) ...[
                        const SizedBox(height: 16),
                        IconButton(
                          onPressed: _speakQuestion,
                          icon: const Icon(
                            Icons.volume_up,
                            color: Colors.blueAccent,
                            size: 32,
                          ),
                          tooltip: 'Dengarkan Pengucapan',
                        ),
                      ],
                      const SizedBox(height: 32),
                      Text(
                        'Ketuk kartu untuk ${_showAnswer ? 'menyembunyikan' : 'melihat'} jawaban',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Navigation buttons - Always use column layout for better responsiveness
          const SizedBox(height: 24),
          Column(
            children: [
              // Toggle answer button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _showAnswer
                        ? [Colors.blueAccent, Colors.lightBlueAccent]
                        : [Colors.teal, Colors.tealAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (_showAnswer ? Colors.blueAccent : Colors.teal)
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _toggleAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _showAnswer ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _showAnswer ? 'Sembunyikan Jawaban' : 'Lihat Jawaban',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Progress tracking buttons - only show when answer is visible
              if (_showAnswer) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient:
                              _cards.isNotEmpty &&
                                  _cards[_currentIndex].isLearned
                              ? LinearGradient(
                                  colors: [
                                    Colors.green.shade400,
                                    Colors.green.shade600,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    Colors.green.shade50,
                                    Colors.green.shade100,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                _cards.isNotEmpty &&
                                    _cards[_currentIndex].isLearned
                                ? Colors.green.shade700
                                : Colors.green.shade300,
                            width: 2,
                          ),
                          boxShadow:
                              _cards.isNotEmpty &&
                                  _cards[_currentIndex].isLearned
                              ? [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: OutlinedButton.icon(
                          onPressed:
                              _cards.isNotEmpty &&
                                  !_cards[_currentIndex].isLearned
                              ? _markAsLearned
                              : null,
                          icon: Icon(
                            _cards.isNotEmpty && _cards[_currentIndex].isLearned
                                ? Icons.check_circle
                                : Icons.school,
                            color:
                                _cards.isNotEmpty &&
                                    _cards[_currentIndex].isLearned
                                ? Colors.white
                                : Colors.green.shade700,
                            size: 20,
                          ),
                          label: Text(
                            _cards.isNotEmpty && _cards[_currentIndex].isLearned
                                ? 'Sudah Dipelajari ✓'
                                : 'Tandai Dipelajari',
                            style: TextStyle(
                              color:
                                  _cards.isNotEmpty &&
                                      _cards[_currentIndex].isLearned
                                  ? Colors.white
                                  : Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient:
                              _cards.isNotEmpty &&
                                  _cards[_currentIndex].isMastered
                              ? LinearGradient(
                                  colors: [
                                    Colors.amber.shade400,
                                    Colors.orange.shade500,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    Colors.amber.shade50,
                                    Colors.amber.shade100,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                _cards.isNotEmpty &&
                                    _cards[_currentIndex].isMastered
                                ? Colors.amber.shade700
                                : Colors.amber.shade300,
                            width: 2,
                          ),
                          boxShadow:
                              _cards.isNotEmpty &&
                                  _cards[_currentIndex].isMastered
                              ? [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: ElevatedButton.icon(
                          onPressed:
                              _cards.isNotEmpty &&
                                  !_cards[_currentIndex].isMastered
                              ? _markAsMastered
                              : null,
                          icon: Icon(
                            _cards.isNotEmpty &&
                                    _cards[_currentIndex].isMastered
                                ? Icons.star
                                : Icons.star_border,
                            color:
                                _cards.isNotEmpty &&
                                    _cards[_currentIndex].isMastered
                                ? Colors.white
                                : Colors.amber.shade700,
                            size: 20,
                          ),
                          label: Text(
                            _cards.isNotEmpty &&
                                    _cards[_currentIndex].isMastered
                                ? 'Dikuasai ⭐'
                                : 'Tandai Dikuasai',
                            style: TextStyle(
                              color:
                                  _cards.isNotEmpty &&
                                      _cards[_currentIndex].isMastered
                                  ? Colors.white
                                  : Colors.amber.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 16),
              // Navigation buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: _currentIndex > 0
                            ? LinearGradient(
                                colors: [
                                  Colors.blue.shade400,
                                  Colors.blue.shade600,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.grey.shade400,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _currentIndex > 0
                            ? [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _currentIndex > 0 ? _previousCard : null,
                        icon: Icon(
                          Icons.arrow_back,
                          color: _currentIndex > 0
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                        label: Text(
                          'Sebelumnya',
                          style: TextStyle(
                            color: _currentIndex > 0
                                ? Colors.white
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: _currentIndex < _cards.length - 1
                            ? LinearGradient(
                                colors: [
                                  Colors.green.shade400,
                                  Colors.green.shade600,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.grey.shade400,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _currentIndex < _cards.length - 1
                            ? [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _currentIndex < _cards.length - 1
                            ? _nextCard
                            : null,
                        icon: Icon(
                          Icons.arrow_forward,
                          color: _currentIndex < _cards.length - 1
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                        label: Text(
                          'Selanjutnya',
                          style: TextStyle(
                            color: _currentIndex < _cards.length - 1
                                ? Colors.white
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
