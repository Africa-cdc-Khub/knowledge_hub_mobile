import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khub_mobile/themes/main_theme.dart';

class EditTextField extends StatefulWidget {
  const EditTextField(
      {super.key,
      this.textLabel,
      this.maxLines,
      this.minLines,
      this.textHint,
      required this.textController,
      this.isEditable,
      this.containerColor,
      this.borderRadius,
      this.textColor,
      this.obscureText,
      this.validator,
      this.onChanged,
      this.keyboardType,
      this.initialValue,
      this.inputFormatters});

  final String? textLabel;
  final String? textHint;
  final TextEditingController textController;
  final bool? isEditable;
  final int? minLines;
  final int? maxLines;
  final Color? containerColor;
  final double? borderRadius;
  final Color? textColor;
  final bool? obscureText;
  final String? initialValue;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  @override
  State<EditTextField> createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  bool _isObscured = false;

  @override
  void initState() {
    setState(() {
      if (widget.obscureText != null) {
        _isObscured = widget.obscureText!;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      enabled: widget.isEditable ?? true,
      validator: widget.validator,
      cursorColor: Theme.of(context).primaryColor,
      obscureText: _isObscured,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      inputFormatters: widget.inputFormatters,
      initialValue: widget.initialValue,
      style: TextStyle(color: widget.textColor ?? Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.containerColor ?? MainTheme.appColors.onPrimary,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(widget.borderRadius ?? 8.0)),
          borderSide: BorderSide.none,
        ),
        hintText: widget.textHint,
        hintStyle: Theme.of(context).textTheme.bodyLarge,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MainTheme.appColors.red200, width: 2),
          borderRadius:
              BorderRadius.circular(widget.borderRadius ?? 8.0), // Custom shape
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MainTheme.appColors.red200, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        label: (widget.textLabel != null)
            ? Text(
                widget.textLabel!,
                style: TextStyle(
                    color: MainTheme.appColors.neutral900,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )
            : null,
        suffixIcon: widget.obscureText != null
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
      ),
    );
  }
}
