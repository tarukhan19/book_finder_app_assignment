// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookSearchResponse _$BookSearchResponseFromJson(Map<String, dynamic> json) =>
    BookSearchResponse(
      numFound: (json['numFound'] as num).toInt(),
      start: (json['start'] as num).toInt(),
      bookModel:
          (json['docs'] as List<dynamic>)
              .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      numFoundExact: json['numFoundExact'] as bool,
    );

Map<String, dynamic> _$BookSearchResponseToJson(BookSearchResponse instance) =>
    <String, dynamic>{
      'numFound': instance.numFound,
      'start': instance.start,
      'numFoundExact': instance.numFoundExact,
      'docs': instance.bookModel,
    };
