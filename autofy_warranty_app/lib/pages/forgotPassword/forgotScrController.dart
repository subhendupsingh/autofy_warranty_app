import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetScrController extends GetxController {
  final PageController _pageController = PageController();
  final forgotPhoneNoScrFormKey = GlobalKey<FormState>();
  final changePasswordFormKey = GlobalKey<FormState>();
  final otpScreenFormKey = GlobalKey<FormState>();
  final TextEditingController forgotPasswordPhoneNoController =
      TextEditingController();
  String otpByUser = "";
  int start = 5;
  bool _isLoading = false;
  String pageFinder = "phoneNoScreen", passwordForReset = "";
  PageController get pageController => this._pageController;
  bool get isLoading => this._isLoading;

  void updateIsLoading() {
    _isLoading = !_isLoading;
    update();
  }

  void goToNextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
    if (pageFinder == "phoneNoScreen") {
      pageFinder = "otpScreen";
    } else if (pageFinder == "otpScreen") {
      pageFinder = "resetPasswordScreen";
    }
    update();
  }

  void goTopreviousPage() {
    if (pageFinder == "otpScreen") {
      pageFinder = "phoneNoScreen";
      _pageController.previousPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    } else if (pageFinder == "resetPasswordScreen") {
      pageFinder = "phoneNoScreen";
      _pageController.animateToPage(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
    update();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          timer.cancel();
        } else {
          start--;
        }
        update();
      },
    );
  }
}
