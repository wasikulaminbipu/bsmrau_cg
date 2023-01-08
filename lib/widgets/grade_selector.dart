import 'package:bsmrau_cg/modals/grading_system.dart';
import 'package:flutter/material.dart';

class GradeSelector extends StatelessWidget {
  final Function(double point) onPressed;

  const GradeSelector({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select Your Grade'),
      children: [
        SizedBox(
          height: 370.0,
          child: GridView.builder(
            itemCount: GradingSystem.grading.length,
            itemBuilder: (context, index) {
              return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () => {
                            onPressed(GradingSystem.getPoints(index)),
                            Navigator.of(context).pop()
                          },
                      child: Text(GradingSystem.getGrade(index))));
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
          ),
        )
      ],
    );
  }
}
