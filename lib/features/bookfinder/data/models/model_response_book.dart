import 'package:book_finder_app_assignment/features/bookfinder/data/models/model_book.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model_response_book.g.dart';

@JsonSerializable()
class BookSearchResponseModel extends Equatable {
  @JsonKey(name: 'numFound')
  final int numFound;

  @JsonKey(name: 'start')
  final int start;

  @JsonKey(name: 'numFoundExact')
  final bool numFoundExact;

  @JsonKey(name: 'docs')
  final List<BookModel> bookModel;

  const BookSearchResponseModel({
    required this.numFound,
    required this.start,
    required this.bookModel,
    required this.numFoundExact
  });

  factory BookSearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BookSearchResponseModelFromJson(json);

  @override
  List<Object?> get props => [numFound, start, bookModel,numFoundExact];
}


