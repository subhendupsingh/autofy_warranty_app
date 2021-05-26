import 'package:autofy_warranty_app/pages/uploadInvoice/customTextFieldForCode.dart';
import 'package:autofy_warranty_app/pages/uploadInvoice/uploadInvoiceController.dart';
import 'package:autofy_warranty_app/pages/uploadInvoice/userDetailsScreen.dart';
import 'package:autofy_warranty_app/pages/widgets/btn.dart';
import 'package:autofy_warranty_app/services/scanImageService.dart';
import 'package:autofy_warranty_app/services/validateSerialCode.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadInvoiceScreen extends StatefulWidget {
  @override
  _UploadInvoiceScreenState createState() => _UploadInvoiceScreenState();
}

class _UploadInvoiceScreenState extends State<UploadInvoiceScreen> {
  late ScanImageServices imageServices;
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
  void initState() {
    Get.put(UploadInvoiceController());
    imageServices = ScanImageServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(right: 15, left: 15, top: 75, bottom: 20),
          child: SingleChildScrollView(
            child: Container(
              width: Get.size.width,
              height: Get.size.height < Get.size.width
                  ? Get.size.height + 77
                  : Get.size.height - 140,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextTitle(),
                      emptyVerticalBox(height: 40),
                      buildSerialCodeComponent(context),
                      emptyVerticalBox(height: 70),
                      buildUploadInvoice(),
                    ],
                  ),
                  buildNextBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  GetBuilder<UploadInvoiceController> buildSerialCodeComponent(
      BuildContext context) {
    return GetBuilder<UploadInvoiceController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSerialCodeInputLable(controller),
          controller.isLoading
              ? buildCircularProgcessIndicator()
              : buildSerialCodeInputField(context, controller),
          emptyVerticalBox(height: 25),
          controller.showValidateWarrentyMsg
              ? controller.validatedSuccessfully
                  ? buildSuccessMsg("Warranty code is validated")
                  : buildDangerMsg("Warranty code is not valid")
              : Container()
        ],
      ),
    );
  }

  Center buildCircularProgcessIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget buildNextBtn() {
    return GetBuilder<UploadInvoiceController>(
      init: UploadInvoiceController(),
      builder: (controller) => GetBtn(
        btnText: "Next",
        width: 170,
        onPressed: () {
          if (controller.isFileUploaded && controller.validatedSuccessfully)
            Get.to(
              () => UserDetailsScreen(),
            );
          else {
            controller.showValidateFileMsg = true;
            controller.showValidateWarrentyMsg = true;
          }
        },
      ),
    );
  }

  Text buildTextTitle() {
    return Text(
      "Register Warranty",
      style: TextStyle(
        fontSize: AppTexts.secondaryHeadingTextSize,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget buildSerialCodeInputLable(UploadInvoiceController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Enter/Scan Warrenty Code",
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
            String msg = await imageServices.captureAndProcessImage();
            if (msg == "Not Found") {
              Get.snackbar(
                "Warrenty Code Not Found",
                "Please Enter It Manually",
              );
            } else if (msg == "No Image Selected") {
              Get.snackbar(msg, "Please Select A Image To Scan Code");
            } else if (msg == "Warranty code is valid.") {
              String code = controller.warrentyCode;
              firstTextEditingController.text = code.substring(0, 4);
              secondTextEditingController.text = code.substring(5, 9);
              thirdTextEditingController.text = code.substring(10, 14);
              fourthTextEditingController.text = code.substring(15);
              controller.validatedSuccessfully = true;
              controller.showValidateWarrentyMsg = true;
            } else {
              String code = controller.warrentyCode;
              firstTextEditingController.text = code.substring(0, 4);
              secondTextEditingController.text = code.substring(5, 9);
              thirdTextEditingController.text = code.substring(10, 14);
              fourthTextEditingController.text = code.substring(15);
              controller.validatedSuccessfully = false;
              controller.showValidateWarrentyMsg = true;
            }
          },
        )
      ],
    );
  }

  Widget buildSerialCodeInputField(
      BuildContext context, UploadInvoiceController controller) {
    return Row(
      children: [
        Expanded(
          child: WarrentyCodeTextField(
            lableText: 'xxxx',
            textFieldController: firstTextEditingController,
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
            maxLength: 4,
            focusNode: fourthFocusNode,
            border: controller.validatedSuccessfully,
            onChanged: (val) async {
              if (val.length == 0) {
                FocusScope.of(context).requestFocus(thirdFocusNode);
              } else if (val.length == 4) {
                String code = firstTextEditingController.text.toString() +
                    "-" +
                    secondTextEditingController.text.toString() +
                    "-" +
                    thirdTextEditingController.text.toString() +
                    "-" +
                    fourthTextEditingController.text.toString();
                controller.isLoading = true;
                String msg =
                    await ValidateSerialCode.validateSerialCode(code: code);

                if (msg == "Warranty code is valid.") {
                  controller.validatedSuccessfully = true;
                  controller.showValidateWarrentyMsg = true;
                  controller.warrentyCode = code;
                } else {
                  controller.validatedSuccessfully = false;
                  controller.showValidateWarrentyMsg = true;
                }
                controller.isLoading = false;
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
    return GetBuilder<UploadInvoiceController>(
      builder: (controller) => Column(
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
          controller.isFileUploading
              ? buildCircularProgcessIndicator()
              : GetBtn(
                  height: 40,
                  width: 100,
                  btnText: "Browse",
                  onPressed: () async {
                    controller.isFileIncorrect = false;
                    controller.isFileSizeExceed = false;
                    controller.isFileUploaded = false;
                    if (controller.warrentyCode.isNotEmpty &&
                        controller.validatedSuccessfully) {
                      controller.showValidateFileMsg = true;
                      await controller.filePicker(imageServices);
                    } else {
                      controller.showValidateWarrentyMsg = true;
                    }
                  },
                ),
          emptyVerticalBox(height: 5),
          Text(
            "10 MB Max*",
            style: TextStyle(
              fontSize: AppTexts.normalTextSize - 4,
            ),
          ),
          emptyVerticalBox(height: 25),
          buildFileUploadMsg(controller),
        ],
      ),
    );
  }

  Widget buildFileUploadMsg(UploadInvoiceController controller) {
    if (controller.showValidateFileMsg) {
      if (controller.isFileUploaded &&
          !controller.isFileIncorrect &&
          !controller.isFileSizeExceed) {
        return buildSuccessMsg("File uploaded successfully");
      } else if (controller.isFileIncorrect) {
        return buildDangerMsg("Only JPG, PNG & PDF is allowed");
      } else if (controller.isFileSizeExceed) {
        return buildDangerMsg("File size exceed(10 MB Max)");
      } else {
        return buildDangerMsg("Please upload the file.");
      }
    }
    return Container();
  }

  Row buildDangerMsg(String text) {
    return Row(
      children: [
        Icon(
          Icons.dangerous,
          color: AppColors.dangerColor,
        ),
        Text(
          text,
          style: TextStyle(
            color: AppColors.dangerColor,
            fontSize: AppTexts.normalTextSize,
          ),
        ),
      ],
    );
  }

  Row buildSuccessMsg(String text) {
    return Row(
      children: [
        Icon(
          Icons.check,
          color: AppColors.successColor,
        ),
        Text(
          text,
          style: TextStyle(
            color: AppColors.successColor,
            fontSize: AppTexts.normalTextSize,
          ),
        )
      ],
    );
  }
}
