// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MomentAdapter extends TypeAdapter<Moment> {
  @override
  final int typeId = 1;

  @override
  Moment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Moment(
      title: fields[1] as String,
      latestUpdate: fields[2] as DateTime,
      description: fields[3] as String,
      dateList: (fields[4] as List).cast<DateTime>(),
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, Moment obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.latestUpdate)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.dateList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MomentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
