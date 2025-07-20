import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database_helper.dart';
import '../../domain/repositories/saved_books_repository.dart';
import '../models/saved_book_model.dart';

@LazySingleton(as: SavedBooksRepository)
class SavedBooksRepositoryImpl implements SavedBooksRepository {
  final HiveService _hiveService;

  SavedBooksRepositoryImpl(this._hiveService);

  @override
  Future<(String?, bool?)> saveBook(BookEntity book) async {
    try {
      final savedBook = SavedBookModel.fromBook(book);
      await _hiveService.saveBook(savedBook);
      return (null, true);
    } catch (e) {
      return (('Failed to save book: ${e.toString()}'), null);
    }
  }

  @override
  Future<(String?, bool?)> removeSavedBook(BookEntity book) async {
    try {
      final bookId = SavedBookModel.fromBook(book).id;
      await _hiveService.removeSavedBook(bookId);
      return (null, true);
    } catch (e) {
      return (('Failed to remove book: ${e.toString()}'), null);
    }
  }

  @override
  Future<(String?, bool?)> isBookSaved(BookEntity book) async {
    try {
      final bookId = SavedBookModel.fromBook(book).id;
      final isSaved = _hiveService.isBookSaved(bookId);
      return (null, isSaved);
    } catch (e) {
      return (('Failed to check book status: ${e.toString()}'), null);
    }
  }

  @override
  Future<(String?, List<BookEntity>?)> getAllSavedBooks() async {
    try {
      final savedBooks = _hiveService.getAllSavedBooks();
      final books = savedBooks.map((savedBook) => savedBook.toEntity()).toList();
      return (null, books);
    } catch (e) {
      return (('Failed to get saved books: ${e.toString()}'), null);
    }
  }

  // Additional methods specific to Hive implementation
  Future<(String?, List<BookEntity>?)> searchSavedBooks(String query) async {
    try {
      final savedBooks = _hiveService.searchSavedBooks(query);
      final books = savedBooks.map((savedBook) => savedBook.toEntity()).toList();
      return (null, books);
    } catch (e) {
      return (('Failed to search saved books: ${e.toString()}'), null);
    }
  }

  Future<(String?, List<BookEntity>?)> getRecentlySavedBooks({int days = 7}) async {
    try {
      final savedBooks = _hiveService.getRecentlySavedBooks(days: days);
      final books = savedBooks.map((savedBook) => savedBook.toEntity()).toList();
      return (null, books);
    } catch (e) {
      return (('Failed to get recently saved books: ${e.toString()}'), null);
    }
  }

  Future<(String?, int?)> getSavedBooksCount() async {
    try {
      final count = _hiveService.getSavedBooksCount();
      return (null, count);
    } catch (e) {
      return (('Failed to get saved books count: ${e.toString()}'), null);
    }
  }

  Future<(String?, bool?)> clearAllSavedBooks() async {
    try {
      await _hiveService.clearAllSavedBooks();
      return (null, true);
    } catch (e) {
      return (('Failed to clear saved books: ${e.toString()}'), null);
    }
  }

  // Stream for real-time updates
  Stream<List<BookEntity>> get savedBooksStream {
    return _hiveService.savedBooksStream.map((_) {
      final savedBooks = _hiveService.getAllSavedBooks();
      return savedBooks.map((savedBook) => savedBook.toEntity()).toList();
    });
  }

  // Backup and restore functionality
  Future<(String?, List<Map<String, dynamic>>?)> exportSavedBooks() async {
    try {
      final exportData = _hiveService.exportSavedBooks();
      return (null, exportData);
    } catch (e) {
      return (('Failed to export saved books: ${e.toString()}'), null);
    }
  }

  Future<(String?, int?)> importSavedBooks(List<Map<String, dynamic>> booksData) async {
    try {
      final importedCount = await _hiveService.importSavedBooks(booksData);
      return (null, importedCount);
    } catch (e) {
      return (('Failed to import saved books: ${e.toString()}'), null);
    }
  }
}