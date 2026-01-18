import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:uslub_araby/providers/uslub_provider.dart';

class UslubScreen extends StatelessWidget {
  const UslubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pencarian'),
        actions: [
          Consumer<UslubProvider>(
            builder: (context, provider, child) {
              if (provider.recentSearches.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ElevatedButton.icon(
                  onPressed: () => _showClearAllDialog(context, provider),
                  icon: const Icon(Icons.delete_sweep),
                  label: const Text('Hapus Semua'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(color: Colors.white),
                    elevation: 0,
                    side: const BorderSide(color: Colors.red, width: 0),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF1a1a2e), // Dark Grey / Deep Blue background
        child: Consumer<UslubProvider>(
          builder: (context, provider, child) {
            if (provider.recentSearches.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: Colors.white54),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada riwayat pencarian',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: provider.recentSearches.length,
              itemBuilder: (context, index) {
                final search = provider.recentSearches[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x33FFFFFF), // Semi-transparent white
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.search, color: Colors.white),
                    title: Text(
                      search,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () {
                        provider.removeFromRecentSearches(search);
                      },
                    ),
                    onTap: () {
                      // Navigate back to home with search query
                      GoRouter.of(context).go('/', extra: search);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, UslubProvider provider) {
    PanaraConfirmDialog.show(
      context,
      title: 'Hapus Semua Riwayat',
      message: 'Apakah Anda yakin ingin menghapus semua riwayat pencarian?',
      confirmButtonText: 'Hapus',
      cancelButtonText: 'Batal',
      onTapCancel: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
      onTapConfirm: () {
        provider.clearAllRecentSearches();
        Navigator.of(context, rootNavigator: true).pop();
      },
      panaraDialogType: PanaraDialogType.warning,
      barrierDismissible: false,
    );
  }
}
