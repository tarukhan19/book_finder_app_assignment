// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedBookModel _$SavedBookModelFromJson(Map<String, dynamic> json) =>
    SavedBookModel(
      id: json['id'] as String,
      savedAt: DateTime.parse(json['savedAt'] as String),
      title: json['title'] as String,
      authorName:
          (json['authorName'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      authorKey:
          (json['authorKey'] as List<dynamic>).map((e) => e as String).toList(),
      coverImage: (json['coverImage'] as num?)?.toInt(),
      firstPublishYear: (json['firstPublishYear'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SavedBookModelToJson(SavedBookModel instance) =>
    <String, dynamic>{
      'authorKey': instance.authorKey,
      'title': instance.title,
      'authorName': instance.authorName,
      'firstPublishYear': instance.firstPublishYear,
      'coverImage': instance.coverImage,
      'id': instance.id,
      'savedAt': instance.savedAt.toIso8601String(),
    };
