// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_difficulty.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RouteDifficultyAdapter extends TypeAdapter<RouteDifficulty> {
  @override
  final int typeId = 2;

  @override
  RouteDifficulty read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RouteDifficulty(
      routeId: fields[0] as String,
      averageWindResistance: fields[1] as double,
      elevationImpact: fields[2] as double,
      finalScore: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RouteDifficulty obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.routeId)
      ..writeByte(1)
      ..write(obj.averageWindResistance)
      ..writeByte(2)
      ..write(obj.elevationImpact)
      ..writeByte(3)
      ..write(obj.finalScore);
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
