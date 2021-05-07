import 'package:autofy_warranty_app/pages/forgotPassword/getChangePasswordScr.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ResetScrController extends GetxController {
  final PageController _pageController = PageController();
  final forgotEmailScrFormKey = GlobalKey<FormState>();
  final changePasswordFormKey = GlobalKey<FormState>();
  bool emailPage = true;
  PageController get pageController => this._pageController;

  void goToEnterPasswordPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
    emailPage = false;
    update();
  }
}
