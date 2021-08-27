import 'package:autofy_warranty_app/controllers/authController.dart';
import 'package:autofy_warranty_app/pages/profile/profileScreen.dart';
import 'package:autofy_warranty_app/pages/serviceRequests/serviceRequestsScreen.dart';
import 'package:autofy_warranty_app/pages/uploadInvoice/uploadInvoiceScreen.dart';
import 'package:autofy_warranty_app/pages/userProduct/userProductScreen.dart';
import 'package:autofy_warranty_app/pages/web_view.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class HomePage extends StatefulWidget {
  final int startingIndex;

  HomePage({
    Key? key,
    required this.startingIndex,
  }) : super(key: key);

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
    // WidgetsBinding.instance?.addPostFrameCallback((_) => initOneSignal());
  }

  initOneSignal() {
    //Remove this method to stop OneSignal Debugging
    // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setLogLevel(OSLogLevel.error, OSLogLevel.none);

    OneSignal.shared.setAppId("0438ea5d-d977-4958-ba37-1a42457da637");

    // OneSignal.shared.setNotificationWillShowInForegroundHandler(
    //     (OSNotificationReceivedEvent event) {
    //   // Will be called whenever a notification is received in foreground
    //   // Display Notification, pass null param for not displaying the notification
    //   event.complete(event.notification);
    // });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print(result.notification.additionalData);
      result.notification.additionalData?.forEach((key, value) {
        if (key == "link") {
          Get.offAll(WebView(initialUrl: value));
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/autofywhite.png",
            width: 40,
            height: 40,
          ),
          Text(appBarTitles[_currentIndex]),
          Text("          "),
        ],
      ),
      backgroundColor: AppColors.primaryColor,
      centerTitle: true,
      actions: _currentIndex == 3
          ? [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: InkWell(
                    onTap: () {
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
                                  child: Text(
                                    "Logout",
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ]
          : [],
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
    // print("+++++++++++++++++++++++++++++++++build ran");
    // if (initialUrl != "") return WebView(initialUrl: initialUrl);

    return Scaffold(
      key: scaffoldKey,
      appBar: _currentIndex == 1 ? null : buildAppBar(),
      body: listOfScreens[_currentIndex],
      bottomNavigationBar: buildBottomBar(),
    );
  }
}
