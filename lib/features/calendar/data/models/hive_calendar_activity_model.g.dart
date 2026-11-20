// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_calendar_activity_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalendarActivityHiveAdapter extends TypeAdapter<CalendarActivityHive> {
  @override
  final int typeId = 0;

  @override
  CalendarActivityHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarActivityHive()
      ..date = fields[0] as DateTime?
      ..activity = fields[1] as String?
      ..id = fields[2] as int?;
  }

  @override
  void write(BinaryWriter writer, CalendarActivityHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.activity)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarActivityHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
