import 'package:csv/csv.dart';

class ParentDb {
  List<Batch> batches;

  ParentDb({required this.batches});

  factory ParentDb.fromCSV({required String csvString}) {
    final List<Batch> tmpBatches = [];

    //Convert CSV String to List
    List<List<dynamic>> csvData = const CsvToListConverter().convert(csvString);

    //Read all the list and complete the batches
    for (var data in csvData) {
      print(data);
    }

    return ParentDb(batches: tmpBatches);
  }
}

class Batch {
  int batchNo;
  List<Faculty> faculties;

  Batch({required this.batchNo, required this.faculties});
}

class Faculty {
  String faculty;
  Database database;

  Faculty({required this.faculty, required this.database});
}

class Database {
  String dbLocation;
  String version;

  Database({required this.dbLocation, required this.version});
}
