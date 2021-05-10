import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';

class GetTextField extends StatelessWidget {
  final TextEditingController textFieldController;
  final bool hasShadow, isPassword, isEnabled, isPassVisible, isEyeVisible;
  final String lableText;
  final VoidCallback? onPressed;
  final String? Function(String?) validatorFun;
  final TextInputType inputType;

  GetTextField({
    required this.textFieldController,
    required this.lableText,
    required this.validatorFun,
    this.hasShadow = false,
    this.isPassword = false,
    this.inputType = TextInputType.text,
    this.isEnabled = true,
    this.isPassVisible = false,
    this.isEyeVisible = false,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: inputType == TextInputType.phone ? 85 : 70,
      child: Card(
        elevation: hasShadow ? 10 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.commonRadius),
        ),
        shadowColor: Colors.white70,
        child: Center(
          child: ListTile(
            title: TextFormField(
              controller: textFieldController,
              validator: validatorFun,
              decoration: InputDecoration(
                hintText: lableText,
                border: InputBorder.none,
                enabled: isEnabled,
                hintStyle: TextStyle(
                  fontSize: AppTexts.inputFieldTextSize,
                ),
              ),
              keyboardType: inputType,
              cursorColor: AppColors.primaryColor,
              obscureText: isPassword,
              maxLength: inputType == TextInputType.phone ? 10 : null,
            ),
            trailing: (isPassword || isPassVisible) && isEyeVisible
                ? isPassVisible
                    ? IconButton(
                        icon: Icon(Icons.visibility_off),
                        onPressed: onPressed,
                        color: AppColors.primaryColor,
                      )
                    : IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: onPressed,
                        color: AppColors.primaryColor,
                      )
                : null,
          ),
        ),
      ),
    );
  }
}
