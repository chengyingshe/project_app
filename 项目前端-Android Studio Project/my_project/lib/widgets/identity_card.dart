import 'package:flutter/material.dart';

class IdentityCard extends StatelessWidget {
  const IdentityCard(
      {Key? key,
      required this.icon,
      required this.textString,
      required this.buttonString,
      required this.onPressed})
      : super(key: key);
  final IconData icon;
  final String textString;
  final String buttonString;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(icon),
            ),
            Text(textString),
          ],
        ),
        TextButton(onPressed: onPressed, child: Text(buttonString)),
      ],
    );
  }
}
