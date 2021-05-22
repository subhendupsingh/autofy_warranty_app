import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';

class GetBtn extends StatelessWidget {
  final String btnText;
  final void Function() onPressed;
  final Color? btnColor;
  final double width, height;
  GetBtn(
      {required this.btnText,
      required this.onPressed,
      this.btnColor,
      this.height = 0,
      this.width = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width == 0 ? double.infinity : width,
      height: height == 0 ? 55 : height,
      child: MaterialButton(
        onPressed: onPressed,
        color: btnColor == null ? AppColors.primaryColor : btnColor,
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
