import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';

class GetBackBtn extends StatelessWidget {
  final VoidCallback onPressed;

  GetBackBtn({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(
            Icons.arrow_back,
            color: AppColors.greyTextColor,
          ),
          Text(
            "Back",
            style: TextStyle(
              color: AppColors.greyTextColor,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
