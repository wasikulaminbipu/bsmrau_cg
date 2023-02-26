// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppPreferencesAdapter extends TypeAdapter<AppPreferences> {
  @override
  final int typeId = 5;

  @override
  AppPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppPreferences(
      batchNo: fields[2] as int,
      faculty: fields[3] as String,
      level: fields[4] as String,
      term: fields[5] as String,
      startCgpa: fields[6] == null ? 0.0 : fields[6] as double,
      apiVersion: fields[0] == null ? 1.0 : fields[0] as double,
      dbVersion: fields[1] == null ? 1 : fields[1] as double,
      pauseUpdateUpto: fields[7] == null ? 1.0 : fields[7] as double,
      themModeIndex: fields[8] == null ? 0 : fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AppPreferences obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.apiVersion)
      ..writeByte(1)
      ..write(obj.dbVersion)
      ..writeByte(2)
      ..write(obj.batchNo)
      ..writeByte(3)
      ..write(obj.faculty)
      ..writeByte(4)
      ..write(obj.level)
      ..writeByte(5)
      ..write(obj.term)
      ..writeByte(6)
      ..write(obj.startCgpa)
      ..writeByte(7)
      ..write(obj.pauseUpdateUpto)
      ..writeByte(8)
      ..write(obj.themModeIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
