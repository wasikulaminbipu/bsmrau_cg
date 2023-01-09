import 'package:bsmrau_cg/pages/calculator_page/calculator_page.dart';
import 'package:bsmrau_cg/providers/calculator_provider.dart';
import 'package:bsmrau_cg/widgets/dropdown_input.dart';
import 'package:bsmrau_cg/providers/initializer_provider.dart';
import 'package:bsmrau_cg/widgets/progress_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfoCollector extends StatelessWidget {
  const InfoCollector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<InitializerState>();
    state.initialize();

    Future.delayed(Duration.zero, () {
      if (state.isReady) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (_) => CalculatorState(),
                builder: (context, child) => const CalculatorPage())));
      }
    });
    return Visibility(
      visible: !state.isStateLoading,
      replacement: ProgressViewer(
          isError: state.isError, progressText: state.stateProgressText),
      child: ListView(
        shrinkWrap: true,
        children: [
          AppDropdownInput<int>(
              hintText: 'Please Select Batch No',
              options: state.getBatchNoList,
              value: state.selectedBatch,
              onChanged: (value) {
                state.setBatchNo = value!;
              }),
          AppDropdownInput<String>(
              hintText: 'Please Select Your Faculty',
              options: state.getFacultyList,
              value: state.selectedFaculty,
              onChanged: (value) {
                state.setFaculty = value!;
              }),
          AppDropdownInput(
              hintText: 'Please Select Your Level',
              options: state.getLevelList,
              value: state.selectedLevel,
              onChanged: (value) {
                state.setLevel = value!;
              }),
          AppDropdownInput(
              hintText: 'Please Select Your Term',
              options: state.getTermList,
              value: state.selectedTerm,
              onChanged: (value) {
                state.setTerm = value!;
              }),
          state.shouldInputCgpa()
              ? TextFormField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15.0),
                    labelText: 'CGPA (Upto Prev. Term)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                  onChanged: (value) => state.setCGPA = value,
                )
              : Container(),
          ElevatedButton(
            onPressed: state.isFormCompleted() ? () => state.save() : null,
            child: const Text('Submit'),
            // style: const ButtonStyle(backgroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}
