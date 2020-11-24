import 'package:flutter/material.dart';
import 'package:kod_wallet_app/auth/shared/shared_design.dart';

class CustomTextField extends StatefulWidget {
  final String title;
  final EdgeInsets padding;
  final int itemLengthCheck;
  final TextEditingController controller;
  final bool showSuffix;
  TextInputAction keyboardAction = TextInputAction.done;
  TextInputType keyboardType = TextInputType.text;

  CustomTextField({
    @required this.padding,
    @required this.title,
    @required this.showSuffix,
    @required this.controller,
    @required this.itemLengthCheck,
    this.keyboardAction,
    this.keyboardType,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  String _submittedValue;

  String get value => _submittedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: formTextFieldDecoration,
      child: Padding(
        padding: widget.padding,
        child: TextFormField(
          keyboardType: widget.keyboardType,
          textInputAction: widget.keyboardAction,
          controller: widget.controller,
          validator: (value) {
            if (value.trim().isEmpty) {
              return '${widget.title} Can\'t Be Empty';
            } else if (value.trim().length < widget.itemLengthCheck) {
              return '${widget.title} Must Be More Than ${widget.itemLengthCheck} Character';
            } else {
              return null;
            }
          },
          decoration: inputDecoration(),
          obscureText: widget.showSuffix ? _obscureText : false,
        ),
      ),
    );
  }

  InputDecoration inputDecoration() {
    if (widget.showSuffix == true) {
      return InputDecoration(
        border: InputBorder.none,
        labelText: widget.title,
        hintText: 'Enter ${widget.title}',
        suffixIcon: GestureDetector(
          child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onTap: () {
            setState(() => _obscureText = !_obscureText);
          },
        ),
      );
    } else {
      return InputDecoration(
        border: InputBorder.none,
        labelText: widget.title,
        hintText: 'Enter ${widget.title}',
      );
    }
  }
}
