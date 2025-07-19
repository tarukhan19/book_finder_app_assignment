import 'package:book_finder_app_assignment/features/bookfinder/data/data_source/remote/book_api_service.dart';
import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/search_result.dart';
import 'package:book_finder_app_assignment/features/bookfinder/domain/repositories/book_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookRepository)
class BookRepositoryImpl implements BookRepository {
  final BookApiService _bookApiService;

  BookRepositoryImpl(this._bookApiService);

  @override
  Future<BookSearchResult> searchBooks(String query, int page) async {
    try {
      final response = await _bookApiService.searchBooks(query, page, 20);
      final books =
          response.bookModel.map((bookModel) {
            return BookEntity(
              authorKey: bookModel.authorKey ?? [],
              title: bookModel.title ?? 'Unknown Title',
              authorName: bookModel.authorName ?? [],
              firstPublishYear: bookModel.firstPublishYear,
              coverImage: bookModel.coverImage,
            );
          }).toList();

      return BookSearchResult( books: books,
        totalResults: response.numFound,
        currentPage: page,
        hasMorePages: (page * 20) < response.numFound,
      );
    } catch (e) {
      throw Exception('Failed to search books: ${e.toString()}');
    }
  }
}
