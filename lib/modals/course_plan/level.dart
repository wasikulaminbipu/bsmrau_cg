import 'package:bsmrau_cg/modals/course_plan/term.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'level.g.dart';

@HiveType(typeId: 3)
class Level extends HiveObject {
  @HiveField(0)
  String name = '';

  @HiveField(1)
  List<Term> terms = <Term>[];

  Level({required this.name, required this.terms});

  factory Level.zero() => Level(name: '', terms: <Term>[]);

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
  String toString() =>
      '{ name: $name, totalCredit: $totalCredits, terms: $terms';
}
