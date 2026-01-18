import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:go_router/go_router.dart';
import 'package:uslub_araby/providers/flashcard_deck_provider.dart';

class FlashcardDeckScreen extends StatefulWidget {
  const FlashcardDeckScreen({super.key});

  @override
  State<FlashcardDeckScreen> createState() => _FlashcardDeckScreenState();
}

class _FlashcardDeckScreenState extends State<FlashcardDeckScreen> {
  @override
  void initState() {
    super.initState();
    // Load decks when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FlashcardDeckProvider>().loadDecks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcard')),
      body: Consumer<FlashcardDeckProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final decks = provider.decks;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Card
                FutureBuilder<Map<String, int>>(
                  future: _getTotalStats(provider),
                  builder: (context, snapshot) {
                    final stats =
                        snapshot.data ??
                        {'total': 0, 'learned': 0, 'mastered': 0};
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              context,
                              stats['total'].toString(),
                              'Total Kartu',
                            ),
                            _buildStatItem(
                              context,
                              stats['learned'].toString(),
                              'Dipelajari',
                            ),
                            _buildStatItem(
                              context,
                              stats['mastered'].toString(),
                              'Dikuasai',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Deck Flashcard',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Deck List or Empty State
                Expanded(
                  child: decks.isEmpty
                      ? _buildEmptyState()
                      : _buildDeckList(decks),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDeckDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<Map<String, int>> _getTotalStats(
    FlashcardDeckProvider provider,
  ) async {
    int total = 0, learned = 0, mastered = 0;
    for (final deck in provider.decks) {
      final stats = await provider.getDeckStats(deck.id);
      total += stats['total']!;
      learned += stats['learned']!;
      mastered += stats['mastered']!;
    }
    return {'total': total, 'learned': learned, 'mastered': mastered};
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.style_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada deck flashcard',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Simpan kata untuk membuat flashcard',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildDeckList(List decks) {
    return ListView.builder(
      itemCount: decks.length,
      itemBuilder: (context, index) {
        final deck = decks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.folder,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(
              deck.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: deck.description != null && deck.description!.isNotEmpty
                ? Text(deck.description!)
                : Text(
                    '${deck.createdAt.day}/${deck.createdAt.month}/${deck.createdAt.year}',
                  ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteDeckDialog(context, deck);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Hapus Deck'),
                    ],
                  ),
                ),
              ],
              child: FutureBuilder<Map<String, int>>(
                future: context.read<FlashcardDeckProvider>().getDeckStats(
                  deck.id,
                ),
                builder: (context, snapshot) {
                  final stats = snapshot.data;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        stats != null ? '${stats['total']} kartu' : '0 kartu',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const Icon(Icons.more_vert),
                    ],
                  );
                },
              ),
            ),
            onTap: () {
              context.go('/flashcard-session/${deck.id}');
            },
          ),
        );
      },
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  void _showCreateDeckDialog(BuildContext context) {
    final TextEditingController deckNameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            const Text(
              'Buat Deck Flashcard Baru',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Form fields
            TextField(
              controller: deckNameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nama Deck',
                hintText: 'Masukkan nama deck...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.folder),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi (Opsional)',
                hintText: 'Deskripsi deck...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final deckName = deckNameController.text.trim();
                      if (deckName.isNotEmpty) {
                        final navigator = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);
                        final success = await context
                            .read<FlashcardDeckProvider>()
                            .createDeck(
                              deckName,
                              descriptionController.text.trim().isEmpty
                                  ? null
                                  : descriptionController.text.trim(),
                            );

                        if (success) {
                          navigator.pop();
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                'Deck "$deckName" berhasil dibuat!',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Gagal membuat deck'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nama deck tidak boleh kosong'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Buat Deck'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showDeleteDeckDialog(BuildContext context, deck) {
    PanaraConfirmDialog.show(
      context,
      title: 'Hapus Deck',
      message:
          'Apakah Anda yakin ingin menghapus deck "${deck.name}"? Semua kartu flashcard di dalam deck ini akan dihapus secara permanen. Tindakan ini tidak dapat dibatalkan.',
      confirmButtonText: 'Hapus',
      cancelButtonText: 'Batal',
      onTapConfirm: () async {
        final messenger = ScaffoldMessenger.of(context);
        final navigator = Navigator.of(context, rootNavigator: true);
        try {
          final success = await context
              .read<FlashcardDeckProvider>()
              .deleteDeck(deck.id);

          navigator.pop(); // Close dialog first

          if (success) {
            messenger.showSnackBar(
              SnackBar(
                content: Text('Deck "${deck.name}" berhasil dihapus'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            messenger.showSnackBar(
              const SnackBar(
                content: Text('Gagal menghapus deck'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          debugPrint('Error in delete deck dialog: $e');
          // Close dialog even if there's an error
          navigator.pop();
          // Show error message
          messenger.showSnackBar(
            SnackBar(
              content: Text('Terjadi kesalahan: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      onTapCancel: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
      panaraDialogType: PanaraDialogType.error,
      barrierDismissible: false,
    );
  }
}
