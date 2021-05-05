import 'dart:ui';

import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import '../widgets/btn.dart';
import '../widgets/link.dart';
import '../widgets/textField.dart';
import '../widgets/textField.dart';
import '../widgets/wave.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String name = "";
  String email = "";
  String password = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GetTextField buildTextField(
    TextEditingController textEditingController, {
    String labelText = "",
  }) {
    return GetTextField(
        textFieldController: textEditingController, lableText: labelText);
  }

  submitButton() {
    return GetBtn(btnText: "SignUp", onPressed: () {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(248, 248, 248, 1),
        body: Column(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                  ),
                  Text(
                    "AUTOFY",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: AppTexts.primaryHeadingTextSize),
                  ),
                  emptyVerticalBox(height: 50),
                  buildTextField(
                    nameController,
                    labelText: "Name",
                  ),
                  emptyVerticalBox(),
                  buildTextField(
                    emailController,
                    labelText: "Email Address",
                  ),
                  emptyVerticalBox(),
                  buildTextField(
                    passwordController,
                    labelText: "Password",
                  ),
                  emptyVerticalBox(),
                  submitButton(),
                  emptyVerticalBox(),
                  Center(
                      child: GetLink(
                    linkText: "Already Have An Account? Sign In",
                    onTapped: () {},
                  )),
                ],
              ),
            ),
            Spacer(),
            GetWave(),
          ],
        ),
      ),
    );
  }
}
