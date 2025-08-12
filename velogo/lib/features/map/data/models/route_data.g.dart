// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RouteDataAdapter extends TypeAdapter<RouteData> {
  @override
  final int typeId = 3;

  @override
  RouteData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RouteData(
      id: fields[0] as String,
      routePoints: (fields[1] as List)
          .map((dynamic e) => (e as Map).cast<String, double>())
          .toList(),
      createdAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RouteData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.routePoints)
      ..writeByte(2)
      ..write(obj.createdAt);
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
