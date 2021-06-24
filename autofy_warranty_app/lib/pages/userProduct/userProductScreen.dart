import 'package:autofy_warranty_app/Model/userProductModelForHive.dart';
import 'package:autofy_warranty_app/controllers/apiController.dart';
import 'package:autofy_warranty_app/pages/userProduct/userProductListTile.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

class UserProducts extends StatefulWidget {
  @override
  _UserProductsState createState() => _UserProductsState();
}

class _UserProductsState extends State<UserProducts> {
  @override
  void initState() {
    EasyLoading.show(status: "Fetching Data...");
    ApiController apiController = ApiController();
    apiController.getUserProductData();
    EasyLoading.dismiss();
    super.initState();
  }

  final Box<UserProductModelForHive> userProductBox =
      Hive.box(BoxNames.userProductBoxName);

  @override
  Widget build(BuildContext context) {
    return userProductBox.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/lottie/empty_list.json",
                  height: 250,
                ),
                Text(
                  "Oops..",
                  style: TextStyle(color: Colors.grey, fontSize: 30),
                ),
                emptyVerticalBox(height: 10),
                Text(
                  "No products found",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                )
              ],
            ),
          )
        : ListView.builder(
            itemBuilder: (context, index) => BuildUserProductListTile(
              userProductModel: userProductBox.get(index)!,
            ),
            itemCount: userProductBox.length,
          );
  }
}
