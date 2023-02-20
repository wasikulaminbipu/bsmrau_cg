abstract class GradingSystem {
  static final grading = [
    {'grade': 'A+', 'point': 4.00},
    {'grade': 'A', 'point': 3.75},
    {'grade': 'A-', 'point': 3.50},
    {'grade': 'B+', 'point': 3.25},
    {'grade': 'B', 'point': 3.00},
    {'grade': 'B-', 'point': 2.75},
    {'grade': 'C+', 'point': 2.50},
    {'grade': 'C', 'point': 2.25},
    {'grade': 'D', 'point': 2.00},
    {'grade': 'F', 'point': 0.00},
    {'grade': 'None', 'point': -1.00},
  ];

  static final List<GradeSlap> gradingN = [];

  static Map<String, dynamic> getGrading(int index) {
    return grading[index];
  }

  static String getGrade(int index) {
    return grading[index]['grade'] as String;
  }

  static double getPoints(int index) {
    return grading[index]['point'] as double;
  }

  static String pointsToGrade(double points) {
    for (var tmpGrading in grading) {
      if (points == tmpGrading['point']) {
        return tmpGrading['grade'].toString();
      }
    }
    return 'O';
  }

  static double gradeToPoints(String grade) {
    for (var tmpGrading in grading) {
      if (grade.trim() == tmpGrading['grade']) {
        return tmpGrading['point'] as double;
      }
    }
    return -1.00;
  }

  static void initiateGrading(String csvString) {}
}

class GradeSlap {
  String grade;
  double point;

  GradeSlap({required this.grade, required this.point});
}
