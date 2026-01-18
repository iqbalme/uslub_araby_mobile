import 'package:go_router/go_router.dart';
import 'package:uslub_araby/main_screen.dart';
import 'package:uslub_araby/screens/home_screen.dart';
import 'package:uslub_araby/screens/uslub_screen.dart';
import 'package:uslub_araby/screens/saved_words_screen.dart';
import 'package:uslub_araby/screens/flashcard_deck_screen.dart';
import 'package:uslub_araby/screens/profile_screen.dart';
import 'package:uslub_araby/screens/settings_screen.dart';
import 'package:uslub_araby/screens/statistics_screen.dart';
import 'package:uslub_araby/screens/about_screen.dart';
import 'package:uslub_araby/screens/word_detail_screen.dart';
import 'package:uslub_araby/screens/flashcard_session_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/uslub',
          builder: (context, state) => const UslubScreen(),
        ),
        GoRoute(
          path: '/saved',
          builder: (context, state) => const SavedWordsScreen(),
        ),
        GoRoute(
          path: '/flashcards',
          builder: (context, state) => const FlashcardDeckScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/statistics',
          builder: (context, state) => const StatisticsScreen(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: '/word/:id',
          builder: (context, state) {
            final wordId = state.pathParameters['id']!;
            return WordDetailScreen(wordId: wordId);
          },
        ),
        GoRoute(
          path: '/flashcard-session/:deckId',
          builder: (context, state) {
            final deckId = state.pathParameters['deckId']!;
            return FlashcardSessionScreen(deckId: deckId);
          },
        ),
      ],
    ),
  ],
);
