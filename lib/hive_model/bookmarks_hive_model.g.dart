// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarks_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookmarksHiveModelAdapter extends TypeAdapter<BookmarksHiveModel> {
  @override
  final int typeId = 0;

  @override
  BookmarksHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookmarksHiveModel()
      ..surahNumber = fields[0] as dynamic
      ..verseNumber = fields[1] as dynamic
      ..surahName = fields[2] as dynamic
      ..index = fields[3] as dynamic
      ..surahIndex = fields[4] as dynamic
      ..verseTranslation = fields[5] as dynamic;
  }

  @override
  void write(BinaryWriter writer, BookmarksHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.surahNumber)
      ..writeByte(1)
      ..write(obj.verseNumber)
      ..writeByte(2)
      ..write(obj.surahName)
      ..writeByte(3)
      ..write(obj.index)
      ..writeByte(4)
      ..write(obj.surahIndex)
      ..writeByte(5)
      ..write(obj.verseTranslation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarksHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
