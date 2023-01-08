abstract class TermSystem {
  static final terms = ['Summer', 'Autumn', 'Winter'];

  static final levels = ['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'];

  static String findTerm(int index) {
    return terms[index];
  }

  static int findTermIndex(String term) {
    return terms.indexOf(term.trim());
  }

  static String findLevel(int index) {
    return levels[index];
  }

  static int findLevelIndex(String level) {
    return levels.indexOf(level.trim());
  }
}
