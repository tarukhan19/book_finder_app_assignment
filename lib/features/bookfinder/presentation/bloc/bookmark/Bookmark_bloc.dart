import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecase/saved_books_use_cases.dart';
import 'bookmark_event.dart';
import 'bookmark_state.dart';

@injectable
class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final SaveBookUseCase _saveBookUseCase;
  final RemoveSavedBookUseCase _removeSavedBookUseCase;
  final IsBookSavedUseCase _isBookSavedUseCase;
  final GetAllSavedBooksUseCase _getAllSavedBooksUseCase;

  BookmarkBloc(
      this._saveBookUseCase,
      this._removeSavedBookUseCase,
      this._isBookSavedUseCase,
      this._getAllSavedBooksUseCase,
      ) : super(const BookmarkInitial()) {
    on<CheckBookmarkStatusEvent>(_onCheckBookmarkStatus);
    on<ToggleBookmarkEvent>(_onToggleBookmark);
    on<LoadAllSavedBooksEvent>(_onLoadAllSavedBooks);
  }

  Future<void> _onCheckBookmarkStatus(
      CheckBookmarkStatusEvent event,
      Emitter<BookmarkState> emit,
      ) async {
    emit(const BookmarkLoading());

    final result = await _isBookSavedUseCase(event.book);
    final (failure, isBookmarked) = result;

    if (failure != null) {
      emit(BookmarkError(message: failure.toString()));
    } else if (isBookmarked != null) {
      emit(BookmarkStatusLoaded(isBookmarked: isBookmarked));
    }
  }

  Future<void> _onToggleBookmark(
      ToggleBookmarkEvent event,
      Emitter<BookmarkState> emit,
      ) async {
    final currentState = state;
    bool currentBookmarkStatus = false;

    if (currentState is BookmarkStatusLoaded) {
      currentBookmarkStatus = currentState.isBookmarked;
    } else if (currentState is BookmarkToggled) {
      currentBookmarkStatus = currentState.isBookmarked;
    }

    emit(const BookmarkLoading());

    if (currentBookmarkStatus) {
      // Remove bookmark
      final result = await _removeSavedBookUseCase(event.book);
      final (failure, success) = result;

      if (failure != null) {
        emit(BookmarkError(message: failure.toString()));
      } else if (success != null) {
        emit(const BookmarkToggled(
          isBookmarked: false,
          message: 'Book removed from bookmarks',
        ));
      }
    } else {
      // Add bookmark
      final result = await _saveBookUseCase(event.book);
      final (failure, success) = result;

      if (failure != null) {
        emit(BookmarkError(message: failure.toString()));
      } else if (success != null) {
        emit(const BookmarkToggled(
          isBookmarked: true,
          message: 'Book saved to bookmarks',
        ));
      }
    }
  }

  Future<void> _onLoadAllSavedBooks(
      LoadAllSavedBooksEvent event,
      Emitter<BookmarkState> emit,
      ) async {
    emit(const BookmarkLoading());

    final result = await _getAllSavedBooksUseCase();
    final (failure, savedBooks) = result;

    if (failure != null) {
      emit(BookmarkError(message: failure.toString()));
    } else if (savedBooks != null) {
      emit(SavedBooksLoaded(savedBooks: savedBooks));
    }
  }
}