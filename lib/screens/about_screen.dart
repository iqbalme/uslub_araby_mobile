import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16,
        ).copyWith(bottom: 100), // Extra bottom padding for navigation bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo/Title
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.library_books,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Kamus Uslub',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Versi 1.0.0',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Description
            const Text(
              'Tentang Aplikasi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Kamus Uslub adalah aplikasi pembelajaran bahasa Arab yang '
                  'dirancang khusus untuk membantu Anda mempelajari ungkapan '
                  'dan idiom dalam bahasa Arab dengan cara yang menyenangkan '
                  'dan interaktif.\n\n'
                  'Aplikasi ini menyediakan:\n'
                  '• Kamus lengkap ungkapan Arab\n'
                  '• Sistem pencarian cerdas\n'
                  '• Fitur bookmark untuk menyimpan kata favorit\n'
                  '• Statistik pembelajaran\n'
                  '• Mode gelap/terang\n'
                  '• Flashcard untuk latihan\n\n'
                  'Dikembangkan dengan ❤️ untuk memudahkan pembelajaran bahasa Arab.',
                  style: TextStyle(fontSize: 14, height: 1.6),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Features
            const Text(
              'Fitur Utama',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            _buildFeatureItem(
              context,
              'Kamus Lengkap',
              'Koleksi ungkapan Arab dengan makna dan contoh penggunaan',
              Icons.book,
            ),

            _buildFeatureItem(
              context,
              'Pencarian Cerdas',
              'Temukan ungkapan dengan cepat melalui fitur pencarian',
              Icons.search,
            ),

            _buildFeatureItem(
              context,
              'Bookmark',
              'Simpan ungkapan favorit untuk akses cepat',
              Icons.bookmark,
            ),

            _buildFeatureItem(
              context,
              'Statistik',
              'Pantau progress belajar Anda',
              Icons.bar_chart,
            ),

            _buildFeatureItem(
              context,
              'Flashcard',
              'Latihan interaktif untuk mengingat ungkapan',
              Icons.style,
            ),

            const SizedBox(height: 24),

            // Contact/Developer
            const Text(
              'Pengembang',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.person, size: 30, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Developer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dikembangkan untuk memudahkan pembelajaran bahasa Arab',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Links
            const Text(
              'Tautan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            _buildLinkItem(
              context,
              'Laporkan Masalah',
              'Kirim feedback atau laporkan bug',
              Icons.bug_report,
              () {
                // TODO: Implement feedback system
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur feedback akan segera hadir'),
                  ),
                );
              },
            ),

            _buildLinkItem(
              context,
              'Bantuan',
              'Panduan penggunaan aplikasi',
              Icons.help,
              () {
                // TODO: Implement help system
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Panduan akan segera tersedia')),
                );
              },
            ),

            const SizedBox(height: 32),

            // Footer
            Center(
              child: Text(
                '© 2024 Kamus Uslub. All rights reserved.',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildLinkItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
