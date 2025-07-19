import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:equatable/equatable.dart';

class BookSearchResult extends Equatable {
  final List<BookEntity> books;
  final int totalResults;
  final int currentPage;
  final bool hasMorePages;

  const BookSearchResult({
    required this.books,
    required this.totalResults,
    required this.currentPage,
    required this.hasMorePages,
  });

  @override
  List<Object?> get props => [books, totalResults, currentPage, hasMorePages];
}
