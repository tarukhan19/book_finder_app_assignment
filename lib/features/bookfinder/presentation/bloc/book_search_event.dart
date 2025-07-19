import 'package:equatable/equatable.dart';

abstract class BookSearchEvent extends Equatable {
  const BookSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchBooksEvent extends BookSearchEvent {
  final String query;

  const SearchBooksEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class LoadMoreBooksEvent extends BookSearchEvent {
  const LoadMoreBooksEvent();
}

class ClearSearchEvent extends BookSearchEvent {
  const ClearSearchEvent();
}

class RefreshSearchEvent extends BookSearchEvent {
  const RefreshSearchEvent();
}
