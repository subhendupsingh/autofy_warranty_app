import 'package:autofy_warranty_app/models/service_request.model.dart';
import 'package:autofy_warranty_app/services/apiService.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ServiceRequestsController extends GetxController {
  @override
  onInit() {
    super.onInit();
    debugPrint("service request controller initialized");
    getAllServiceRequests();
  }

  List<ServiceRequestModel> _serviceRequestsList = [];

  List<ServiceRequestModel> get serviceRequestsList => _serviceRequestsList;

  void getAllServiceRequests() async {
    ApiService apiService = Get.find<ApiService>();

    EasyLoading.show();
    Either<String, List<ServiceRequestModel>> res =
        await apiService.fetchAllServiceRequests();
    res.fold((errorString) {
      return Get.snackbar("An Error Occured", errorString);
    }, (serviceRequestList) {
      _serviceRequestsList = serviceRequestList;
      update();
    });

    EasyLoading.dismiss();
  }
}
