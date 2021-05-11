import 'package:autofy_warranty_app/pages/forgotPassword/forgotScrController.dart';
import 'package:autofy_warranty_app/pages/widgets/link.dart';
import 'package:autofy_warranty_app/services/resetPasswordService.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  final TextEditingController otpFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetScrController>(
      builder: (val) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          emptyVerticalBox(height: 30),
          Text(
            "Enter OTP",
            style: TextStyle(
              fontSize: AppTexts.secondaryHeadingTextSize,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          emptyVerticalBox(height: 10),
          Text(
            "Enter the OTP, You received on your register mobile no.",
            style: TextStyle(
              color: AppColors.greyTextColor,
              fontSize: AppTexts.inputFieldTextSize,
            ),
          ),
          emptyVerticalBox(height: 50),
          Form(
            key: val.otpScreenFormKey,
            child: PinCodeTextField(
              appContext: context,
              length: 6,
              onChanged: (otp) {
                otpFieldController.text = otp;
                val.otpByUser = otp;
                print(val.otpByUser);
              },
              controller: otpFieldController,
              validator: (otp) {
                if (otp!.length != 6) {
                  return "Please enter OTP";
                }
              },
              obscureText: false,
              blinkWhenObscuring: true,
              keyboardType: TextInputType.number,
              animationType: AnimationType.scale,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.circle,
              ),
            ),
          ),
          Row(
            children: [
              GetLink(
                linkText: "Resend OTP",
                onTapped: () async {
                  if (val.start == 0) {
                    // Resend OTP
                    val.updateIsLoading();
                    final userData = Hive.box('UserData');
                    String res = await ResetPasswordService.sendOtp(
                      phoneNo: userData.get("phoneNoForResetPassword"),
                    );
                    val.updateIsLoading();
                    if (res == "OTP Send Successfully") {
                      val.start = 180;
                      Get.snackbar(
                        "OTP successfully send",
                        "Please enter new OTP.",
                      );
                      val.startTimer();
                    } else {
                      Get.snackbar("OTP ERROR", res);
                    }
                  }
                },
              ),
              GetLink(
                linkText: val.start == 0 ? "" : " in ${val.start}",
                onTapped: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
