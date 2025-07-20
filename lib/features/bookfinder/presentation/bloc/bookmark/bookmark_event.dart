import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:equatable/equatable.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object> get props => [];
}

class CheckBookmarkStatusEvent extends BookmarkEvent {
  final BookEntity book;

  const CheckBookmarkStatusEvent({required this.book});

  @override
  List<Object> get props => [book];
}

class ToggleBookmarkEvent extends BookmarkEvent {
  final BookEntity book;

  const ToggleBookmarkEvent({required this.book});

  @override
  List<Object> get props => [book];
}

class LoadAllSavedBooksEvent extends BookmarkEvent {
  const LoadAllSavedBooksEvent();
}