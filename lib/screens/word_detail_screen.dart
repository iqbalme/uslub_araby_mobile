import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uslub_araby/providers/uslub_provider.dart';

class WordDetailScreen extends StatefulWidget {
  final String wordId;

  const WordDetailScreen({super.key, required this.wordId});

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  Kamus? _kamus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWordDetails();
  }

  Future<void> _fetchWordDetails() async {
    final provider = Provider.of<DictionaryProvider>(context, listen: false);
    final intId = int.tryParse(widget.wordId);
    if (intId != null) {
      final kamus = await provider.getWordById(intId);
      if (mounted) { // Cek jika widget masih ada di tree
        setState(() {
          _kamus = kamus;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(_isLoading || _kamus == null ? 'Memuat...' : _kamus!.makna), // Ganti ke makna
        actions: [
          if (!_isLoading && _kamus != null)
            Consumer<SavedWordsProvider>(
              builder: (context, savedWordsProvider, child) {
                final bool isSaved = savedWordsProvider.isSaved(_kamus!);
                return IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.blueAccent : null,
                  ),
                  onPressed: () {
                    savedWordsProvider.toggleSaved(_kamus!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          !isSaved // Logikanya terbalik di sini
                              ? '"${_kamus!.makna}" disimpan.'
                              : '"${_kamus!.makna}" dihapus dari daftar simpan.',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  tooltip: 'Simpan Kata',
                );
              },
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_kamus == null) {
      return const Center(
        child: Text(
          'Detail kata tidak ditemukan.',
          style: TextStyle(fontSize: 18, color: Colors.redAccent),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ungkapan Arab
          Text(
            _kamus!.ungkapan, // Ganti ke ungkapan
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          const Divider(thickness: 1.5),
          const SizedBox(height: 20),
          // Label "Contoh Penggunaan"
          Text(
            'Contoh Penggunaan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
          ),
          const SizedBox(height: 10),
          // Contoh Penggunaan
          Text(
            _kamus!.contoh ?? 'Tidak ada contoh tersedia.', // Ganti ke contoh
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }
}
