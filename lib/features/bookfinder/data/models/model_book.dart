import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model_book.g.dart';

@JsonSerializable()
class BookModel extends Equatable {
  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'author_name')
  final List<String>? authorName;

  @JsonKey(name: 'author_key')
  final List<String>? authorKey;

  @JsonKey(name: 'cover_i')
  final int? coverImage;

  @JsonKey(name: 'first_publish_year')
  final int? firstPublishYear;

  const BookModel({
    required this.title,
    required this.authorName,
    required this.authorKey,
    required this.coverImage,
    required this.firstPublishYear,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookModelToJson(this);

  @override
  List<Object?> get props => [
    title,
    authorName,
    authorKey,
    coverImage,
    firstPublishYear,
  ];
}
