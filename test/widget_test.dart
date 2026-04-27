import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uslub_araby/main.dart';
import 'package:uslub_araby/providers/profile_provider.dart';

void main() {
  testWidgets('Layar utama menampilkan judul dan ikon pencarian', (
    WidgetTester tester,
  ) async {
    // Bangun widget MyApp di dalam lingkungan tes
    final profileProvider = ProfileProvider();
    await tester.pumpWidget(MyApp(profileProvider: profileProvider));

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
