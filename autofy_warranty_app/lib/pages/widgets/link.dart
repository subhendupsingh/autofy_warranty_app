import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';

class GetLink extends StatelessWidget {
  final String linkText;
  final void Function() onTapped;

  GetLink({required this.linkText, required this.onTapped});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: Text(
        linkText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppTexts.linkTextSize,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
