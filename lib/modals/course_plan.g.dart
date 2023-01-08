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
      faculty: fields[0] as String,
      levels: (fields[4] as List).cast<Level>(),
      startCgpa: fields[2] as double,
      startLocation: fields[1] as CourseLocation,
      currentLocation: fields[3] as CourseLocation,
    );
  }

  @override
  void write(BinaryWriter writer, CoursePlan obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.faculty)
      ..writeByte(1)
      ..write(obj.startLocation)
      ..writeByte(2)
      ..write(obj.startCgpa)
      ..writeByte(3)
      ..write(obj.currentLocation)
      ..writeByte(4)
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

class LevelAdapter extends TypeAdapter<Level> {
  @override
  final int typeId = 3;

  @override
  Level read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Level(
      name: fields[0] as String,
      terms: (fields[1] as List).cast<Term>(),
    );
  }

  @override
  void write(BinaryWriter writer, Level obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.terms);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TermAdapter extends TypeAdapter<Term> {
  @override
  final int typeId = 2;

  @override
  Term read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Term(
      name: fields[0] as String,
      courses: (fields[1] as List).cast<Course>(),
    );
  }

  @override
  void write(BinaryWriter writer, Term obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.courses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TermAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CourseAdapter extends TypeAdapter<Course> {
  @override
  final int typeId = 1;

  @override
  Course read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Course(
      name: fields[0] == null ? '' : fields[0] as String,
      credits: fields[1] == null ? 0 : fields[1] as double,
      pointAchieved: fields[2] == null ? -1 : fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Course obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.credits)
      ..writeByte(2)
      ..write(obj.pointAchieved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
