import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database_helper.dart';
import '../../domain/repositories/saved_books_repository.dart';
import '../models/saved_book_model.dart';

@LazySingleton(as: SavedBooksRepository)
class SavedBooksRepositoryImpl implements SavedBooksRepository {
  final DatabaseHelper _databaseHelper;

  SavedBooksRepositoryImpl(this._databaseHelper);

  @override
  Future<(String?, bool?)> saveBook(BookEntity book) async {
    try {
      final savedBook = SavedBookModel.fromBook(book);
      await _databaseHelper.saveBook(savedBook);
      return (null, true);
    } catch (e) {
      return (('Failed to save book: ${e.toString()}'), null);
    }
  }

  @override
  Future<(String?, bool?)> removeSavedBook(BookEntity book) async {
    try {
      final bookId = SavedBookModel.fromBook(book).id;
      await _databaseHelper.removeSavedBook(bookId);
      return (null, true);
    } catch (e) {
      return (('Failed to remove book: ${e.toString()}'), null);
    }
  }

  @override
  Future<(String?, bool?)> isBookSaved(BookEntity book) async {
    try {
      final bookId = SavedBookModel.fromBook(book).id;
      final isSaved = await _databaseHelper.isBookSaved(bookId);
      return (null, isSaved);
    } catch (e) {
      return (('Failed to check book status: ${e.toString()}'), null);
    }
  }

  @override
  Future<(String?, List<BookEntity>?)> getAllSavedBooks() async {
    try {
      final savedBooks = await _databaseHelper.getAllSavedBooks();
      final books = savedBooks.map((savedBook) => savedBook.toEntity()).toList();
      return (null, books);
    } catch (e) {
      return (('Failed to get saved books: ${e.toString()}'), null);
    }
  }
}