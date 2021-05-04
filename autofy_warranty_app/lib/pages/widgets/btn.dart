import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';

class GetBtn extends StatelessWidget {
  final String btnText;
  final void Function() onPressed;

  GetBtn({required this.btnText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: MaterialButton(
        onPressed: onPressed,
        color: AppColors.primaryColor,
        child: Text(
          btnText,
          style: TextStyle(
            fontSize: AppTexts.normalTextSize,
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.commonRadius),
        ),
      ),
    );
  }
}
