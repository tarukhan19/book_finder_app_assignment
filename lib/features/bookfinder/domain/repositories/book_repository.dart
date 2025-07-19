
import '../entities/search_result.dart';

abstract class BookRepository {
  Future<BookSearchResult> searchBooks(String query , int page);
}