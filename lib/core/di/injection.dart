import 'package:book_finder_app_assignment/features/bookfinder/data/data_source/remote/book_api_service.dart';
import 'package:book_finder_app_assignment/features/bookfinder/data/repositories/book_repository_impl.dart';
import 'package:book_finder_app_assignment/features/bookfinder/domain/repositories/book_repository.dart';
import 'package:book_finder_app_assignment/features/bookfinder/presentation/bloc/book_search_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/bookfinder/domain/usecase/search_book_use_case.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Network
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<BookApiService>(() => BookApiService(getIt<Dio>()));

  // Repository
  getIt.registerLazySingleton<BookRepository>(
        () => BookRepositoryImpl(getIt<BookApiService>()),
  );

  // Use Cases
  getIt.registerLazySingleton<SearchBooksUseCase>(
        () => SearchBooksUseCase(getIt<BookRepository>()),
  );

  // BLoC
  getIt.registerFactory<BookSearchBloc>(
        () => BookSearchBloc(getIt<SearchBooksUseCase>()),
  );
}
