import 'package:autofy_warranty_app/models/service_request.model.dart';
import 'package:autofy_warranty_app/models/tracker_response.model.dart';
import 'package:autofy_warranty_app/pages/serviceRequests/serviceRequestController.dart';
import 'package:autofy_warranty_app/pages/web_view.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:get/get.dart';

class ServiceReqTrackerScreen extends StatefulWidget {
  final ServiceRequestModel serReq;
  ServiceReqTrackerScreen({required this.serReq});

  @override
  _ServiceReqTrackerScreenState createState() =>
      _ServiceReqTrackerScreenState();
}

class _ServiceReqTrackerScreenState extends State<ServiceReqTrackerScreen> {
  bool isDetailed = false;
  final Color pendingColor = Colors.grey;
  final Color doneColor = Color(0xFF27AA69);
  final IconData doneIcon = Icons.check;

  final TextStyle headingStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Status"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.receipt_rounded,
              size: 20,
            ),
            onPressed: () {
              Get.to(
                () => WebView(
                  initialUrl:
                      "https://warranty.autofystore.com/terms-and-conditions",
                ),
              );
            },
          ),
          emptyHorizontalBox(width: 10),
        ],
        elevation: 0.0,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext ctxt, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: true,
              pinned: false,
              flexibleSpace: Container(
                padding: EdgeInsets.all(8),
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(color: AppColors.primaryColor),
                child: Card(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            height: 50,
                            width: 50,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: "${widget.serReq.productImageUrl}",
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.error_outline,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          subtitle: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text("SKU: ${widget.serReq.productSku}")),
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "${widget.serReq.productName}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
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
                                      widget.serReq.serviceRequestNumber
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    emptyVerticalBox(height: 5),
                                    Text(
                                      "${widget.serReq.created}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    emptyVerticalBox(height: 5),
                                    Text(
                                      "${widget.serReq.warrantyCode}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: GetBuilder<ServiceRequestsController>(builder: (controller) {
          TrackerResponse? trackerResponse = controller.trackerResponse;
          int? statusCode = trackerResponse?.statusCode ?? 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              emptyVerticalBox(height: 10),
              Visibility(
                visible: (statusCode == 0 &&
                        controller.trackerResponse?.trackingResOne?.events !=
                            null) ||
                    (statusCode == 3 &&
                        controller.trackerResponse?.trackingResThree?.data
                                ?.events !=
                            null),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Shipment Details",
                    style: headingStyle,
                  ),
                ),
              ),
              Visibility(
                visible: (statusCode == 0 &&
                        controller.trackerResponse?.trackingResOne?.events !=
                            null) ||
                    (statusCode == 3 &&
                        controller.trackerResponse?.trackingResThree?.data
                                ?.events !=
                            null),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(flex: 1, child: Text("Courier Name:")),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "${statusCode == 0 ? trackerResponse?.trackingResOne?.carrierName : trackerResponse?.trackingResThree?.data?.carrierName ?? 'Not Available'}",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      emptyVerticalBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(flex: 1, child: Text("AWB No:")),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "${statusCode == 0 ? trackerResponse?.trackingResOne?.awbNo : trackerResponse?.trackingResThree?.data?.awbNo ?? 'Not Available'}",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              emptyVerticalBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Current Status",
                  style: headingStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListTile(
                  leading: Icon(
                    Icons.pin_drop_rounded,
                    color: Colors.teal,
                    size: 40,
                  ),
                  title: Text(
                    "${controller.trackerResponse?.status}",
                  ),
                ),
              ),
              emptyVerticalBox(height: 10),
              Visibility(
                visible: (statusCode == 0 &&
                        controller.trackerResponse?.trackingResOne?.events !=
                            null) ||
                    (statusCode == 3 &&
                        controller.trackerResponse?.trackingResThree?.data
                                ?.events !=
                            null),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Tracking History",
                    style: headingStyle,
                  ),
                ),
              ),
              Visibility(
                visible: (statusCode == 0 &&
                        controller.trackerResponse?.trackingResOne?.events !=
                            null) ||
                    (statusCode == 3 &&
                        controller.trackerResponse?.trackingResThree?.data
                                ?.events !=
                            null),
                child: Expanded(
                  child: ListView.builder(
                      itemCount: statusCode == 0
                          ? trackerResponse?.trackingResOne?.events?.length
                          : trackerResponse
                              ?.trackingResThree?.data?.events?.length,
                      itemBuilder: (bc, index) {
                        var events;

                        statusCode == 0
                            ? events = trackerResponse?.trackingResOne?.events!
                                .toList()
                            : events = trackerResponse
                                ?.trackingResThree?.data?.events!
                                .toList();

                        // List<statusCode ==1 ? EventOne : EventThree>? events = statusCode == 3
                        //     ? trackerResponse?.trackingResThree?.data?.events!
                        //         .toList()
                        //     : trackerResponse?.trackingResOne?.events?.reversed
                        //         .toList();
                        return TimelineTile(
                          alignment: TimelineAlign.manual,
                          isFirst: index == 0,
                          isLast: index + 1 == events?.length,
                          indicatorStyle: IndicatorStyle(
                            iconStyle: IconStyle(
                                iconData: Icons.check, color: Colors.white),
                            width: 30,
                            color: doneColor,
                            padding: EdgeInsets.all(6),
                          ),
                          beforeLineStyle: LineStyle(
                            color: doneColor,
                          ),
                          afterLineStyle: LineStyle(
                            color: doneColor,
                          ),
                          lineXY: 0.1,
                          endChild: SizedBox(
                            height: 50,
                            child: ListTile(
                              title: Text("${events![index].remarks}"),
                              subtitle: Text(
                                  "${events[index].location} on ${events[index].time == null ? "" : formatDate(events[index].time)}"),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              emptyVerticalBox(),
              // Expanded(
              //   child: ListView(
              //     physics: BouncingScrollPhysics(),
              //     children: [
              //       TimelineTile(
              //         alignment: TimelineAlign.manual,
              //         lineXY: 0.1,
              //         indicatorStyle: IndicatorStyle(
              //           iconStyle: IconStyle(
              //               iconData:
              //                   determineIcon(target: 1, current: statusCode),
              //               color: Colors.white),
              //           width: 30,
              //           color: determineColor(target: 1, current: statusCode),
              //           padding: EdgeInsets.all(6),
              //         ),
              //         isFirst: true,
              //         afterLineStyle: LineStyle(
              //           color: determineColor(target: 1, current: statusCode),
              //         ),
              //         endChild: Container(
              //           height: 50,
              //           child: ListTile(
              //             title: Text("Picked Up"),
              //             subtitle: Text("Package has been picked up"),
              //           ),
              //         ),
              //       ),
              //       TimelineTile(
              //         alignment: TimelineAlign.manual,
              //         lineXY: 0.1,
              //         indicatorStyle: IndicatorStyle(
              //           iconStyle: IconStyle(
              //               iconData:
              //                   determineIcon(target: 2, current: statusCode),
              //               color: Colors.white),
              //           width: 30,
              //           color: statusCode >= 2 ? doneColor : pendingColor,
              //           padding: EdgeInsets.all(6),
              //         ),
              //         beforeLineStyle: LineStyle(
              //           color: determineColor(target: 2, current: statusCode),
              //         ),
              //         afterLineStyle: LineStyle(
              //           color: determineColor(target: 2, current: statusCode),
              //         ),
              //         endChild: ListTile(
              //           onTap: () {
              //             setState(() {
              //               isDetailed = !isDetailed;
              //             });
              //           },
              //           title: Text("In Transit"),
              //           subtitle: Text("Package is in transit"),
              //           trailing: Icon(Icons.expand),
              //         ),
              //       ),
              //       for (Event event in controller
              //               .trackerResponse?.tracking?.data?.events?.reversed
              //               .toList() ??
              //           []) ...[
              //         Visibility(
              //           visible: isDetailed,
              //           child: TimelineTile(
              //               alignment: TimelineAlign.manual,
              //               lineXY: 0.1,
              //               indicatorStyle: const IndicatorStyle(
              //                 width: 8,
              //                 color: Color(0xFF27AA69),
              //                 padding: EdgeInsets.all(6),
              //               ),
              //               beforeLineStyle: LineStyle(color: Colors.green),
              //               afterLineStyle: LineStyle(color: Colors.green),
              //               endChild: Row(
              //                 children: [
              //                   SizedBox(
              //                     width: 30,
              //                   ),
              //                   Expanded(
              //                     child: ListTile(
              //                       title: Text("${event.remarks}"),
              //                       subtitle: Text(
              //                           "${event.location} on ${helperFile.formatDate(event.time!)}"),
              //                     ),
              //                   )
              //                 ],
              //               )),
              //         ),
              //       ],
              //       TimelineTile(
              //         alignment: TimelineAlign.manual,
              //         lineXY: 0.1,
              //         indicatorStyle: IndicatorStyle(
              //           iconStyle: IconStyle(
              //               iconData:
              //                   determineIcon(target: 3, current: statusCode),
              //               color: Colors.white),
              //           width: 30,
              //           color: determineColor(target: 3, current: statusCode),
              //           padding: EdgeInsets.all(6),
              //         ),
              //         isLast: true,
              //         beforeLineStyle: LineStyle(
              //           color: determineColor(target: 3, current: statusCode),
              //         ),
              //         endChild: ListTile(
              //           title: Text("Delivered"),
              //           subtitle:
              //               Text("The product has been succedfully delivered"),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          );
        }),
      ),
    );
  }
}
