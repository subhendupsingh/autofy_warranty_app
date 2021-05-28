import 'package:autofy_warranty_app/pages/forgotPassword/forgotScrController.dart';
import 'package:autofy_warranty_app/pages/forgotPassword/getChangePasswordScr.dart';
import 'package:autofy_warranty_app/pages/forgotPassword/getPhoneNoScreen.dart';
import 'package:autofy_warranty_app/pages/forgotPassword/otpScreen.dart';
import 'package:autofy_warranty_app/pages/signIn/signInPage.dart';
import 'package:autofy_warranty_app/pages/widgets/backBtn.dart';
import 'package:autofy_warranty_app/pages/widgets/btn.dart';
import 'package:autofy_warranty_app/services/resetPasswordService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ResetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<ResetScrController>(
          init: ResetScrController(),
          builder: (val) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GetBackBtn(
                    onPressed: () {
                      if (val.pageFinder == "phoneNoScreen")
                        Get.offAll(SignInPage());
                      else {
                        val.goTopreviousPage();
                      }
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 160,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      allowImplicitScrolling: true,
                      physics: NeverScrollableScrollPhysics(),
                      controller: val.pageController,
                      children: [
                        ForgotPasswordPhoneNoScreen(),
                        OtpScreen(),
                        ChangePasswordScreen()
                      ],
                    ),
                  ),
                  GetBtn(
                    btnText: val.isLoading
                        ? "Loading..."
                        : getBtnText(val.pageFinder),
                    onPressed: val.isLoading
                        ? () {}
                        : () async {
                            final userData = Hive.box('UserData');
                            if (val.pageFinder == "phoneNoScreen") {
                              FocusScope.of(context).unfocus();
                              if (!val.forgotPhoneNoScrFormKey.currentState!
                                  .validate()) {
                                Get.snackbar(
                                  "Phone number Error",
                                  "Please check your phone number",
                                );
                              } else if (val
                                  .forgotPhoneNoScrFormKey.currentState!
                                  .validate()) {
                                val.updateIsLoading();
                                String res = await ResetPasswordService.sendOtp(
                                  phoneNo:
                                      val.forgotPasswordPhoneNoController.text,
                                );
                                val.updateIsLoading();
                                if (res == "OTP Send Successfully") {
                                  val.goToNextPage();
                                  val.startTimer();
                                } else {
                                  Get.snackbar("OTP ERROR", res);
                                }
                              }
                            } else if (val.pageFinder == "otpScreen") {
                              FocusScope.of(context).unfocus();
                              if (!val.otpScreenFormKey.currentState!
                                  .validate()) {
                                Get.snackbar(
                                  "OTP Error",
                                  "Please Enter OTP",
                                );
                              } else {
                                val.updateIsLoading();
                                print(userData
                                    .get("userIdForResetPassword")
                                    .toString());
                                String res =
                                    await ResetPasswordService.authenticateOtp(
                                  userId: userData
                                      .get("userIdForResetPassword")
                                      .toString(),
                                  otp: val.otpByUser,
                                );
                                val.updateIsLoading();
                                if (res == "You are verified") {
                                  val.goToNextPage();
                                } else {
                                  Get.snackbar("OTP Error", res);
                                }
                              }
                            } else if (val.pageFinder ==
                                "resetPasswordScreen") {
                              if (!val.changePasswordFormKey.currentState!
                                  .validate()) {
                                Get.snackbar(
                                  "Password Error",
                                  "Please check both password",
                                );
                              } else {
                                val.updateIsLoading();
                                print(val.passwordForReset);
                                await ResetPasswordService.resetPasswordService(
                                  userId: userData
                                      .get('userIdForResetPassword')
                                      .toString(),
                                  password: val.passwordForReset,
                                );
                                Get.snackbar(
                                  "Password Change",
                                  "Your password request served successfully",
                                );
                                Future.delayed(
                                  Duration(
                                    seconds: 4,
                                  ),
                                  () {
                                    val.updateIsLoading();
                                    Get.offAll(
                                      () => SignInPage(),
                                    );
                                  },
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
      ),
    );
  }

  String getBtnText(String pageFinder) {
    if (pageFinder == "phoneNoScreen") {
      return "Send OTP";
    } else if (pageFinder == "otpScreen") {
      return "Verify OTP";
    } else {
      return "Change Password";
    }
  }
}
