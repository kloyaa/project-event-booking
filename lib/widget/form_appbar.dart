import 'package:app/const/material.dart';
import 'package:flutter/material.dart';

TextField inputAppBarTextField({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextEditingController controller,
  required Color color,
  required FocusNode focusNode,
  maxLines = 4,
}) {
  return TextField(
    style: textFieldStyle.copyWith(
      fontWeight: FontWeight.bold,
    ),
    controller: controller,
    focusNode: focusNode,
    maxLines: maxLines,
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      labelStyle: textFieldStyle,
      contentPadding: const EdgeInsets.all(20),
      filled: true,
      fillColor: color,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      labelText: labelText,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      floatingLabelStyle: textFieldStyle.copyWith(
        height: 5,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: textFieldStyle,
    ),
  );
}
