import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userBox = Hive.box('userData');
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("HOMEPAGE ${userBox.get("token")}"),
        ),
      ),
    );
  }
}
