import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:uslub_araby/main.dart';
import 'package:uslub_araby/providers/theme_provider.dart';
import 'package:uslub_araby/providers/dictionary_provider.dart';

void main() {
  // Setup provider yang dibutuhkan untuk tes
  Widget createTestableWidget({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DictionaryProvider()),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('Layar utama menampilkan judul dan ikon pencarian', (WidgetTester tester) async {
    // Bangun widget MyApp di dalam lingkungan tes
    await tester.pumpWidget(createTestableWidget(child: const MyApp()));

    // Tunggu semua frame selesai dirender
    await tester.pumpAndSettle();

    // Verifikasi bahwa judul AppBar "Kamus Digital" ditampilkan
    expect(find.text('Kamus Digital'), findsOneWidget);

    // Verifikasi bahwa ada ikon pencarian di AppBar
    expect(find.byIcon(Icons.search), findsOneWidget);
    
    // Verifikasi bahwa ada teks "Daftar Kata" yang merupakan judul bagian
    expect(find.text('Daftar Kata'), findsOneWidget);
  });
}
