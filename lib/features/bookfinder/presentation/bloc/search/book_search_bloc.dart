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

  /*
  If the query is blank, reset to initial state.
  Emit a loading state.
  Fetch page 1 of the result using SearchBooksUseCase.
  If the number of books < 20, set hasReachedMax = true (no more pages).
  Emit BookSearchLoaded with page 1 data.
   */
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
          hasReachedMax:  result.books.length < 20,
          currentPage: 1,
          currentQuery: event.query,
        ),
      );
    } catch (e) {
      emit(BookSearchError(message: e.toString()));
    }
  }

  // same as _onSearchBooks
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

  /*
 If current state isn’t BookSearchLoaded or all data has been loaded (hasReachedMax), return immediately.
  Calls SearchBooksUseCase with currentPage + 1.
  Appends newly fetched books to existing list (...currentState.books).
  Checks if returned list has fewer than 20 items. If yes, that means there’s no more data to fetch, so hasReachedMax = true.
 Emits new BookSearchLoaded state with:
  Combined book list
  Incremented page
  Same query
   */
  Future<void> _onLoadMoreBooks(
      LoadMoreBooksEvent event,
      Emitter<BookSearchState> emit,
      ) async {
    final currentState = state;
    if (currentState is! BookSearchLoaded || currentState.hasReachedMax) {
      return;
    }

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
  // Resets everything to the initial state (empty screen, no query or results)
  void _onClearSearch(ClearSearchEvent event, Emitter<BookSearchState> emit) {
    emit(const BookSearchInitial());
  }
}

