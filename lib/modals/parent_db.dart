import 'package:csv/csv.dart';

class ParentDb {
  List<Batch> batches;

  ParentDb({required this.batches});

  factory ParentDb.fromCSV({required String csvString}) {
    ParentDb parentDb = ParentDb(batches: []);

    //Convert CSV String to List
    List<List<dynamic>> csvData = const CsvToListConverter()
        .convert(csvString, fieldDelimiter: ',', eol: '\n');
    csvData = csvData.sublist(1);

    //Read all the list and complete the batches
    for (var data in csvData) {
      Faculty faculty;
      faculty = Faculty(
          name: data[1],
          database: Database(
              dbLocation: data[3], version: double.parse(data[2].toString())));
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

  // ===========================================================================
  //------------------------Getters---------------------------------------------
  //============================================================================
  List<int> get batchList {
    List<int> tmpList = [];
    for (var batch in batches) {
      tmpList.add(batch.batchNo);
    }
    return tmpList;
  }

  List<String> facultyList(int batchNo) {
    List<String> tmpList = [];

    if (batchNo == null || batchNo < 0) return tmpList;

    final List<Faculty> faculties = getBatchByBatchNo(batchNo).faculties;
    for (var faculty in faculties) {
      tmpList.add(faculty.name);
    }
    return tmpList;
  }

  String dbLink({required int batchNo, required String facultyName}) {
    final dbLocation = getBatchByBatchNo(batchNo)
        .faculties
        .firstWhere((element) => element.name == facultyName)
        .database
        .dbLocation;
    return 'https://raw.githubusercontent.com/wasikulaminbipu/bsmrau_cg/master/db/$dbLocation';
  }

  double dbVersion({required int batchNo, required String facultyName}) {
    final dbVersion = getBatchByBatchNo(batchNo)
        .faculties
        .firstWhere((element) => element.name == facultyName)
        .database
        .version;
    return dbVersion;
    // return 0.00;
  }

  Batch getBatchByBatchNo(int batchNo) {
    return batches.firstWhere((element) => element.batchNo == batchNo,
        orElse: () => Batch(batchNo: 0, faculties: []));
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
  double version;

  Database({required this.dbLocation, required this.version});
}
