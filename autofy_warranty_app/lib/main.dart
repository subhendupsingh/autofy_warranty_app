import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'pages/signIn/signInPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Autofy',
      home: GetDesign(),
    );
  }
}

class GetDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInPage();
  }
}
