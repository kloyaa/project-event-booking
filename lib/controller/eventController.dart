import 'package:app/common/formatPrint.dart';
import 'package:app/const/uri.dart';
import 'package:app/controller/userController.dart';
import 'package:app/services/location_coordinates.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  List myEvents = [];

  Future<void> createEvent(data) async {
    await Dio().post("$baseUrl/event", data: data);
    //formatPrint("createEvent", response.data);
  }

  Future<dynamic> getEvents() async {
    final userCtrl = Get.put(UserController());
    final response = await Dio().get(
      "$baseUrl/event/category/get-by-planner",
      queryParameters: {
        "accountId": userCtrl.loginData["accountId"],
      },
    );
    // formatPrint("getEvents", response.data);
    return response.data;
  }

  Future<dynamic> getNearbyEvents() async {
    final locationCoord = await getLocation();

    final response = await Dio().get(
      "$baseUrl/event/all",
      queryParameters: {
        "latitude": locationCoord!.latitude,
        "longitude": locationCoord.longitude,
      },
    );
    formatPrint("getNearbyEvents", response.data);
    return response.data;
  }

  Future<void> deleteEvent(id) async {
    await Dio().delete("$baseUrl/event/$id");
  }
}
