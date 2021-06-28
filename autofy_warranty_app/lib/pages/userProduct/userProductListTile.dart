import 'package:autofy_warranty_app/Model/userProductModelForHive.dart';
import 'package:autofy_warranty_app/pages/repairScreen/repairScreen.dart';
import 'package:autofy_warranty_app/services/localStorageService.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class BuildUserProductListTile extends StatelessWidget {
  final UserProductModelForHive userProductModel;
  late final String whatsAppMsg;
  static late String userName, userAddress, userEmail, userPhone;
  late final String warrantyCode;
  BuildUserProductListTile({required this.userProductModel}) {
    userName = LocalStoragaeService.getUserValue(UserField.Name) ?? "";
    userAddress = LocalStoragaeService.getUserValue(UserField.Address) ?? "";
    userEmail = LocalStoragaeService.getUserValue(UserField.Email) ?? "";
    userPhone = LocalStoragaeService.getUserValue(UserField.Phone) ?? "";
    warrantyCode = userProductModel.warrantyCode ?? "";

    String productDetail =
        "\n-----------------------------------\nPRODUCT DETAILS\n-----------------------------------\nSKU: ${userProductModel.productSKU}\nNAME: ${userProductModel.productName}\nWARRANTY CODE: $warrantyCode";
    String userDetails =
        "\n-----------------------------------\nUSER DETAILS\n-----------------------------------\nName: $userName\nEmail: $userEmail\nPhone: $userPhone\nAddress: $userAddress";
    whatsAppMsg =
        "Hi, I need help with my product that is in warranty.$productDetail$userDetails";
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: buildUserProductLeadingImage(),
            title: buildUserProductTitleText(),
            isThreeLine: true,
            subtitle: buildUserProductSubtitleText(),
          ),
          Row(
            children: [
              buildUserProductFunctionBtn(
                iconData: Icons.handyman_outlined,
                title: "Repair",
                onPreesed: () {
                  Get.to(
                    () => RepairProductScreen(
                      warrantyCode: userProductModel.warrantyCode ?? "",
                    ),
                  );
                },
              ),
              buildHelpBtn(
                () async {
                  var whatsappUrl =
                      "whatsapp://send?phone=919999933907&text=$whatsAppMsg";
                  await urlLauncher.canLaunch(whatsappUrl)
                      ? urlLauncher.launch(whatsappUrl)
                      : urlLauncher.launch(
                          "https://wa.me/919999933907?text=$whatsAppMsg",
                        );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Expanded buildUserProductFunctionBtn(
      {required IconData iconData,
      required String title,
      required VoidCallback onPreesed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: MaterialButton(
          onPressed: title == "Repair"
              ? userProductModel.showRepairButton == true
                  ? onPreesed
                  : () {}
              : onPreesed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: Colors.white,
              ),
              emptyHorizontalBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
          color: title == "Repair"
              ? userProductModel.showRepairButton == true
                  ? AppColors.primaryColor
                  : AppColors.greyTextColor
              : AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  Widget buildUserProductSubtitleText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "\nPurchase Date: ${userProductModel.purchaseDate}",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text:
                    "\nRemaining attempts: ${userProductModel.numberOfRepairRequestsLeft}",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: "\nSKU : ${userProductModel.productSKU!}",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: "\nCode : ${userProductModel.warrantyCode!}",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Text(
              "Warranty Status : ",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Flexible(
              flex: 1,
              child: Text(
                userProductModel.warrantyStatus!,
                style: TextStyle(
                  color: userProductModel.warrantyStatus! == "Active"
                      ? AppColors.successColor
                      : AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            emptyHorizontalBox(width: 5),
            userProductModel.warrantyStatus! == "Pending Approval"
                ? Tooltip(
                    waitDuration: Duration(seconds: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.greyTextColor,
                          blurRadius: 2,
                        )
                      ],
                    ),
                    verticalOffset: 5,
                    preferBelow: false,
                    height: 30,
                    message:
                        "Your warrenty request is under observation.\nIt activate soon. Thank You.",
                    child: Icon(
                      Icons.help,
                      size: 18,
                      color: AppColors.greyTextColor,
                    ),
                  )
                : Text(""),
          ],
        ),
      ],
    );
  }

  Text buildUserProductTitleText() {
    return Text(
      userProductModel.productName ?? "",
      style: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildUserProductLeadingImage() {
    return GestureDetector(
      onTap: () {
        Get.defaultDialog(
          title: "",
          barrierDismissible: true,
          content: CachedNetworkImage(
            imageUrl: userProductModel.productImageURL ?? "",
            placeholder: (context, url) => CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.error_outline,
              color: AppColors.primaryColor,
            ),
          ),
        );
      },
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: userProductModel.productImageURL ?? "",
          placeholder: (context, url) => CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primaryColor,
            ),
          ),
          errorWidget: (context, url, error) => Icon(
            Icons.error_outline,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }

  buildHelpBtn(VoidCallback onPreesed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: MaterialButton(
          onPressed: onPreesed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/wpIcon.png",
                width: 20,
                height: 20,
              ),
              emptyHorizontalBox(width: 10),
              Text(
                "Help",
                style: TextStyle(
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
          color: AppColors.successColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}
