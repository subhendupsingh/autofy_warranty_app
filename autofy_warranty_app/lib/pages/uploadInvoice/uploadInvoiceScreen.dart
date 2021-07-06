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

  String preCode = "";
  @override
  void initState() {
    Get.put(UploadInvoiceController());
    imageServices = ScanImageServices();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<UploadInvoiceController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              right: 15,
              left: 15,
              top: 25,
              bottom: 0,
            ),
            width: Get.size.width,
            height: Get.size.height < Get.size.width
                ? Get.size.height + 127
                : Get.size.height - 160,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSerialCodeComponent(context),
                      emptyVerticalBox(),
                      buildUploadInvoice(),
                      Center(
                        child: Text(
                          "DEMO INVOICE",
                          style: TextStyle(
                            fontSize: AppTexts.normalTextSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          'assets/billDemo.jpg',
                          height: 260,
                        ),
                      ),
                      emptyVerticalBox(height: 60),
                    ],
                  ),
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
                      : buildDangerMsg(
                          "Looks like you are entering incorrect Warranty code. Please check the warranty card and re-enter the correct code or email us on support@autofystore.com with this screenshot & your warranty card photo")
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
            enable: !controller.validatedSuccessfully,
            maxLength: 4,
            focusNode: firstFocusNode,
            border: controller.validatedSuccessfully,
            onChanged: (val) {
              if (val.length == 4) {
                FocusScope.of(context).requestFocus(secondFocusNode);
                validateCode(controller);
              }
            },
          ),
        ),
        Expanded(
          child: WarrantyCodeTextField(
            lableText: 'xxxx',
            textFieldController: secondTextEditingController,
            enable: !controller.validatedSuccessfully,
            maxLength: 4,
            focusNode: secondFocusNode,
            border: controller.validatedSuccessfully,
            onChanged: (val) {
              if (val.length == 4) {
                FocusScope.of(context).requestFocus(thirdFocusNode);
                validateCode(controller);
              } else if (val.length == 0) {
                FocusScope.of(context).requestFocus(firstFocusNode);
              }
            },
          ),
        ),
        Expanded(
          child: WarrantyCodeTextField(
            lableText: 'xxxx',
            enable: !controller.validatedSuccessfully,
            textFieldController: thirdTextEditingController,
            maxLength: 4,
            focusNode: thirdFocusNode,
            border: controller.validatedSuccessfully,
            onChanged: (val) async {
              if (val.length == 4) {
                FocusScope.of(context).requestFocus(fourthFocusNode);
                validateCode(controller);
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
            enable: !controller.validatedSuccessfully,
            maxLength: 4,
            focusNode: fourthFocusNode,
            border: controller.validatedSuccessfully,
            onChanged: (val) async {
              if (val.length == 0) {
                FocusScope.of(context).requestFocus(thirdFocusNode);
              } else if (val.length == 4) {
                controller.isCodeLenError = false;
                controller.showValidateWarrantyMsg = false;
                await validateCode(controller);
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
            "Upload Invoice (Only .jpg, .jpeg, .png, .pdf supported)",
            style: TextStyle(
              fontSize: AppTexts.normalTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          emptyVerticalBox(height: 20),
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
        return buildSuccessMsg(
            controller.uploadedfileName + " uploaded successfully");
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
        Flexible(
          flex: 1,
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.dangerColor,
              fontSize: AppTexts.normalTextSize,
            ),
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
        Flexible(
          flex: 1,
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.successColor,
              fontSize: AppTexts.normalTextSize,
            ),
          ),
        )
      ],
    );
  }

  Future validateCode(controller) async {
    String code = firstTextEditingController.text.toString() +
        "-" +
        secondTextEditingController.text.toString() +
        "-" +
        thirdTextEditingController.text.toString() +
        "-" +
        fourthTextEditingController.text.toString();

    String msg = "";
    print("code : ${code.length}");

    if (code.length == 19) {
      controller.isLoading = true;
      if (preCode != code) {
        preCode = code;
        msg = await ValidateSerialCode.validateSerialCode(code: code);
      }
      if (msg == "Warranty code is valid.") {
        controller.validatedSuccessfully = true;
        controller.showValidateWarrantyMsg = true;
        controller.warrantyCode = code;
      } else {
        controller.validatedSuccessfully = false;
        controller.showValidateWarrantyMsg = true;
      }
      controller.isLoading = false;
    }
  }
}
