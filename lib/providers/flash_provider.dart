import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FlashState extends ChangeNotifier {
  bool _changeAnimation = false;
  bool _navigateNextPage = false;
  late Box<dynamic> _coreDb;

  void initialize() async {
    //Initialize DB box
    _coreDb = Hive.box('coreDb');

    //Check if everything is ready to go further steps
    if (!_changeAnimation) startAnimation();
    // print("Started Me as a cool effect");
  }

  void startAnimation() {
    Timer(
        const Duration(seconds: 4),
        () => {
              checkDbAvailability()
                  ? _changeAnimation = true
                  : _changeAnimation = false,
              notifyListeners(),
              //Check the logic here
              //Need attention
              Timer(const Duration(seconds: 2),
                  () => {_navigateNextPage = true, notifyListeners()})
            });
  }

  bool checkDbAvailability() {
    return _coreDb.containsKey('dataAvailable');
  }

  bool swapAnimation() {
    return _changeAnimation;
  }

  bool navigateNextPage() {
    return _navigateNextPage;
  }

  void storeDB() async {}
}
