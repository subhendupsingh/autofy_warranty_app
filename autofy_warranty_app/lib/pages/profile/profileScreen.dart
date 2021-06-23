import 'package:autofy_warranty_app/controllers/authController.dart';
import 'package:autofy_warranty_app/pages/profile/updateProfileScreen.dart';
import 'package:autofy_warranty_app/pages/widgets/btn.dart';
import 'package:autofy_warranty_app/services/localStorageService.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ProfileSreen extends StatefulWidget {
  @override
  _ProfileSreenState createState() => _ProfileSreenState();
}

class _ProfileSreenState extends State<ProfileSreen> {
  var userName = LocalStoragaeService.getUserValue(UserField.Name);

  var userEmail = LocalStoragaeService.getUserValue(UserField.Email);

  var userPhone = LocalStoragaeService.getUserValue(UserField.Phone);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: Get.size.width,
              height: Get.size.height,
              color: AppColors.primaryColor,
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 20),
              child: ClipOval(
                child: SvgPicture.network(
                  "https://avatars.dicebear.com/api/micah/$userName.svg",
                  height: 90,
                  width: 90,
                  semanticsLabel: "UserProfile",
                  placeholderBuilder: (context) => CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.secondaryColor,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 120,
              ),
              alignment: Alignment.topCenter,
              child: Text(
                userName,
                style: TextStyle(
                  color: AppColors.secondaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 160,
              ),
              alignment: Alignment.topCenter,
              child: Text(
                "+91 " + userPhone,
                style: TextStyle(
                  color: AppColors.secondaryColor,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 180,
              ),
              alignment: Alignment.topCenter,
              child: Text(
                userEmail,
                style: TextStyle(
                  color: AppColors.secondaryColor,
                  fontSize: 16,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await Get.to(() => UpdateProfileScreen());
                setState(() {
                  userName = LocalStoragaeService.getUserValue(UserField.Name);
                  userEmail =
                      LocalStoragaeService.getUserValue(UserField.Email);
                  userPhone =
                      LocalStoragaeService.getUserValue(UserField.Phone);
                });
              },
              child: Container(
                margin: EdgeInsets.only(
                  top: 175,
                  right: 10,
                ),
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.mode_edit,
                  color: AppColors.lightGreyTextColor,
                  size: 25,
                ),
              ),
            ),
            Positioned(
              top: 220,
              child: Container(
                color: Colors.grey.shade200,
                width: Get.size.width,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GetBtn(
                        width: 150,
                        btnText: "Logout",
                        onPressed: () {
                          Get.defaultDialog(
                            title: "\nAlert",
                            content: Column(
                              children: [
                                Text("Are you sure you want to logout?"),
                                ButtonBar(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        AuthController.to.logOut();
                                      },
                                      child: Text("Logout"),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: FaIcon(
                                FontAwesomeIcons.facebook,
                                color: AppColors.primaryColor,
                                size: 30,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: FaIcon(
                                FontAwesomeIcons.instagram,
                                color: AppColors.primaryColor,
                                size: 30,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: FaIcon(
                                FontAwesomeIcons.linkedin,
                                color: AppColors.primaryColor,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                height: Get.size.height - 363,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
