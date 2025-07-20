import 'package:book_finder_app_assignment/features/bookfinder/data/data_source/remote/book_api_service.dart';
import 'package:book_finder_app_assignment/features/bookfinder/data/repositories/book_repository_impl.dart';
import 'package:book_finder_app_assignment/features/bookfinder/data/repositories/saved_books_repository_impl.dart';
import 'package:book_finder_app_assignment/features/bookfinder/domain/repositories/book_repository.dart';
import 'package:book_finder_app_assignment/features/bookfinder/presentation/bloc/bookmark/Bookmark_bloc.dart';
import 'package:book_finder_app_assignment/features/bookfinder/presentation/bloc/search/book_search_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/bookfinder/domain/repositories/saved_books_repository.dart';
import '../../features/bookfinder/domain/usecase/saved_books_use_cases.dart';
import '../../features/bookfinder/domain/usecase/search_book_use_case.dart';
import '../database/database_helper.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  await getIt.reset();

  // Clear any existing registrations to avoid conflicts
  if (getIt.isRegistered<DatabaseHelper>()) {
    await getIt.reset();
  }

  // Database
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // Network
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<BookApiService>(
    () => BookApiService(getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<BookRepository>(
        () => BookRepositoryImpl(getIt<BookApiService>()),
  );
  getIt.registerLazySingleton<SavedBooksRepository>(
        () => SavedBooksRepositoryImpl(getIt<DatabaseHelper>()),
  );

  // Use Cases
  getIt.registerLazySingleton<SearchBooksUseCase>(
    () => SearchBooksUseCase(getIt<BookRepository>()),
  );

  getIt.registerLazySingleton<SaveBookUseCase>(
    () => SaveBookUseCase(getIt<SavedBooksRepository>()),
  );
  getIt.registerLazySingleton<RemoveSavedBookUseCase>(
    () => RemoveSavedBookUseCase(getIt<SavedBooksRepository>()),
  );
  getIt.registerLazySingleton<IsBookSavedUseCase>(
    () => IsBookSavedUseCase(getIt<SavedBooksRepository>()),
  );
  getIt.registerLazySingleton<GetAllSavedBooksUseCase>(
    () => GetAllSavedBooksUseCase(getIt<SavedBooksRepository>()),
  );

  // BLoC
  getIt.registerFactory<BookSearchBloc>(
    () => BookSearchBloc(getIt<SearchBooksUseCase>()),
  );

  getIt.registerFactory<BookmarkBloc>(
    () => BookmarkBloc(
      getIt<SaveBookUseCase>(),
      getIt<RemoveSavedBookUseCase>(),
      getIt<IsBookSavedUseCase>(),
      getIt<GetAllSavedBooksUseCase>(),
    ),
  );

  print('✅ All dependencies registered successfully');

  // Test registration
  try {
    final bookmarkBloc = getIt<BookmarkBloc>();
    print('✅ BookmarkBloc test successful: $bookmarkBloc');
  } catch (e) {
    print('❌ BookmarkBloc test failed: $e');
  }

}
