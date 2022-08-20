import 'package:app/const/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

SizedBox elevatedButton({
  required String label,
  required Function function,
  required Color btnColor,
  required Color labelColor,
}) {
  return SizedBox(
    height: 55.0,
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () => function(),
      style: ElevatedButton.styleFrom(
        primary: btnColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: kDefaultRadius,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.roboto(
          color: labelColor,
          fontSize: 11.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}
