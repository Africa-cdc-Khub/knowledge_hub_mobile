import 'package:flutter/material.dart';

class MultiSelectableChipList extends StatefulWidget {
  final List<String> options;

  const MultiSelectableChipList({super.key, required this.options});

  @override
  State<MultiSelectableChipList> createState() => _AutocompleteTextFieldState();
}

class _AutocompleteTextFieldState extends State<MultiSelectableChipList> {
  final List<String> _selectedOptions = [];

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          children: widget.options.map((option) {
            return FilterChip(
              label: Text(option),
              selected: _selectedOptions.contains(option),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    _selectedOptions.add(option);
                  } else {
                    _selectedOptions.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}