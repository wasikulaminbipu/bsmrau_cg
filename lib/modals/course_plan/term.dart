import 'package:bsmrau_cg/modals/course_plan/course.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'term.g.dart';

@HiveType(typeId: 2)
class Term extends HiveObject {
  @HiveField(0)
  String name = '';

  @HiveField(1)
  List<Course> courses = [];

  Term({
    required this.name,
    required this.courses,
  });

  //-----------------------------------------------------------------------------
  //-----------------------------Getters-----------------------------------------
  //-----------------------------------------------------------------------------
  double get totalCredits {
    double tmpCredits = 0.00;
    for (var course in courses) {
      tmpCredits += course.credits;
    }
    return tmpCredits;
  }

  double get workingCredits {
    double credits = 0.00;

    for (var course in courses) {
      credits += course.calculatableCredits;
    }

    return credits;
  }

  //Calculate the gpa
  double get gpa {
    double tmpTotalCredit = 0.00;
    double tmpTotalPoint = 0.00;

    for (var course in courses) {
      tmpTotalCredit += course.calculatableCredits;
      tmpTotalPoint += course.calculatableTotalPoints;
    }

    return tmpTotalCredit == 0 ? 0.0 : tmpTotalPoint / tmpTotalCredit;
  }

  // double get calculatableGpa => allResultPublished ? gpa : 0;

  int get totalCourses => courses.length;

  int get resultGot {
    int courseCount = 0;
    for (var course in courses) {
      if (course.isUsed) courseCount++;
    }
    return courseCount;
  }

  bool get allResultPublished {
    if (resultGot == courses.length) return true;
    return false;
  }

  //------------------Functions----------------------------------------
  void insertCourse({required String courseName, required double credits}) {
    int index = getCourseIndex(courseName);

    index < 0
        ? courses
            .add(Course(name: courseName, credits: credits, pointAchieved: -1))
        : courses[index].credits = credits;
  }

  int getCourseIndex(String courseName) {
    int index = -1;
    for (int i = 0; i < courses.length; i++) {
      if (courses[i].name == courseName) index = i;
    }
    return index;
  }

  //-----------------Factory Constructors------------------------------

  factory Term.fromJson(Map<String, dynamic> term) {
    List<Course> tmpCourses = [];

    for (var course in term['courses']) {
      Course tmpCourse = Course.fromJson(course);
      tmpCourses.add(tmpCourse);
    }

    return Term(name: term['name'], courses: tmpCourses);
  }

  //=============Override Methods============
  @override
  String toString() {
    return '{ name: $name, totalCredits: $totalCredits, courses: $courses } ';
  }
}
