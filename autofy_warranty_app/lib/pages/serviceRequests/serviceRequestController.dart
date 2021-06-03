import 'package:autofy_warranty_app/models/service_request.model.dart';
import 'package:autofy_warranty_app/models/tracker_response.model.dart';
import 'package:autofy_warranty_app/pages/serviceRequests/serviceReqTrackerScreen.dart';
import 'package:autofy_warranty_app/services/apiService.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ServiceRequestsController extends GetxController {
  List<ServiceRequestModel> _serviceRequestsList = [];
  TrackerResponse? trackerResponse;

  List<ServiceRequestModel> get serviceRequestsList => _serviceRequestsList;

  static ServiceRequestsController get to =>
      Get.find<ServiceRequestsController>();

  @override
  onInit() {
    super.onInit();
    debugPrint("service request controller initialized");
    getAllServiceRequests();
  }

  void removeServiceList() {
    _serviceRequestsList = [];
    update();
  }

  void getAllServiceRequests() async {
    EasyLoading.show(status: "Fetching Data...");
    ApiService apiService = ApiService.to;

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

  void trackOrderWithServiceNumber({
    required ServiceRequestModel serReqModel,
  }) async {
    EasyLoading.show(status: "Tracking Order...");
    ApiService apiService = ApiService.to;

    final res = await apiService.fetchOrderStatus(
        serviceNumber: serReqModel.serviceRequestNumber);

    EasyLoading.dismiss();

    res.fold((errorString) {
      return Get.snackbar("An Error Occured", errorString);
    }, (trRes) {
      trackerResponse = trRes;
      Get.to(() => ServiceReqTrackerScreen(serReq: serReqModel));
      update();
    });
  }
}
