import 'dart:convert';
import 'package:flutter/cupertino.dart';

void formatPrint(String title, jsonData) {
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  String prettyprint = encoder.convert(jsonData);
  debugPrint("$title $prettyprint");
}
