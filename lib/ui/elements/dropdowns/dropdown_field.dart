import 'package:flutter/material.dart';
import 'package:khub_mobile/models/option_item_model.dart';
import 'package:khub_mobile/themes/main_theme.dart';

class DropdownField extends StatefulWidget {
  final List<OptionItemModel> itemList;
  final Function(OptionItemModel) onItemSelected;
  final String? placeholder;
  final Color? containerColor;
  final OptionItemModel? initialSelectedItem;

  const DropdownField(
      {super.key,
      required this.itemList,
      required this.onItemSelected,
      this.placeholder,
      this.containerColor,
      this.initialSelectedItem});

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  OptionItemModel? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialSelectedItem;
    // if (dropdownValue != null) {
    //   _optionController.text = dropdownValue!.name;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: widget.containerColor ?? Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
        child: DropdownButton(
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            hint: Text(
              widget.placeholder ?? "",
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w400),
            ),
            underline: Container(color: MainTheme.appColors.neutral200),
            isExpanded: true,
            items: widget.itemList.map((OptionItemModel item) {
              return DropdownMenuItem<OptionItemModel>(
                value: item,
                child: Text(item.name),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  dropdownValue = value;
                });
                widget.onItemSelected(value);
              }
            }),
      ),
    );
  }
}
