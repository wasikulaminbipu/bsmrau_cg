import 'package:csv/csv.dart';

class ParentDb {
  List<Batch> batches;

  ParentDb({required this.batches});

  factory ParentDb.fromCSV({required String csvString}) {
    ParentDb parentDb = ParentDb(batches: []);

    //Convert CSV String to List
    List<dynamic> csvData = const CsvToListConverter()
        .convert(csvString, fieldDelimiter: ',', eol: '\n');

    //Read all the list and complete the batches
    for (var data in csvData) {
      Faculty faculty;
      faculty = Faculty(
          name: data[1],
          database: Database(dbLocation: data[3], version: data[2]));
      parentDb.insertBatch(Batch(batchNo: data[0], faculties: [faculty]));
    }

    return parentDb;
  }

  bool checkBatchAvailability(int batchNo) {
    for (var batch in batches) {
      if (batch.batchNo == batchNo) return true;
    }
    return false;
  }

  int getBatchIndex(int batchNo) {
    for (var batch in batches) {
      if (batch.batchNo == batchNo) return batches.indexOf(batch);
    }

    return -1;
  }

  void insertBatch(Batch batch) {
    int batchIndex = getBatchIndex(batch.batchNo);
    if (batchIndex < 0) {
      batches.add(batch);
    } else {
      batches[batchIndex].insertFaculty(batch.faculties[0]);
    }
  }
}

class Batch {
  int batchNo;
  List<Faculty> faculties;

  Batch({required this.batchNo, required this.faculties});

  int getFacultyIndex(String facultyName) {
    for (var faculty in faculties) {
      if (faculty.name == facultyName) return faculties.indexOf(faculty);
    }

    return -1;
  }

  void insertFaculty(Faculty faculty) {
    int facultyIndex = getFacultyIndex(faculty.name);
    if (facultyIndex < 0) {
      faculties.add(faculty);
    } else {
      if (faculties[facultyIndex].database.version < faculty.database.version) {
        faculties[facultyIndex].database = faculty.database;
      }
    }
  }
}

class Faculty {
  String name;
  Database database;

  Faculty({required this.name, required this.database});
}

class Database {
  String dbLocation;
  int version;

  Database({required this.dbLocation, required this.version});
}
