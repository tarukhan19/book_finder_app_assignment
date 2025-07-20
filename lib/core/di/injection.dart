import 'package:book_finder_app_assignment/features/bookfinder/data/data_source/remote/book_api_service.dart';
import 'package:book_finder_app_assignment/features/bookfinder/data/repositories/book_repository_impl.dart';
import 'package:book_finder_app_assignment/features/bookfinder/data/repositories/saved_books_repository_impl.dart';
import 'package:book_finder_app_assignment/features/bookfinder/domain/repositories/book_repository.dart';
import 'package:book_finder_app_assignment/features/bookfinder/presentation/bloc/bookmark/Bookmark_bloc.dart';
import 'package:book_finder_app_assignment/features/bookfinder/presentation/bloc/search/book_search_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/bookfinder/data/data_source/database/database_helper.dart';
import '../../features/bookfinder/domain/repositories/saved_books_repository.dart';
import '../../features/bookfinder/domain/usecase/saved_books_use_cases.dart';
import '../../features/bookfinder/domain/usecase/search_book_use_case.dart';
import '../../features/bookfinder/presentation/bloc/dashboard/dashboard_bloc.dart';
import '../platform/service_platform.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  await getIt.reset();

  // Core Services
  getIt.registerLazySingleton<HiveService>(() {
    final hiveService = HiveService.instance;
    // Open boxes immediately
    hiveService.openBoxes();
    return hiveService;
  });

  getIt.registerLazySingleton<PlatformService>(() {
    return PlatformService();
  });

  // Network
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<BookApiService>(
    () => BookApiService(getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<BookRepository>(
        () => BookRepositoryImpl(getIt<BookApiService>()),
  );
  getIt.registerLazySingleton<SavedBooksRepository>(() {
    return SavedBooksRepositoryImpl(getIt<HiveService>());
  });

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

  getIt.registerFactory<DashboardBloc>(() {
    return DashboardBloc(getIt<PlatformService>());
  });

  getIt.registerFactory<BookmarkBloc>(
    () => BookmarkBloc(
      getIt<SaveBookUseCase>(),
      getIt<RemoveSavedBookUseCase>(),
      getIt<IsBookSavedUseCase>(),
      getIt<GetAllSavedBooksUseCase>(),
    ),
  );
}
