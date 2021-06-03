import 'package:autofy_warranty_app/controllers/apiController.dart';
import 'package:autofy_warranty_app/controllers/authController.dart';
import 'package:autofy_warranty_app/pages/forgotPassword/forgotPassword.dart';
import 'package:autofy_warranty_app/pages/homepage/homepageScreen.dart';
import 'package:autofy_warranty_app/pages/signIn/signInController.dart';
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

  SignInPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _signInFormKey,
          child: GetBuilder<SignInController>(
            init: SignInController(),
            builder: (val) => Column(
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
                      emptyVerticalBox(height: 50),
                      GetTextField(
                        textFieldController: emailController,
                        lableText: "Email Address",
                        isEnabled: val.isLoading ? false : true,
                        validatorFun: (email) {
                          if (email == "") {
                            return "Please Enter Email...";
                          } else if (!EmailValidator.validate(email!)) {
                            return "Please Enter Valid Email...";
                          }
                        },
                        hasShadow: true,
                        isPassword: false,
                        inputType: TextInputType.emailAddress,
                      ),
                      emptyVerticalBox(height: 5),
                      GetTextField(
                        textFieldController: passwordController,
                        isEnabled: val.isLoading ? false : true,
                        validatorFun: (password) {
                          if (password == "") {
                            return "Please Enter Password...";
                          } else if (!password!.length.isGreaterThan(3)) {
                            return "Password is too small atleast size 8 Charater";
                          }
                        },
                        lableText: "Password",
                        hasShadow: true,
                        isPassword: val.isVisible ? false : true,
                        onPressed: () => val.updateVisible(),
                        isPassVisible: val.isVisible,
                        isEyeVisible: true,
                      ),
                      emptyVerticalBox(),
                      GetBtn(
                        onPressed: val.isLoading
                            ? () {}
                            : () async {
                                if (_signInFormKey.currentState!.validate()) {
                                  ApiController apiController = ApiController();
                                  val.updateLoading();
                                  String res =
                                      await apiController.authenticateUser(
                                    email: emailController.text.toLowerCase(),
                                    password: passwordController.text,
                                  );
                                  val.updateLoading();
                                  if (res == "SuccessFully Logged in") {
                                    Get.snackbar("$res", "Thank you");
                                    AuthController.to.getAuthenticationStatus();
                                  } else if (res == "Something want wrong" ||
                                      res == "Internal server error") {
                                    Get.snackbar(
                                      "$res",
                                      "Please try after sometime.",
                                    );
                                  } else {
                                    Get.snackbar("$res", "Thank you");
                                  }
                                }
                              },
                        btnText: val.isLoading ? "Loading..." : "Sign In",
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
      ),
    );
  }
}
