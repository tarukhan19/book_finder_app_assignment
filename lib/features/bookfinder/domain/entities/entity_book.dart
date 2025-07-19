import 'package:equatable/equatable.dart';

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
    required this.firstPublishYear,
    required this.coverImage,
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
