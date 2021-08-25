import 'package:autofy_warranty_app/controllers/apiController.dart';
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
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _signInFormKey,
          child: GetBuilder<SignInController>(
            init: SignInController(),
            builder: (val) => SingleChildScrollView(
              child: Container(
                width: Get.width,
                height: Get.height - 28,
                child: Stack(
                  children: [
                    GetWave(),
                    Positioned(
                      right: 30,
                      left: 30,
                      top: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/autofy.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          emptyVerticalBox(height: 40),
                          Text(
                            'Welcome to \nAutofy',
                            style: TextStyle(
                              fontSize: AppTexts.primaryHeadingTextSize,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          emptyVerticalBox(),
                          GetTextField(
                            textFieldController: emailController,
                            lableText: "Email / Phone Number",
                            isEnabled: val.isLoading ? false : true,
                            validatorFun: (email) {
                              if (email!.trim() == "") {
                                return "Please Enter Email/Phone Number...";
                              } else if (!EmailValidator.validate(email) &&
                                  email.length < 10) {
                                return "Invalid Email/Phone Number";
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
                                return "Password should be Atleast 6 Chars";
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
                                    if (_signInFormKey.currentState!
                                        .validate()) {
                                      ApiController apiController =
                                          ApiController();
                                      val.updateLoading();
                                      String res =
                                          await apiController.authenticateUser(
                                        email:
                                            emailController.text.toLowerCase(),
                                        password: passwordController.text,
                                      );
                                      val.updateLoading();
                                      if (res == "SuccessFully Logged in") {
                                        Get.snackbar("$res", "Thank you");
                                        Get.offAll(HomePage(
                                          startingIndex: 0,
                                        ));
                                      } else if (res ==
                                              "Something want wrong" ||
                                          res == "Internal server error") {
                                        Get.snackbar(
                                          "$res",
                                          "Please try after sometime.",
                                        );
                                      } else {
                                        Get.snackbar("$res", "");
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
                                  linkText: "Forgot Password?",
                                  onTapped: () {
                                    print("CALL");
                                    Get.to(
                                      ResetPassword(),
                                    );
                                  }),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
