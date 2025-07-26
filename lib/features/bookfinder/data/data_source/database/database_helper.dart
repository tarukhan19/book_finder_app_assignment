import 'package:hive_flutter/hive_flutter.dart';
import '../../models/saved_book_model.dart';

class HiveService {

  // Step 1: Private constructor
  HiveService._internal();

  // Step 2: Static instance (created only once)
  static final HiveService _instance = HiveService._internal();

  // Step 3: Public getter to access the instance
  static HiveService get instance => _instance;

  Box<SavedBookModel>? _savedBooksBox;
  static const String _savedBooksBoxName = 'saved_books';

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
}