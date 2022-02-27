import 'package:flutter/material.dart';
import 'package:step_bank/themes.dart';

class ButtonWidget extends StatelessWidget {
  final String? text;
  final Color? color;
  final VoidCallback? onClicked;

  const ButtonWidget({
    Key? key,
    this.text,
    this.color,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
                // side: const BorderSide(color: Colors.red)
            ),
            primary: color,
            minimumSize: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * 0.06)),
        onPressed: onClicked,
        child: Text(
          text!,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ));
  }
}
