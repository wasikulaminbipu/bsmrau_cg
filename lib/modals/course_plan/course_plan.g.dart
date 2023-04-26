// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoursePlanAdapter extends TypeAdapter<CoursePlan> {
  @override
  final int typeId = 4;

  @override
  CoursePlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoursePlan(
      levels: (fields[2] as List).cast<Level>(),
      startCgpa: fields[1] as double,
      startLocation: fields[0] as CourseLocation,
      currentLocation: fields[3] as CourseLocation,
    );
  }

  @override
  void write(BinaryWriter writer, CoursePlan obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.startLocation)
      ..writeByte(3)
      ..write(obj.currentLocation)
      ..writeByte(1)
      ..write(obj.startCgpa)
      ..writeByte(2)
      ..write(obj.levels);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoursePlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
