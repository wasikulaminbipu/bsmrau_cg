import 'package:hive_flutter/hive_flutter.dart';

part 'course.g.dart';

@HiveType(typeId: 1)
class Course extends HiveObject {
  @HiveField(0, defaultValue: '')
  String name = '';

  @HiveField(1, defaultValue: 0)
  double credits = 0.0;

  @HiveField(2, defaultValue: -1)
  double pointAchieved = -1;

  Course(
      {required this.name, required this.credits, required this.pointAchieved});

  factory Course.zero() => Course(name: '', credits: 0.00, pointAchieved: 0.00);

  factory Course.fromJson(Map<String, dynamic> course) => Course(
      name: course['name'],
      credits: (course['credits'] as num).toDouble(),
      pointAchieved: -1);

  //=========Getters=======================
  bool get isUsed => pointAchieved < 0 ? false : true;

  double get calculatableCredits => isUsed ? credits : 0.00;

  double get calculatableAchievedPoints => isUsed ? pointAchieved : 0.00;

  double get calculatableTotalPoints => isUsed ? credits * pointAchieved : 0.00;

  //=========Override Methods=================

  @override
  String toString() =>
      '{ name: $name, credits: $credits, pointAchieved: $pointAchieved }';
}
