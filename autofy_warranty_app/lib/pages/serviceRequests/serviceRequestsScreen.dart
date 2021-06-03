import 'package:autofy_warranty_app/models/duck_head.dart';
import 'package:autofy_warranty_app/models/service_request.model.dart';
import 'package:autofy_warranty_app/pages/serviceRequests/serviceReqTrackerScreen.dart';
import 'package:autofy_warranty_app/pages/serviceRequests/serviceRequestController.dart';
import 'package:autofy_warranty_app/services/apiService.dart';
import 'package:autofy_warranty_app/services/localStorageService.dart';

import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class ServiceRequestsScreen extends StatelessWidget {
  buildServiceRequestTile({required ServiceRequestModel serReq}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              trailing: GestureDetector(
                onTap: () async {
                  try {
                    String waMsg =
                        "Hey, I need help with my repair request with ServiceNumber: ${serReq.serviceRequestNumber}\nMy Details:\nName: ${LocalStoragaeService.getUserValue(UserField.Name)}\nEmail: ${LocalStoragaeService.getUserValue(UserField.Email)}\nPhone: ${LocalStoragaeService.getUserValue(UserField.Phone)}";
                    var whatsappUrl =
                        "whatsapp://send?phone=919999933907&text=$waMsg";
                    urlLauncher.launch(whatsappUrl);
                  } catch (e) {
                    print(e);
                  }
                },
                child: Icon(Icons.help_outline_rounded),
              ),
              leading: Container(
                height: 50,
                width: 50,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: "${serReq.productImageUrl}",
                  placeholder: (context, url) => CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                ),
              ),
              subtitle: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text("SKU: ${serReq.productSku}")),
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "${serReq.productName}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              // height: 120,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service Number:",
                          style: TextStyle(color: Colors.grey),
                        ),
                        emptyVerticalBox(height: 5),
                        Text(
                          "Request Date:",
                          style: TextStyle(color: Colors.grey),
                        ),
                        emptyVerticalBox(height: 5),
                        Text(
                          "Warranty Code:",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serReq.serviceRequestNumber.toString(),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        emptyVerticalBox(height: 5),
                        Text(
                          "${serReq.created}",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        emptyVerticalBox(height: 5),
                        Text(
                          "${serReq.warrantyCode}",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            emptyVerticalBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: OutlineButton(
                borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                onPressed: () {
                  ServiceRequestsController.to
                      .trackOrderWithServiceNumber(serReqModel: serReq);
                },
                child: Text("Track"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildActiveList() {
    return GetBuilder<ServiceRequestsController>(
        init: Get.put(ServiceRequestsController()),
        builder: (ctrl) {
          List<ServiceRequestModel> serReqList = ctrl.serviceRequestsList;
          return serReqList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        "assets/lottie/empty_list.json",
                        height: 250,
                      ),
                      Text(
                        "Oops..",
                        style: TextStyle(color: Colors.grey, fontSize: 30),
                      ),
                      emptyVerticalBox(height: 10),
                      Text(
                        "No repair requests found",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: serReqList.length,
                  itemBuilder: (_, index) {
                    return buildServiceRequestTile(serReq: serReqList[index]);
                  },
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: buildActiveList(),
      ),
    );

    // DefaultTabController(
    //   length: 2,
    //   child: Scaffold(
    //     backgroundColor: Colors.grey[200],
    //     appBar: AppBar(
    //       title: Text("Repair Requests"),
    //       backgroundColor: AppColors.primaryColor,
    //       bottom: TabBar(
    //         indicatorColor: Colors.white,
    //         tabs: [
    //           Tab(
    //             text: "Active",
    //             icon: Icon(Icons.check_box_outlined),
    //           ),
    //           Tab(
    //             text: "Past",
    //             icon: Icon(Icons.check_box_rounded),
    //           ),
    //         ],
    //       ),
    //     ),
    //     body: TabBarView(
    //       children: [
    //         buildActiveList(),
    //         Center(
    //           child: Icon(Icons.check_box_rounded),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
