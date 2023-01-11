import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:bsmrau_cg/providers/calculator_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GradeViewer extends StatelessWidget {
  const GradeViewer({
    Key? key,
    required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth / 10 * 9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const DisplayGpa(),
          Container(
            height: screenWidth / 6,
            width: screenWidth / 1000,
            color: Colors.black,
          ),
          const DisplayCgpa(),
        ],
      ),
    );
  }
}

class DisplayCgpa extends StatelessWidget {
  const DisplayCgpa({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double cgpa =
        context.select<CalculatorState, double>((value) => value.cgpa);
    return Column(
      children: [
        const Text("CGPA", style: TextStyle(fontSize: 18.0)),
        AnimatedFlipCounter(
          value: cgpa,
          fractionDigits: 4,
          textStyle: const TextStyle(
            fontSize: 29.0,
          ),
        ),
      ],
    );
  }
}

class DisplayGpa extends StatelessWidget {
  const DisplayGpa({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double gpa =
        context.select<CalculatorState, double>((value) => value.gpa);
    return Column(
      children: [
        const Text("Calculated GPA", style: TextStyle(fontSize: 20.0)),
        AnimatedFlipCounter(
          value: gpa,
          fractionDigits: 4,
          textStyle:
              const TextStyle(fontSize: 70.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
