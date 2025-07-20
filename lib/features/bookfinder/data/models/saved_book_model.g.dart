// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedBookModelAdapter extends TypeAdapter<SavedBookModel> {
  @override
  final int typeId = 0;

  @override
  SavedBookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedBookModel(
      id: fields[0] as String,
      savedAt: fields[1] as DateTime,
      title: fields[2] as String,
      authorName: (fields[3] as List).cast<String>(),
      authorKey: (fields[4] as List).cast<String>(),
      coverId: fields[5] as int?,
      firstPublishYear: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SavedBookModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.savedAt)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.authorName)
      ..writeByte(4)
      ..write(obj.authorKey)
      ..writeByte(5)
      ..write(obj.coverId)
      ..writeByte(6)
      ..write(obj.firstPublishYear);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedBookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
