import 'package:bsmrau_cg/pages/calculator_page/calculator_counter.dart';
import 'package:bsmrau_cg/pages/calculator_page/term_selector.dart';
import 'package:bsmrau_cg/providers/calculator_provider.dart';
import 'package:bsmrau_cg/providers/preferences_provider.dart';
import 'package:bsmrau_cg/widgets/subject_tile.dart';
import 'package:bsmrau_cg/widgets/update_dialogue.dart';
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
    context.read<CalculatorState>().initialize();

    final int courseCount =
        context.select<CalculatorState, int>((value) => value.courses.length);
    final bool showUpdateDialog = context
        .select<PreferenceState, bool>((value) => value.showAppUpdateDialogue);
    showUpdateDialogue(context: context, condition: showUpdateDialog);
    return Flexible(
      child: ListView.builder(
        padding: const EdgeInsets.all(0.00),
        shrinkWrap: true,
        itemCount: courseCount,
        itemBuilder: (BuildContext context, int index) {
          return SubjectTile(
            courseIndex: index,
          );
        },
      ),
    );
  }
}

void showUpdateDialogue(
    {required BuildContext context, bool condition = true}) {
  if (!condition) return;
  Future.delayed(Duration.zero, () {
    showDialog(
        context: context,
        builder: (_) => UpdateDialogue(onRemindMe: () {}, onDownload: () {}));
  });
}
