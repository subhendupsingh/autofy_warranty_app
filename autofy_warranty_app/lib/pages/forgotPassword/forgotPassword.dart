import 'package:autofy_warranty_app/pages/forgotPassword/forgotScrController.dart';
import 'package:autofy_warranty_app/pages/forgotPassword/getChangePasswordScr.dart';
import 'package:autofy_warranty_app/pages/forgotPassword/getEmailScreen.dart';
import 'package:autofy_warranty_app/pages/signIn/signinPage.dart';
import 'package:autofy_warranty_app/pages/widgets/backBtn.dart';
import 'package:autofy_warranty_app/pages/widgets/btn.dart';
import 'package:autofy_warranty_app/pages/widgets/wave.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<ResetScrController>(
          init: ResetScrController(),
          builder: (val) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GetBackBtn(onPressed: () => Get.offAll(SignInPage())),
                Expanded(
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    allowImplicitScrolling: true,
                    physics: NeverScrollableScrollPhysics(),
                    controller: val.pageController,
                    children: [
                      ForgotPasswordEmailScreen(),
                      ChangePasswordScreen()
                    ],
                  ),
                ),
                GetBtn(
                  btnText: val.emailPage ? "Verify Email" : "Reset Password",
                  onPressed: () {
                    if (val.emailPage) {
                      if (!val.forgotEmailScrFormKey.currentState!.validate() &&
                          val.emailPage) {
                        Get.snackbar(
                          "Email Error",
                          "Please check your email",
                        );
                      } else if (val.forgotEmailScrFormKey.currentState!
                              .validate() &&
                          val.emailPage) {
                        val.goToEnterPasswordPage();
                      }
                    } else {
                      if (!val.changePasswordFormKey.currentState!.validate()) {
                        Get.snackbar(
                          "Password Error",
                          "Please check both password",
                        );
                      } else {
                        Get.snackbar(
                          "Password Change",
                          "Your password request served successfully",
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
