import 'package:autofy_warranty_app/controllers/authController.dart';

import 'package:autofy_warranty_app/pages/profile/profile.dart';
import 'package:autofy_warranty_app/pages/serviceRequests/serviceRequestsScreen.dart';
import 'package:autofy_warranty_app/pages/uploadInvoice/uploadInvoiceScreen.dart';
import 'package:autofy_warranty_app/pages/userProduct/userProductScreen.dart';
import 'package:autofy_warranty_app/pages/web_view.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class HomePage extends StatefulWidget {
  int startingIndex;
  HomePage({Key? key, required this.startingIndex}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    _currentIndex = widget.startingIndex;
    initOneSignal();
  }

  initOneSignal() {
    //Remove this method to stop OneSignal Debugging
    // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setLogLevel(OSLogLevel.error, OSLogLevel.none);

    OneSignal.shared.setAppId("45bf8716-87ec-43a1-9aed-dbb6f8cba67b");

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print(
          "Notif received while in foreground==========================================================>");
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print(
          "App Opened by clicking on notif==============================================================>");
      print(result.notification.additionalData);
      result.notification.additionalData?.forEach((key, value) {
        if (key == "initialUrl") {
          Get.to(() => WebView(
                initialUrl: value,
              ));
        }
      });

      // Will be called whenever a notification is opened/button pressed.
    });
  }

  int _currentIndex = 0;
  final List<Widget> listOfScreens = [
    UserProducts(),
    ServiceRequestsScreen(),
    RegisterWarranty(),
    ProfileSreen()
  ];

  final List<String> appBarTitles = [
    "Your Products",
    "Repair Request",
    "Register Warranty",
    "Your Profile",
  ];

  buildAppBar() {
    return AppBar(
      title: Text(appBarTitles[_currentIndex]),
      actions: _currentIndex == 3
          ? [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  Get.defaultDialog(
                    title: "\nAlert",
                    content: Column(
                      children: [
                        Text("Are you sure you want to logout?"),
                        ButtonBar(
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                AuthController.to.logOut();
                              },
                              child: Text("Logout"),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ]
          : [],
      backgroundColor: AppColors.primaryColor,
      centerTitle: true,
    );
  }

  buildBottomBar() {
    return BottomNavigationBar(
      unselectedItemColor: Colors.grey,
      selectedItemColor: AppColors.primaryColor,
      showUnselectedLabels: true,
      currentIndex: _currentIndex,
      onTap: (value) {
        setState(() {
          _currentIndex = value;
        });
      },
      items: [
        BottomNavigationBarItem(
          label: "Products",
          icon: Icon(
            Icons.list,
          ),
        ),
        BottomNavigationBarItem(
          label: "Repair Request",
          icon: Icon(
            Icons.handyman_outlined,
          ),
        ),
        BottomNavigationBarItem(
          label: "Register Warranty",
          icon: Icon(
            Icons.library_add_rounded,
          ),
        ),
        BottomNavigationBarItem(
          label: "Profile",
          icon: Icon(
            Icons.person,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: _currentIndex == 1 ? null : buildAppBar(),
        body: listOfScreens[_currentIndex],
        bottomNavigationBar: buildBottomBar(),
      ),
    );
  }
}
