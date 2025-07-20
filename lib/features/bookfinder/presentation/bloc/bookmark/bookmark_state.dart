import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:equatable/equatable.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object> get props => [];
}

class BookmarkInitial extends BookmarkState {
  const BookmarkInitial();
}

class BookmarkLoading extends BookmarkState {
  const BookmarkLoading();
}

class BookmarkStatusLoaded extends BookmarkState {
  final bool isBookmarked;

  const BookmarkStatusLoaded({required this.isBookmarked});

  @override
  List<Object> get props => [isBookmarked];
}

class BookmarkToggled extends BookmarkState {
  final bool isBookmarked;
  final String message;

  const BookmarkToggled({
    required this.isBookmarked,
    required this.message,
  });

  @override
  List<Object> get props => [isBookmarked, message];
}

class SavedBooksLoaded extends BookmarkState {
  final List<BookEntity> savedBooks;

  const SavedBooksLoaded({required this.savedBooks});

  @override
  List<Object> get props => [savedBooks];
}

class BookmarkError extends BookmarkState {
  final String message;

  const BookmarkError({required this.message});

  @override
  List<Object> get props => [message];
}