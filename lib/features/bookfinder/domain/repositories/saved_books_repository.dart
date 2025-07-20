
import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';

abstract class SavedBooksRepository {
  Future<(String?, bool?)> saveBook(BookEntity book);
  Future<(String?, bool?)> removeSavedBook(BookEntity book);
  Future<(String?, bool?)> isBookSaved(BookEntity book);
  Future<(String?, List<BookEntity>?)> getAllSavedBooks();
}