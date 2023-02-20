import 'package:bsmrau_cg/modals/app_constants.dart';
import 'package:bsmrau_cg/modals/app_preferences.dart';
import 'package:bsmrau_cg/modals/app_releases.dart';
import 'package:bsmrau_cg/modals/course_plan.dart';
import 'package:bsmrau_cg/modals/parent_db.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

enum Error {
  noError,
  databaseError,
  downloadError,
  connectionError,
  noInternet
}

class InitializerState extends ChangeNotifier {
  late int _selectedBatch = 0;
  late String _selectedFaculty = '';
  late String _selectedLevel = '';
  late String _selectedTerm = '';
  late double _selectedCGPA = 0.00;

  //Variables after all the input completed
  CoursePlan? _coursePlan;
  AppPreferences _appPreferences = AppPreferences.zero();
  late Box<dynamic> _coreDb;
  // BaseData? _baseData;
  ParentDb? _parentDb;
  AppReleases? _appReleases;

  //State Control Variables
  // bool _isError = false;
  bool _isReady = false;
  bool _stateLoading = true;
  bool isInitialized = false;
  bool _isDbAvailable = false;
  Error _error = Error.noError;

  //============================================================================
  //------------------State Initializers----------------------------------------
  //============================================================================

  void initialize() async {
    if (isInitialized) return;
    // print('Printing');
    isInitialized = true;

    //Initialize Database
    _coreDb = Hive.box('coreDb');

    await _recursiveFunctions(
        function: getBaseData,
        stopCondition: checkParentDbAvailability,
        runAfter: initializeBasicData);
  }

  Future<void> getBaseData() async {
    if (_parentDb == null) {
      await http.get(Uri.parse(AppConstants.parentDbUrl)).then((value) => {
            if (value.statusCode == 200)
              {
                _parentDb = ParentDb.fromCSV(csvString: value.body),
                _removeError(Error.downloadError)
              }
            else
              {_registerError(Error.downloadError)}
          });
      await http.get(Uri.parse(AppConstants.releasesDbUrl)).then((value) => {
            if (value.statusCode == 200)
              {
                _appReleases = AppReleases.fromCSV(value.body),
                _removeError(Error.downloadError)
              }
            else
              {_registerError(Error.downloadError)}
          });
    }
  }

  void initializeBasicData() {
    isInitialized = true;
    _stateLoading = false;

    notifyListeners();
  }

  //============================================================================
  //------------------------Private Functions-----------------------------------
  //============================================================================
  void _registerError(Error error) {
    if (error == _error) return;

    if (_error.index < error.index) {
      _error = error;
    }
  }

  void _removeError(Error error) {
    if (error == _error) {
      _error = Error.noError;
    }
  }

  Future<void> _recursiveFunctions(
      {bool Function()? stopCondition,
      void Function()? runAfter,
      required Future<void> Function() function}) async {
    if (stopCondition!()) return;

    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());

    //Check whether connection state has changed or not and notify listeners for state changes

    if (connectivityResult != ConnectivityResult.wifi &&
        connectivityResult != ConnectivityResult.mobile) {
      _registerError(Error.noInternet);
    } else {
      _removeError(Error.noInternet);
    }

    //Try to use the function
    if (_error != Error.noInternet) {
      try {
        await function();
        _removeError(Error.connectionError);
      } catch (e) {
        _registerError(Error.connectionError);
      }
    }

    //Check whether the condition has met or not

    if (stopCondition()) {
      _error = Error.noError;
      runAfter!();
    } else {
      notifyListeners();
      _recursiveFunctions(
          function: function, stopCondition: stopCondition, runAfter: runAfter);
    }
  }

  //============================================================================
  //----------------------Getters are Here--------------------------------------
  //============================================================================

  bool get isReady {
    return _isReady;
  }

  bool get isStateLoading {
    return _stateLoading;
  }

  bool get isDbAvailable => _isDbAvailable;

  bool get isError {
    return _error != Error.noError;
  }

  int get selectedBatch {
    return _selectedBatch;
  }

  String get selectedFaculty {
    return _selectedFaculty;
  }

  String get selectedLevel {
    return _selectedLevel;
  }

  String get selectedTerm {
    return _selectedTerm;
  }

  List<int> get getBatchNoList {
    return _parentDb?.batchList ?? [];
  }

  List<String> get getFacultyList {
    return _parentDb?.facultyList(selectedBatch) ?? [];
  }

  List<String> get getLevelList {
    return _coursePlan?.levelsList ?? [];
  }

  List<String> get getTermList {
    return _coursePlan?.termsList ?? [];
  }

  String get stateProgressText {
    String message = 'Loading States...';

    if (_error == Error.noInternet) {
      message = 'No Internet Connection';
    } else if (_error == Error.databaseError) {
      message = 'Database Failed to Connect';
    } else if (_error == Error.connectionError) {
      message = 'Connection Failed!';
    } else if (_error == Error.downloadError) {
      message = 'Download Failed!';
    } else {
      message = 'Loading States...';
    }

    return message;
  }

  //============================================================================
  //---------------------------Setters are Here---------------------------------
  //============================================================================

  set setBatchNo(int batchNo) {
    _selectedBatch = batchNo;
    notifyListeners();
  }

  set setFaculty(String facultyName) {
    _selectedFaculty = facultyName;
    notifyListeners();
  }

  set setLevel(String level) {
    _selectedLevel = level;
    notifyListeners();
  }

  set setTerm(String term) {
    _selectedTerm = term;
    notifyListeners();
  }

  set setCGPA(String cgpa) {
    _selectedCGPA = double.parse(cgpa.trim());
    notifyListeners();
  }

  //============================================================================
  //--------------------------State Changing Functions--------------------------
  //============================================================================

  bool shouldInputCgpa() {
    if (_selectedLevel == 'Level 1' && _selectedTerm == 'Summer') {
      return false;
    }
    return true;
  }

  bool isFormCompleted() {
    if (_selectedBatch > 0 && _selectedFaculty.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool isStateFormCompleted() {
    if (_selectedBatch > 0 &&
        _selectedFaculty.isNotEmpty &&
        _selectedLevel.isNotEmpty &&
        _selectedTerm.isNotEmpty) {
      if (_selectedCGPA > 0 || !shouldInputCgpa()) {
        return true;
      }
    }
    return false;
  }

  //============================================================================
  //---------------------------------Availability Testers-----------------------
  //============================================================================
  bool checkParentDbAvailability() {
    if (_parentDb != null) return true;
    return false;
  }

  bool checkCoursePlanAvailability() {
    return _coursePlan != null;
  }

  bool checkInputDataAvailability() {
    if (_coreDb.isNotEmpty &&
        _coreDb.containsKey('batch') &&
        _coreDb.containsKey('faculty') &&
        _coreDb.containsKey('level') &&
        _coreDb.containsKey('term') &&
        _coreDb.containsKey('db_version') &&
        _coreDb.containsKey('cgpa')) return true;
    return false;
  }

  //============================================================================
  //------------------------------State Finalizers------------------------------
  //============================================================================

  Future<void> save() async {
    if (_stateLoading == false) {
      _stateLoading = true;
      notifyListeners();
    }

    await _recursiveFunctions(
        function: _prepareDb,
        stopCondition: checkCoursePlanAvailability,
        runAfter: _startStageDataCollection);
  }

  Future<void> finalize() async {
    if (_stateLoading == false) {
      _stateLoading = true;
      notifyListeners();
    }

    _updateStageData();

    await _recursiveFunctions(
        function: _saveInputData,
        stopCondition: checkInputDataAvailability,
        runAfter: _finalizeDatabase);

    _isReady = true;
    notifyListeners();
  }

  Future<void> _saveInputData() async {
    _appPreferences.batchNo = _selectedBatch;
    _appPreferences.faculty = _selectedFaculty;
    _appPreferences.level = _selectedLevel;
    _appPreferences.term = _selectedTerm;
    _appPreferences.startCgpa = _selectedCGPA;
    _appPreferences.dbVersion = _parentDb?.dbVersion(
            batchNo: _selectedBatch, facultyName: _selectedFaculty) ??
        0;
    _appPreferences.apiVersion = _appReleases?.latestVersion ?? 1.0;
    _appPreferences.pauseUpdateUpto = _appPreferences.apiVersion;
  }

  Future<void> _finalizeDatabase() async {
    await _coreDb.put(AppConstants.dataAvailabilityKey, true);
  }

  Future<void> _prepareDb() async {
    //get the dbLink from the variables
    String dbLink = _parentDb?.dbLink(
            batchNo: selectedBatch, facultyName: selectedFaculty) ??
        '';

    //Parse the data from internet
    await http.get(Uri.parse(dbLink)).then((response) => {
          if (response.statusCode == 200)
            {
              _coursePlan = CoursePlan.fromCSV(response.body.toString()),
              saveDb(),
              _removeError(Error.databaseError)
            }
          else
            {_registerError(Error.databaseError)}
        });
  }

  void _startStageDataCollection() {
    _stateLoading = false;
    _isDbAvailable = true;
    notifyListeners();
  }

  void _updateStageData() {
    try {
      _coursePlan!.inputInitialData(
          level: _selectedLevel, term: _selectedTerm, cgpa: _selectedCGPA);

      _removeError(Error.databaseError);
    } catch (e) {
      _registerError(Error.databaseError);
    }
  }

  void saveDb() {
    _coreDb.put(AppConstants.coursePlanDbKey, _coursePlan);
    _coreDb.put(AppConstants.preferenceDbKey, _appPreferences);
  }

  //========================================================================
  //------------------------------------Contact Methods---------------------
  //========================================================================
  Future<void> contactMessage() async {
    await launchUrl(Uri.parse('sms:${AppConstants.phone}'));
  }

  Future<void> contactCall() async {
    await launchUrl(Uri.parse('tel:${AppConstants.phone}'));
  }

  Future<void> contactMail() async {
    await launchUrl(Uri.parse(
        'mailto: ${AppConstants.mail}?subject=${AppConstants.mailSubject}&body=${AppConstants.mailBody}'));
  }
}
