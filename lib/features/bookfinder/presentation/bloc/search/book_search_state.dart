import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:equatable/equatable.dart';


abstract class BookSearchState extends Equatable {
  const BookSearchState();

  @override
  List<Object> get props => [];
}

// Show placeholder or welcome screen
class BookSearchInitial extends BookSearchState {
  const BookSearchInitial();
}

// Show full-screen loading/shimmer
class BookSearchLoading extends BookSearchState {
  const BookSearchLoading();
}

// Display books list
class BookSearchLoaded extends BookSearchState {
  final List<BookEntity> books;
  final bool hasReachedMax;
  final int currentPage;
  final String currentQuery;

  const BookSearchLoaded({
    required this.books,
    required this.hasReachedMax,
    required this.currentPage,
    required this.currentQuery,
  });

  @override
  List<Object> get props => [books, hasReachedMax, currentPage, currentQuery];
}

// Show spinner at end of list
class BookSearchLoadingMore extends BookSearchState {
  final List<BookEntity> books;
  final int currentPage;
  final String currentQuery;

  const BookSearchLoadingMore({
    required this.books,
    required this.currentPage,
    required this.currentQuery,
  });

  @override
  List<Object> get props => [books, currentPage, currentQuery];
}

// Show error message or retry option
class BookSearchError extends BookSearchState {
  final String message;

  const BookSearchError({required this.message});

  @override
  List<Object> get props => [message];
}
