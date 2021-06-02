import 'package:autofy_warranty_app/models/duck_head.dart';
import 'package:autofy_warranty_app/models/service_request.model.dart';
import 'package:autofy_warranty_app/pages/serviceRequests/serviceReqTrackerScreen.dart';
import 'package:autofy_warranty_app/pages/serviceRequests/serviceRequestController.dart';
import 'package:autofy_warranty_app/services/apiService.dart';

import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceRequestsScreen extends StatelessWidget {
  buildServiceRequestTile({required ServiceRequestModel serReq}) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: ExpansionTile(
          tilePadding: const EdgeInsets.only(right: 10),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: EdgeInsets.all(8),
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
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
                        // emptyVerticalBox(height: 5),
                        // Text(
                        //   "Purchase Date:",
                        //   style: TextStyle(color: Colors.grey),
                        // ),
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
                        // emptyVerticalBox(height: 5),
                        // Text(
                        //   "23/02/2020",
                        //   style: TextStyle(fontWeight: FontWeight.w600),
                        // ),
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
                  // ApiService.to.fetchOrderStatus(
                  //     data: DuckHead.resStatus1, servieNumber: "joejofjeoj");
                  ServiceRequestsController.to.trackOrderWithServiceNumber(
                      serReqModel: serReq, resData: DuckHead.resStatus1);
                  //   () => ServiceReqTrackerScreen(
                  //     serReq: serReq,
                  //   ),
                  // );
                },
                child: Text("Track"),
              ),
            ),
          ],
          title: ListTile(
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
        ),
      ),
    );
  }

  buildActiveList() {
    return GetBuilder<ServiceRequestsController>(
        init: Get.put(ServiceRequestsController()),
        builder: (ctrl) {
          List<ServiceRequestModel> serReqList = ctrl.serviceRequestsList;
          return ListView.builder(
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
        appBar: AppBar(
          title: Text("Repair Requests"),
        ),
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
