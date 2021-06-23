import 'package:autofy_warranty_app/pages/serviceRequests/serviceRequestController.dart';
import 'package:autofy_warranty_app/pages/signIn/signInPage.dart';
import 'package:autofy_warranty_app/services/localStorageService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AuthController extends GetxController {
  final Dio _dio = Dio();
  final baseUrl = "https://wapi.autofystore.com";

  getx.RxBool isUserLoggedIn = false.obs;

  @override
  onInit() {
    super.onInit();
    getAuthenticationStatus();
  }

  static AuthController get to => getx.Get.find<AuthController>();

  getAuthenticationStatus() {
    // dynamic ls = LocalStoragaeService.getUserValue(UserField.Token);

    // isUserLoggedIn.value = ls != null;
  }

  Future<bool> registerUser(Map<String, String> data) async {
    bool isRegistrationSuccess = false;
    try {
      Response response =
          await _dio.post<Map>("$baseUrl/api/v1/register", data: data);

      if (response.statusCode == 200) {
        LocalStoragaeService.updateUserData(response.data);

        getx.Get.snackbar("Registraion Successful", "Please log in",
            colorText: Colors.green);

        isRegistrationSuccess = true;
      }
    } on DioError catch (e) {
      debugPrint("${e.response!.data["message"]}");
      getx.Get.snackbar("User already registered", e.response!.data["message"],
          colorText: Colors.red, backgroundColor: Colors.white);
    } catch (e) {
      print(e);
      getx.Get.snackbar("Registraion Failed", "Please try again",
          colorText: Colors.red);
    }

    return isRegistrationSuccess;
  }

  logOut() async {
    ServiceRequestsController.to.removeServiceList();
    EasyLoading.show(status: "Logging Out..");
    await LocalStoragaeService.deleteUserData();
    getx.Get.offAll(SignInPage());
    EasyLoading.dismiss();
  }
}
