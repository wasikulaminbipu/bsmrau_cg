import 'package:bsmrau_cg/pages/calculator_page/grade_viewer.dart';
import 'package:bsmrau_cg/providers/calculator_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorCounter extends StatelessWidget {
  const CalculatorCounter({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 5.0,
      // height: screenHeight / 10 * 5,
      // decoration: BoxDecoration(
      //     color: Theme.of(context).colorScheme.surface,
      //     boxShadow: [BoxShadow(blurRadius: 2.0, spreadRadius: 1.0)]),
      // color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight / 100 * 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [CourseAmountChip()],
              ),
            ),
            GradeViewer(screenWidth: screenWidth),
            // TermSelector(screenHeight: screenHeight, screenWidth: screenWidth),
            SizedBox(
              height: screenHeight * 0.03,
            )
          ],
        ),
      ),
    );
  }
}

class CourseAmountChip extends StatelessWidget {
  const CourseAmountChip({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CalculatorState>();

    return Tooltip(
      message:
          "Count is based on ${state.usedCourses} out of ${state.totalCourses} courses",
      child: Chip(
        label: Text("${state.usedCourses}/${state.totalCourses}"),
      ),
    );
  }
}
