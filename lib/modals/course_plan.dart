import 'package:csv/csv.dart';
import 'package:hive/hive.dart';
part 'course_plan.g.dart';

@HiveType(typeId: 4)
class CoursePlan extends HiveObject {
  // @HiveField(0)
  // String faculty = '';

  @HiveField(0)
  CourseLocation startLocation;

  @HiveField(1)
  double startCgpa = 0.00;

  @HiveField(2)
  CourseLocation currentLocation;

  @HiveField(3)
  List<Level> levels = [];

  CoursePlan(
      {
      // required this.faculty,
      required this.levels,
      required this.startCgpa,
      required this.startLocation,
      required this.currentLocation});

  factory CoursePlan.fromJson(
    Map<String, dynamic> coursePlan,
  ) {
    List<Level> tmpLevels = [];

    //Decode all the level files and store it in the temporary variable
    for (var level in coursePlan['levels']) {
      Level tmpLevel = Level.fromJson(level);
      tmpLevels.add(tmpLevel);
    }

    return CoursePlan(
        // faculty: coursePlan['faculty'],
        levels: tmpLevels,
        startCgpa: 0.00,
        startLocation: CourseLocation(levelIndex: 0, termIndex: 0),
        currentLocation: CourseLocation(levelIndex: 0, termIndex: 0));
  }

  factory CoursePlan.fromCSV(String csvString) {
    //Convert CSV String to List
    List<List<dynamic>> csvData = const CsvToListConverter()
        .convert(csvString, fieldDelimiter: ',', eol: '\n');

    CoursePlan coursePlan = CoursePlan(
        // faculty: facultyName,
        levels: [],
        startCgpa: 0.00,
        startLocation: CourseLocation(levelIndex: 0, termIndex: 0),
        currentLocation: CourseLocation(levelIndex: 0, termIndex: 0));

    for (var elements in csvData) {
      final credits = (double.tryParse(elements[4].toString()) ?? 0.00) +
          (double.tryParse(elements[5].toString()) ?? 0.00);

      coursePlan.insertLevel(
          levelName: elements[0] ?? '',
          termName: elements[1] ?? '',
          courseName: '${elements[2]}: ${elements[3]}',
          credits: credits);
    }

    return coursePlan;
  }

  void update(String csvCoursePlan) {
    final newPlan = CoursePlan.fromCSV(csvCoursePlan);

    for (var i = 0; i < newPlan.levels.length; i++) {
      var level = newPlan.levels[i];
      //Update the level name if correction available
      if (level.name != levels[i].name) {
        levels[i].name = level.name;
      }
      for (var j = 0; j < level.terms.length; j++) {
        var term = level.terms[j];
        //Update the term name if correction available
        if (term.name != levels[i].terms[j].name) {
          levels[i].terms[j].name = term.name;
        }
        for (var k = 0; k < term.courses.length; k++) {
          var course = term.courses[k];
          //Update the course name if correction available
          if (course.name != levels[i].terms[j].courses[k].name) {
            levels[i].terms[j].courses[k].name = course.name;
          }
          //Update the course name if correction available
          if (course.credits != levels[i].terms[j].courses[k].credits) {
            levels[i].terms[j].courses[k].credits = course.credits;
          }
        }
      }
    }
    save();
  }

  //-----------------------------------------------------------------------------
  //----------------Input Type Methods-------------------------------------------
  //-----------------------------------------------------------------------------

  //This method is to get the initial data such as level, term and cgpa upto previous term
  //the data will be stored in the variables available
  void inputInitialData(
      {required String level, required String term, required double cgpa}) {
    startLocation = _getIndex(term: term, level: level);
    startCgpa = cgpa;
    currentLocation = startLocation;
    save();
  }

  //This method is created for setting the achieved point
  //At first get the course index and point achieved then update it
  void setPointAchieved(
      {required int courseIndex, required double pointAchieved}) {
    levels[currentLocation.levelIndex]
        .terms[currentLocation.termIndex]
        .courses[courseIndex]
        .pointAchieved = pointAchieved;
    save();
  }

  //-----------------------------------------------------------------------------
  //-----------------State Type Methods------------------------------------------
  //-----------------------------------------------------------------------------

  //This Method is created for changing term data
  //This method should get the next term data based on current term and level
  void nextTerm() {
    currentLocation.levelIndex =
        (currentLocation.levelIndex < (levels.length - 1) &&
                currentLocation.termIndex ==
                    (levels[currentLocation.levelIndex].terms.length - 1))
            ? currentLocation.levelIndex + 1
            : currentLocation.levelIndex;
    currentLocation.termIndex = (currentLocation.termIndex <
            (levels[currentLocation.levelIndex].terms.length - 1))
        ? currentLocation.termIndex + 1
        : 0;
    save();
  }

  //This method is created for changing term data
  //This method should get previous term data based on current term and level
  void previousTerm() {
    currentLocation.levelIndex =
        (currentLocation.levelIndex > 0 && currentLocation.termIndex == 0)
            ? currentLocation.levelIndex - 1
            : currentLocation.levelIndex;
    currentLocation.termIndex = (currentLocation.termIndex == 0)
        ? levels[currentLocation.levelIndex].terms.length - 1
        : (currentLocation.termIndex - 1);
    save();
  }

  //-----------------------------------------------------------------------------
  //------------------------------Getters----------------------------------------
  //-----------------------------------------------------------------------------

  //This getter is created for getting current term data availble
  List<String> get levelsList {
    List<String> tmpLevels = [];

    for (var level in levels) {
      if (!tmpLevels.contains(level.name)) tmpLevels.add(level.name);
    }

    return tmpLevels;
  }

  List<String> get termsList {
    List<String> tmpTerms = [];

    for (var level in levels) {
      for (var term in level.terms) {
        if (!tmpTerms.contains(term.name)) tmpTerms.add(term.name);
      }
    }

    return tmpTerms;
  }

  List<Course> get currentCourses {
    return levels[currentLocation.levelIndex]
        .terms[currentLocation.termIndex]
        .courses;
  }

  double get currentGPA {
    return levels[currentLocation.levelIndex]
        .terms[currentLocation.termIndex]
        .gpa;
  }

  String get currentTerm {
    String name = '';
    if (currentLocation != null && levels.length > currentLocation.levelIndex) {
      name =
          '${levels[currentLocation.levelIndex].name} : ${levels[currentLocation.levelIndex].terms[currentLocation.termIndex].name}';
    }
    return name;
  }

  //This getter is created to toogle the next button based on terms available
  bool get showNextButton {
    return (currentLocation.levelIndex == levels.length - 1 &&
            currentLocation.termIndex ==
                levels[currentLocation.levelIndex].terms.length - 1)
        ? false
        : true;
  }

  //This getter is created to toggle the prev button based on terms available
  bool get showPrevButton {
    return (currentLocation.levelIndex == 0 && currentLocation.termIndex == 0)
        ? false
        : true;
  }

  double get totalCredits {
    double tmpTotalCredits = 0.00;

    for (var level in levels) {
      tmpTotalCredits += level.totalCredits;
    }

    return tmpTotalCredits;
  }

  //This getter is created for calculating cgpa upto current term in the page view
  double get cgpa {
    double tmpTotalCredits = 0.00;
    double tmpTotalPoints = 0.00;

    //Loop over all the levels available upto current level
    for (var i = 0; i <= currentLocation.levelIndex; i++) {
      //Loop over all the terms available upto current term
      for (var j = 0; j <= currentLocation.termIndex; j++) {
        var data = levels[i].terms[j];

        //Check If current location is before the start Loc      ation
        if (i < startLocation.levelIndex ||
            (startLocation.levelIndex == i && j < startLocation.termIndex)) {
          //When its before the start Location
          tmpTotalCredits += data.totalCredits;
          tmpTotalPoints += (startCgpa * data.totalCredits);
        } else {
          // print(startCgpa);
          //When its in start location or further
          tmpTotalCredits += data.workingCredits;
          tmpTotalPoints += (data.workingCredits * data.gpa);
        }
      }
    }

    //At First check if the totalCredits is zero to avoid divide-by-zero error
    return tmpTotalCredits > 0 ? tmpTotalPoints / tmpTotalCredits : 0;
  }

  //============================================================================
  //----------------------------Functions---------------------------------------
  //============================================================================

  void insertLevel(
      {required String levelName,
      required String termName,
      required String courseName,
      required double credits}) {
    int index = getLevelIndex(levelName);

    if (index < 0) {
      levels.add(Level(name: levelName, terms: []));
      index = getLevelIndex(levelName);
    }

    levels[index].insertCourse(
        termName: termName, courseName: courseName, credits: credits);
  }

  int getLevelIndex(String levelName) {
    int index = -1;
    for (int i = 0; i < levels.length; i++) {
      if (levels[i].name == levelName) index = i;
    }
    return index;
  }

  //-----------------------------------------------------------------------------
  //--------------------------------Private Methods------------------------------
  //-----------------------------------------------------------------------------

  //This is a private method generally created to search the index of terms and levels
  CourseLocation _getIndex({required String term, required String level}) {
    for (var i = 0; i < levels.length; i++) {
      if (levels[i].name == level) {
        for (var j = 0; j < levels[i].terms.length; j++) {
          if (levels[i].terms[j].name == term) {
            return CourseLocation(termIndex: j, levelIndex: i);
          }
        }
      }
    }
    return CourseLocation(levelIndex: 0, termIndex: 0);
  }

  //-----------------------------------------------------------------------------
  //---------------------------Ovirride Mehods-----------------------------------
  //-----------------------------------------------------------------------------

  @override
  String toString() {
    return '{totalCredits: $totalCredits, levels: $levels, startLocation: $startLocation, currentLocation: $currentLocation, startCgpa: $startCgpa}, ';
  }
}

@HiveType(typeId: 3)
class Level extends HiveObject {
  @HiveField(0)
  String name = '';

  @HiveField(1)
  List<Term> terms = [];

  Level({required this.name, required this.terms});

  factory Level.fromJson(Map<String, dynamic> level) {
    List<Term> tmpTerms = [];

    //Decode all the courses file and store in the temporary variable
    for (var term in level['terms']) {
      Term tmpTerm = Term.fromJson(term);
      tmpTerms.add(tmpTerm);
    }

    return Level(name: level['name'], terms: tmpTerms);
  }

  //============================================================================
  //----------------------------Functions---------------------------------------
  //============================================================================

  void insertCourse(
      {required String termName,
      required String courseName,
      required double credits}) {
    int index = getTermIndex(termName);

    if (index < 0) {
      terms.add(Term(name: termName, courses: []));
      index = getTermIndex(termName);
    }

    terms[index].insertCourse(courseName: courseName, credits: credits);
  }

  int getTermIndex(String termName) {
    int index = -1;
    for (int i = 0; i < terms.length; i++) {
      if (terms[i].name == termName) index = i;
    }
    return index;
  }

  //-----------------------------------------------------------------------------
  //----------------------------Getters------------------------------------------
  //-----------------------------------------------------------------------------
  double get totalCredits {
    double tmpTotalCredits = 0.00;

    for (var term in terms) {
      tmpTotalCredits += term.totalCredits;
    }

    return tmpTotalCredits;
  }

  @override
  String toString() {
    return '{ name: $name, totalCredit: $totalCredits, terms: $terms';
  }
}

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
      if (course.isUsed) credits += course.credits;
    }

    return credits;
  }

  //Calculate the gpa
  double get gpa {
    double tmpTotalCredit = 0.00;
    double tmpTotalPoint = 0.00;

    for (var course in courses) {
      if (course.isUsed) {
        tmpTotalCredit += course.credits;
        tmpTotalPoint += course.credits * course.pointAchieved;
      }
    }

    return tmpTotalCredit == 0 ? 0.0 : tmpTotalPoint / tmpTotalCredit;
  }

  int get totalCourses {
    return courses.length;
  }

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

  factory Course.fromJson(Map<String, dynamic> course) {
    return Course(
        name: course['name'],
        credits: (course['credits'] as num).toDouble(),
        pointAchieved: -1);
  }

  //=========Getters=======================
  bool get isUsed {
    if (pointAchieved < 0) return false;
    return true;
  }

  //=========Override Methods=================

  @override
  String toString() {
    return '{ name: $name, credits: $credits, pointAchieved: $pointAchieved }';
  }
}

@HiveType(typeId: 0)
class CourseLocation extends HiveObject {
  @HiveField(0)
  int levelIndex = 0;

  @HiveField(1)
  int termIndex = 0;

  CourseLocation({required this.levelIndex, required this.termIndex});

  @override
  String toString() {
    return "{levelIndex: $levelIndex, termIndex: $termIndex} ";
  }
}
