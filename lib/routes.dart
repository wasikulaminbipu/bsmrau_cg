import 'package:bsmrau_cg/pages/calculator_page/calculator_page.dart';
import 'package:bsmrau_cg/pages/initializer_page/initializer_page.dart';
import 'package:bsmrau_cg/providers/calculator_provider.dart';
import 'package:bsmrau_cg/providers/initializer_provider.dart';
import 'package:provider/provider.dart';

final routes = {
  '/': (context) => ChangeNotifierProvider<CalculatorState>(
      create: (_) => CalculatorState(),
      builder: (_, __) => const CalculatorPage()),
  '/init': (context) => ChangeNotifierProvider<InitializerState>(
      create: (context) => InitializerState(),
      builder: (context, __) => const InitializerPage()),
};
