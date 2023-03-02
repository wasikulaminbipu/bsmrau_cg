// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'term.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
