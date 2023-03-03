import 'package:hive_flutter/hive_flutter.dart';

part 'course_location.g.dart';

@HiveType(typeId: 0)
class CourseLocation extends HiveObject {
  @HiveField(0)
  int levelIndex = 0;

  @HiveField(1)
  int termIndex = 0;

  CourseLocation({required this.levelIndex, required this.termIndex});

  factory CourseLocation.zero() {
    return CourseLocation(levelIndex: 0, termIndex: 0);
  }

  @override
  String toString() {
    return "{levelIndex: $levelIndex, termIndex: $termIndex} ";
  }
}
