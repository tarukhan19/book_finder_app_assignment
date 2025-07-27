import 'package:book_finder_app_assignment/features/bookfinder/data/data_source/remote/book_api_service.dart';
import 'package:book_finder_app_assignment/features/bookfinder/data/models/model_book.dart';
import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_search_result.dart';
import 'package:book_finder_app_assignment/features/bookfinder/domain/repositories/book_repository.dart';
import 'package:injectable/injectable.dart';

/*
response.numFound -> comes from the API ,It indicates how many total books matched the search query.
currentPage -> current page number we passed into the method
hasMorePages ->
page * 20 gives us the number of books fetched so far.
If we're on
------Page 1 → 1 * 20 = 20
------Page 2 → 2 * 20 = 40

(Because each API call fetches 20 books per page.)

Let's say API says numFound = 90
Page 1 → 20 < 87 → true → yes, there are more pages
Page 2 → 40 < 87 → true → yes, there are more pages
Page 5 → 100 < 87 → false → no more pages
 */
@LazySingleton(as: BookRepository)
class BookRepositoryImpl implements BookRepository {
  final BookApiService _bookApiService;

  BookRepositoryImpl(this._bookApiService);

  @override
  Future<BookSearchResultEntity> searchBooks(String query, int page) async {
    try {
      final response = await _bookApiService.searchBooks(query, page, 20);
      // Handle empty response or null docs
      if (response.bookModel.isEmpty) {
        return BookSearchResultEntity(
          books: [],
          totalResults: response.numFound,
          currentPage: page,
          hasMorePages: false,
        );
      }

      // Filter and map books with null safety
      final books =
          response.bookModel.where((bookModel) => bookModel.title != null).map((
            bookModel,
          ) {
            return BookEntity(
              authorKey: bookModel.authorKey ?? [],
              title: bookModel.title ?? 'Unknown Title',
              authorName: bookModel.authorName ?? [],
              firstPublishYear: bookModel.firstPublishYear,
              coverImage: bookModel.coverImage,
            );
          }).toList();

      return BookSearchResultEntity(
        books: books ?? [],
        totalResults: response.numFound,
        currentPage: page,
        hasMorePages: (page * 20) < response.numFound,
      );
    } catch (e) {
      throw Exception('Failed to search books: ${e.toString()}');
    }
  }
}
