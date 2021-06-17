import 'package:autofy_warranty_app/main.dart';
import 'package:autofy_warranty_app/pages/homepage/homepageScreen.dart';
import 'package:autofy_warranty_app/pages/repairScreen/repairScreenController.dart';
import 'package:autofy_warranty_app/pages/serviceRequests/serviceRequestController.dart';
import 'package:autofy_warranty_app/services/apiService.dart';
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
          "Warranty activation request has been sent for approval",
          "",
          colorText: Colors.green,
          backgroundColor: Colors.white,
        );
      }
    } on DioError catch (e) {
      print(e.response!.data["message"]);
      getx.Get.snackbar(
        e.response!.data["message"],
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } catch (e) {
      getx.Get.snackbar(
        "Something Went Wrong",
        "Please try again",
        colorText: Colors.red,
      );
    } finally {
      await EasyLoading.dismiss();
    }
  }

  authenticateUser({required String email, required String password}) async {
    Response response;
    try {
      response = await _dio.post(
        "$baseUrl/api/v1/authenticate",
        data: {"username": email, "password": password},
      );
      if (response.statusCode == 200) {
        LocalStoragaeService.updateUserData(response.data);
        await getUserProductData();
        ApiService.to.updateDioAuthorizationToken();
        return "SuccessFully Logged in";
      }
    } catch (e) {
      String? res = "";
      res = e.toString().substring(53, 56);
      if (res == "401") {
        return "Invalid email or password";
      } else if (res == "500") {
        return "Internal server error";
      } else {
        getx.Get.log(e.toString());
        return "Something want wrong";
      }
    }
    return "";
  }

  getUserProductData() async {
    Response userProductResponse;
    int userId = LocalStoragaeService.getUserValue(UserField.Id);
    String token = LocalStoragaeService.getUserValue(UserField.Token);
    try {
      userProductResponse = await _dio.get(
        "$baseUrl/api/v1/user/product",
        queryParameters: {
          "user_id": userId,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer " + token,
          },
        ),
      );
      await LocalStoragaeService.addUserProductData(
        userProductsResponce: userProductResponse.data,
      );
    } catch (e) {
      print(e);
    }
  }

  getWarrantyInfo({required String warrantyCode}) async {
    Response userProductWarrantyInfoResponce;
    String token = LocalStoragaeService.getUserValue(UserField.Token);
    RepairScreenController controller = getx.Get.find();
    controller.isLoading.value = true;
    Map<String, dynamic> userProductWarrentyInfo = {};
    try {
      userProductWarrantyInfoResponce = await _dio.get(
        "$baseUrl/api/v1/warranty/info",
        options: Options(
          headers: {
            "Authorization": "Bearer " + token,
          },
        ),
        queryParameters: {"code": warrantyCode},
      );
      userProductWarrentyInfo =
          userProductWarrantyInfoResponce.data as Map<String, dynamic>;
      controller.userProductWarrantyInfo.value = userProductWarrentyInfo;
      print(userProductWarrentyInfo);
    } catch (e) {
      print(e);
    }
    controller.isLoading.value = false;
    return userProductWarrentyInfo;
  }

  generateRepairRequest({required FormData formData}) async {
    Response repairRequestResponce;
    String token = LocalStoragaeService.getUserValue(UserField.Token);
    RepairScreenController controller = getx.Get.find();

    controller.isLoading.value = true;
    try {
      repairRequestResponce = await _dio.post(
        "$baseUrl/api/v1/warranty/repair",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer " + token,
          },
        ),
      );

      if (repairRequestResponce.statusCode == 200) {
        controller.isLoading.value = false;
        ServiceRequestsController.to.getAllServiceRequests(hidden: true);
        return repairRequestResponce.data;
      }
    } on DioError catch (e) {
      controller.isLoading.value = false;
      return e.response!.data;
    } catch (e) {
      controller.isLoading.value = false;

      return {"message": "Something want wrong..."};
    }
  }

  updateProfile(Map<dynamic, dynamic> userData) async {
    print("Function Called");
    Response userProfileUpdateResponse;
    String token = LocalStoragaeService.getUserValue(UserField.Token);
    try {
      userProfileUpdateResponse = await _dio.post(
        "$baseUrl/api/v1/user/update",
        data: userData,
        options: Options(
          headers: {
            "Authorization": "Bearer " + token,
          },
        ),
      );
      print(userProfileUpdateResponse.data.toString());
      if (userProfileUpdateResponse.statusCode == 200) {
        print("sucess");
        return {
          "success": true,
          "message": userProfileUpdateResponse.data["message"]
        };
      }
    } on DioError catch (e) {
      print("dio error");
      return {"success": false, "message": e.response!.data["message"]};
    } catch (e) {
      print("other error");
      return {"success": false, "message": "Something want wrong..."};
    }
  }
}
