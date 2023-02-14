//Import Type: Basic Flutter
import 'package:bsmrau_cg/modals/parent_db.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//Import Type: Splash Screen
import 'package:flutter_native_splash/flutter_native_splash.dart';
// Import Type: Database
import 'package:hive_flutter/hive_flutter.dart';
//Import Type: Theming
import 'package:bsmrau_cg/theme.dart';
//Import Type: Provider
import 'package:provider/provider.dart';
import 'package:bsmrau_cg/providers/calculator_provider.dart';
import 'package:bsmrau_cg/providers/initializer_provider.dart';
//Import Type: Page
import 'package:bsmrau_cg/pages/calculator_page/calculator_page.dart';
import 'package:bsmrau_cg/pages/initializer_page/initializer_page.dart';
//Import Type: Modals
import 'package:bsmrau_cg/modals/course_plan.dart';

import 'package:http/http.dart' as http;

Future<void> initializeDb() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CourseAdapter());
  Hive.registerAdapter(TermAdapter());
  Hive.registerAdapter(LevelAdapter());
  Hive.registerAdapter(CoursePlanAdapter());
  Hive.registerAdapter(CourseLocationAdapter());
  await Hive.openBox('coreDb');
}

Future<void> importCSV() async {
  final value = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/wasikulaminbipu/bsmrau_cg/master/db/parent_db.csv'));
  ParentDb.fromCSV(csvString: value.body.toString());
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //Database
  await initializeDb();
  await importCSV();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const AppBSMRAUCG());
    FlutterNativeSplash.remove();
  });
}

class AppBSMRAUCG extends StatelessWidget {
  const AppBSMRAUCG({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BSMRAU CG',
      theme: lightTheme(),
      darkTheme: darkTheme(),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,

      home: Hive.box('coreDb').containsKey('dataAvailable')
          ? ChangeNotifierProvider(
              create: (_) => CalculatorState(),
              builder: (context, child) => const CalculatorPage())
          : ChangeNotifierProvider(
              create: (_) => InitializerState(),
              builder: (context, child) => const InitializerPage()),
    );
  }
}
