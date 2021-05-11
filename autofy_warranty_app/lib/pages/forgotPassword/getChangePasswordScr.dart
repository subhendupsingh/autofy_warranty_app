import 'package:autofy_warranty_app/pages/forgotPassword/forgotScrController.dart';
import 'package:autofy_warranty_app/pages/widgets/textField.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetScrController>(
      init: ResetScrController(),
      builder: (val) => Form(
        key: val.changePasswordFormKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: RangeMaintainingScrollPhysics(),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                emptyVerticalBox(height: 30),
                Text(
                  "Create New Password",
                  style: TextStyle(
                    fontSize: AppTexts.secondaryHeadingTextSize,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                emptyVerticalBox(height: 10),
                Text(
                  "Your new password must be different\nfrom previouse used password.",
                  style: TextStyle(
                    color: AppColors.greyTextColor,
                    fontSize: AppTexts.inputFieldTextSize,
                  ),
                ),
                emptyVerticalBox(height: 50),
                GetTextField(
                  textFieldController: passwordController,
                  lableText: "Password",
                  validatorFun: (password) {
                    if (password == "") {
                      return "Please Enter Password...";
                    } else if (!password!.length.isGreaterThan(7)) {
                      return "Password is too small atleast size 8 Charater";
                    }
                  },
                  hasShadow: true,
                  isPassword: true,
                  isEnabled: val.isLoading ? false : true,
                  inputType: TextInputType.text,
                ),
                GetTextField(
                  textFieldController: confirmPasswordController,
                  lableText: "Confirm Password",
                  validatorFun: (password) {
                    if (password == "") {
                      return "Please Enter Password...";
                    } else if (passwordController.text !=
                        confirmPasswordController.text) {
                      return "Both password must be same.";
                    }
                    val.passwordForReset = password.toString();
                  },
                  hasShadow: true,
                  isPassword: true,
                  isEnabled: val.isLoading ? false : true,
                  inputType: TextInputType.text,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
