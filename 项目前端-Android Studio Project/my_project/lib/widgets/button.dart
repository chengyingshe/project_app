import 'package:flutter/material.dart';
import '../constant.dart';

class Button extends StatefulWidget {
  const Button(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.width,
      this.height})
      : super(key: key);
  final double? width;
  final double? height;
  final Widget child;
  final VoidCallback onPressed;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonColor),
          ),
          onPressed: widget.onPressed,
          child: widget.child),
    );
  }
}
