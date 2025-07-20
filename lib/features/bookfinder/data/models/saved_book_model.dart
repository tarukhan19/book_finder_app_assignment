import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/entity_book.dart';
part 'saved_book_model.g.dart';

@JsonSerializable()
class SavedBookModel extends BookEntity {
  final String id; // Unique identifier for saved book
  final DateTime savedAt;

  const SavedBookModel({
    required this.id,
    required this.savedAt,
    required super.title,
    required super.authorName,
    required super.authorKey,
    super.coverImage,
    super.firstPublishYear,
  });

  factory SavedBookModel.fromJson(Map<String, dynamic> json) => _$SavedBookModelFromJson(json);

  Map<String, dynamic> toJson() => _$SavedBookModelToJson(this);

  // Convert from Book entity to SavedBookModel
  factory SavedBookModel.fromBook(BookEntity book) {
    return SavedBookModel(
      id: _generateId(book),
      savedAt: DateTime.now(),
      title: book.title,
      authorName: book.authorName,
      authorKey: book.authorKey,
      coverImage: book.coverImage,
      firstPublishYear: book.firstPublishYear,
    );
  }

  // Convert to Book entity
  BookEntity toEntity() {
    return BookEntity(
      title: title,
      authorName: authorName,
      authorKey: authorKey,
      coverImage: coverImage,
      firstPublishYear: firstPublishYear,
    );
  }

  // Convert to/from database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authorName': authorName?.join(','), // Store as comma-separated string
      'authorKey': authorKey?.join(','), // Store as comma-separated string
      'coverId': coverImage,
      'firstPublishYear': firstPublishYear,
      'savedAt': savedAt.millisecondsSinceEpoch,
    };
  }

  factory SavedBookModel.fromMap(Map<String, dynamic> map) {
    return SavedBookModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      authorName: (map['authorName'] as String?)?.split(',') ?? [],
      authorKey: (map['authorKey'] as String?)?.split(',') ?? [],
      coverImage: map['coverId'] as int?,
      firstPublishYear: map['firstPublishYear'] as int?,
      savedAt: DateTime.fromMillisecondsSinceEpoch(map['savedAt'] ?? 0),
    );
  }

  // Generate unique ID based on book properties
  static String _generateId(BookEntity book) {
    final titleHash = book.title.hashCode;
    final authorsHash = book.authorName?.join(',').hashCode;
    return '${titleHash}_$authorsHash';
  }

  @override
  List<Object?> get props => [
    id,
    savedAt,
    title,
    authorName,
    authorKey,
    coverImage,
    firstPublishYear,
  ];
}