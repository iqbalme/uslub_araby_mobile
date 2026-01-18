import 'package:flutter/foundation.dart';
import 'package:uslub_araby/data/database.dart';
import 'package:drift/drift.dart';

class FlashcardDeckProvider with ChangeNotifier {
  final AppDatabase _database = AppDatabase();
  final List<FlashcardDeck> _decks = [];
  bool _isLoading = false;

  List<FlashcardDeck> get decks => _decks;
  bool get isLoading => _isLoading;

  Future<void> loadDecks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _decks.clear();
      _decks.addAll(await _database.getAllDecks());
    } catch (e) {
      debugPrint('Error loading decks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createDeck(String name, String? description) async {
    try {
      final deckCompanion = FlashcardDecksCompanion.insert(
        name: name,
        description: Value(description),
      );

      await _database.insertDeck(deckCompanion);
      await loadDecks(); // Reload decks after creation
      return true;
    } catch (e) {
      debugPrint('Error creating deck: $e');
      return false;
    }
  }

  Future<bool> deleteDeck(int id) async {
    try {
      await _database.deleteDeck(id);
      await loadDecks(); // Reload decks after deletion
      return true;
    } catch (e) {
      debugPrint('Error deleting deck: $e');
      return false;
    }
  }

  Future<Map<String, int>> getDeckStats(int deckId) async {
    try {
      return await _database.getDeckStats(deckId);
    } catch (e) {
      debugPrint('Error getting deck stats: $e');
      return {'total': 0, 'learned': 0, 'mastered': 0};
    }
  }

  Future<List<FlashcardCard>> getCardsByDeckId(int deckId) async {
    try {
      return await _database.getCardsByDeckId(deckId);
    } catch (e) {
      debugPrint('Error getting cards: $e');
      return [];
    }
  }

  Future<FlashcardCard?> getCardById(int cardId) async {
    try {
      return await _database.getCardById(cardId);
    } catch (e) {
      debugPrint('Error getting card by id: $e');
      return null;
    }
  }

  Future<bool> isWordInDeck(int deckId, int wordId) async {
    try {
      return await _database.isWordInDeck(deckId, wordId);
    } catch (e) {
      debugPrint('Error checking if word is in deck: $e');
      return false;
    }
  }

  Future<bool> addCardToDeck(int deckId, int wordId) async {
    try {
      // Check if word is already in deck
      final alreadyExists = await isWordInDeck(deckId, wordId);
      if (alreadyExists) {
        return false; // Word already exists in deck
      }

      final cardCompanion = FlashcardCardsCompanion.insert(
        deckId: deckId,
        wordId: wordId,
      );
      await _database.insertCard(cardCompanion);
      return true;
    } catch (e) {
      debugPrint('Error adding card: $e');
      return false;
    }
  }

  Future<bool> removeCardFromDeck(int cardId) async {
    try {
      await _database.deleteCard(cardId);
      return true;
    } catch (e) {
      debugPrint('Error removing card: $e');
      return false;
    }
  }

  Future<bool> updateCardProgress(
    int cardId,
    bool isLearned,
    bool isMastered,
  ) async {
    try {
      final card = await getCardById(cardId);
      if (card == null) {
        debugPrint('Card with id $cardId not found');
        return false;
      }

      final updatedCard = card.copyWith(
        isLearned: isLearned,
        isMastered: isMastered,
      );

      await _database.updateCard(updatedCard);
      return true;
    } catch (e) {
      debugPrint('Error updating card: $e');
      return false;
    }
  }
}
