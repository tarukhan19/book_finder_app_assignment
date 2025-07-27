import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_book.dart';
import 'package:hive/hive.dart';

part 'model_saved_book.g.dart';

/*
@HiveType(typeId: 0): Marks the class as a Hive object and assigns it a unique typeId.
This is required so Hive can serialize/deserialize it.
Each class you store in Hive must have a unique type ID.

Each field is annotated with @HiveField(index) which:
Tells Hive how to store data
The number must be unique and consistent across app versions
 */

@HiveType(typeId: 0)
class SavedBookModel extends HiveObject {
  @HiveField(0)
  String id; // Unique identifier for saved book

  @HiveField(1)
  DateTime savedAt;

  @HiveField(2)
  String title;

  @HiveField(3)
  List<String> authorName;

  @HiveField(4)
  List<String> authorKey;

  @HiveField(5)
  int? coverId;

  @HiveField(6)
  int? firstPublishYear;

  SavedBookModel({
    required this.id,
    required this.savedAt,
    required this.title,
    required this.authorName,
    required this.authorKey,
    this.coverId,
    this.firstPublishYear,
  });

  // This factory constructor converts a BookEntity (domain) into a SavedBookModel
  factory SavedBookModel.fromBook(BookEntity book) {
    return SavedBookModel(
      id: _generateId(book),
      savedAt: DateTime.now(),
      title: book.title,
      authorName: book.authorName,
      authorKey: book.authorKey,
      coverId: book.coverImage,
      firstPublishYear: book.firstPublishYear,
    );
  }

  // Generate unique ID based on book properties
  static String _generateId(BookEntity book) {
    final titleHash = book.title.hashCode;
    final authorsHash = book.authorName.join(',').hashCode;
    return '${titleHash}_$authorsHash';
  }
}