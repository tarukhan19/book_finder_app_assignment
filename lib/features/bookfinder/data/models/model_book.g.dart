// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookModel _$BookModelFromJson(Map<String, dynamic> json) => BookModel(
  title: json['title'] as String?,
  authorName:
      (json['author_name'] as List<dynamic>?)?.map((e) => e as String).toList(),
  authorKey:
      (json['author_key'] as List<dynamic>?)?.map((e) => e as String).toList(),
  coverImage: (json['cover_i'] as num?)?.toInt(),
  firstPublishYear: (json['first_publish_year'] as num?)?.toInt(),
);

Map<String, dynamic> _$BookModelToJson(BookModel instance) => <String, dynamic>{
  'title': instance.title,
  'author_name': instance.authorName,
  'author_key': instance.authorKey,
  'cover_i': instance.coverImage,
  'first_publish_year': instance.firstPublishYear,
};
