import 'package:autofy_warranty_app/pages/uploadInvoice/customTextFieldForCode.dart';
import 'package:autofy_warranty_app/pages/uploadInvoice/imageProcessingController.dart';
import 'package:autofy_warranty_app/pages/widgets/btn.dart';
import 'package:autofy_warranty_app/pages/widgets/textField.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadInvoiceScreen extends StatefulWidget {
  @override
  _UploadInvoiceScreenState createState() => _UploadInvoiceScreenState();
}

class _UploadInvoiceScreenState extends State<UploadInvoiceScreen> {
  final TextEditingController firstTextEditingController =
      TextEditingController();

  final TextEditingController secondTextEditingController =
      TextEditingController();

  final TextEditingController thirdTextEditingController =
      TextEditingController();

  final TextEditingController fourthTextEditingController =
      TextEditingController();

  final FocusNode firstFocusNode = FocusNode();

  final FocusNode secondFocusNode = FocusNode();

  final FocusNode thirdFocusNode = FocusNode();

  final FocusNode fourthFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: Get.size.width,
          height: Get.size.height,
          padding:
              const EdgeInsets.only(right: 15, left: 15, top: 75, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Register Warranty",
                    style: TextStyle(
                      fontSize: AppTexts.secondaryHeadingTextSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  emptyVerticalBox(height: 40),
                  GetBuilder<ImageProcessingController>(
                    init: ImageProcessingController(),
                    builder: (controller) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSerialCodeInputLable(controller),
                        controller.capturingImage
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryColor,
                                  ),
                                ),
                              )
                            : buildSerialCodeInputField(context, controller),
                        emptyVerticalBox(height: 10),
                        controller.validatedSuccessfully
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: AppColors.successColor,
                                  ),
                                  Text(
                                    "Serial code validated",
                                    style: TextStyle(
                                      color: AppColors.successColor,
                                      fontSize: AppTexts.normalTextSize,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  emptyVerticalBox(height: 70),
                  buildUploadInvoice(),
                ],
              ),
              Positioned(
                bottom: 10,
                child: GetBtn(
                  btnText: "Next",
                  width: 170,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSerialCodeInputLable(ImageProcessingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Enter/Scan Serial Code",
          style: TextStyle(
            fontSize: AppTexts.normalTextSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.camera_alt_rounded,
            color: AppColors.primaryColor,
          ),
          onPressed: () async {
            String msg =
                await controller.captureAndProcessImage("warrentyCard");
            if (msg == "Not Found") {
              Get.snackbar(
                  "Warrenty Code Not Found", "Please Enter It Manually");
            } else if (msg == "Please Check Your Code") {
              String code = controller.warrentyCode;
              firstTextEditingController.text = code.substring(0, 4);
              secondTextEditingController.text = code.substring(5, 9);
              thirdTextEditingController.text = code.substring(10, 14);
              fourthTextEditingController.text = code.substring(15);
              controller.validatedSuccessfully = true;
              Get.snackbar("Warrenty Code Found", msg);
            } else if (msg == "No Image Selected") {
              Get.snackbar(msg, "Please Select A Image To Scan Code");
            }
          },
        )
      ],
    );
  }

  Widget buildSerialCodeInputField(
      BuildContext context, ImageProcessingController controller) {
    return Row(
      children: [
        Expanded(
          child: WarrentyCodeTextField(
            lableText: 'xxxx',
            textFieldController: firstTextEditingController,
            validatorFun: (val) {
              return "";
            },
            maxLength: 4,
            focusNode: firstFocusNode,
            border: controller.validatedSuccessfully,
            onChanged: (val) {
              if (val.length == 4) {
                FocusScope.of(context).requestFocus(secondFocusNode);
              }
            },
          ),
        ),
        Expanded(
          child: WarrentyCodeTextField(
            lableText: 'xxxx',
            textFieldController: secondTextEditingController,
            validatorFun: (val) {},
            maxLength: 4,
            focusNode: secondFocusNode,
            border: controller.validatedSuccessfully,
            onChanged: (val) {
              if (val.length == 4) {
                FocusScope.of(context).requestFocus(thirdFocusNode);
              } else if (val.length == 0) {
                FocusScope.of(context).requestFocus(firstFocusNode);
              }
            },
          ),
        ),
        Expanded(
          child: WarrentyCodeTextField(
            lableText: 'xxxx',
            textFieldController: thirdTextEditingController,
            validatorFun: (val) {},
            maxLength: 4,
            focusNode: thirdFocusNode,
            border: controller.validatedSuccessfully,
            onChanged: (val) {
              if (val.length == 4) {
                FocusScope.of(context).requestFocus(fourthFocusNode);
              } else if (val.length == 0) {
                FocusScope.of(context).requestFocus(secondFocusNode);
              }
            },
          ),
        ),
        Expanded(
          child: WarrentyCodeTextField(
            lableText: 'xxxx',
            textFieldController: fourthTextEditingController,
            validatorFun: (val) {},
            maxLength: 4,
            focusNode: fourthFocusNode,
            border: controller.validatedSuccessfully,
            onChanged: (val) {
              if (val.length == 0) {
                FocusScope.of(context).requestFocus(thirdFocusNode);
              } else if (val.length == 4) {
                controller.validatedSuccessfully = true;
              } else if (val.length < 4) {
                controller.validatedSuccessfully = false;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildUploadInvoice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upload Invoice (PDF,JPG,PNG)",
          style: TextStyle(
            fontSize: AppTexts.normalTextSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        emptyVerticalBox(height: 10),
        GetBtn(
          btnText: "Browse",
          onPressed: () {},
          height: 40,
          width: 100,
        ),
        emptyVerticalBox(height: 5),
        Text(
          "10 MB Max*",
          style: TextStyle(
            fontSize: AppTexts.normalTextSize - 4,
          ),
        ),
      ],
    );
  }
}
