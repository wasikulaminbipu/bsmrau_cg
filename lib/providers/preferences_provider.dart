import 'package:bsmrau_cg/modals/app_constants.dart';
import 'package:bsmrau_cg/modals/app_preferences.dart';
import 'package:bsmrau_cg/modals/app_releases.dart';
import 'package:bsmrau_cg/modals/course_plan.dart';
import 'package:bsmrau_cg/modals/parent_db.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class PreferenceState extends ChangeNotifier {
  double apiVersion = 0.00;
  int dbVersion = 0;

  late final Box<dynamic> _coreDb;

  AppPreferences _appPreferences = AppPreferences.zero();
  AppRelease _appUpdate = AppRelease.zero();

  bool _initialized = false;
  void initialize() {
    if (_initialized) return;
    _coreDb = Hive.box(AppConstants.dbName);
    if (_coreDb.containsKey(AppConstants.dataAvailabilityKey)) {
      _appPreferences =
          _coreDb.get(AppConstants.preferenceDbKey) ?? AppPreferences.zero();
      _initialized = true;
    }

    checkForAppUpdate();
    checkForDbUpdate();
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  //============================================================================
  //-----------------------------Getters----------------------------------------
  //============================================================================

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
    late final onlineDbVersion;

    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      await http.get(Uri.parse(AppConstants.parentDbUrl)).then((value) => {
            if (value.statusCode == 200)
              {
                parentDb = ParentDb.fromCSV(csvString: value.body),
                onlineDbVersion = parentDb.dbVersion(
                    batchNo: _appPreferences.batchNo,
                    facultyName: _appPreferences.faculty),
                if (onlineDbVersion > _appPreferences.dbVersion)
                  {
                    updateCoursePlan(
                        dbLink: parentDb.dbLink(
                            batchNo: _appPreferences.batchNo,
                            facultyName: _appPreferences.faculty)),
                    _appPreferences.update(dbVersion: onlineDbVersion)
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
                if (appReleases.latestVersion > _appPreferences.apiVersion &&
                    appReleases.latestVersion > _appPreferences.pauseUpdateUpto)
                  {_appUpdate = appReleases.latestRelease}
              }
          });
    }
  }
}
