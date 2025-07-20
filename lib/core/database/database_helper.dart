import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../features/bookfinder/data/models/saved_book_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'books.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE saved_books(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        authorName TEXT,
        authorKey TEXT,
        coverId INTEGER,
        firstPublishYear INTEGER,
        savedAt INTEGER NOT NULL
      )
    ''');
  }

  // Save a book
  Future<void> saveBook(SavedBookModel book) async {
    final db = await database;
    await db.insert(
      'saved_books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Remove a saved book
  Future<void> removeSavedBook(String bookId) async {
    final db = await database;
    await db.delete(
      'saved_books',
      where: 'id = ?',
      whereArgs: [bookId],
    );
  }

  // Check if book is saved
  Future<bool> isBookSaved(String bookId) async {
    final db = await database;
    final result = await db.query(
      'saved_books',
      where: 'id = ?',
      whereArgs: [bookId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  // Get all saved books
  Future<List<SavedBookModel>> getAllSavedBooks() async {
    final db = await database;
    final result = await db.query(
      'saved_books',
      orderBy: 'savedAt DESC',
    );
    return result.map((map) => SavedBookModel.fromMap(map)).toList();
  }

  // Get saved book by ID
  Future<SavedBookModel?> getSavedBook(String bookId) async {
    final db = await database;
    final result = await db.query(
      'saved_books',
      where: 'id = ?',
      whereArgs: [bookId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return SavedBookModel.fromMap(result.first);
    }
    return null;
  }

  // Clear all saved books
  Future<void> clearAllSavedBooks() async {
    final db = await database;
    await db.delete('saved_books');
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}