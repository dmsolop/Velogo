// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_difficulty.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RouteDifficultyAdapter extends TypeAdapter<RouteDifficulty> {
  @override
  final int typeId = 4;

  @override
  RouteDifficulty read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RouteDifficulty(
      routeId: fields[0] as String,
      difficulty: fields[1] as double,
      calculatedAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RouteDifficulty obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.routeId)
      ..writeByte(1)
      ..write(obj.difficulty)
      ..writeByte(2)
      ..write(obj.calculatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteDifficultyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
