import 'package:autofy_warranty_app/controllers/authController.dart';
import 'package:autofy_warranty_app/pages/profile/updateProfileScreen.dart';
import 'package:autofy_warranty_app/pages/widgets/btn.dart';
import 'package:autofy_warranty_app/pages/widgets/link.dart';
import 'package:autofy_warranty_app/services/localStorageService.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

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
      backgroundColor: Colors.grey.shade200,
      body: Container(
        color: Colors.grey.shade200,
        child: Stack(
          children: [
            Column(
              children: [
                buildTopPart(),
                buildBottomPart(),
              ],
            ),
            Positioned(
              bottom: -10,
              child: Container(
                width: Get.width,
                child: Column(
                  children: [
                    // buildLogoutBtn(),
                    buildSocialMediaBtn(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GetBtn buildLogoutBtn() {
    return GetBtn(
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
    );
  }

  Widget buildBottomPart() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        width: Get.size.width,
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            buildAmazonLink(),
            emptyVerticalBox(),
            buildReportBug(),
          ],
        ),
      ),
    );
  }

  buildTopPart() {
    return Container(
      color: AppColors.primaryColor,
      child: Column(
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
              userName ?? "",
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
              "+91 " + userPhone.toString(),
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            child: Text(
              userEmail ?? "",
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
                      LocalStoragaeService.getUserValue(UserField.Address) ??
                          "";
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
      ),
    );
  }

  buildAmazonLink() {
    return GestureDetector(
      onTap: () {
        launch("https://amzn.to/2VhZWCd");
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: Get.width - 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.amazon,
              color: AppColors.primaryColor,
              size: 36,
            ),
            emptyHorizontalBox(width: 15),
            Text(
              "Browse More Autofy Products",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
            onPressed: () async {
              printError(info: "CALL");
              await canLaunch(
                      'fb://facewebmodal/f?href=https://www.facebook.com/autofyautomotive/')
                  ? launch(
                      'fb://facewebmodal/f?href=https://www.facebook.com/autofyautomotive/')
                  : launch('https://www.facebook.com/autofyautomotive/');
            },
            icon: FaIcon(
              FontAwesomeIcons.facebook,
              color: AppColors.primaryColor,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () async {
              await canLaunch('instagram://user?username=autofystore')
                  ? launch('instagram://user?username=autofystore')
                  : launch('https://instagram.com/autofystore');
            },
            icon: FaIcon(
              FontAwesomeIcons.instagram,
              color: AppColors.primaryColor,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              launch('https://www.linkedin.com/company/autofyauto/');
            },
            icon: FaIcon(
              FontAwesomeIcons.linkedin,
              color: AppColors.primaryColor,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              launch('https://amzn.to/2VhZWCd');
            },
            icon: FaIcon(
              FontAwesomeIcons.amazon,
              color: AppColors.primaryColor,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  buildReportBug() {
    return GestureDetector(
      onTap: () async {
        String msg = "";
        msg += "User Email : " +
            LocalStoragaeService.getUserValue(UserField.Email).toString() +
            "\n";

        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          msg += "Device Model: " + iosInfo.model! + "\n";
        } else if (Platform.isAndroid) {
          AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
          msg += "Device Model: " + androidDeviceInfo.model! + "\n";
        }
        msg += "Mobile No : " +
            LocalStoragaeService.getUserValue(UserField.Phone).toString() +
            "\n";
        msg += "*--TYPE YOUR ISSUE BELOW--*\n";

        var whatsappUrl = "whatsapp://send?phone=919999933907&text=$msg";
        await urlLauncher.canLaunch(whatsappUrl)
            ? urlLauncher.launch(whatsappUrl)
            : urlLauncher.launch(
                "https://wa.me/919999933907?text=$msg",
              );
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        width: Get.width - 40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Facing Issue?",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Divider(
              color: AppColors.greyTextColor,
            ),
            Text(
              "Report a bug",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppTexts.linkTextSize,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
