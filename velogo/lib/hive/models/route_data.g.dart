// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RouteDataAdapter extends TypeAdapter<RouteData> {
  @override
  final int typeId = 1;

  @override
  RouteData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RouteData(
      id: fields[0] as String,
      name: fields[1] as String,
      points: (fields[2] as List)
          .map((dynamic e) => (e as Map).cast<String, double>())
          .toList(),
      totalDistance: fields[3] as double,
      totalElevationGain: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RouteData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.points)
      ..writeByte(3)
      ..write(obj.totalDistance)
      ..writeByte(4)
      ..write(obj.totalElevationGain);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
