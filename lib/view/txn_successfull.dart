import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';

class ViewTxnSuccess extends StatefulWidget {
  const ViewTxnSuccess({Key? key}) : super(key: key);

  @override
  State<ViewTxnSuccess> createState() => _ViewTxnSuccessState();
}

class _ViewTxnSuccessState extends State<ViewTxnSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Center(
        child: Image.asset(
          "images/success_2.gif",
        ),
      ),
    );
  }
}
