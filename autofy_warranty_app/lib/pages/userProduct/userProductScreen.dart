import 'package:autofy_warranty_app/Model/userProductModelForHive.dart';
import 'package:autofy_warranty_app/controllers/apiController.dart';
import 'package:autofy_warranty_app/pages/userProduct/userProductListTile.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

class UserProducts extends StatefulWidget {
  @override
  _UserProductsState createState() => _UserProductsState();
}

class _UserProductsState extends State<UserProducts> {
  ApiController apiController = ApiController();

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
        : FutureBuilder(
            future: apiController.getUserProductData(isShow: true),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              return ListView.builder(
                itemBuilder: (context, index) => BuildUserProductListTile(
                  userProductModel: userProductBox.get(index)!,
                ),
                itemCount: userProductBox.length,
              );
            });
  }
}
