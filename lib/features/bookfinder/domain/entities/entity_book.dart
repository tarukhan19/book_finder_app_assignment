import 'package:equatable/equatable.dart';

/*
it is Pure business logic. Represents the core app concept. No dependency on Flutter, Dio, JSON, Hive, etc.

BookEntity is part of the domain layer, and it defines the structure of a book in my application.
I use Equatable to compare entities by value, which helps avoid unnecessary UI rebuilds and enables
predictable behavior in state management tools like BLoC.
 */

class BookEntity extends Equatable {
  final List<String> authorKey;
  final String title;
  final List<String> authorName;
  final int? firstPublishYear;
  final int? coverImage;

   const BookEntity({
    required this.authorKey,
    required this.title,
    required this.authorName,
     this.firstPublishYear,
     this.coverImage,
  });

  String get coverUrl {
    if (coverImage != null) {
      return 'https://covers.openlibrary.org/b/id/$coverImage-M.jpg';
    }
    return '';
  }

  String get authorString =>
      authorName.isEmpty ? 'Unknown Author' : authorName.join(', ');

  @override
  List<Object?> get props => [
    authorKey,
    title,
    authorName,
    firstPublishYear,
    coverImage,
    ];
}
