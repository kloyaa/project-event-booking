import 'package:app/common/formatPrint.dart';
import 'package:app/const/uri.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProfileController extends GetxController {
  Map profile = {};

  Future<dynamic> getProfile(String id) async {
    final response = await Dio().get("$baseUrl/profile/s/$id");
    formatPrint("getProfile", response.data);
    profile = response.data;
    return response.data;
  }

  Future<dynamic> createProfile(data) async {
    final response = await Dio().post("$baseUrl/profile", data: data);
    formatPrint("createProfile", response.data);
    return response.statusCode;
  }

  Future<void> updateAvatar(data) async {
    final response = await Dio().put(
      "$baseUrl/profile/avatar",
      data: http.FormData.fromMap({
        "accountId": data["accountId"],
        'img': await http.MultipartFile.fromFile(
          data["img"]["path"],
          filename: data["img"]["name"],
          contentType: MediaType("image", "jpeg"), //important
        ),
      }),
    );
    formatPrint("updateAvatar", response.data);
  }

  Future<void> updateProfile(data) async {
    final response = await Dio().put("$baseUrl/profile", data: data);
    formatPrint("updateProfile", response.data);
  }

  Future<void> updateProfileAddress(data) async {
    final response = await Dio().put("$baseUrl/profile/address", data: data);
    formatPrint("updateProfileAddress", response.data);
  }
}
