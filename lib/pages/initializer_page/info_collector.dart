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

    Future.delayed(Duration.zero,
        () => {if (state.isReady) Navigator.pushNamed(context, '/')});

    return Visibility(
      visible: !state.isStateLoading,
      replacement: ProgressViewer(
          isError: state.isError, progressText: state.stateProgressText),
      child: Visibility(
        visible: state.isDbAvailable,
        replacement: BasicDataCollector(state: state),
        child: StageDataCollector(state: state),
      ),
    );
  }
}

class BasicDataCollector extends StatelessWidget {
  const BasicDataCollector({
    super.key,
    required this.state,
  });

  final InitializerState state;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        AppDropdownInput<int>(
            hintText: 'Please Select Batch No',
            options: state.getBatchNoList,
            value: state.selectedBatch,
            onChanged: (value) {
              state.setBatchNo = value!;
            }),
        Visibility(
          visible: state.getFacultyList != [],
          child: AppDropdownInput<String>(
              hintText: 'Please Select Your Faculty',
              options: state.getFacultyList,
              value: state.selectedFaculty,
              onChanged: (value) {
                state.setFaculty = value!;
              }),
        ),
        ElevatedButton(
          onPressed: state.isFormCompleted() ? () => state.save() : null,
          child: const Text('Download Course Plan'),
          // style: const ButtonStyle(backgroundColor: Colors.white),
        ),
      ],
    );
  }
}

class StageDataCollector extends StatelessWidget {
  const StageDataCollector({
    super.key,
    required this.state,
  });

  final InitializerState state;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
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
          onPressed:
              state.isStateFormCompleted() ? () => state.finalize() : null,
          child: const Text('Submit & Start App'),
          // style: const ButtonStyle(backgroundColor: Colors.white),
        ),
      ],
    );
  }
}
