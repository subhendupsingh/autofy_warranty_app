import 'package:autofy_warranty_app/pages/signIn/signInPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AuthController extends GetxController {
  final Dio _dio = Dio();
  final baseUrl = "https://wapi.autofystore.com";

  Future<bool> registerUser(Map<String, String> data) async {
    bool isRegistrationSuccess = false;
    try {
      EasyLoading.show();
      Response response =
          await _dio.post<Map>("$baseUrl/api/v1/register", data: data);
      if (response.statusCode == 200) {
        getx.Get.snackbar("Registraion Successful", "Please log in",
            colorText: Colors.green);
        getx.Get.to(SignInPage());
        isRegistrationSuccess = true;
      }
    } catch (e) {
      getx.Get.snackbar("Registraion Failed", "Please try again",
          colorText: Colors.red);
    } finally {
      EasyLoading.dismiss();
    }

    return isRegistrationSuccess;
  }
}
