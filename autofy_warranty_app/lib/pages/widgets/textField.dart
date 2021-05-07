import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';

class GetTextField extends StatelessWidget {
  final TextEditingController textFieldController;
  final bool hasShadow, isPassword;
  final String lableText;
  String? Function(String?) validatorFun;
  GetTextField({
    required this.textFieldController,
    required this.lableText,
    required this.validatorFun,
    this.hasShadow = false,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Card(
        elevation: hasShadow ? 10 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.commonRadius),
        ),
        shadowColor: Colors.white70,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: textFieldController,
              validator: validatorFun,
              decoration: InputDecoration(
                hintText: lableText,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: AppTexts.inputFieldTextSize,
                ),
              ),
              cursorColor: AppColors.primaryColor,
              obscureText: isPassword,
            ),
          ),
        ),
      ),
    );
  }
}
