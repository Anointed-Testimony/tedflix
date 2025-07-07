// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_show_watch_progress_table.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TVShowWatchProgressTableAdapter
    extends TypeAdapter<TVShowWatchProgressTable> {
  @override
  final int typeId = 2;

  @override
  TVShowWatchProgressTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TVShowWatchProgressTable(
      tvShowId: fields[0] as int,
      seasonNumber: fields[1] as int,
      episodeNumber: fields[2] as int,
      progress: fields[3] as double,
      lastWatchedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TVShowWatchProgressTable obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.tvShowId)
      ..writeByte(1)
      ..write(obj.seasonNumber)
      ..writeByte(2)
      ..write(obj.episodeNumber)
      ..writeByte(3)
      ..write(obj.progress)
      ..writeByte(4)
      ..write(obj.lastWatchedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TVShowWatchProgressTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
