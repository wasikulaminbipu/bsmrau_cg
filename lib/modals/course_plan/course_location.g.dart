// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CourseLocationAdapter extends TypeAdapter<CourseLocation> {
  @override
  final int typeId = 0;

  @override
  CourseLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CourseLocation(
      levelIndex: fields[0] as int,
      termIndex: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CourseLocation obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.levelIndex)
      ..writeByte(1)
      ..write(obj.termIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
