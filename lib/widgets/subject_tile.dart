import 'package:bsmrau_cg/modals/grading_system.dart';
import 'package:bsmrau_cg/providers/calculator_provider.dart';
import 'package:bsmrau_cg/widgets/grade_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class SubjectTile extends StatelessWidget {
  final int courseIndex;
  const SubjectTile({
    super.key,
    required this.courseIndex,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.select<CalculatorState,
            Tuple3<String, double, void Function(int, double)>>(
        (value) => Tuple3(value.courses[courseIndex].name,
            value.courses[courseIndex].credits, value.setGrade));

    return Card(
      elevation: 5.0,
      child: ListTile(
        leading: GradeTile(
          courseIndex: courseIndex,
        ),
        contentPadding: const EdgeInsets.all(0.0),
        title: Text(state.item1, style: const TextStyle(fontSize: 20.0)),
        subtitle: Align(
            alignment: Alignment.bottomLeft,
            child: Chip(label: Text('Credit: ${state.item2}'))),
        onTap: () => showDialog(
            context: context,
            builder: (context) => GradeSelector(
                  onPressed: ((point) => state.item3(courseIndex, point)),
                )),
      ),
    );
  }
}

class GradeTile extends StatelessWidget {
  const GradeTile({
    Key? key,
    required this.courseIndex,
  }) : super(key: key);

  final int courseIndex;

  @override
  Widget build(BuildContext context) {
    final point = context.select<CalculatorState, double>(
        (value) => value.courses[courseIndex].pointAchieved);
    return CircleAvatar(
      radius: 40.0,
      child: Text(GradingSystem.pointsToGrade(point)),
    );
  }
}
