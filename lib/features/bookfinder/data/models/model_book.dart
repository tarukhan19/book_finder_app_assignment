import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model_book.g.dart';

/*
This class is used to represent a book entity received from a remote API. It:
Parses JSON using json_serializable.
Implements equality checks using Equatable.

@JsonKey(name: 'author_name') maps the JSON key 'author_name' to the Dart variable authorName.

Equatable helps compare objects by their values instead of their memory reference. It’s very useful
when working with state management because it ensures two objects with the same content are considered equal.
I just define the list of properties to compare in the props getter, and Equatable takes care of the rest.

props is a list of the fields that matter when checking equality.
Equatable uses this list to automatically override:
== operator
hashCode


This factory constructor allows me to create a BookModel from JSON. The actual parsing logic is handled
by the auto-generated function _$BookModelFromJson, which is created by the json_serializable
package using build_runner.
It saves me from manually writing JSON parsing code and ensures strong typing and consistency across the app.
 */

@JsonSerializable()
class BookModel extends Equatable {
  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'author_name')
  final List<String> authorName;

  @JsonKey(name: 'author_key')
  final List<String> authorKey;

  @JsonKey(name: 'cover_i')
  final int coverImage;

  @JsonKey(name: 'first_publish_year')
  final int firstPublishYear;

  const BookModel({
    required this.title,
    required this.authorName,
    required this.authorKey,
    required this.coverImage,
    required this.firstPublishYear,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  @override
  List<Object?> get props => [
    title,
    authorName,
    authorKey,
    coverImage,
    firstPublishYear,
  ];
}
