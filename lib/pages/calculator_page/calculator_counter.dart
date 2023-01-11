import 'package:bsmrau_cg/pages/calculator_page/grade_viewer.dart';
import 'package:bsmrau_cg/providers/calculator_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class CalculatorCounter extends StatelessWidget {
  const CalculatorCounter({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 5.0,
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
    final state = context.select<CalculatorState, Tuple2<int, int>>(
        (value) => Tuple2(value.usedCourses, value.totalCourses));

    return Tooltip(
      message: "Count is based on ${state.item1} out of ${state.item2} courses",
      child: Chip(
        label: Text("${state.item1}/${state.item2}"),
      ),
    );
  }
}
