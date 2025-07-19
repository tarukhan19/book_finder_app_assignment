import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:equatable/equatable.dart';


abstract class BookSearchState extends Equatable {
  const BookSearchState();

  @override
  List<Object> get props => [];
}

class BookSearchInitial extends BookSearchState {
  const BookSearchInitial();
}

class BookSearchLoading extends BookSearchState {
  const BookSearchLoading();
}

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

  BookSearchLoaded copyWith({
    List<BookEntity>? books,
    bool? hasReachedMax,
    int? currentPage,
    String? currentQuery,
  }) {
    return BookSearchLoaded(
      books: books ?? this.books,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      currentQuery: currentQuery ?? this.currentQuery,
    );
  }

  @override
  List<Object> get props => [books, hasReachedMax, currentPage, currentQuery];
}

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

class BookSearchError extends BookSearchState {
  final String message;

  const BookSearchError({required this.message});

  @override
  List<Object> get props => [message];
}
