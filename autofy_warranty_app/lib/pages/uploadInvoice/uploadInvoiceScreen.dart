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

class RegisterWarranty extends StatefulWidget {
  @override
  _RegisterWarrantyState createState() => _RegisterWarrantyState();
}

class _RegisterWarrantyState extends State<RegisterWarranty> {
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
              const EdgeInsets.only(right: 15, left: 15, top: 25, bottom: 20),
          child: SingleChildScrollView(
            child: Container(
              width: Get.size.width,
              height: Get.size.height < Get.size.width
                  ? Get.size.height + 77
                  : Get.size.height - 190,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSerialCodeComponent(context),
                      emptyVerticalBox(height: 70),
                      buildUploadInvoice(),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: buildNextBtn(),
                  ),
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
          emptyVerticalBox(),
          controller.isLoading
              ? buildCircularProgcessIndicator()
              : buildSerialCodeInputField(context, controller),
          emptyVerticalBox(height: 25),
          controller.showValidateWarrantyMsg
              ? controller.validatedSuccessfully
                  ? buildSuccessMsg("Warranty code is validated")
                  : controller.isCodeLenError
                      ? buildDangerMsg(
                          "Warranty code should be of 16 Characters")
                      : buildDangerMsg("Warranty code is not validated")
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
            controller.showValidateWarrantyMsg = true;
            controller.isFileSelected = false;
          }
        },
      ),
    );
  }

  Widget buildSerialCodeInputLable(UploadInvoiceController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Enter/Scan Warranty Code",
          style: TextStyle(
            fontSize: AppTexts.normalTextSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        // IconButton(
        //   icon: Icon(
        //     Icons.camera_alt_rounded,
        //     color: AppColors.primaryColor,
        //   ),
        //   onPressed: () async {
        //     String msg = await imageServices.captureAndProcessImage();
        //     controller.showValidateWarrantyMsg = true;
        //     if (msg == "Not Found") {
        //       Get.snackbar(
        //         "Warranty Code Not Found",
        //         "Please Enter It Manually",
        //       );
        //     } else if (msg == "No Image Selected") {
        //       Get.snackbar(msg, "Please Select A Image To Scan Code");
        //     } else if (msg == "Warranty code is valid.") {
        //       controller.validatedSuccessfully = true;
        //       String code = controller.warrantyCode;
        //       firstTextEditingController.text = code.substring(0, 4);
        //       secondTextEditingController.text = code.substring(5, 9);
        //       thirdTextEditingController.text = code.substring(10, 14);
        //       fourthTextEditingController.text = code.substring(15);
        //     } else {
        //       controller.validatedSuccessfully = false;
        //       String code = controller.warrantyCode;
        //       firstTextEditingController.text = code.substring(0, 4);
        //       secondTextEditingController.text = code.substring(5, 9);
        //       thirdTextEditingController.text = code.substring(10, 14);
        //       fourthTextEditingController.text = code.substring(15);
        //     }
        //   },
        // )
      ],
    );
  }

  Widget buildSerialCodeInputField(
      BuildContext context, UploadInvoiceController controller) {
    return Row(
      children: [
        Expanded(
          child: WarrantyCodeTextField(
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
          child: WarrantyCodeTextField(
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
          child: WarrantyCodeTextField(
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
          child: WarrantyCodeTextField(
            lableText: 'xxxx',
            textFieldController: fourthTextEditingController,
            maxLength: 4,
            focusNode: fourthFocusNode,
            border: controller.validatedSuccessfully,
            onChanged: (val) async {
              if (val.length == 0) {
                FocusScope.of(context).requestFocus(thirdFocusNode);
              } else if (val.length == 4) {
                controller.isCodeLenError = false;
                controller.showValidateWarrantyMsg = false;
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
                  controller.showValidateWarrantyMsg = true;
                  controller.warrantyCode = code;
                } else {
                  controller.validatedSuccessfully = false;
                  controller.showValidateWarrantyMsg = true;
                }
                controller.isLoading = false;
              } else if (val.length < 4) {
                controller.validatedSuccessfully = false;
                controller.isCodeLenError = true;
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

                    if (controller.warrantyCode.isNotEmpty &&
                        controller.validatedSuccessfully) {
                      controller.isFileSelected = true;
                      controller.showValidateFileMsg = true;
                      await controller.filePicker(imageServices);
                    } else {
                      controller.showValidateWarrantyMsg = true;
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
      } else if (!controller.isFileSelected) {
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
