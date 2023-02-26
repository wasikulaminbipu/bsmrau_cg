import 'package:bsmrau_cg/modals/app_constants.dart';
import 'package:bsmrau_cg/providers/calculator_provider.dart';
import 'package:bsmrau_cg/widgets/action_button.dart';
import 'package:bsmrau_cg/widgets/alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class TermSelector extends StatelessWidget {
  const TermSelector({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final state = context.read<CalculatorState>();
    final stateData = context.select<CalculatorState, Tuple3>((value) =>
        Tuple3(value.termName, value.allowNextTerm, value.allowPrevTerm));
    final termName = stateData.item1;
    final allowNextTerm = stateData.item2;
    final allowPrevTerm = stateData.item3;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActionButton(
            icon: Icons.skip_previous,
            onPressed: state.showPrevButton
                ? (allowPrevTerm
                    ? state.prevTerm
                    : () => showDialog(
                        context: context,
                        builder: (_) => const CustomAlertDialogue(
                              details: AppConstants.prevTermWarning,
                            )))
                : null,
          ),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  fixedSize: Size.fromWidth(screenWidth / 10 * 6),
                  elevation: 5.0),
              child: Text(termName)),
          ActionButton(
            icon: Icons.skip_next,
            // onPressed:
            onPressed: state.showNextButton
                ? (allowNextTerm
                    ? state.nextTerm
                    : () => showDialog(
                        context: context,
                        builder: (_) => const CustomAlertDialogue(
                              details: AppConstants.nextTermWarning,
                            )))
                : null,
          )
        ],
      ),
    );
  }
}
