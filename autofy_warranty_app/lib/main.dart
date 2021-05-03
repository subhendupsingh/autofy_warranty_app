import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:autofy_warranty_app/pages/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Autofy',
      home: Scaffold(body: HomePage()),
    );
  }
}
