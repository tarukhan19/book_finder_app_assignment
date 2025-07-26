import 'package:book_finder_app_assignment/features/bookfinder/data/models/model_book.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_book.g.dart';

@JsonSerializable()
class BookSearchResponse extends Equatable {
  @JsonKey(name: 'numFound')
  final int numFound;

  @JsonKey(name: 'start')
  final int start;

  @JsonKey(name: 'numFoundExact')
  final bool numFoundExact;

  @JsonKey(name: 'docs')
  final List<BookModel> bookModel;

  const BookSearchResponse({
    required this.numFound,
    required this.start,
    required this.bookModel,
    required this.numFoundExact
  });

  factory BookSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$BookSearchResponseFromJson(json);

  @override
  List<Object?> get props => [numFound, start, bookModel,numFoundExact];
}


