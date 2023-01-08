import 'package:bsmrau_cg/modals/course_plan.dart';
import 'package:bsmrau_cg/pages/calculator_page/calculator_page.dart';
import 'package:bsmrau_cg/pages/initializer_page/initializer_page.dart';
import 'package:bsmrau_cg/providers/calculator_provider.dart';
import 'package:bsmrau_cg/providers/initializer_provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //Database
  await Hive.initFlutter();
  Hive.registerAdapter(CourseAdapter());
  Hive.registerAdapter(TermAdapter());
  Hive.registerAdapter(LevelAdapter());
  Hive.registerAdapter(CoursePlanAdapter());
  Hive.registerAdapter(CourseLocationAdapter());
  await Hive.openBox('coreDb');

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
      theme: FlexThemeData.light(
        scheme: FlexScheme.sakura,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 9,
        swapColors: true,
        subThemesData: const FlexSubThemesData(),
        keyColors: const FlexKeyColors(),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        fontFamily: GoogleFonts.bakbakOne().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.sakura,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 15,
        subThemesData: const FlexSubThemesData(),
        keyColors: const FlexKeyColors(),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        fontFamily: GoogleFonts.bakbakOne().fontFamily,
      ),
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
