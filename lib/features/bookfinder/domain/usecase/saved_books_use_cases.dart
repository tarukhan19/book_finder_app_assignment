import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:injectable/injectable.dart';
import '../repositories/saved_books_repository.dart';

@lazySingleton
class SaveBookUseCase {
  final SavedBooksRepository repository;

  SaveBookUseCase(this.repository);

  Future<(String?, bool?)> call(BookEntity book) async {
    return await repository.saveBook(book);
  }
}

@lazySingleton
class RemoveSavedBookUseCase {
  final SavedBooksRepository repository;

  RemoveSavedBookUseCase(this.repository);

  Future<(String?, bool?)> call(BookEntity book) async {
    return await repository.removeSavedBook(book);
  }
}

@lazySingleton
class IsBookSavedUseCase {
  final SavedBooksRepository repository;

  IsBookSavedUseCase(this.repository);

  Future<(String?, bool?)> call(BookEntity book) async {
    return await repository.isBookSaved(book);
  }
}