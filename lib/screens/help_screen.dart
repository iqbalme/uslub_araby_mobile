import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panduan Penggunaan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16).copyWith(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Panduan Lengkap Aplikasi Kamus Uslub',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Selamat datang di aplikasi Kamus Uslub! Berikut adalah panduan lengkap untuk membantu Anda menggunakan semua fitur aplikasi ini.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Pencarian
            _buildSection(
              'Pencarian Ungkapan',
              '1. Buka aplikasi dan ketuk pada kolom pencarian di halaman utama.\n'
                  '2. Ketik kata kunci dalam bahasa Arab atau Indonesia.\n'
                  '3. Aplikasi akan menampilkan hasil pencarian secara real-time.\n'
                  '4. Ketuk pada hasil untuk melihat detail lengkap ungkapan.',
            ),

            // Bookmark
            _buildSection(
              'Menyimpan Kata Favorit (Bookmark)',
              '1. Pada halaman detail ungkapan, ketuk ikon bookmark.\n'
                  '2. Ungkapan akan disimpan ke daftar kata tersimpan.\n'
                  '3. Akses daftar tersimpan melalui menu "Kata Tersimpan".\n'
                  '4. Ketuk ikon bookmark lagi untuk menghapus dari daftar.',
            ),

            // Flashcard
            _buildSection(
              'Latihan dengan Flashcard',
              '1. Buka menu "Flashcard" dari halaman utama.\n'
                  '2. Pilih deck flashcard yang tersedia.\n'
                  '3. Ketuk kartu untuk melihat makna.\n'
                  '4. Gunakan tombol navigasi untuk berpindah antar kartu.\n'
                  '5. Lacak progress latihan Anda.',
            ),

            // Statistik
            _buildSection(
              'Melihat Statistik Pembelajaran',
              '1. Buka menu "Statistik" dari halaman utama.\n'
                  '2. Lihat ringkasan aktivitas pembelajaran Anda.\n'
                  '3. Pantau jumlah kata yang telah dipelajari.\n'
                  '4. Lihat progress harian dan mingguan.',
            ),

            // Pengaturan
            _buildSection(
              'Pengaturan Aplikasi',
              '1. Buka menu "Pengaturan" dari halaman utama.\n'
                  '2. Ubah tema aplikasi (gelap/terang).\n'
                  '3. Sesuaikan preferensi pembelajaran.\n'
                  '4. Kelola data aplikasi.',
            ),

            // Tips
            _buildSection(
              'Tips Pembelajaran',
              '- Pelajari ungkapan dalam konteks kalimat.\n'
                  '- Gunakan flashcard secara rutin untuk mengingat.\n'
                  '- Simpan kata-kata sulit ke bookmark.\n'
                  '- Lihat statistik untuk memotivasi diri.',
            ),

            const SizedBox(height: 32),
            Center(
              child: Text(
                'Jika Anda mengalami kesulitan, hubungi pengembang melalui menu "Laporkan Masalah".',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 14, height: 1.6)),
        const SizedBox(height: 16),
      ],
    );
  }
}
