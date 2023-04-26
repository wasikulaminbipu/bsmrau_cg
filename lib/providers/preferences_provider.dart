import 'dart:io';
import 'package:bsmrau_cg/app_constants.dart';
import 'package:bsmrau_cg/modals/app_preferences.dart';
import 'package:bsmrau_cg/modals/app_releases.dart';
import 'package:bsmrau_cg/modals/course_plan/course_plan.dart';
import 'package:bsmrau_cg/modals/downloader.dart';
import 'package:bsmrau_cg/modals/parent_db.dart';
import 'package:bsmrau_cg/widgets/update_dialogue.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PreferenceState extends ChangeNotifier {
  double apiVersion = 0.00;
  int dbVersion = 0;

  final Box<dynamic> _coreDb = Hive.box(AppConstants.dbName);

  AppPreferences? _appPreferences;
  AppRelease _appUpdate = AppRelease.zero();

  PackageInfo? _packageInfo;

  bool _initialized = false;
  String path = '';
  int downloadProgress = 0;
  final Downloader _downloader = Downloader();

  String _id = '';
  DownloadTaskStatus _status = DownloadTaskStatus.undefined;
  int _progress = 0;

  void initialize() async {
    if (_initialized) return;
    _downloader.initialize();
    _packageInfo = await PackageInfo.fromPlatform();

    if (_coreDb.containsKey(AppConstants.dataAvailabilityKey)) {
      _appPreferences =
          _coreDb.get(AppConstants.preferenceDbKey) ?? AppPreferences.zero();

      checkForAppUpdate();
      checkForDbUpdate();

      //Adjust app version
      // if ((_appPreferences?.apiVersion ?? 0.00) < AppConstants.version) {
      //   _appPreferences?.update(apiVersion: AppConstants.version);
      // }
      _initialized = true;
    }
    // else {
    //   _appPreferences?.update(apiVersion: AppConstants.version);
    //   _appPreferences?.update(pauseUpdateVersion: AppConstants.version);
    // }

    Future.delayed(Duration.zero, notifyListeners);
  }

  //============================================================================
  //-----------------------------Getters----------------------------------------
  //============================================================================
  String get appLink => _appUpdate.source;
  String get releaseType => _appUpdate.releaseType;
  bool get showAvoidButton => _appUpdate.updateLevel < 2;
  bool get showBackButton => _appUpdate.updateLevel < 3;
  ThemeMode get themMode =>
      ThemeMode.values[_appPreferences?.themModeIndex ?? 0];
  String get initialRoute =>
      Hive.box('coreDb').containsKey('dataAvailable') ? '/' : '/init';

  //TODO: create the app Updatable when build number changes
  bool get appUpdatable =>
      _appUpdate.version != AppRelease.zero().version &&
      _appUpdate.version != _packageInfo?.version;

  //============================================================================
  //-----------------------------Other Functions--------------------------------
  //============================================================================

  void updateCoursePlan({required String dbLink}) async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      //Parse the data from internet
      await http.get(Uri.parse(dbLink)).then((response) {
        CoursePlan? coursePlan;
        if (response.statusCode == 200) {
          if (_coreDb.containsKey(AppConstants.coursePlanDbKey)) {
            coursePlan = _coreDb.get(AppConstants.coursePlanDbKey)!;
          }

          coursePlan?.update(response.body);
        }
      });
    }
    notifyListeners();
  }

  void checkForDbUpdate() async {
    late final ParentDb parentDb;
    late final double onlineDbVersion;

    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      if (_appPreferences == null ||
          _appPreferences?.batchNo == 0 ||
          _appPreferences?.faculty == '') {
        // print("No");
        return;
      }

      await http.get(Uri.parse(AppConstants.parentDbUrl)).then((value) => {
            if (value.statusCode == 200)
              {
                parentDb = ParentDb.fromCSV(csvString: value.body),
                onlineDbVersion = parentDb.dbVersion(
                    batchNo: _appPreferences?.batchNo ?? 0,
                    facultyName: _appPreferences?.faculty ?? ''),
                if (onlineDbVersion > (_appPreferences?.dbVersion ?? 0))
                  {
                    updateCoursePlan(
                        dbLink: parentDb.dbLink(
                            batchNo: _appPreferences?.batchNo ?? 0,
                            facultyName: _appPreferences?.faculty ?? '')),
                    _appPreferences?.update(dbVersion: onlineDbVersion),
                  }
              }
          });
    }
  }

  void checkForAppUpdate() async {
    late final AppReleases appReleases;

    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      await http.get(Uri.parse(AppConstants.releasesDbUrl)).then((value) => {
            if (value.statusCode == 200)
              {
                appReleases = AppReleases.fromCSV(value.body),
                // print(appReleases.latestVersion != _packageInfo?.version ||
                //     appReleases.latestVersion != _packageInfo?.buildNumber),
                if (appReleases.latestVersion != _packageInfo?.version ||
                    appReleases.latestVersion != _packageInfo?.buildNumber)
                  {_appUpdate = appReleases.latestRelease}
                else
                  {_appUpdate = AppRelease.zero()},
                notifyListeners()
                // if (appReleases.latestVersion >
                //         (_appPreferences?.apiVersion ?? 0) &&
                //     appReleases.latestVersion >
                //         (_appPreferences?.pauseUpdateUpto ?? 0))
                //   {_appUpdate = appReleases.latestRelease, notifyListeners()}
              }
          });
    }
  }

  //============================================================================
  //---------------------------Download Related---------------------------------
  //============================================================================
  Future<void> _setPath() async {
    Directory tmpPath = await getApplicationDocumentsDirectory();
    String localPath = '${tmpPath.path}${Platform.pathSeparator}AppReleases';
    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) await savedDir.create();

    path = localPath;
  }

  void cancelUpdate() {
    remindUpdate();
    _appPreferences?.pauseUpdateUpto = _appUpdate.version;
  }

  void remindUpdate() {
    _appUpdate = AppRelease.zero();
    notifyListeners();
  }

  Future<void> downloadApp() async {
    final permissionStatus = await Permission.storage.request();

    if (!permissionStatus.isGranted) return;

    await _setPath();

    _downloader.onChanged = (dynamic data) {
      _id = data[0];
      _status = data[1];
      _progress = data[2];
    };

    bool pathExist = await Directory(path).exists();

    if (!pathExist) return;
    await _downloader.download(source: _appUpdate.source, path: path);
    await installApp();
  }

  Future<void> installApp() async {
    //Create the file path
    String filePath = '$path${Platform.pathSeparator}${_appUpdate.source}';
    //Check if the path exist. If not exist return
    bool pathExist = await File(filePath).exists();
    if (!pathExist) return;
    //Open the file in the path
    await OpenFilex.open(filePath);
    // _appPreferences?.update(apiVersion: _appUpdate?.version);
  }

  void showUpdateDialogue({required BuildContext context}) {
    if (!appUpdatable ||
        !_coreDb.containsKey(AppConstants.dataAvailabilityKey)) {
      return;
    }
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          builder: (_) => UpdateDialogue(
              onRemindMe: remindUpdate, onDownload: downloadApp));
    });
  }

  //============================================================================
  //----------------------------------Theme Related-----------------------------
  //============================================================================
  void changeTheme() {
    _appPreferences?.update(
        themeModeIndex: _appPreferences?.themModeIndex == 2
            ? 0
            : (_appPreferences?.themModeIndex ?? 0) + 1);
    notifyListeners();
  }
}
