import 'package:autofy_warranty_app/controllers/authController.dart';
import 'package:autofy_warranty_app/pages/signup/signupPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
      title: 'Autofy',
      home: GetDesign(),
      builder: EasyLoading.init(),
    );
  }
}

class GetDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignUpPage();
  }
}
