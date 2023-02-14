import 'package:bsmrau_cg/modals/course_plan.dart';
import 'package:bsmrau_cg/modals/parent_db.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

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
    _coreDb = Hive.box('coreDb');
    if (_coreDb.containsKey('coursePlan')) {
      _coursePlan = _coreDb.get('coursePlan')!;
      _initialized = true;
    }
    checkForDbUpdate();
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

  //============================================================================
  //-----------------------------Other Functions--------------------------------
  //============================================================================
  void checkForDbUpdate() async {
    final int batchNo = await _coreDb.get('batch');
    final String facultyName = await _coreDb.get('faculty');
    final int currentDbVersion = await _coreDb.get('db_version');

    late final ParentDb parentDb;
    late final onlineDbVersion;

    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      await http
          .get(Uri.parse(
              'https://raw.githubusercontent.com/wasikulaminbipu/bsmrau_cg/master/db/parent_db.csv'))
          .then((value) => {
                if (value.statusCode == 200)
                  {
                    parentDb = ParentDb.fromCSV(csvString: value.body),
                    onlineDbVersion = parentDb.dbVersion(
                        batchNo: batchNo, facultyName: facultyName),
                    if (onlineDbVersion > currentDbVersion)
                      {
                        updateCoursePlan(
                            dbLink: parentDb.dbLink(
                                batchNo: batchNo, facultyName: facultyName)),
                        _coreDb.put('db_version', onlineDbVersion)
                      }
                  }
              });
    }
  }

  void updateCoursePlan({required String dbLink}) async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      //Parse the data from internet
      await http.get(Uri.parse(dbLink)).then((response) => {
            if (response.statusCode == 200)
              {_coursePlan.update(response.body), print("Initiated Update")}
          });
    }
    _coursePlan = await _coreDb.get('coursePlan')!;
    notifyListeners();
  }
}
