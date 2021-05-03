import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:autofy_warranty_app/pages/homepageController.dart';
import 'package:autofy_warranty_app/utils/constants.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<HomePageController>(
      init: HomePageController(),
      builder: (val) => Center(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Autofy"),
          ),
          body: Center(
            child: Text(
              '${val.counter.value}',
              style: TextStyle(
                fontSize: AppTexts.primaryHeadingTextSize,
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => val.increment(),
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
