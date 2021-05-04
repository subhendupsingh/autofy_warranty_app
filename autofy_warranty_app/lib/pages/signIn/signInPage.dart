import 'package:autofy_warranty_app/pages/widgets/btn.dart';
import 'package:autofy_warranty_app/pages/widgets/link.dart';
import 'package:autofy_warranty_app/pages/widgets/textField.dart';
import 'package:autofy_warranty_app/pages/widgets/wave.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 30, left: 30, top: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello \nWelcome to \nAutofy',
                style: TextStyle(
                  fontSize: AppTexts.primaryHeadingTextSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GetTextField(
                textFieldController: emailController,
                lableText: "Email Address",
                hasShadow: true,
                isPassword: false,
              ),
              SizedBox(
                height: 5,
              ),
              GetTextField(
                textFieldController: passwordController,
                lableText: "Password",
                hasShadow: true,
                isPassword: true,
              ),
              SizedBox(
                height: 20,
              ),
              GetBtn(
                onPressed: () {},
                btnText: "Sign In",
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GetLink(linkText: "Forget Your Password?", onTapped: () {}),
                  GetLink(linkText: "Sign Up", onTapped: () {}),
                ],
              ),
            ],
          ),
        ),
        GetWave(),
      ],
    );
  }
}
