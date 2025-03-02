// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherDataAdapter extends TypeAdapter<WeatherData> {
  @override
  final int typeId = 0;

  @override
  WeatherData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherData(
      lat: fields[0] as double,
      lon: fields[1] as double,
      windSpeed: fields[2] as double,
      windDirection: fields[3] as double,
      windGust: fields[4] as double,
      timestamp: fields[5] as DateTime,
      source: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.lon)
      ..writeByte(2)
      ..write(obj.windSpeed)
      ..writeByte(3)
      ..write(obj.windDirection)
      ..writeByte(4)
      ..write(obj.windGust)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.source);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
