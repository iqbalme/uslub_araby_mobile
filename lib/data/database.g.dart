// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UslubTable extends Uslub with TableInfo<$UslubTable, UslubData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UslubTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ungkapanMeta = const VerificationMeta(
    'ungkapan',
  );
  @override
  late final GeneratedColumn<String> ungkapan = GeneratedColumn<String>(
    'ungkapan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maknaMeta = const VerificationMeta('makna');
  @override
  late final GeneratedColumn<String> makna = GeneratedColumn<String>(
    'makna',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contohMeta = const VerificationMeta('contoh');
  @override
  late final GeneratedColumn<String> contoh = GeneratedColumn<String>(
    'contoh',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, ungkapan, makna, contoh];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'uslub';
  @override
  VerificationContext validateIntegrity(
    Insertable<UslubData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ungkapan')) {
      context.handle(
        _ungkapanMeta,
        ungkapan.isAcceptableOrUnknown(data['ungkapan']!, _ungkapanMeta),
      );
    }
    if (data.containsKey('makna')) {
      context.handle(
        _maknaMeta,
        makna.isAcceptableOrUnknown(data['makna']!, _maknaMeta),
      );
    }
    if (data.containsKey('contoh')) {
      context.handle(
        _contohMeta,
        contoh.isAcceptableOrUnknown(data['contoh']!, _contohMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UslubData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UslubData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ungkapan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ungkapan'],
      ),
      makna: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}makna'],
      ),
      contoh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contoh'],
      ),
    );
  }

  @override
  $UslubTable createAlias(String alias) {
    return $UslubTable(attachedDatabase, alias);
  }
}

class UslubData extends DataClass implements Insertable<UslubData> {
  final int id;
  final String? ungkapan;
  final String? makna;
  final String? contoh;
  const UslubData({required this.id, this.ungkapan, this.makna, this.contoh});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || ungkapan != null) {
      map['ungkapan'] = Variable<String>(ungkapan);
    }
    if (!nullToAbsent || makna != null) {
      map['makna'] = Variable<String>(makna);
    }
    if (!nullToAbsent || contoh != null) {
      map['contoh'] = Variable<String>(contoh);
    }
    return map;
  }

  UslubCompanion toCompanion(bool nullToAbsent) {
    return UslubCompanion(
      id: Value(id),
      ungkapan: ungkapan == null && nullToAbsent
          ? const Value.absent()
          : Value(ungkapan),
      makna: makna == null && nullToAbsent
          ? const Value.absent()
          : Value(makna),
      contoh: contoh == null && nullToAbsent
          ? const Value.absent()
          : Value(contoh),
    );
  }

  factory UslubData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UslubData(
      id: serializer.fromJson<int>(json['id']),
      ungkapan: serializer.fromJson<String?>(json['ungkapan']),
      makna: serializer.fromJson<String?>(json['makna']),
      contoh: serializer.fromJson<String?>(json['contoh']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ungkapan': serializer.toJson<String?>(ungkapan),
      'makna': serializer.toJson<String?>(makna),
      'contoh': serializer.toJson<String?>(contoh),
    };
  }

  UslubData copyWith({
    int? id,
    Value<String?> ungkapan = const Value.absent(),
    Value<String?> makna = const Value.absent(),
    Value<String?> contoh = const Value.absent(),
  }) => UslubData(
    id: id ?? this.id,
    ungkapan: ungkapan.present ? ungkapan.value : this.ungkapan,
    makna: makna.present ? makna.value : this.makna,
    contoh: contoh.present ? contoh.value : this.contoh,
  );
  UslubData copyWithCompanion(UslubCompanion data) {
    return UslubData(
      id: data.id.present ? data.id.value : this.id,
      ungkapan: data.ungkapan.present ? data.ungkapan.value : this.ungkapan,
      makna: data.makna.present ? data.makna.value : this.makna,
      contoh: data.contoh.present ? data.contoh.value : this.contoh,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UslubData(')
          ..write('id: $id, ')
          ..write('ungkapan: $ungkapan, ')
          ..write('makna: $makna, ')
          ..write('contoh: $contoh')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ungkapan, makna, contoh);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UslubData &&
          other.id == this.id &&
          other.ungkapan == this.ungkapan &&
          other.makna == this.makna &&
          other.contoh == this.contoh);
}

class UslubCompanion extends UpdateCompanion<UslubData> {
  final Value<int> id;
  final Value<String?> ungkapan;
  final Value<String?> makna;
  final Value<String?> contoh;
  const UslubCompanion({
    this.id = const Value.absent(),
    this.ungkapan = const Value.absent(),
    this.makna = const Value.absent(),
    this.contoh = const Value.absent(),
  });
  UslubCompanion.insert({
    this.id = const Value.absent(),
    this.ungkapan = const Value.absent(),
    this.makna = const Value.absent(),
    this.contoh = const Value.absent(),
  });
  static Insertable<UslubData> custom({
    Expression<int>? id,
    Expression<String>? ungkapan,
    Expression<String>? makna,
    Expression<String>? contoh,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ungkapan != null) 'ungkapan': ungkapan,
      if (makna != null) 'makna': makna,
      if (contoh != null) 'contoh': contoh,
    });
  }

  UslubCompanion copyWith({
    Value<int>? id,
    Value<String?>? ungkapan,
    Value<String?>? makna,
    Value<String?>? contoh,
  }) {
    return UslubCompanion(
      id: id ?? this.id,
      ungkapan: ungkapan ?? this.ungkapan,
      makna: makna ?? this.makna,
      contoh: contoh ?? this.contoh,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ungkapan.present) {
      map['ungkapan'] = Variable<String>(ungkapan.value);
    }
    if (makna.present) {
      map['makna'] = Variable<String>(makna.value);
    }
    if (contoh.present) {
      map['contoh'] = Variable<String>(contoh.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UslubCompanion(')
          ..write('id: $id, ')
          ..write('ungkapan: $ungkapan, ')
          ..write('makna: $makna, ')
          ..write('contoh: $contoh')
          ..write(')'))
        .toString();
  }
}

class $FlashcardDecksTable extends FlashcardDecks
    with TableInfo<$FlashcardDecksTable, FlashcardDeck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlashcardDecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flashcard_decks';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlashcardDeck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FlashcardDeck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlashcardDeck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FlashcardDecksTable createAlias(String alias) {
    return $FlashcardDecksTable(attachedDatabase, alias);
  }
}

class FlashcardDeck extends DataClass implements Insertable<FlashcardDeck> {
  final int id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FlashcardDeck({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FlashcardDecksCompanion toCompanion(bool nullToAbsent) {
    return FlashcardDecksCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FlashcardDeck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlashcardDeck(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FlashcardDeck copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FlashcardDeck(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FlashcardDeck copyWithCompanion(FlashcardDecksCompanion data) {
    return FlashcardDeck(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardDeck(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlashcardDeck &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FlashcardDecksCompanion extends UpdateCompanion<FlashcardDeck> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FlashcardDecksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FlashcardDecksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<FlashcardDeck> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FlashcardDecksCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return FlashcardDecksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardDecksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FlashcardCardsTable extends FlashcardCards
    with TableInfo<$FlashcardCardsTable, FlashcardCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlashcardCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<int> deckId = GeneratedColumn<int>(
    'deck_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES flashcard_decks (id)',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES uslub (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isLearnedMeta = const VerificationMeta(
    'isLearned',
  );
  @override
  late final GeneratedColumn<bool> isLearned = GeneratedColumn<bool>(
    'is_learned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_learned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isMasteredMeta = const VerificationMeta(
    'isMastered',
  );
  @override
  late final GeneratedColumn<bool> isMastered = GeneratedColumn<bool>(
    'is_mastered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_mastered" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deckId,
    wordId,
    createdAt,
    isLearned,
    isMastered,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flashcard_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlashcardCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('deck_id')) {
      context.handle(
        _deckIdMeta,
        deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_learned')) {
      context.handle(
        _isLearnedMeta,
        isLearned.isAcceptableOrUnknown(data['is_learned']!, _isLearnedMeta),
      );
    }
    if (data.containsKey('is_mastered')) {
      context.handle(
        _isMasteredMeta,
        isMastered.isAcceptableOrUnknown(data['is_mastered']!, _isMasteredMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FlashcardCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlashcardCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      deckId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deck_id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isLearned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_learned'],
      )!,
      isMastered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_mastered'],
      )!,
    );
  }

  @override
  $FlashcardCardsTable createAlias(String alias) {
    return $FlashcardCardsTable(attachedDatabase, alias);
  }
}

class FlashcardCard extends DataClass implements Insertable<FlashcardCard> {
  final int id;
  final int deckId;
  final int wordId;
  final DateTime createdAt;
  final bool isLearned;
  final bool isMastered;
  const FlashcardCard({
    required this.id,
    required this.deckId,
    required this.wordId,
    required this.createdAt,
    required this.isLearned,
    required this.isMastered,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['deck_id'] = Variable<int>(deckId);
    map['word_id'] = Variable<int>(wordId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_learned'] = Variable<bool>(isLearned);
    map['is_mastered'] = Variable<bool>(isMastered);
    return map;
  }

  FlashcardCardsCompanion toCompanion(bool nullToAbsent) {
    return FlashcardCardsCompanion(
      id: Value(id),
      deckId: Value(deckId),
      wordId: Value(wordId),
      createdAt: Value(createdAt),
      isLearned: Value(isLearned),
      isMastered: Value(isMastered),
    );
  }

  factory FlashcardCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlashcardCard(
      id: serializer.fromJson<int>(json['id']),
      deckId: serializer.fromJson<int>(json['deckId']),
      wordId: serializer.fromJson<int>(json['wordId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isLearned: serializer.fromJson<bool>(json['isLearned']),
      isMastered: serializer.fromJson<bool>(json['isMastered']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deckId': serializer.toJson<int>(deckId),
      'wordId': serializer.toJson<int>(wordId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isLearned': serializer.toJson<bool>(isLearned),
      'isMastered': serializer.toJson<bool>(isMastered),
    };
  }

  FlashcardCard copyWith({
    int? id,
    int? deckId,
    int? wordId,
    DateTime? createdAt,
    bool? isLearned,
    bool? isMastered,
  }) => FlashcardCard(
    id: id ?? this.id,
    deckId: deckId ?? this.deckId,
    wordId: wordId ?? this.wordId,
    createdAt: createdAt ?? this.createdAt,
    isLearned: isLearned ?? this.isLearned,
    isMastered: isMastered ?? this.isMastered,
  );
  FlashcardCard copyWithCompanion(FlashcardCardsCompanion data) {
    return FlashcardCard(
      id: data.id.present ? data.id.value : this.id,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isLearned: data.isLearned.present ? data.isLearned.value : this.isLearned,
      isMastered: data.isMastered.present
          ? data.isMastered.value
          : this.isMastered,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardCard(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('wordId: $wordId, ')
          ..write('createdAt: $createdAt, ')
          ..write('isLearned: $isLearned, ')
          ..write('isMastered: $isMastered')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, deckId, wordId, createdAt, isLearned, isMastered);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlashcardCard &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          other.wordId == this.wordId &&
          other.createdAt == this.createdAt &&
          other.isLearned == this.isLearned &&
          other.isMastered == this.isMastered);
}

class FlashcardCardsCompanion extends UpdateCompanion<FlashcardCard> {
  final Value<int> id;
  final Value<int> deckId;
  final Value<int> wordId;
  final Value<DateTime> createdAt;
  final Value<bool> isLearned;
  final Value<bool> isMastered;
  const FlashcardCardsCompanion({
    this.id = const Value.absent(),
    this.deckId = const Value.absent(),
    this.wordId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isLearned = const Value.absent(),
    this.isMastered = const Value.absent(),
  });
  FlashcardCardsCompanion.insert({
    this.id = const Value.absent(),
    required int deckId,
    required int wordId,
    this.createdAt = const Value.absent(),
    this.isLearned = const Value.absent(),
    this.isMastered = const Value.absent(),
  }) : deckId = Value(deckId),
       wordId = Value(wordId);
  static Insertable<FlashcardCard> custom({
    Expression<int>? id,
    Expression<int>? deckId,
    Expression<int>? wordId,
    Expression<DateTime>? createdAt,
    Expression<bool>? isLearned,
    Expression<bool>? isMastered,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (wordId != null) 'word_id': wordId,
      if (createdAt != null) 'created_at': createdAt,
      if (isLearned != null) 'is_learned': isLearned,
      if (isMastered != null) 'is_mastered': isMastered,
    });
  }

  FlashcardCardsCompanion copyWith({
    Value<int>? id,
    Value<int>? deckId,
    Value<int>? wordId,
    Value<DateTime>? createdAt,
    Value<bool>? isLearned,
    Value<bool>? isMastered,
  }) {
    return FlashcardCardsCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      wordId: wordId ?? this.wordId,
      createdAt: createdAt ?? this.createdAt,
      isLearned: isLearned ?? this.isLearned,
      isMastered: isMastered ?? this.isMastered,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<int>(deckId.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isLearned.present) {
      map['is_learned'] = Variable<bool>(isLearned.value);
    }
    if (isMastered.present) {
      map['is_mastered'] = Variable<bool>(isMastered.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardCardsCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('wordId: $wordId, ')
          ..write('createdAt: $createdAt, ')
          ..write('isLearned: $isLearned, ')
          ..write('isMastered: $isMastered')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UslubTable uslub = $UslubTable(this);
  late final $FlashcardDecksTable flashcardDecks = $FlashcardDecksTable(this);
  late final $FlashcardCardsTable flashcardCards = $FlashcardCardsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    uslub,
    flashcardDecks,
    flashcardCards,
  ];
}

typedef $$UslubTableCreateCompanionBuilder =
    UslubCompanion Function({
      Value<int> id,
      Value<String?> ungkapan,
      Value<String?> makna,
      Value<String?> contoh,
    });
typedef $$UslubTableUpdateCompanionBuilder =
    UslubCompanion Function({
      Value<int> id,
      Value<String?> ungkapan,
      Value<String?> makna,
      Value<String?> contoh,
    });

final class $$UslubTableReferences
    extends BaseReferences<_$AppDatabase, $UslubTable, UslubData> {
  $$UslubTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FlashcardCardsTable, List<FlashcardCard>>
  _flashcardCardsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.flashcardCards,
    aliasName: $_aliasNameGenerator(db.uslub.id, db.flashcardCards.wordId),
  );

  $$FlashcardCardsTableProcessedTableManager get flashcardCardsRefs {
    final manager = $$FlashcardCardsTableTableManager(
      $_db,
      $_db.flashcardCards,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_flashcardCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UslubTableFilterComposer extends Composer<_$AppDatabase, $UslubTable> {
  $$UslubTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ungkapan => $composableBuilder(
    column: $table.ungkapan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get makna => $composableBuilder(
    column: $table.makna,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contoh => $composableBuilder(
    column: $table.contoh,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> flashcardCardsRefs(
    Expression<bool> Function($$FlashcardCardsTableFilterComposer f) f,
  ) {
    final $$FlashcardCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flashcardCards,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardCardsTableFilterComposer(
            $db: $db,
            $table: $db.flashcardCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UslubTableOrderingComposer
    extends Composer<_$AppDatabase, $UslubTable> {
  $$UslubTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ungkapan => $composableBuilder(
    column: $table.ungkapan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get makna => $composableBuilder(
    column: $table.makna,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contoh => $composableBuilder(
    column: $table.contoh,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UslubTableAnnotationComposer
    extends Composer<_$AppDatabase, $UslubTable> {
  $$UslubTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ungkapan =>
      $composableBuilder(column: $table.ungkapan, builder: (column) => column);

  GeneratedColumn<String> get makna =>
      $composableBuilder(column: $table.makna, builder: (column) => column);

  GeneratedColumn<String> get contoh =>
      $composableBuilder(column: $table.contoh, builder: (column) => column);

  Expression<T> flashcardCardsRefs<T extends Object>(
    Expression<T> Function($$FlashcardCardsTableAnnotationComposer a) f,
  ) {
    final $$FlashcardCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flashcardCards,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.flashcardCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UslubTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UslubTable,
          UslubData,
          $$UslubTableFilterComposer,
          $$UslubTableOrderingComposer,
          $$UslubTableAnnotationComposer,
          $$UslubTableCreateCompanionBuilder,
          $$UslubTableUpdateCompanionBuilder,
          (UslubData, $$UslubTableReferences),
          UslubData,
          PrefetchHooks Function({bool flashcardCardsRefs})
        > {
  $$UslubTableTableManager(_$AppDatabase db, $UslubTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UslubTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UslubTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UslubTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> ungkapan = const Value.absent(),
                Value<String?> makna = const Value.absent(),
                Value<String?> contoh = const Value.absent(),
              }) => UslubCompanion(
                id: id,
                ungkapan: ungkapan,
                makna: makna,
                contoh: contoh,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> ungkapan = const Value.absent(),
                Value<String?> makna = const Value.absent(),
                Value<String?> contoh = const Value.absent(),
              }) => UslubCompanion.insert(
                id: id,
                ungkapan: ungkapan,
                makna: makna,
                contoh: contoh,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UslubTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({flashcardCardsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (flashcardCardsRefs) db.flashcardCards,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (flashcardCardsRefs)
                    await $_getPrefetchedData<
                      UslubData,
                      $UslubTable,
                      FlashcardCard
                    >(
                      currentTable: table,
                      referencedTable: $$UslubTableReferences
                          ._flashcardCardsRefsTable(db),
                      managerFromTypedResult: (p0) => $$UslubTableReferences(
                        db,
                        table,
                        p0,
                      ).flashcardCardsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.wordId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UslubTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UslubTable,
      UslubData,
      $$UslubTableFilterComposer,
      $$UslubTableOrderingComposer,
      $$UslubTableAnnotationComposer,
      $$UslubTableCreateCompanionBuilder,
      $$UslubTableUpdateCompanionBuilder,
      (UslubData, $$UslubTableReferences),
      UslubData,
      PrefetchHooks Function({bool flashcardCardsRefs})
    >;
typedef $$FlashcardDecksTableCreateCompanionBuilder =
    FlashcardDecksCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$FlashcardDecksTableUpdateCompanionBuilder =
    FlashcardDecksCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$FlashcardDecksTableReferences
    extends BaseReferences<_$AppDatabase, $FlashcardDecksTable, FlashcardDeck> {
  $$FlashcardDecksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$FlashcardCardsTable, List<FlashcardCard>>
  _flashcardCardsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.flashcardCards,
    aliasName: $_aliasNameGenerator(
      db.flashcardDecks.id,
      db.flashcardCards.deckId,
    ),
  );

  $$FlashcardCardsTableProcessedTableManager get flashcardCardsRefs {
    final manager = $$FlashcardCardsTableTableManager(
      $_db,
      $_db.flashcardCards,
    ).filter((f) => f.deckId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_flashcardCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FlashcardDecksTableFilterComposer
    extends Composer<_$AppDatabase, $FlashcardDecksTable> {
  $$FlashcardDecksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> flashcardCardsRefs(
    Expression<bool> Function($$FlashcardCardsTableFilterComposer f) f,
  ) {
    final $$FlashcardCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flashcardCards,
      getReferencedColumn: (t) => t.deckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardCardsTableFilterComposer(
            $db: $db,
            $table: $db.flashcardCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FlashcardDecksTableOrderingComposer
    extends Composer<_$AppDatabase, $FlashcardDecksTable> {
  $$FlashcardDecksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FlashcardDecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlashcardDecksTable> {
  $$FlashcardDecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> flashcardCardsRefs<T extends Object>(
    Expression<T> Function($$FlashcardCardsTableAnnotationComposer a) f,
  ) {
    final $$FlashcardCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flashcardCards,
      getReferencedColumn: (t) => t.deckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.flashcardCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FlashcardDecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlashcardDecksTable,
          FlashcardDeck,
          $$FlashcardDecksTableFilterComposer,
          $$FlashcardDecksTableOrderingComposer,
          $$FlashcardDecksTableAnnotationComposer,
          $$FlashcardDecksTableCreateCompanionBuilder,
          $$FlashcardDecksTableUpdateCompanionBuilder,
          (FlashcardDeck, $$FlashcardDecksTableReferences),
          FlashcardDeck,
          PrefetchHooks Function({bool flashcardCardsRefs})
        > {
  $$FlashcardDecksTableTableManager(
    _$AppDatabase db,
    $FlashcardDecksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlashcardDecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlashcardDecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlashcardDecksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FlashcardDecksCompanion(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FlashcardDecksCompanion.insert(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FlashcardDecksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({flashcardCardsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (flashcardCardsRefs) db.flashcardCards,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (flashcardCardsRefs)
                    await $_getPrefetchedData<
                      FlashcardDeck,
                      $FlashcardDecksTable,
                      FlashcardCard
                    >(
                      currentTable: table,
                      referencedTable: $$FlashcardDecksTableReferences
                          ._flashcardCardsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FlashcardDecksTableReferences(
                            db,
                            table,
                            p0,
                          ).flashcardCardsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.deckId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FlashcardDecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlashcardDecksTable,
      FlashcardDeck,
      $$FlashcardDecksTableFilterComposer,
      $$FlashcardDecksTableOrderingComposer,
      $$FlashcardDecksTableAnnotationComposer,
      $$FlashcardDecksTableCreateCompanionBuilder,
      $$FlashcardDecksTableUpdateCompanionBuilder,
      (FlashcardDeck, $$FlashcardDecksTableReferences),
      FlashcardDeck,
      PrefetchHooks Function({bool flashcardCardsRefs})
    >;
typedef $$FlashcardCardsTableCreateCompanionBuilder =
    FlashcardCardsCompanion Function({
      Value<int> id,
      required int deckId,
      required int wordId,
      Value<DateTime> createdAt,
      Value<bool> isLearned,
      Value<bool> isMastered,
    });
typedef $$FlashcardCardsTableUpdateCompanionBuilder =
    FlashcardCardsCompanion Function({
      Value<int> id,
      Value<int> deckId,
      Value<int> wordId,
      Value<DateTime> createdAt,
      Value<bool> isLearned,
      Value<bool> isMastered,
    });

final class $$FlashcardCardsTableReferences
    extends BaseReferences<_$AppDatabase, $FlashcardCardsTable, FlashcardCard> {
  $$FlashcardCardsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FlashcardDecksTable _deckIdTable(_$AppDatabase db) =>
      db.flashcardDecks.createAlias(
        $_aliasNameGenerator(db.flashcardCards.deckId, db.flashcardDecks.id),
      );

  $$FlashcardDecksTableProcessedTableManager get deckId {
    final $_column = $_itemColumn<int>('deck_id')!;

    final manager = $$FlashcardDecksTableTableManager(
      $_db,
      $_db.flashcardDecks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deckIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UslubTable _wordIdTable(_$AppDatabase db) => db.uslub.createAlias(
    $_aliasNameGenerator(db.flashcardCards.wordId, db.uslub.id),
  );

  $$UslubTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<int>('word_id')!;

    final manager = $$UslubTableTableManager(
      $_db,
      $_db.uslub,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FlashcardCardsTableFilterComposer
    extends Composer<_$AppDatabase, $FlashcardCardsTable> {
  $$FlashcardCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLearned => $composableBuilder(
    column: $table.isLearned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMastered => $composableBuilder(
    column: $table.isMastered,
    builder: (column) => ColumnFilters(column),
  );

  $$FlashcardDecksTableFilterComposer get deckId {
    final $$FlashcardDecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.flashcardDecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardDecksTableFilterComposer(
            $db: $db,
            $table: $db.flashcardDecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UslubTableFilterComposer get wordId {
    final $$UslubTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.uslub,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UslubTableFilterComposer(
            $db: $db,
            $table: $db.uslub,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlashcardCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $FlashcardCardsTable> {
  $$FlashcardCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLearned => $composableBuilder(
    column: $table.isLearned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMastered => $composableBuilder(
    column: $table.isMastered,
    builder: (column) => ColumnOrderings(column),
  );

  $$FlashcardDecksTableOrderingComposer get deckId {
    final $$FlashcardDecksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.flashcardDecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardDecksTableOrderingComposer(
            $db: $db,
            $table: $db.flashcardDecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UslubTableOrderingComposer get wordId {
    final $$UslubTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.uslub,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UslubTableOrderingComposer(
            $db: $db,
            $table: $db.uslub,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlashcardCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlashcardCardsTable> {
  $$FlashcardCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isLearned =>
      $composableBuilder(column: $table.isLearned, builder: (column) => column);

  GeneratedColumn<bool> get isMastered => $composableBuilder(
    column: $table.isMastered,
    builder: (column) => column,
  );

  $$FlashcardDecksTableAnnotationComposer get deckId {
    final $$FlashcardDecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.flashcardDecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardDecksTableAnnotationComposer(
            $db: $db,
            $table: $db.flashcardDecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UslubTableAnnotationComposer get wordId {
    final $$UslubTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.uslub,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UslubTableAnnotationComposer(
            $db: $db,
            $table: $db.uslub,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlashcardCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlashcardCardsTable,
          FlashcardCard,
          $$FlashcardCardsTableFilterComposer,
          $$FlashcardCardsTableOrderingComposer,
          $$FlashcardCardsTableAnnotationComposer,
          $$FlashcardCardsTableCreateCompanionBuilder,
          $$FlashcardCardsTableUpdateCompanionBuilder,
          (FlashcardCard, $$FlashcardCardsTableReferences),
          FlashcardCard,
          PrefetchHooks Function({bool deckId, bool wordId})
        > {
  $$FlashcardCardsTableTableManager(
    _$AppDatabase db,
    $FlashcardCardsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlashcardCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlashcardCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlashcardCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> deckId = const Value.absent(),
                Value<int> wordId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isLearned = const Value.absent(),
                Value<bool> isMastered = const Value.absent(),
              }) => FlashcardCardsCompanion(
                id: id,
                deckId: deckId,
                wordId: wordId,
                createdAt: createdAt,
                isLearned: isLearned,
                isMastered: isMastered,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int deckId,
                required int wordId,
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isLearned = const Value.absent(),
                Value<bool> isMastered = const Value.absent(),
              }) => FlashcardCardsCompanion.insert(
                id: id,
                deckId: deckId,
                wordId: wordId,
                createdAt: createdAt,
                isLearned: isLearned,
                isMastered: isMastered,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FlashcardCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({deckId = false, wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (deckId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.deckId,
                                referencedTable: $$FlashcardCardsTableReferences
                                    ._deckIdTable(db),
                                referencedColumn:
                                    $$FlashcardCardsTableReferences
                                        ._deckIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (wordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.wordId,
                                referencedTable: $$FlashcardCardsTableReferences
                                    ._wordIdTable(db),
                                referencedColumn:
                                    $$FlashcardCardsTableReferences
                                        ._wordIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FlashcardCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlashcardCardsTable,
      FlashcardCard,
      $$FlashcardCardsTableFilterComposer,
      $$FlashcardCardsTableOrderingComposer,
      $$FlashcardCardsTableAnnotationComposer,
      $$FlashcardCardsTableCreateCompanionBuilder,
      $$FlashcardCardsTableUpdateCompanionBuilder,
      (FlashcardCard, $$FlashcardCardsTableReferences),
      FlashcardCard,
      PrefetchHooks Function({bool deckId, bool wordId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UslubTableTableManager get uslub =>
      $$UslubTableTableManager(_db, _db.uslub);
  $$FlashcardDecksTableTableManager get flashcardDecks =>
      $$FlashcardDecksTableTableManager(_db, _db.flashcardDecks);
  $$FlashcardCardsTableTableManager get flashcardCards =>
      $$FlashcardCardsTableTableManager(_db, _db.flashcardCards);
}
