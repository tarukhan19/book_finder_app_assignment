import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/saved_books_repository.dart';
import '../data_source/database/database_helper.dart';
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
}