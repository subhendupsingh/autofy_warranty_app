import 'package:autofy_warranty_app/pages/signIn/signInPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AuthController extends GetxController {
  final Dio _dio = Dio();
  final baseUrl = "https://wapi.autofystore.com";

  Future<bool> registerUser(Map<String, String> data) async {
    bool isRegistrationSuccess = false;
    try {
      Response response =
          await _dio.post<Map>("$baseUrl/api/v1/register", data: data);
      print(response.data);
      if (response.statusCode == 200) {
        getx.Get.snackbar("Registraion Successful", "Please log in",
            colorText: Colors.green);
        getx.Get.to(SignInPage());
        isRegistrationSuccess = true;
      }
    } on DioError catch (e) {
      //TODO: Remove these print statement, instead use debug prints
      print(e.response!.data["message"]);
      getx.Get.snackbar("Registraion Failed", e.response!.data["message"],
          colorText: Colors.red, backgroundColor: Colors.white);
    } catch (e) {
      print(e);
      getx.Get.snackbar("Registraion Failed", "Please try again",
          colorText: Colors.red);
    }

    return isRegistrationSuccess;
  }
}
