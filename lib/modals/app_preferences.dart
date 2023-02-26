import "package:hive_flutter/hive_flutter.dart";
part 'app_preferences.g.dart';

@HiveType(typeId: 5)
class AppPreferences extends HiveObject {
  @HiveField(0, defaultValue: 1.0)
  double apiVersion = 1.0;

  @HiveField(1, defaultValue: 1)
  double dbVersion = 1;

  @HiveField(2)
  int batchNo;

  @HiveField(3)
  String faculty;

  @HiveField(4)
  String level;

  @HiveField(5)
  String term;

  @HiveField(6, defaultValue: 0.00)
  double startCgpa;

  @HiveField(7, defaultValue: 1.0)
  double pauseUpdateUpto = 1.0;

  @HiveField(8, defaultValue: 0)
  int themModeIndex = 0;

  AppPreferences({
    required this.batchNo,
    required this.faculty,
    required this.level,
    required this.term,
    required this.startCgpa,
    required this.apiVersion,
    required this.dbVersion,
    required this.pauseUpdateUpto,
    required this.themModeIndex,
  });

  factory AppPreferences.zero() {
    return AppPreferences(
        batchNo: 0,
        faculty: '',
        level: '',
        term: '',
        startCgpa: 0.00,
        apiVersion: 0,
        dbVersion: 0,
        pauseUpdateUpto: 0,
        themModeIndex: 0);
  }

  //============================================================================
  //-------------------------Getters------------------------------------------
  //============================================================================

  //============================================================================
  //-------------------------Functions------------------------------------------
  //============================================================================
  void update(
      {double? apiVersion,
      double? dbVersion,
      int? batchNo,
      String? faculty,
      String? level,
      String? term,
      double? startCgpa,
      double? pauseUpdateVersion,
      int? themeModeIndex}) {
    this.apiVersion = apiVersion!;
    this.dbVersion = dbVersion!;
    this.batchNo = batchNo!;
    this.faculty = faculty!;
    this.level = level!;
    this.term = term!;
    this.startCgpa = startCgpa!;
    pauseUpdateUpto = pauseUpdateVersion!;
    save();
  }
  // bool appUpdateRequired(double version) => apiVersion < version;

  // bool dbUpdateRequired()
}
