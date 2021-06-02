import 'package:autofy_warranty_app/pages/homepage/homepageController.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetBottomNaviGationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<HomePageController>(
      builder: (controller) => BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: AppColors.primaryColor,
        currentIndex: controller.bottomNavigationBarIndex.value,
        onTap: (value) => controller.changePage(value),
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
      ),
    );
  }
}
