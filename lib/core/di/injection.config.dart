// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:book_finder_app_assignment/core/di/injection.dart' as _i5;
import 'package:book_finder_app_assignment/core/platform/service_platform.dart'
    as _i1061;
import 'package:book_finder_app_assignment/features/bookfinder/data/data_source/database/database_helper.dart'
    as _i398;
import 'package:book_finder_app_assignment/features/bookfinder/data/data_source/remote/book_api_service.dart'
    as _i1029;
import 'package:book_finder_app_assignment/features/bookfinder/data/repositories/book_repository_impl.dart'
    as _i881;
import 'package:book_finder_app_assignment/features/bookfinder/data/repositories/saved_books_repository_impl.dart'
    as _i989;
import 'package:book_finder_app_assignment/features/bookfinder/domain/repositories/book_repository.dart'
    as _i539;
import 'package:book_finder_app_assignment/features/bookfinder/domain/repositories/saved_books_repository.dart'
    as _i270;
import 'package:book_finder_app_assignment/features/bookfinder/domain/usecase/saved_books_use_cases.dart'
    as _i805;
import 'package:book_finder_app_assignment/features/bookfinder/domain/usecase/search_book_use_case.dart'
    as _i810;
import 'package:book_finder_app_assignment/features/bookfinder/presentation/bloc/bookmark/Bookmark_bloc.dart'
    as _i808;
import 'package:book_finder_app_assignment/features/bookfinder/presentation/bloc/dashboard/dashboard_bloc.dart'
    as _i895;
import 'package:book_finder_app_assignment/features/bookfinder/presentation/bloc/search/book_search_bloc.dart'
    as _i63;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dioProvider = _$DioProvider();
    final coreModule = _$CoreModule();
    gh.lazySingleton<_i361.Dio>(() => dioProvider.dio);
    gh.lazySingleton<_i398.HiveService>(() => coreModule.hiveService);
    gh.lazySingleton<_i1061.PlatformService>(() => _i1061.PlatformService());
    gh.lazySingleton<_i1029.BookApiService>(
        () => _i1029.BookApiService(gh<_i361.Dio>()));
    gh.lazySingleton<_i270.SavedBooksRepository>(
        () => _i989.SavedBooksRepositoryImpl(gh<_i398.HiveService>()));
    gh.factory<_i895.DashboardBloc>(
        () => _i895.DashboardBloc(gh<_i1061.PlatformService>()));
    gh.lazySingleton<_i805.SaveBookUseCase>(
        () => _i805.SaveBookUseCase(gh<_i270.SavedBooksRepository>()));
    gh.factory<_i805.RemoveSavedBookUseCase>(
        () => _i805.RemoveSavedBookUseCase(gh<_i270.SavedBooksRepository>()));
    gh.factory<_i805.IsBookSavedUseCase>(
        () => _i805.IsBookSavedUseCase(gh<_i270.SavedBooksRepository>()));
    gh.lazySingleton<_i539.BookRepository>(
        () => _i881.BookRepositoryImpl(gh<_i1029.BookApiService>()));
    gh.factory<_i808.BookmarkBloc>(() => _i808.BookmarkBloc(
          gh<_i805.SaveBookUseCase>(),
          gh<_i805.RemoveSavedBookUseCase>(),
          gh<_i805.IsBookSavedUseCase>(),
        ));
    gh.lazySingleton<_i810.SearchBooksUseCase>(
        () => _i810.SearchBooksUseCase(gh<_i539.BookRepository>()));
    gh.factory<_i63.BookSearchBloc>(
        () => _i63.BookSearchBloc(gh<_i810.SearchBooksUseCase>()));
    return this;
  }
}

class _$DioProvider extends _i5.DioProvider {}

class _$CoreModule extends _i5.CoreModule {}
