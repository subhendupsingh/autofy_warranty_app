import 'package:autofy_warranty_app/controllers/authController.dart';
import 'package:autofy_warranty_app/pages/profile/updateProfileScreen.dart';
import 'package:autofy_warranty_app/pages/widgets/btn.dart';
import 'package:autofy_warranty_app/pages/widgets/link.dart';
import 'package:autofy_warranty_app/services/localStorageService.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
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

  var userAddress = LocalStoragaeService.getUserValue(UserField.Address) ?? "";
  var userCity = LocalStoragaeService.getUserValue(UserField.City) ?? "";
  var userState = LocalStoragaeService.getUserValue(UserField.State) ?? "";
  var userPostalCode =
      LocalStoragaeService.getUserValue(UserField.PostalCode) ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.primaryColor,
          child: Column(
            children: [
              buildTopPart(),
              buildBottomPart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomPart() {
    return Container(
      color: Colors.grey.shade200,
      width: Get.size.width,
      height: Get.height - 360,
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildAddress(),
          Column(
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
              buildSocialMediaBtn()
            ],
          ),
        ],
      ),
    );
  }

  buildTopPart() {
    return Column(
      children: [
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
        emptyVerticalBox(),
        Container(
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
        emptyVerticalBox(height: 10),
        Container(
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
          child: Text(
            userEmail,
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 2.0),
          child: GestureDetector(
            onTap: () async {
              await Get.to(() => UpdateProfileScreen());
              setState(() {
                userName =
                    LocalStoragaeService.getUserValue(UserField.Name) ?? "";
                userEmail =
                    LocalStoragaeService.getUserValue(UserField.Email) ?? "";
                userPhone =
                    LocalStoragaeService.getUserValue(UserField.Phone) ?? "";
                userAddress =
                    LocalStoragaeService.getUserValue(UserField.Address) ?? "";
                userCity =
                    LocalStoragaeService.getUserValue(UserField.City) ?? "";
                userState =
                    LocalStoragaeService.getUserValue(UserField.State) ?? "";
                userPostalCode =
                    LocalStoragaeService.getUserValue(UserField.PostalCode) ??
                        "";
              });
            },
            child: Container(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.mode_edit,
                color: AppColors.lightGreyTextColor,
                size: 25,
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildAddress() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      width: Get.width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Address",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Divider(
            color: AppColors.greyTextColor,
          ),
          userAddress == ""
              ? GetLink(
                  linkText: "Add New Address",
                  onTapped: () async {
                    await Get.to(() => UpdateProfileScreen());
                    setState(() {
                      userName =
                          LocalStoragaeService.getUserValue(UserField.Name) ??
                              "";
                      userEmail =
                          LocalStoragaeService.getUserValue(UserField.Email) ??
                              "";
                      userPhone =
                          LocalStoragaeService.getUserValue(UserField.Phone) ??
                              "";
                      userAddress = LocalStoragaeService.getUserValue(
                              UserField.Address) ??
                          "";
                      userCity =
                          LocalStoragaeService.getUserValue(UserField.City) ??
                              "";
                      userState =
                          LocalStoragaeService.getUserValue(UserField.State) ??
                              "";
                      userPostalCode = LocalStoragaeService.getUserValue(
                              UserField.PostalCode) ??
                          "";
                    });
                  },
                )
              : Text(
                  "$userAddress, $userCity, $userState, $userPostalCode",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
        ],
      ),
    );
  }

  buildSocialMediaBtn() {
    return Padding(
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
    );
  }
}
