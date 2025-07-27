import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_search_result.dart';
import 'package:book_finder_app_assignment/features/bookfinder/domain/repositories/book_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SearchBooksUseCase {
  final BookRepository _bookRepository;

  SearchBooksUseCase(this._bookRepository);

  Future<BookSearchResultEntity> call(String query, int page) async{
    if(query.trim().isEmpty) {
      throw Exception('Search Query cannot be empty');
    }
    return await _bookRepository.searchBooks(query, page);
  }
}