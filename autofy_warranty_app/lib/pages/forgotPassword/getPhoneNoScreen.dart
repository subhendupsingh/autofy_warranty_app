import 'package:autofy_warranty_app/pages/forgotPassword/forgotScrController.dart';
import 'package:autofy_warranty_app/pages/widgets/textField.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordPhoneNoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: RangeMaintainingScrollPhysics(),
      children: [
        Column(
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
              "Enter the mobile number associated with your account and we'll verify and give you privilege to change password.",
              style: TextStyle(
                color: AppColors.greyTextColor,
                fontSize: AppTexts.inputFieldTextSize,
              ),
            ),
            emptyVerticalBox(height: 50),
            GetBuilder<ResetScrController>(
              init: ResetScrController(),
              builder: (val) => Form(
                key: val.forgotPhoneNoScrFormKey,
                child: GetTextField(
                  textFieldController: val.forgotPasswordPhoneNoController,
                  lableText: "Mobile No",
                  isEnabled: val.isLoading ? false : true,
                  validatorFun: (mobileNo) {
                    if (mobileNo == "") {
                      return "Please Enter phone number...";
                    } else if (mobileNo!.length != 10) {
                      return "Please enter valid mobile no.";
                    }
                  },
                  hasShadow: true,
                  isPassword: false,
                  inputType: TextInputType.phone,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
