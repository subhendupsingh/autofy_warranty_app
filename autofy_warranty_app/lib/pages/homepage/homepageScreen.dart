import 'package:autofy_warranty_app/controllers/authController.dart';
import 'package:autofy_warranty_app/pages/homepage/bottomNavigationBar.dart';
import 'package:autofy_warranty_app/pages/homepage/homepageController.dart';
import 'package:autofy_warranty_app/pages/profile/profile.dart';
import 'package:autofy_warranty_app/pages/serviceRequests/serviceRequestsScreen.dart';
import 'package:autofy_warranty_app/pages/uploadInvoice/uploadInvoiceScreen.dart';
import 'package:autofy_warranty_app/pages/userProduct/userProductScreen.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<HomePageController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(controller.appBarTitle.value),
          actions: controller.bottomNavigationBarIndex.value == 3
              ? [
                  IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        AuthController.to.logOut();
                      }),
                ]
              : [],
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
        ),
        body: selectPage(controller),
        bottomNavigationBar: GetBottomNaviGationBar(),
      ),
    );
  }

  Widget selectPage(HomePageController controller) {
    if (controller.bottomNavigationBarIndex.value == 0) {
      return UserProducts();
    } else if (controller.bottomNavigationBarIndex.value == 1) {
      return ServiceRequestsScreen();
    } else if (controller.bottomNavigationBarIndex.value == 2) {
      return RegisterWarranty();
    } else if (controller.bottomNavigationBarIndex.value == 3) {
      return ProfileSreen();
    }
    return Container();
  }
}
