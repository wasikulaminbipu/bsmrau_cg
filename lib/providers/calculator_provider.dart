import 'package:bsmrau_cg/modals/app_constants.dart';
import 'package:bsmrau_cg/modals/course_plan.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CalculatorState extends ChangeNotifier {
  bool _initialized = false;
  CoursePlan _coursePlan = CoursePlan(
    // faculty: '',
    levels: [],
    startCgpa: 0,
    startLocation: CourseLocation(levelIndex: 0, termIndex: 0),
    currentLocation: CourseLocation(levelIndex: 0, termIndex: 0),
  );

  late Box<dynamic> _coreDb;

  void initialize() async {
    if (_initialized) return;
    //check if any data available or push to initializer
    //If No data available nevigate to initializerPage
    _coreDb = Hive.box(AppConstants.dbName);
    if (_coreDb.isNotEmpty &&
        _coreDb.containsKey(AppConstants.dataAvailabilityKey) &&
        _coreDb.containsKey(AppConstants.coursePlanDbKey)) {
      _coursePlan = _coreDb.get(AppConstants.coursePlanDbKey)!;
      _initialized = true;
    }

    Future.delayed(Duration.zero, () => notifyListeners());
  }

  //============================================================================
  //-------------------------Getters--------------------------------------------
  //============================================================================

  List<Course> get courses {
    if (!_initialized) return [];
    return _coursePlan.currentCourses;
  }

  double get gpa {
    if (!_initialized) return 0.00;
    return _coursePlan.currentGPA;
  }

  double get cgpa {
    if (!_initialized) return 0.00;
    return _coursePlan.cgpa;
  }

  //-------------------------State Based Getters--------------------------------
  bool get showNextButton {
    return _coursePlan.showNextButton;
  }

  bool get showPrevButton {
    return _coursePlan.showPrevButton;
  }

  String get termName {
    return _coursePlan.currentTerm;
  }

  int get totalCourses {
    return courses.length;
  }

  int get usedCourses {
    int used = 0;
    for (var course in courses) {
      if (course.isUsed) used++;
    }
    return used;
  }

  //----------------------Function Based Getters--------------------------------
  String getCourseTitle(int index) {
    String title = '';

    if (index < courses.length) title = courses[index].name;

    return title;
  }

  double getCourseCredit(int index) {
    double credit = 0;

    if (index < courses.length) credit = courses[index].credits;

    return credit;
  }

  double getPointAchieved(int index) {
    double points = 0;

    if (index < courses.length) points = courses[index].pointAchieved;

    return points;
  }

  //============================================================================
  //---------------------------Setters------------------------------------------
  //============================================================================

  void setGrade(int index, double pointAchieved) {
    _coursePlan.setPointAchieved(
        courseIndex: index, pointAchieved: pointAchieved);
    notifyListeners();
  }

  //============================================================================
  //------------------------------State Control Functions-----------------------
  //============================================================================

  void nextTerm() {
    _coursePlan.nextTerm();
    notifyListeners();
  }

  void prevTerm() {
    _coursePlan.previousTerm();
    notifyListeners();
  }
}
