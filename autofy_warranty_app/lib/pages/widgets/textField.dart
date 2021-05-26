import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';

class GetTextField extends StatelessWidget {
  final TextEditingController textFieldController;
  final bool hasShadow, isPassword, isEnabled, isPassVisible, isEyeVisible;
  final String lableText;
  final VoidCallback? onPressed;
  final void Function(String)? onChanged;
  final String? Function(String?) validatorFun;
  final TextInputType inputType;
  final int maxLength;
  final double height;
  final FocusNode? focusNode;
  final IconData? suffixIcon;
  GetTextField(
      {required this.textFieldController,
      required this.lableText,
      required this.validatorFun,
      this.hasShadow = false,
      this.isPassword = false,
      this.inputType = TextInputType.text,
      this.isEnabled = true,
      this.isPassVisible = false,
      this.isEyeVisible = false,
      this.onPressed,
      this.maxLength = 0,
      this.focusNode,
      this.height = 65.0,
      this.onChanged,
      this.suffixIcon});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Card(
        elevation: hasShadow ? 10 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.commonRadius),
        ),
        shadowColor: Colors.white70,
        child: ListTile(
          title: TextFormField(
            controller: textFieldController,
            validator: validatorFun,
            decoration: InputDecoration(
              suffixIcon: suffixIcon == null ? Text("") : Icon(suffixIcon),
              hintText: lableText,
              border: InputBorder.none,
              counterText: "",
              enabled: isEnabled,
              hintStyle: TextStyle(
                fontSize: AppTexts.inputFieldTextSize,
              ),
            ),
            keyboardType: inputType,
            cursorColor: AppColors.primaryColor,
            obscureText: isPassword,
            onChanged: onChanged,
            maxLength: inputType == TextInputType.phone
                ? 10
                : maxLength != 0
                    ? maxLength
                    : null,
            focusNode: focusNode,
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
    );
  }
}
