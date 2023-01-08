import 'package:bsmrau_cg/modals/course_plan.dart';
import 'package:bsmrau_cg/modals/grading_system.dart';
import 'package:bsmrau_cg/widgets/grade_selector.dart';
import 'package:flutter/material.dart';

class SubjectTile extends StatelessWidget {
  final Course course;
  final Function(double point) onPressed;
  const SubjectTile({super.key, required this.course, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    print(GradingSystem.pointsToGrade(course.pointAchieved));
    return Card(
      elevation: 5.0,
      child: ListTile(
        leading: CircleAvatar(
          radius: 40.0,
          child: Text(GradingSystem.pointsToGrade(course.pointAchieved)),
        ),
        contentPadding: const EdgeInsets.all(0.0),
        title: Text(course.name, style: const TextStyle(fontSize: 20.0)),
        subtitle: Align(
            alignment: Alignment.bottomLeft,
            child: Chip(label: Text('Credit: ${course.credits}'))),
        onTap: () => showDialog(
            context: context,
            builder: (context) => GradeSelector(
                  onPressed: onPressed,
                )),
      ),
    );
  }

  // void _selectResult(BuildContext context) {
  //   showDialog(context: context, builder: builder)
  // }
}
