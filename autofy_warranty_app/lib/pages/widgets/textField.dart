import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';

class GetTextField extends StatelessWidget {
  final TextEditingController textFieldController;
  final bool hasShadow, isPassword;
  final String lableText;
  GetTextField({
    required this.textFieldController,
    required this.lableText,
    this.hasShadow = false,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Card(
        elevation: hasShadow ? 10 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.commonRadius),
        ),
        shadowColor: Colors.white70,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: TextFormField(
            controller: textFieldController,
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
    );
  }
}
