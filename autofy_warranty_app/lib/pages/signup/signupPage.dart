import 'dart:ui';
import 'package:autofy_warranty_app/controllers/authController.dart';
import 'package:autofy_warranty_app/pages/signIn/signInPage.dart';
import 'package:autofy_warranty_app/services/localStorageService.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/btn.dart';
import '../widgets/link.dart';
import '../widgets/textField.dart';
import '../widgets/wave.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  AuthController authController = Get.find<AuthController>();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  bool isRegistering = false;

  // Image logo = Image.asset(
  //   'assets/images/autofy_logo.png',
  //   width: 150,
  // );

  Text buildSignUpText() => Text(
        "Sign Up",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
            fontSize: AppTexts.primaryHeadingTextSize),
      );

  GetTextField buildNameField() {
    return GetTextField(
      hasShadow: true,
      textFieldController: nameController,
      lableText: "Name",
      validatorFun: (value) {
        if (value == null) {
          return "Name can't be empty";
        }
        if (value == "") {
          return "Name can't be empty";
        }
        if (value.length > 0) {
          return null;
        }
      },
    );
  }

  GetTextField buildEmailField() {
    return GetTextField(
      hasShadow: true,
      textFieldController: emailController,
      lableText: "Email",
      validatorFun: (value) {
        if (value == null) {
          return "The Email can't be empty";
        }
        if (GetUtils.isEmail(value)) {
          return null;
        }
        return "Enter a valid email";
      },
    );
  }

  GetTextField buildPhoneNumField() {
    return GetTextField(
      hasShadow: true,
      textFieldController: phoneController,
      lableText: "Phone Number",
      validatorFun: (value) {
        if (value == null) {
          return "The Phone Number can't be empty";
        }
        if ((!value.isNumericOnly) || (value.length != 10)) {
          return "Enter a valid phone number";
        }
        return null;
      },
    );
  }

  GetTextField buildPasswordField() {
    return GetTextField(
      isPassword: true,
      hasShadow: true,
      textFieldController: passwordController,
      lableText: "Password",
      validatorFun: (value) {
        if (value == null) {
          return "The Password can't be empty";
        }
        if (value.length > 6) {
          return null;
        }
        return "Password should be atleast 6 digits long";
      },
    );
  }

  GetBtn buildSubmitButton() {
    return GetBtn(
        btnText: isRegistering ? "Please Wait..." : "SignUp",
        onPressed: () async {
          if (isRegistering) return;
          if (_formKey.currentState!.validate()) {
            setState(() {
              isRegistering = true;
            });
            final AuthController authController = AuthController();
            await authController.registerUser({
              "email": emailController.text.trim(),
              "name": nameController.text.trim(),
              "password": passwordController.text.trim(),
              "phone": phoneController.text.trim(),
            });
            setState(() {
              isRegistering = false;
            });
          }
        });
  }

  Center signInLink = Center(
    child: GetLink(
      linkText: "Already Have An Account? Sign In",
      onTapped: () => Get.to(SignInPage()),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(248, 248, 248, 1),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  emptyVerticalBox(height: 100),
                  buildSignUpText(),
                  emptyVerticalBox(height: 40),
                  buildNameField(),
                  emptyVerticalBox(height: 15),
                  buildEmailField(),
                  emptyVerticalBox(height: 15),
                  buildPhoneNumField(),
                  emptyVerticalBox(height: 15),
                  buildPasswordField(),
                  emptyVerticalBox(),
                  buildSubmitButton(),
                  emptyVerticalBox(),
                  signInLink,
                  emptyVerticalBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
