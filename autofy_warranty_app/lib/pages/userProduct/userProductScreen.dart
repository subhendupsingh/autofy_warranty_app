import 'package:autofy_warranty_app/Model/userProductModelForHive.dart';
import 'package:autofy_warranty_app/pages/userProduct/userProductListTile.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserProducts extends StatelessWidget {
  final Box<UserProductModelForHive> userProductBox =
      Hive.box(BoxNames.userProductBoxName);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => BuildUserProductListTile(
        userProductModel: userProductBox.get(index)!,
      ),
      itemCount: userProductBox.length,
    );
  }
}
