import 'package:get/get.dart';

class HomePageController extends GetxController {
  var bottomNavigationBarIndex = 0.obs;
  var appBarTitle = "Your Products".obs;

  void changePage(int val) {
    bottomNavigationBarIndex.value = val;
    if (bottomNavigationBarIndex.value == 0) {
      appBarTitle.value = "Your Products";
    } else if (bottomNavigationBarIndex.value == 1) {
      appBarTitle.value = "Repair Request";
    } else if (bottomNavigationBarIndex.value == 2) {
      appBarTitle.value = "Register Warranty";
    } else if (bottomNavigationBarIndex.value == 3) {
      appBarTitle.value = "Your Profile";
    }
  }
}
