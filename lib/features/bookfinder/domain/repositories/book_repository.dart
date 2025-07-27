
import '../entities/entity_search_result.dart';

abstract class BookRepository {
  Future<BookSearchResultEntity> searchBooks(String query , int page);
}