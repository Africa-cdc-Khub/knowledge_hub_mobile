import 'package:flutter/material.dart';
import 'package:khub_mobile/models/option_item_model.dart';
import 'package:khub_mobile/themes/main_theme.dart';

class DropDownWithChips extends StatefulWidget {
  final List<OptionItemModel> options;
  final Function(List<OptionItemModel>) itemsSelected;
  final Color? containerColor;
  final String? placeholder;
  final List<OptionItemModel>? initialSelectedItems;

  const DropDownWithChips(
      {super.key,
      required this.options,
      required this.itemsSelected,
      this.containerColor,
      this.placeholder,
      this.initialSelectedItems});

  @override
  State<DropDownWithChips> createState() => _DropDownWithChipsState();
}

class _DropDownWithChipsState extends State<DropDownWithChips> {
  late List<OptionItemModel> _selectedItems = [];
  OptionItemModel? _selectedOption;

  @override
  void initState() {
    super.initState();
    // Initialize _selectedItems with initialSelectedItems if provided
    _selectedItems = widget.initialSelectedItems ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.containerColor ?? Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _selectedItems.isNotEmpty
                ? Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: _selectedItems.map((item) {
                      return Chip(
                        deleteIconColor: Theme.of(context).primaryColor,
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        label: Text(item.name),
                        onDeleted: () {
                          setState(() {
                            _selectedItems.remove(item);
                          });
                          widget.itemsSelected(_selectedItems);
                        },
                      );
                    }).toList(),
                  )
                : const SizedBox.shrink(),
            DropdownButton<OptionItemModel>(
              value: _selectedOption,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              hint: Text(
                widget.placeholder ?? "Select item",
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.w400),
              ),
              underline: Container(color: MainTheme.appColors.neutral200),
              isExpanded: true,
              onChanged: (OptionItemModel? newValue) {
                if (newValue != null && !_selectedItems.contains(newValue)) {
                  setState(() {
                    _selectedItems.add(newValue);
                    _selectedOption = null;
                  });
                }
                widget.itemsSelected(_selectedItems);
              },
              items: widget.options.map((OptionItemModel option) {
                return DropdownMenuItem<OptionItemModel>(
                  value: option,
                  child: Text(option.name),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
