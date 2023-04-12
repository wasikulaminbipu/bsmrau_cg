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
          version: release[1].toString(),
          buildNumber: release[2].toString(),
          // apiVersion: double.parse(release[1].toString()),
          source: release[3].toString()));
    }

    return AppReleases(releases: tmpReleases);
  }

  //============================================================================
  //---------------------------Getters------------------------------------------
  //============================================================================
  AppRelease get latestRelease => releases.last;

  // {
  //   AppRelease tmpRelease =
  //       AppRelease(updateLevel: 0, apiVersion: 0, source: '');

  //   for (var release in releases) {
  //     if (release.apiVersion > tmpRelease.apiVersion) {
  //       tmpRelease = release;
  //     }
  //   }

  //   return tmpRelease;
  // }

  String get latestVersion => latestRelease.version;
  String get latestBuild => latestRelease.buildNumber;
}

class AppRelease {
  int updateLevel;
  String version;
  String buildNumber;
  // double apiVersion;
  String source;

  AppRelease(
      {required this.updateLevel,
      // required this.apiVersion,
      required this.version,
      required this.buildNumber,
      required this.source});

  factory AppRelease.zero() {
    return AppRelease(
        updateLevel: 0, version: '0', buildNumber: '0', source: '');
  }

  String get releaseType {
    String type = '';
    switch (updateLevel) {
      case 3:
        type = 'Severe';
        break;
      case 2:
        type = 'Moderate';
        break;
      default:
        type = 'Normal';
    }
    return type;
  }
}
