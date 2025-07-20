import 'package:hive_flutter/hive_flutter.dart';
import '../../models/saved_book_model.dart';

class HiveService {
  static const String _savedBooksBoxName = 'saved_books';
  static HiveService? _instance;
  Box<SavedBookModel>? _savedBooksBox;

  HiveService._internal();

  static HiveService get instance {
    _instance ??= HiveService._internal();
    return _instance!;
  }

  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SavedBookModelAdapter());
    }
  }

  // Open boxes
  Future<void> openBoxes() async {
    _savedBooksBox ??= await Hive.openBox<SavedBookModel>(_savedBooksBoxName);
  }

  // Get saved books box
  Box<SavedBookModel> get savedBooksBox {
    if (_savedBooksBox == null || !_savedBooksBox!.isOpen) {
      throw Exception('Saved books is not opened. Call openBoxes() first.');
    }
    return _savedBooksBox!;
  }

  // Save a book
  Future<void> saveBook(SavedBookModel book) async {
    try {
      await savedBooksBox.put(book.id, book);
    } catch (e) {
      throw Exception('Failed to save book: $e');
    }
  }

  // Remove a saved book
  Future<void> removeSavedBook(String bookId) async {
    try {
      await savedBooksBox.delete(bookId);
    } catch (e) {
      throw Exception('Failed to remove book: $e');
    }
  }

  // Check if book is saved
  bool isBookSaved(String bookId) {
    try {
      return savedBooksBox.containsKey(bookId);
    } catch (e) {
      return false;
    }
  }

  // Get all saved books
  List<SavedBookModel> getAllSavedBooks() {
    try {
      final books = savedBooksBox.values.toList();
      // Sort by saved date (newest first)
      books.sort((a, b) => b.savedAt.compareTo(a.savedAt));
      return books;
    } catch (e) {
      return [];
    }
  }

  // Get saved book by ID
  SavedBookModel? getSavedBook(String bookId) {
    try {
      return savedBooksBox.get(bookId);
    } catch (e) {
      return null;
    }
  }

  // Clear all saved books
  Future<void> clearAllSavedBooks() async {
    try {
      await savedBooksBox.clear();
    } catch (e) {
      throw Exception('Failed to clear saved books: $e');
    }
  }

  // Get number of saved books
  int getSavedBooksCount() {
    try {
      return savedBooksBox.length;
    } catch (e) {
      return 0;
    }
  }

  // Get saved books stream for real-time updates
  Stream<BoxEvent> get savedBooksStream {
    return savedBooksBox.watch();
  }

  // Search saved books by title
  List<SavedBookModel> searchSavedBooks(String query) {
    try {
      if (query.trim().isEmpty) {
        return getAllSavedBooks();
      }

      final allBooks = getAllSavedBooks();
      final queryLower = query.toLowerCase();

      return allBooks.where((book) {
        return book.title.toLowerCase().contains(queryLower) ||
            book.authorName.any((author) =>
                author.toLowerCase().contains(queryLower));
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Get books saved in last N days
  List<SavedBookModel> getRecentlySavedBooks({int days = 7}) {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));
      final allBooks = getAllSavedBooks();

      return allBooks.where((book) =>
          book.savedAt.isAfter(cutoffDate)
      ).toList();
    } catch (e) {
      return [];
    }
  }

  // Backup saved books to JSON
  List<Map<String, dynamic>> exportSavedBooks() {
    try {
      final books = getAllSavedBooks();
      return books.map((book) => {
        'id': book.id,
        'title': book.title,
        'authorName': book.authorName,
        'authorKey': book.authorKey,
        'coverId': book.coverId,
        'firstPublishYear': book.firstPublishYear,
        'savedAt': book.savedAt.toIso8601String(),
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Import saved books from JSON
  Future<int> importSavedBooks(List<Map<String, dynamic>> booksData) async {
    try {
      int importedCount = 0;

      for (final bookData in booksData) {
        final savedBook = SavedBookModel(
          id: bookData['id'] ?? '',
          title: bookData['title'] ?? '',
          authorName: List<String>.from(bookData['authorName'] ?? []),
          authorKey: List<String>.from(bookData['authorKey'] ?? []),
          coverId: bookData['coverId'] as int?,
          firstPublishYear: bookData['firstPublishYear'] as int?,
          savedAt: DateTime.parse(bookData['savedAt'] ?? DateTime.now().toIso8601String()),
        );

        await saveBook(savedBook);
        importedCount++;
      }

      print('Imported $importedCount books');
      return importedCount;
    } catch (e) {
      print('Error importing saved books: $e');
      throw Exception('Failed to import books: $e');
    }
  }
}