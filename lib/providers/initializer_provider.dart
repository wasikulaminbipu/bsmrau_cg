import 'dart:convert';
import 'package:bsmrau_cg/modals/base_data.dart';
import 'package:bsmrau_cg/modals/course_plan.dart';
import 'package:bsmrau_cg/modals/term_system.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class InitializerState extends ChangeNotifier {
  // late List<String<String>> _bachNoList = [];
  late List<int> _batchNoList = [];
  late final List<String> _facultyList = [];
  late final List<String> _levelList = [];
  // List.generate(5, (index) => 'Level $index');
  late final List<String> _termList = [];

  late int _selectedBatch = 0;
  late String _selectedFaculty = '';
  late String _selectedLevel = '';
  late String _selectedTerm = '';
  late double _selectedCGPA = 0.00;

  //Variables after all the input completed
  CoursePlan? _coursePlan;
  late Box<dynamic> _coreDb;
  BaseData? _baseData;

  //State Control Variables
  bool _isError = false;
  bool _isReady = false;
  bool _stateLoading = true;
  bool isInitialized = false;

  //============================================================================
  //------------------State Initializers----------------------------------------
  //============================================================================

  void initialize() async {
    if (isInitialized) return;

    isInitialized = true;

    //Initialize Database
    _coreDb = Hive.box('coreDb');

    await _recursiveFunctions(
        function: getBaseData,
        stopCondition: checkBaseDataAvailability,
        runAfter: initializeBasicData);
  }

  void initializeBasicData() {
    //Set Batch Data List
    _batchNoList =
        List.generate(8, (index) => _baseData!.totalBatches - 6 + index);

    //generate Faculty List
    for (var faculty in _baseData!.faculties) {
      _facultyList.add(faculty.name);
    }

    //generate Term List
    // _levelList.addAll(List.generate(5, (index) => 'Level ${index + 1}'));
    _levelList.addAll(TermSystem.levels);

    //generate Level List
    _termList.addAll(TermSystem.terms);

    isInitialized = true;
    _stateLoading = false;

    notifyListeners();
  }

  bool checkBaseDataAvailability() {
    return _baseData != null;
  }

  Future<void> _recursiveFunctions(
      {bool Function()? stopCondition,
      void Function()? runAfter,
      required Future<void> Function() function}) async {
    if (stopCondition!()) return;

    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());

    //Check whether connection state has changed or not and notify listeners for state changes
    if (_isError != (connectivityResult == ConnectivityResult.none)) {
      _isError = !_isError;
    }

    //Try to use the function
    if (!_isError) {
      try {
        await function();
      } catch (e) {
        _isError = true;
      }
    }

    //Check whether the condition has met or not

    if (stopCondition() && !_isError) {
      runAfter!();
      _isError = false;
      notifyListeners();
    } else {
      notifyListeners();
      await _recursiveFunctions(
          function: function, stopCondition: stopCondition, runAfter: runAfter);
    }
  }

  Future<void> getBaseData() async {
    if (_baseData == null) {
      await http
          .get(Uri.parse('https://api.npoint.io/4702f66a9fe254eb6786'))
          .then((value) => {
                if (value.statusCode == 200)
                  {
                    _baseData = BaseData.fromJson(json.decode(value.body)),
                    _isError = false
                  }
                else
                  {
                    _isError = true,
                    _baseData = const BaseData(
                        totalFaculties: 0, totalBatches: 0, faculties: [])
                  }
              });
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

  bool get isError {
    return _isError;
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
    return _batchNoList;
  }

  List<String> get getFacultyList {
    return _facultyList;
  }

  List<String> get getLevelList {
    return _levelList;
  }

  List<String> get getTermList {
    return _termList;
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

    if (facultyName != 'Veterinary Medicine' && _levelList.length == 5) {
      _levelList.removeAt(4);
    }
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

  Future<void> save() async {
    if (_stateLoading == false) {
      _isError = false;
      _stateLoading = true;
      notifyListeners();
    }

    await _recursiveFunctions(
        function: _saveInputData,
        stopCondition: checkInputDataAvailability,
        runAfter: _finalizeDatabase);

    await _recursiveFunctions(
        function: _prepareDb,
        stopCondition: checkCoursePlanAvailability,
        runAfter: _startCalculator);
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
        _coreDb.containsKey('cgpa')) return true;
    return false;
  }

  Future<void> _saveInputData() async {
    await _coreDb.put('batch', _selectedBatch);
    await _coreDb.put('faculty', _selectedFaculty);
    await _coreDb.put('level', _selectedLevel);
    await _coreDb.put('term', _selectedTerm);
    await _coreDb.put('cgpa', _selectedCGPA);
  }

  Future<void> _prepareDb() async {
    //get the dbLink from the variables
    String dbLink = _baseData!.faculties
        .firstWhere((element) => element.name == _selectedFaculty)
        .batches
        .firstWhere((element) =>
            element.minBatch <= _selectedBatch &&
            element.maxBatch >= _selectedBatch)
        .dbLink;

    //Parse the data from internet
    await http.get(Uri.parse(dbLink)).then((response) => {
          if (response.statusCode == 200)
            {
              _coursePlan =
                  CoursePlan.fromJson(jsonDecode(response.body.toString())),
              saveDb(_coursePlan!)
            }
          else
            {
              _isError = true,
            }
        });
  }

  Future<void> _finalizeDatabase() async {
    await _coreDb.put('dataAvailable', true);
  }

  void _startCalculator() {
    _isReady = true;
    notifyListeners();
  }

  void saveDb(CoursePlan coursePlan) {
    _coreDb.put('coursePlan', coursePlan);
  }
}