import 'package:bsmrau_cg/pages/calculator_page/calculator_counter.dart';
import 'package:bsmrau_cg/pages/calculator_page/term_selector.dart';
import 'package:bsmrau_cg/providers/calculator_provider.dart';
import 'package:bsmrau_cg/widgets/subject_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          const CalculatorCounter(),
          TermSelector(
              screenHeight: screenSize.height, screenWidth: screenSize.width),
          const CourseList(),
        ],
      ),
    );
  }
}

class CourseList extends StatelessWidget {
  const CourseList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CalculatorState>();
    state.initialize();

    return ListView.builder(
      padding: const EdgeInsets.all(0.00),
      shrinkWrap: true,
      itemCount: state.courses.length,
      itemBuilder: (BuildContext context, int index) {
        return SubjectTile(
          course: state.courses[index],
          onPressed: ((point) => {state.setGrade(index, point), print(point)}),
        );
      },
    );
  }
}
