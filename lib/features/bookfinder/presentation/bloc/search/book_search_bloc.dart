import 'package:book_finder_app_assignment/features/bookfinder/domain/usecase/search_book_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'book_search_event.dart';
import 'book_search_state.dart';

@injectable
class BookSearchBloc extends Bloc<BookSearchEvent, BookSearchState> {
  final SearchBooksUseCase _searchBooksUseCase;

  BookSearchBloc(this._searchBooksUseCase) : super(const BookSearchInitial()) {
    on<SearchBooksEvent>(_onSearchBooks);
    on<LoadMoreBooksEvent>(_onLoadMoreBooks);
    on<ClearSearchEvent>(_onClearSearch);
    on<RefreshSearchEvent>(_onRefreshSearch);
  }
  Future<void> _onSearchBooks(
      SearchBooksEvent event,
      Emitter<BookSearchState> emit,
      ) async {
    if (event.query.trim().isEmpty) {
      emit(BookSearchInitial());
      return;
    }

    emit(const BookSearchLoading());

    try {
      final result = await _searchBooksUseCase(event.query, 1);
      emit(
        BookSearchLoaded(
          books: result.books,
          hasReachedMax: result.hasMorePages,
          currentPage: 1,
          currentQuery: event.query,
        ),
      );
    } catch (e) {
      emit(BookSearchError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreBooks(
      LoadMoreBooksEvent event,
      Emitter<BookSearchState> emit,
      ) async {
    final currentState = state;
    if (currentState is! BookSearchLoaded || currentState.hasReachedMax) {
      return;
    }

    emit(
      BookSearchLoadingMore(
        books: currentState.books,
        currentPage: currentState.currentPage,
        currentQuery: currentState.currentQuery,
      ),
    );

    try {
      final result = await _searchBooksUseCase(
          currentState.currentQuery, currentState.currentPage + 1
      );
      final allBooks = [...currentState.books, ...result.books];

      emit(
        BookSearchLoaded(
            books: allBooks,
            hasReachedMax: result.books.length < 20,
            currentPage: currentState.currentPage + 1,
            currentQuery: currentState.currentQuery
        ),
      );
    } catch (e) {
      emit(BookSearchError(message: e.toString()));
    }
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<BookSearchState> emit) {
    emit(const BookSearchInitial());
  }

  Future<void> _onRefreshSearch(
      RefreshSearchEvent event,
      Emitter<BookSearchState> emit,
      ) async {
    final currentState = state;
    if (currentState is BookSearchLoaded) {
      emit(const BookSearchLoading());


      try {
        final result = await _searchBooksUseCase(currentState.currentQuery,  1);
        emit(
          BookSearchLoaded(
            books: result.books,
            hasReachedMax: result.books.length < 20,
            currentPage: 1,
            currentQuery: currentState.currentQuery,
          ),
        );
      } catch (e) {
        emit(BookSearchError(message: e.toString()));
      }
    }
  }
}

