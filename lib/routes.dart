import 'package:bsmrau_cg/pages/calculator_page/calculator_page.dart';
import 'package:bsmrau_cg/pages/initializer_page/initializer_page.dart';
import 'package:bsmrau_cg/providers/calculator_provider.dart';
import 'package:bsmrau_cg/providers/initializer_provider.dart';
import 'package:provider/provider.dart';

final routes = {
  '/': (context) => ChangeNotifierProvider(
      create: (_) => CalculatorState(),
      builder: (_, __) => const CalculatorPage()),
  '/init': (_) => ChangeNotifierProvider(
      create: (_) => InitializerState(),
      builder: (_, __) => const InitializerPage()),
};
