import 'dart:developer';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

callNumber(number) async {
  log(number, name: "CALL");
  await FlutterPhoneDirectCaller.callNumber(number);
}
