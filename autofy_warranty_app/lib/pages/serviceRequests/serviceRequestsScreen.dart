import 'package:autofy_warranty_app/models/service_request.model.dart';
import 'package:autofy_warranty_app/pages/serviceRequests/serviceRequestController.dart';
import 'package:autofy_warranty_app/services/localStorageService.dart';

import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class ServiceRequestsScreen extends StatefulWidget {
  @override
  _ServiceRequestsScreenState createState() => _ServiceRequestsScreenState();
}

class _ServiceRequestsScreenState extends State<ServiceRequestsScreen> {
  @override
  initState() {
    super.initState();
    if (ServiceRequestsController.to.isReqMade) {
      ServiceRequestsController.to.getAllServiceRequests(hidden: true);
    } else {
      ServiceRequestsController.to.getAllServiceRequests();
    }
  }

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
                    final String waMsg =
                        "Hey, I need help with my repair request with ServiceNumber: ${serReq.serviceRequestNumber}\nMy Details:\nName: ${LocalStoragaeService.getUserValue(UserField.Name)}\nEmail: ${LocalStoragaeService.getUserValue(UserField.Email)}\nPhone: ${LocalStoragaeService.getUserValue(UserField.Phone)}";
                    final whatsappUrl =
                        "whatsapp://send?phone=919999933907&text=$waMsg";
                    urlLauncher.launch(whatsappUrl);
                  } catch (e) {
                    print(e);
                  }
                },
                child: SvgPicture.asset(
                  "assets/images/wa.svg",
                  width: 35,
                ),
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
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Icon(
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
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
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
                        const Text(
                          "Service Number:",
                          style: TextStyle(color: Colors.grey),
                        ),
                        emptyVerticalBox(height: 5),
                        const Text(
                          "Request Date:",
                          style: TextStyle(color: Colors.grey),
                        ),
                        emptyVerticalBox(height: 5),
                        const Text(
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
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        emptyVerticalBox(height: 5),
                        Text(
                          "${serReq.created}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        emptyVerticalBox(height: 5),
                        Text(
                          "${serReq.warrantyCode}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
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
                child: Text(serReq.statusCode >= 3 ? "Details" : "Track"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSerReqsList({bool isForActiveReqs = true}) {
    return GetBuilder<ServiceRequestsController>(builder: (ctrl) {
      List<ServiceRequestModel> serReqList = isForActiveReqs
          ? ctrl.activeSerReqs.reversed.toList()
          : ctrl.completedSerReqs.reversed.toList();
      return ctrl.isReqMade
          ? serReqList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        "assets/lottie/smiley.json",
                        height: 250,
                      ),
                      Text(
                        "Rejoice!",
                        style: TextStyle(color: Colors.grey, fontSize: 30),
                      ),
                      emptyVerticalBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Text(
                          "All your Autofy products are working just fine",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: serReqList.length,
                  itemBuilder: (_, index) {
                    return buildServiceRequestTile(serReq: serReqList[index]);
                  },
                )
          : Text("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text("Repair Requests"),
            centerTitle: true,
            backgroundColor: AppColors.primaryColor,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_box_outline_blank),
                      emptyHorizontalBox(width: 10),
                      Text("Active")
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_box),
                      emptyHorizontalBox(width: 10),
                      Text("Past")
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              buildSerReqsList(isForActiveReqs: true),
              buildSerReqsList(isForActiveReqs: false),
            ],
          ),
        ),
      ),
    );
  }
}
