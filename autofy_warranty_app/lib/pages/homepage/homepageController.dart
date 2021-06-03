import 'package:get/get.dart';

class HomePageController extends GetxController {
  var bottomNavigationBarIndex = 0.obs;
  var appBarTitle = "Your Products".obs;

  static HomePageController get to => Get.find<HomePageController>();

  set setIndex(passedIndex) => bottomNavigationBarIndex.value = passedIndex;

  void changePage(int val) {
    // print("HEy: KUNJ" + val.toString());
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
