import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stoic_quotes_app/models/models.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  DatabaseService._internal();

  factory DatabaseService() => _instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quotes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE quotes (
            id INTEGER PRIMARY KEY,
            text TEXT,
            author TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertQuote(Quote quote) async {
    final db = await database;
    await db.insert('quotes', {
      'text': quote.text,
      'author': quote.author,
    });
  }

  Future<void> deleteQuote(Quote quote) async {
  final db = await database;
  await db.delete(
    'quotes',
    where: 'text = ? AND author = ?',
    whereArgs: [quote.text, quote.author],
  );
}

  Future<List<Quote>> getFavoriteQuotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('quotes');

    return List.generate(maps.length, (i) {
      return Quote(
        text: maps[i]['text'],
        author: maps[i]['author'],
      );
    });
  }
}
