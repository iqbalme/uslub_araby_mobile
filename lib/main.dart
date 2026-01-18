import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uslub_araby/app_router.dart';
import 'package:uslub_araby/providers/uslub_provider.dart';
import 'package:uslub_araby/providers/theme_provider.dart';
import 'package:uslub_araby/providers/saved_words_provider.dart';
import 'package:uslub_araby/providers/flashcard_deck_provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.lightBlue[300],
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(
          context,
        ).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.lightBlue[900],
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UslubProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SavedWordsProvider()),
        ChangeNotifierProvider(create: (_) => FlashcardDeckProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            routerConfig: router,
            title: 'Uslub Dictionary',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
