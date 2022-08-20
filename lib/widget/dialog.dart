import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

dynamic dialogDelete(context, {message, action}) {
  return Alert(
    context: context,
    desc: message,
    style: AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: false,
      backgroundColor: kLight,
      descStyle: GoogleFonts.roboto(
        color: kDark,
        fontSize: 14,
      ),
    ),
    buttons: [
      DialogButton(
        color: kWhite,
        child: Text(
          "DISMISS",
          style: GoogleFonts.roboto(
            color: kDark,
            fontSize: 10,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      DialogButton(
        color: kDanger,
        child: Text(
          "CONTINUE",
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
        onPressed: () => action(),
      )
    ],
  ).show();
}
