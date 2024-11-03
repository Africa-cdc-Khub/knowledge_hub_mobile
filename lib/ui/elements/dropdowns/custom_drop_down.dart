import 'package:flutter/material.dart';
import 'package:khub_mobile/models/option_item_model.dart';

class CustomDropDown extends StatefulWidget {
  final List<OptionItemModel> options;
  final double? width;
  final Function(OptionItemModel) onItemSelected;
  final String? placeholder;
  final String? label;
  final Color? containerColor;
  final Color? textColor;
  final OptionItemModel? initialSelectedItem;

  const CustomDropDown(
      {super.key,
      required this.options,
      required this.onItemSelected,
      this.width,
      this.placeholder,
      this.label,
      this.containerColor,
      this.textColor,
      this.initialSelectedItem});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  final TextEditingController _optionController = TextEditingController();
  OptionItemModel? _selectedMenu;

  @override
  void initState() {
    super.initState();
    _selectedMenu = widget.initialSelectedItem;
    if (_selectedMenu != null) {
      _optionController.text = _selectedMenu!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: widget.containerColor ?? Colors.white,
            border: Border.all(color: Colors.transparent)),
        child: DropdownMenu<OptionItemModel>(
          initialSelection: _selectedMenu,
          trailingIcon: const Icon(Icons.keyboard_arrow_down),
          selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up),
          controller: _optionController,
          width: constraints.maxWidth,
          hintText: widget.placeholder ?? '',
          requestFocusOnTap: true,
          enableFilter: true,
          textStyle: TextStyle(color: widget.textColor ?? Colors.black),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: widget.containerColor ?? Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              // Set the border radius
              borderSide: const BorderSide(
                  color: Colors.transparent), // Remove the border
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              // Set the border radius when focused
              borderSide: const BorderSide(
                  color: Colors.transparent), // Remove the border when focused
            ),
          ),
          label: widget.label != null ? Text(widget.label ?? '') : null,
          onSelected: (OptionItemModel? menu) {
            if (menu != null) {
              setState(() {
                _selectedMenu = menu;
              });
              widget.onItemSelected(menu);
            }
          },
          dropdownMenuEntries: widget.options
              .map<DropdownMenuEntry<OptionItemModel>>((OptionItemModel menu) {
            return DropdownMenuEntry<OptionItemModel>(
                value: menu, label: menu.name);
          }).toList(),
        ),
      );
    });
  }
}
