import 'package:autofy_warranty_app/pages/forgotPassword/forgotScrController.dart';
import 'package:autofy_warranty_app/pages/widgets/textField.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordEmailScreen extends StatelessWidget {
  final TextEditingController forgotPasswordEmailController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        emptyVerticalBox(height: 30),
        Text(
          "Reset Password",
          style: TextStyle(
            fontSize: AppTexts.secondaryHeadingTextSize,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        emptyVerticalBox(height: 10),
        Text(
          "Enter the email associated with your account\nand we'll verify and give you privilege to\nchange password.",
          style: TextStyle(
            color: AppColors.greyTextColor,
            fontSize: AppTexts.inputFieldTextSize,
          ),
        ),
        emptyVerticalBox(height: 50),
        GetBuilder<ResetScrController>(
          init: ResetScrController(),
          builder: (val) => Form(
            key: val.forgotEmailScrFormKey,
            child: GetTextField(
              textFieldController: forgotPasswordEmailController,
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
          ),
        ),
      ],
    );
  }
}
