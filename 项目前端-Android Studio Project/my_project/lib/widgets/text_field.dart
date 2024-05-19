import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String prefixText;
  final String? hintText;
  final Widget? suffix;
  final TextEditingController? controller;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  const MyTextField({
    Key? key,
    required this.prefixText,
    this.hintText,
    this.suffix,
    this.controller,
    this.obscureText,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText == true ? true : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      decoration: InputDecoration(
        icon: Text(widget.prefixText),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        filled: true,
        border: InputBorder.none,
        hintText: widget.hintText,
        suffixIcon: widget.suffix,
      ),
    );
  }
}

class MyTextFiledGrayBackground extends StatefulWidget {
  const MyTextFiledGrayBackground(
      {Key? key, this.controller, required this.readOnly})
      : super(key: key);
  final TextEditingController? controller;
  final bool readOnly;

  @override
  State<MyTextFiledGrayBackground> createState() =>
      _MyTextFiledGrayBackgroundState();
}

class _MyTextFiledGrayBackgroundState extends State<MyTextFiledGrayBackground> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: widget.controller,
        decoration:
            const InputDecoration(border: InputBorder.none, filled: true),
        maxLines: 10,
        readOnly: widget.readOnly,
      ),
    );
  }
}
