import 'package:book_finder_app_assignment/features/bookfinder/data/models/response_book.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../../core/utils/api_constants.dart';

part 'book_api_service.g.dart';

@lazySingleton
@RestApi(baseUrl: apiBaseUrl)
abstract class BookApiService {
  @factoryMethod
  factory BookApiService(Dio dio) = _BookApiService;

  @GET(searchBook)
  Future<BookSearchResponse> searchBooks(
    @Query('q') String? bookName,
    @Query('page') int page,
    @Query('limit') int limit,
  );
}
