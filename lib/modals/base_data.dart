class BaseData {
  final int totalFaculties;
  final int totalBatches;
  final List<Faculty> faculties;

  const BaseData(
      {required this.totalFaculties,
      required this.totalBatches,
      required this.faculties});

  factory BaseData.fromJson(Map<String, dynamic> baseData) {
    final List<Faculty> tmpFaculties = [];

    for (var faculty in baseData['faculties']) {
      tmpFaculties.add(Faculty.fromJson(faculty));
    }

    return BaseData(
        totalFaculties: baseData['total_faculties'] ?? 0,
        totalBatches: baseData['total_batches'] ?? 0,
        faculties: tmpFaculties);
  }

  @override
  String toString() {
    String baseData =
        "{ totalFaculties = $totalFaculties, totalBatches = $totalBatches ";
    for (var faculty in faculties) {
      baseData += faculty.toString();
    }

    baseData += " }";

    return baseData;
  }
}

class Faculty {
  final String name;
  final List<Batch> batches;
  const Faculty({required this.name, required this.batches});

  factory Faculty.fromJson(Map<String, dynamic> faculty) {
    final List<Batch> tmpBatches = [];

    for (var batch in faculty['batches']) {
      tmpBatches.add(Batch.fromJson(batch));
    }

    return Faculty(name: faculty['name'] ?? '', batches: tmpBatches);
  }

  @override
  String toString() {
    String faculty = "{ name = $name, batches = ";
    for (var batch in batches) {
      faculty += batch.toString();
    }

    faculty += " }";

    return faculty;
  }
}

class Batch {
  final int minBatch;
  final int maxBatch;
  final String dbLink;

  const Batch(
      {required this.minBatch, required this.maxBatch, required this.dbLink});

  factory Batch.fromJson(Map<String, dynamic> batch) {
    return Batch(
        minBatch: batch['min_batch'] ?? 0,
        maxBatch: batch['max_batch'] ?? 0,
        dbLink: batch['db_link'] ?? '');
  }

  @override
  String toString() {
    return "{minBatch = $minBatch, maxBatch = $maxBatch, dbLink= $dbLink";
  }
}
