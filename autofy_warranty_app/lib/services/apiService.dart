import 'dart:convert';

import 'package:autofy_warranty_app/models/service_request.model.dart';
import 'package:autofy_warranty_app/models/tracker_response.model.dart';
import 'package:autofy_warranty_app/services/localStorageService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as getx;
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';

class ApiService extends getx.GetxService {
  final Dio _dio = Dio();
  final baseUrl = "https://wapi.autofystore.com";

  @override
  onInit() {
    super.onInit();
    debugPrint("Initialized Api Service");
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {
      "Authorization":
          "Bearer ${LocalStoragaeService.getUserValue(UserField.Token)}"
    };
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          print('${options.method} REQUESTING ${options.uri}');
          if (options.method != "GET") {
            print(" - With -");
            print("${options.data}");
          }
          handler.next(options);
        },
        onResponse:
            (Response response, ResponseInterceptorHandler handler) async {
          print('${response.statusCode} RESPONSE \n ${response.data}');
          handler.next(response);
        },
        onError: (DioError e, ErrorInterceptorHandler handler) async {
          debugPrint("API ERROR");
          debugPrint("${e.response?.data}");
          handler.next(e);
        },
      ),
    );
  }

  void updateDioAuthorizationToken() {
    _dio.options.headers = {
      "Authorization":
          "Bearer ${LocalStoragaeService.getUserValue(UserField.Token)}"
    };
  }

  static ApiService get to => getx.Get.find<ApiService>();

  fetchProducts() async {
    try {
      Response res = await _dio.get('/api/v1/product');
      return res.data;
    } on DioError catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  activateWarranty({Map<String, dynamic>? data}) async {
    await EasyLoading.show();
    try {
      Response res =
          await _dio.post('/api/v1/warranty/activate', queryParameters: data);

      if (res.statusCode == 200) {
        await EasyLoading.dismiss();
        return "success";
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
    return "";
  }

  Future<Either<String, List<ServiceRequestModel>>>
      fetchAllServiceRequests() async {
    List<ServiceRequestModel> serviceRequests = [];
    try {
      Response res = await _dio.get('/api/v1/user/serviceRequests/',
          queryParameters: {
            "user_id": LocalStoragaeService.getUserValue(UserField.Id)
          });
      if (res.statusCode == 200) {
        List<dynamic> data = res.data;
        data.forEach((element) {
          serviceRequests.add(
            ServiceRequestModel.fromJson(element),
          );
        });
      }
    } on DioError catch (e) {
      print("DIO error");
      print(e);
      return Left(e.message);
    } catch (e) {
      print("Unknown error");
      print(e);
      return Left("Unknown Error Occured");
    }
    return Right(serviceRequests);
  }

  Future<Either<String, TrackerResponse?>> fetchOrderStatus(
      {required String serviceNumber}) async {
    TrackerResponse? trackerResponse;
    try {
      Response response = await _dio.get("/api/v1/serviceRequest/track/",
          queryParameters: {"service_request_number": serviceNumber});

      dynamic res = response.data;

      if (res["statusCode"] == 0) {
        trackerResponse = TrackerResponse(
          status: res["status"],
          statusCode: res["statusCode"],
          trackingResOne: res["tracking"] == null
              ? null
              : TrackingResOne.fromJson(
                  jsonDecode(res["tracking"]).values.first,
                ),
        );
      } else {
        trackerResponse = TrackerResponse.fromJson(res);
      }
    } on DioError catch (dioError) {
      print(dioError);
      return Left(dioError.message);
    } catch (e) {
      print(e);
      return Left("Unknown Error Occured");
    }
    return Right(trackerResponse);
  }
}
