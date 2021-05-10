import 'package:autofy_warranty_app/pages/forgotPassword/forgotPassword.dart';
import 'package:autofy_warranty_app/pages/signup/signupPage.dart';
import 'package:autofy_warranty_app/pages/widgets/btn.dart';
import 'package:autofy_warranty_app/pages/widgets/link.dart';
import 'package:autofy_warranty_app/pages/widgets/textField.dart';
import 'package:autofy_warranty_app/pages/widgets/wave.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _signInFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _signInFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30, left: 30, top: 75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello \nWelcome to \nAutofy',
                      style: TextStyle(
                        fontSize: AppTexts.primaryHeadingTextSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    emptyVerticalBox(height: 30),
                    GetTextField(
                      textFieldController: emailController,
                      lableText: "Email Address",
                      validatorFun: (email) {
                        if (email == "") {
                          return "Please Enter Email...";
                        } else if (!EmailValidator.validate(email!)) {
                          return "Please Enter Valid Email...";
                        }
                      },
                      hasShadow: true,
                      isPassword: false,
                    ),
                    emptyVerticalBox(height: 5),
                    GetTextField(
                      textFieldController: passwordController,
                      validatorFun: (password) {
                        if (password == "") {
                          return "Please Enter Password...";
                        } else if (!password!.length.isGreaterThan(7)) {
                          return "Password is too small atleast size 8 Charater";
                        }
                      },
                      lableText: "Password",
                      hasShadow: true,
                      isPassword: true,
                    ),
                    emptyVerticalBox(),
                    GetBtn(
                      onPressed: () {
                        if (_signInFormKey.currentState!.validate()) {
                          Get.snackbar("Success", "done");
                        }
                      },
                      btnText: "Sign In",
                    ),
                    emptyVerticalBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GetLink(
                          linkText: "Forget Your Password?",
                          onTapped: () => Get.to(
                            ResetPassword(),
                          ),
                        ),
                        GetLink(
                          linkText: "Sign Up",
                          onTapped: () => Get.to(
                            SignUpPage(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GetWave(),
            ],
          ),
        ),
      ),
    );
  }
}
