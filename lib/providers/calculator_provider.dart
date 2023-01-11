import 'package:bsmrau_cg/modals/course_plan.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CalculatorState extends ChangeNotifier {
  bool _initialized = false;
  CoursePlan _coursePlan = CoursePlan(
    faculty: '',
    levels: [],
    startCgpa: 0,
    startLocation: CourseLocation(levelIndex: 0, termIndex: 0),
    currentLocation: CourseLocation(levelIndex: 0, termIndex: 0),
  );

  late Box<dynamic> _coreDb;

  void initialize() async {
    if (_initialized) return;
    _coreDb = Hive.box('coreDb');
    if (_coreDb.containsKey('coursePlan')) {
      _coursePlan = _coreDb.get('coursePlan')!;
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
