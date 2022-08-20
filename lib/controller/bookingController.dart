import 'package:app/common/formatPrint.dart';
import 'package:app/const/uri.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  Future<void> createBooking(data) async {
    final response = await Dio().post("$baseUrl/booking", data: data);
    formatPrint("createBooking", response.data);
  }

  Future<dynamic> getCustomerBookings(query) async {
    final response = await Dio().get(
      "$baseUrl/booking/get-by-customer",
      queryParameters: query,
    );
    formatPrint("getCustomerBookings", response.data);
    return response.data;
  }

  Future<dynamic> getPlannerBookings(query) async {
    final response = await Dio().get(
      "$baseUrl/booking/get-by-planner",
      queryParameters: query,
    );
    formatPrint("getPlannerBookings", response.data);
    return response.data;
  }

  Future<void> updateBookingStatus(body) async {
    await Dio().put("$baseUrl/booking/update/booking-status", data: body);
    formatPrint("updateBookingStatus", body);
  }
}
