import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:step_bank/themes.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? textController;
  final String? hintText;
  final TextInputAction? textInputAction;
  // final String? labelText;
  final Icon? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? clickSuffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool? enable;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldWidget({
    Key? key,
    this.hintText,
    this.textInputAction,
    this.textController,
    // this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.clickSuffixIcon,
    required this.obscureText,
    this.keyboardType,
    this.enable,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      controller: textController,
      style: Mytheme.textHint,
      enabled: enable,
      textInputAction: textInputAction,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
          fillColor: const Color(0xFFEFF0FB), filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFFA7ABC3)),
          // labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: textController!.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  onPressed: clickSuffixIcon,
                  icon: Icon(
                    suffixIcon,
                    color: Colors.green,
                  )),
          enabledBorder:  OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(14)),

          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green, width: 1.7),
              borderRadius: BorderRadius.circular(14))),
    );
  }
}
