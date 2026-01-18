
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uslub_araby/providers/uslub_provider.dart';

class UslubScreen extends StatelessWidget {
  const UslubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UslubProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kamus Uslub'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) => provider.search(query),
              decoration: InputDecoration(
                hintText: 'Cari Uslub...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.words.isEmpty
                    ? const Center(child: Text('Tidak ada data ditemukan.'))
                    : ListView.builder(
                        itemCount: provider.words.length,
                        itemBuilder: (context, index) {
                          final uslub = provider.words[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    uslub.arab,
                                    style: GoogleFonts.scheherazadeNew(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    uslub.latin,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
