// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_show_table.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TVShowTableAdapter extends TypeAdapter<TVShowTable> {
  @override
  final int typeId = 1;

  @override
  TVShowTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TVShowTable(
      id: fields[0] as int,
      name: fields[1] as String,
      posterPath: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TVShowTable obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.posterPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TVShowTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
