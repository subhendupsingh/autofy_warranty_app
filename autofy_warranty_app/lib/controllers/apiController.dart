import 'package:autofy_warranty_app/services/localStorageService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart' as getx;

class ApiController extends GetxController {
  final Dio _dio = Dio();
  final baseUrl = "https://wapi.autofystore.com";

  fetchProducts() async {
    String token =
        LocalStoragaeService.getUserValue(UserField.Token).toString();

    try {
      Response res = await _dio.get(
        'https://wapi.autofystore.com/api/v1/product',
        options: Options(
          headers: {"Authorization": "Bearer " + token},
        ),
      );
      return res.data;
    } on DioError catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  activateWarranty({Map<String, dynamic>? data}) async {
    await EasyLoading.show();
    String token =
        LocalStoragaeService.getUserValue(UserField.Token).toString();

    try {
      print("aming a get req");
      Response res = await _dio.post(
        'https://wapi.autofystore.com/api/v1/warranty/activate',
        queryParameters: data,
        options: Options(
          headers: {"Authorization": "Bearer " + token},
        ),
      );

      if (res.statusCode == 200) {
        getx.Get.snackbar(
            "Warranty activation request has been sent for approval", "",
            colorText: Colors.green, backgroundColor: Colors.white);
      }
    } on DioError catch (e) {
      print(e.response!.data["message"]);
      getx.Get.snackbar(e.response!.data["message"], "",
          colorText: Colors.red, backgroundColor: Colors.white);
    } catch (e) {
      getx.Get.snackbar("Something Went Wrong", "Please try again",
          colorText: Colors.red);
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
