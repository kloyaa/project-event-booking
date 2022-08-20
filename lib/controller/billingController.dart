import 'package:app/common/formatPrint.dart';
import 'package:app/const/uri.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class BillingController extends GetxController {
  Future<void> createBilling(Map data) async {
    try {
      formatPrint("createBilling", data);
      await Dio().put("$baseUrl/booking/update/payment-status", data: {
        "_id": data["_id"],
        "status": "paid",
      });
      data.remove("_id"); //Remove _id
      await Dio().post("$baseUrl/billing", data: data);
    } on DioError catch (e) {
      formatPrint("createBilling:error", e.response!.data);
    }
  }

  Future<dynamic> getCustomerBilling(String id) async {
    try {
      final response = await Dio().get("$baseUrl/billing/get-by-customer/$id");
      formatPrint("getCustomerBilling", response.data);
      return response.data;
    } on DioError catch (e) {
      formatPrint("getCustomerBilling:error", e.response!.data);
    }
  }

  Future<dynamic> getPlannerBilling(String id) async {
    try {
      final response = await Dio().get("$baseUrl/billing/get-by-planner/$id");
      formatPrint("getPlannerBilling", response.data);
      return response.data;
    } on DioError catch (e) {
      formatPrint("getPlannerBilling:error", e.response!.data);
    }
  }
}
