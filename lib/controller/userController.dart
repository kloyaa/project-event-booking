import 'package:app/const/uri.dart';
import 'package:app/controller/profileController.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Map loginData = {};

  Future<dynamic> login({email, password}) async {
    try {
      final loginResponse = await Dio().post(
        "$baseUrl/user/login",
        data: {
          "email": email,
          "password": password,
        },
      );
      // ASSIGN VALUE TO GLOBAL STATE
      loginData = {
        "accountId": loginResponse.data["_id"],
        "email": loginResponse.data["email"],
      };

      return loginResponse.statusCode;
      // GET PROFIL E
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        print(e.response);
      }
      return e.response!.statusCode;
    }
  }

  Future<dynamic> register({email, password}) async {
    try {
      final registerResponse = await Dio().post(
        "$baseUrl/user/register",
        data: {
          "email": email,
          "password": password,
        },
      );

      // ASSIGN VALUE TO GLOBAL STATE
      loginData = {
        "accountId": registerResponse.data["accountId"],
        "email": registerResponse.data["email"],
      };
      return registerResponse.statusCode;
      // REDIRECT TO NEXT STEP
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        print(e.response);
      }
      return e.response!.statusCode;
    }
  }

  Future<void> logout() async {
    Get.toNamed("/loading");
    Future.delayed(const Duration(milliseconds: 500), () {
      final profileCtrl = Get.put(ProfileController());
      loginData.clear();
      profileCtrl.profile.clear();

      Get.toNamed("/login");
    });
  }
}
