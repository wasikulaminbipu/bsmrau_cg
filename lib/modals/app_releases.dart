import 'package:csv/csv.dart';

class AppReleases {
  final List<AppRelease> releases;

  AppReleases({required this.releases});

  factory AppReleases.fromCSV(String csvString) {
    final List<AppRelease> tmpReleases = [];

    List<List<dynamic>> tmpList = const CsvToListConverter()
        .convert(csvString, fieldDelimiter: ',', eol: '\n');

    tmpList = tmpList.sublist(1);

    for (var release in tmpList) {
      tmpReleases.add(AppRelease(
          updateLevel: int.parse(release[0].toString()),
          apiVersion: double.parse(release[1].toString()),
          source: release[2].toString()));
    }

    return AppReleases(releases: tmpReleases);
  }

  //============================================================================
  //---------------------------Getters------------------------------------------
  //============================================================================
  AppRelease get latestRelease {
    AppRelease tmpRelease =
        AppRelease(updateLevel: 0, apiVersion: 0, source: '');

    for (var release in releases) {
      if (release.apiVersion > tmpRelease.apiVersion) {
        tmpRelease = release;
      }
    }

    return tmpRelease;
  }

  double get latestVersion => latestRelease.apiVersion;
}

class AppRelease {
  int updateLevel;
  double apiVersion;
  String source;

  AppRelease(
      {required this.updateLevel,
      required this.apiVersion,
      required this.source});

  factory AppRelease.zero() {
    return AppRelease(updateLevel: 0, apiVersion: 0, source: '');
  }
}
