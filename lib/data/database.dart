import 'package:drift/drift.dart';
import 'connection/connection.dart' as impl;

part 'database.g.dart';

@DataClassName('UslubData')
class Uslub extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ungkapan => text().nullable()();
  TextColumn get makna => text().nullable()();
  TextColumn get contoh => text().nullable()();
}

@DataClassName('FlashcardDeck')
class FlashcardDecks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('FlashcardCard')
class FlashcardCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get deckId => integer().references(FlashcardDecks, #id)();
  IntColumn get wordId => integer().references(Uslub, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isLearned => boolean().withDefault(const Constant(false))();
  BoolColumn get isMastered => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Uslub, FlashcardDecks, FlashcardCards])
class AppDatabase extends _$AppDatabase {
  // Singleton pattern
  static AppDatabase? _instance;

  AppDatabase._internal() : super(impl.connect());

  factory AppDatabase() {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Insert initial data
        await _seedInitialData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Create new tables for flashcard functionality
          await m.createTable(flashcardDecks);
          await m.createTable(flashcardCards);
        }
      },
    );
  }

  Future<void> seedInitialData() async {
    await _seedInitialData();
  }

  Future<void> _seedInitialData() async {
    // Check if data already exists
    final existingData = await getAllWords();
    if (existingData.isNotEmpty) return;

    // Insert initial data
    await into(uslub).insert(
      UslubCompanion.insert(
        ungkapan: const Value('بلغني أن ...'),
        makna: const Value('DENGAR DENGAR'),
        contoh: const Value('''بلغني أنك تزوجت
Dengar dengar kamu udah nikah.

بلغني أنك تعددت
Dengar dengar kamu nikah lagi

بلغني أنها تسكن في هذه المدينة
Dengar dengar dia tinggal di kota ini

بلغني أن الأستاذ يغيب اليوم
Dengar dengar dosennya gak masuk hari ini'''),
      ),
    );

    await into(uslub).insert(
      UslubCompanion.insert(
        ungkapan: const Value('ما شاء الله'),
        makna: const Value('APA YANG DIKEHENDAKI ALLAH'),
        contoh: const Value('''ما شاء الله، أنتِ جميلة جداً
MashaAllah, kamu cantik sekali.

ما شاء الله على نجاحك
MashaAllah atas kesuksesanmu

ما شاء الله، الطفل جميل
MashaAllah, bayinya cantik'''),
      ),
    );

    await into(uslub).insert(
      UslubCompanion.insert(
        ungkapan: const Value('إن شاء الله'),
        makna: const Value('INSYA ALLAH'),
        contoh: const Value('''إن شاء الله أنجح في الامتحان
Insya Allah saya lulus ujian.

إن شاء الله نلتقي غداً
Insya Allah kita bertemu besok

إن شاء الله كل شيء سيكون على ما يرام
Insya Allah semuanya akan baik-baik saja'''),
      ),
    );

    await into(uslub).insert(
      UslubCompanion.insert(
        ungkapan: const Value('الحمد لله'),
        makna: const Value('ALHAMDULILLAH'),
        contoh: const Value('''الحمد لله على الصحة
Alhamdulillah atas kesehatan.

الحمد لله، نجحت في الاختبار
Alhamdulillah, saya lulus tes

الحمد لله على كل شيء
Alhamdulillah atas segalanya'''),
      ),
    );

    await into(uslub).insert(
      UslubCompanion.insert(
        ungkapan: const Value('لا إله إلا الله'),
        makna: const Value('TIDAK ADA TUHAN SELAIN ALLAH'),
        contoh: const Value('''لا إله إلا الله محمد رسول الله
La ilaha illallah Muhammadur rasulullah

لا إله إلا الله
La ilaha illallah'''),
      ),
    );
  }

  Future<List<UslubData>> getAllWords() => select(uslub).get();

  Future<List<UslubData>> searchWords(String query) {
    final lowerQuery = '%${query.toLowerCase()}%';
    return (select(uslub)..where(
          (t) =>
              t.ungkapan.lower().like(lowerQuery) |
              t.makna.lower().like(lowerQuery) |
              t.contoh.lower().like(lowerQuery),
        ))
        .get();
  }

  Future<UslubData?> getWordById(int id) {
    return (select(uslub)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Flashcard Deck methods
  Future<List<FlashcardDeck>> getAllDecks() => select(flashcardDecks).get();

  Future<FlashcardDeck?> getDeckById(int id) {
    return (select(
      flashcardDecks,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertDeck(FlashcardDecksCompanion deck) {
    return into(flashcardDecks).insert(deck);
  }

  Future<bool> updateDeck(FlashcardDeck deck) {
    return update(flashcardDecks).replace(deck);
  }

  Future<int> deleteDeck(int id) {
    return (delete(flashcardDecks)..where((t) => t.id.equals(id))).go();
  }

  // Flashcard Card methods
  Future<List<FlashcardCard>> getCardsByDeckId(int deckId) {
    return (select(
      flashcardCards,
    )..where((t) => t.deckId.equals(deckId))).get();
  }

  Future<FlashcardCard?> getCardById(int cardId) {
    return (select(
      flashcardCards,
    )..where((t) => t.id.equals(cardId))).getSingleOrNull();
  }

  Future<bool> isWordInDeck(int deckId, int wordId) async {
    final result = await (select(
      flashcardCards,
    )..where((t) => t.deckId.equals(deckId) & t.wordId.equals(wordId))).get();
    return result.isNotEmpty;
  }

  Future<int> insertCard(FlashcardCardsCompanion card) {
    return into(flashcardCards).insert(card);
  }

  Future<int> deleteCard(int id) {
    return (delete(flashcardCards)..where((t) => t.id.equals(id))).go();
  }

  Future<bool> updateCard(FlashcardCard card) {
    return update(flashcardCards).replace(card);
  }

  Future<int> resetFlashcardProgress() async {
    return (update(flashcardCards)
          ..where((t) => t.isLearned.equals(true) | t.isMastered.equals(true)))
        .write(
          FlashcardCardsCompanion(
            isLearned: const Value(false),
            isMastered: const Value(false),
          ),
        );
  }

  // Get deck statistics
  Future<Map<String, int>> getDeckStats(int deckId) async {
    final cards = await getCardsByDeckId(deckId);
    final learned = cards.where((card) => card.isLearned).length;
    final mastered = cards.where((card) => card.isMastered).length;
    return {'total': cards.length, 'learned': learned, 'mastered': mastered};
  }
}
