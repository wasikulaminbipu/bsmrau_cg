import 'package:flutter/material.dart';

class AppDropdownInput<T> extends StatelessWidget {
  final String hintText;
  final List<T> options;
  final T value;
  // final String Function(T) getLabel;
  final void Function(T?) onChanged;

  const AppDropdownInput({
    super.key,
    this.hintText = 'Please select an Option',
    required this.options,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: FormField<T>(
        builder: (FormFieldState<T> state) {
          return InputDecorator(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              labelText: hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
            isEmpty: value == null || value == '',
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: options.contains(value) ? value : null,
                isDense: true,
                onChanged: onChanged,
                items: options.map((T item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      item.toString(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
