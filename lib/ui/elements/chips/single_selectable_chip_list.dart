import 'package:flutter/material.dart';

class SingleSelectableChipList extends StatefulWidget {
  final List<String> options;

  const SingleSelectableChipList({super.key, required this.options});

  @override
  State<SingleSelectableChipList> createState() => _AutocompleteTextFieldState();
}

class _AutocompleteTextFieldState extends State<SingleSelectableChipList> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          children: widget.options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: _selectedOption == option,
              onSelected: (bool selected) {
                setState(() {
                  _selectedOption = selected ? option : null;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}