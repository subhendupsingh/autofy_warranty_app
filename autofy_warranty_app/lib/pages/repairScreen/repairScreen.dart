import 'dart:typed_data';

import 'package:autofy_warranty_app/controllers/apiController.dart';
import 'package:autofy_warranty_app/pages/homepage/homepageScreen.dart';
import 'package:autofy_warranty_app/pages/repairScreen/generatePDF.dart';
import 'package:autofy_warranty_app/pages/repairScreen/repairScreenController.dart';
import 'package:autofy_warranty_app/pages/widgets/btn.dart';
import 'package:autofy_warranty_app/pages/widgets/textField.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class RepairProductScreen extends StatefulWidget {
  final String warrantyCode;
  RepairProductScreen({required this.warrantyCode});
  @override
  _RepairProductScreenState createState() => _RepairProductScreenState();
}

class _RepairProductScreenState extends State<RepairProductScreen> {
  ApiController _apiController = ApiController();

  @override
  void initState() {
    super.initState();
    fetchWarrantyData();
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController orderController = TextEditingController(),
      portalController = TextEditingController(),
      nameController = TextEditingController(),
      emailController = TextEditingController(),
      phoneNumberController = TextEditingController(),
      addressController = TextEditingController(),
      stateController = TextEditingController(),
      cityController = TextEditingController(),
      postalCodeController = TextEditingController();
  final dropDownKey = GlobalKey();

  RepairScreenController controller = Get.put(RepairScreenController());
  fetchWarrantyData() async {
    await _apiController.getWarrantyInfo(warrantyCode: widget.warrantyCode);
    nameController.text = controller.userProductWarrantyInfo["name"] ?? "";
    emailController.text = controller.userProductWarrantyInfo["email"] ?? "";
    phoneNumberController.text =
        controller.userProductWarrantyInfo["phone"] ?? "";
    orderController.text =
        controller.userProductWarrantyInfo["orderNumber"] ?? "";
    portalController.text = controller.userProductWarrantyInfo["portal"] ?? "";
    addressController.text =
        controller.userProductWarrantyInfo["address"] ?? "";
    cityController.text = controller.userProductWarrantyInfo["city"] ?? "";
    stateController.text = controller.userProductWarrantyInfo["state"] ?? "";
    postalCodeController.text =
        controller.userProductWarrantyInfo["postalCode"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return GetX<RepairScreenController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text("Request Repair"),
          backgroundColor: AppColors.primaryColor,
        ),
        body: controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                ),
              )
            : SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 20.0,
                          left: 20.0,
                          bottom: 80.0,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                // color: Colors.grey[100],
                                child: ListTile(
                                  leading: Icon(
                                    Icons.error_outline_rounded,
                                    color: Colors.amber,
                                    size: 30,
                                  ),
                                  subtitle: Text(
                                    "1. We have auto-filled some fields for you; kindly review the same before proceeding.\n\n2. Please verify/edit the address on this screen - the same address will be used for pickup & delivery of the product.",
                                  ),
                                ),
                              ),
                              Text(
                                '   Buyer Information:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              emptyVerticalBox(height: 10),
                              GetTextField(
                                textFieldController: nameController,
                                lableText: "Name",
                                hasShadow: true,
                                validatorFun: (value) {
                                  if (value!.isEmpty) {
                                    return "Name can't be emtpy";
                                  }
                                  return null;
                                },
                              ),
                              GetTextField(
                                  textFieldController: emailController,
                                  lableText: "Email",
                                  hasShadow: true,
                                  validatorFun: (value) {
                                    if (!value!.isEmail) {
                                      return "Please enter a valid email";
                                    }
                                    return null;
                                  }),
                              GetTextField(
                                  textFieldController: phoneNumberController,
                                  lableText: "Phone Number",
                                  hasShadow: true,
                                  validatorFun: (value) {
                                    if (!value!.isPhoneNumber) {
                                      return "Please enter a valid phone number";
                                    }
                                    return null;
                                  }),
                              emptyVerticalBox(),
                              Text(
                                '   Product Information:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              emptyVerticalBox(height: 10),
                              GetTextField(
                                textFieldController: orderController,
                                lableText: "Order Number",
                                isEnabled: false,
                                validatorFun: (value) {
                                  if (value!.isEmpty) {
                                    return "Please fill in the order number";
                                  }
                                  return null;
                                },
                              ),
                              GetTextField(
                                textFieldController: portalController,
                                lableText: "Protal",
                                isEnabled: false,
                                validatorFun: (value) {
                                  if (value!.isEmpty) {
                                    return "Please fill in the Portal number";
                                  }
                                  return null;
                                },
                              ),
                              emptyVerticalBox(),
                              Text(
                                '   Address Information:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              emptyVerticalBox(height: 10),
                              GetTextField(
                                textFieldController: addressController,
                                lableText: "Address",
                                hasShadow: true,
                                height: 125,
                                maxLines: 5,
                                validatorFun: (value) {
                                  if (value!.isEmpty) {
                                    return "Please fill in your address";
                                  }
                                  return null;
                                },
                              ),
                              GetTextField(
                                textFieldController: cityController,
                                lableText: "City",
                                hasShadow: true,
                                validatorFun: (value) {
                                  if (value!.isEmpty) {
                                    return "Please fill in your city name";
                                  }
                                  return null;
                                },
                              ),
                              GetTextField(
                                textFieldController: stateController,
                                lableText: "State",
                                hasShadow: true,
                                validatorFun: (value) {
                                  if (value!.isEmpty) {
                                    return "Please fill in your state name";
                                  }
                                  return null;
                                },
                              ),
                              GetTextField(
                                textFieldController: postalCodeController,
                                lableText: "Postal Code",
                                hasShadow: true,
                                validatorFun: (value) {
                                  if (value!.isEmpty) {
                                    return "Please fill in your postal code";
                                  }
                                  return null;
                                },
                              ),
                              emptyVerticalBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GetBtn(
                          btnText: "Request Repair",
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              dio.FormData repairRequestData =
                                  dio.FormData.fromMap(
                                {
                                  "validWarrantyCode": widget.warrantyCode,
                                  "name": nameController.value.text,
                                  "email": emailController.text,
                                  "phone": phoneNumberController.value.text,
                                  "address": addressController.value.text,
                                  "city": cityController.value.text,
                                  "state": stateController.value.text,
                                  "postal": postalCodeController.value.text,
                                  "test": true,
                                  "isCourierAllocated": true,
                                },
                              );

                              Map<String, dynamic> result =
                                  await _apiController.generateRepairRequest(
                                          formData: repairRequestData)
                                      as Map<String, dynamic>;
                              print(result.toString());
                              if (result.length <= 2) {
                                Get.snackbar("Repair Request Not Apporved",
                                    result["message"]);
                              } else {
                                buildDialog(result);
                              }
                            }
                          },
                          height: 60,
                          width: Get.width - 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void buildDialog(Map<String, dynamic> result) {
    Get.dialog(
      Center(
        child: Container(
          height: result["courierArranged"] ? 540 : 690,
          width: Get.width - 40,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "Your Product Repair request has been generated successfully.\n\n",
                      style: TextStyle(
                        color: AppColors.successColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextSpan(
                      text: "Service Request Number: \n",
                      style: TextStyle(
                        color: AppColors.successColor,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: "${result["serviceRequestNumber"]}\n\n",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.successColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    result["courierArranged"]
                        ? TextSpan(
                            children: [
                              TextSpan(
                                text: "Please Click the ",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "Print Shipping Label ",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "to download Autofy Service Center Details.\n\n",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "NOTE :\n\n",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "1. Pack all accessories of the product - in case of LED foglights pack both lights, switch etc.\n2. After packing, paste Shipping Label on the outer package.\n3. If print is not available, you can write the address & stick on the parcel",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )
                        : TextSpan(
                            children: [
                              TextSpan(
                                text: "Your pin code is ",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "NOT ",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "serviceable for Reverse Pickup, we request you to kindly pack the product safely (to avoid physical damage during transit else warranty would void) & ship it to our warehouse. ",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "CLICK ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "the ",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "\"PRINT SHIPPING LABEL\" ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "button to get our address details.\n\n",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "NOTE :\n\n",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "1. Pack all accessories of the product - in case of LED foglights pack both lights, switch etc.\n2. After packing, paste Shipping Label on the outer package.\n3. If print is not available, you can write the address & stick on the parcel",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              emptyVerticalBox(height: 50),
              GetBtn(
                btnText: "Print Shipping label".toUpperCase(),
                onPressed: () async {
                  await createPDF(result: result);
                },
              ),
              emptyVerticalBox(),
              GetBtn(
                btnText: "SHOW ALL REQUESTS",
                onPressed: () async {
                  Get.offAll(HomePage(
                    startingIndex: 1,
                  ));
                },
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future createPDF({required Map<String, dynamic> result}) async {
    PdfDocument pdfDocument = PdfDocument();
    final page = pdfDocument.pages.add();
    page.graphics.drawImage(
      PdfBitmap(await _readImageData()),
      Rect.fromLTWH(0, 0, 30, 30),
    );
    page.graphics.drawString(
      "Autofy",
      PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold),
      brush: PdfBrushes.indianRed,
      bounds: Rect.fromLTWH(30, 2, 70, 70),
    );
    page.graphics.drawString(
      "Your Repair Request Generated Successfully",
      PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
      brush: PdfBrushes.green,
      bounds:
          Rect.fromLTWH(page.size.width / 2 - 190, 3, page.size.width - 80, 50),
    );
    // PdfGrid grid = PdfGrid();
    // grid.columns.add(count: 5);
    // grid.headers.add(1);
    // grid.style = PdfGridStyle(
    //   font: PdfStandardFont(PdfFontFamily.helvetica, 12),
    //   cellPadding: PdfPaddings(left: 5, top: 2, bottom: 2, right: 2),
    // );
    // PdfGridRow header = grid.headers[0];
    // header.cells[0].value = "Sr. No";
    // header.cells[1].value = "Service Request Number";
    // header.cells[2].value = "Product SKU";
    // header.cells[3].value = "Product Name";
    // header.cells[4].value = "Courier Arranged";

    // PdfGridRow row = grid.rows.add();
    // row.cells[0].value = "1";
    // row.cells[1].value = result["serviceRequestNumber"];
    // row.cells[2].value = result["productSKU"];
    // row.cells[3].value = result["productName"];
    // row.cells[4].value = result["courierArranged"]
    //     ? "Courier arranged by autofy."
    //     : "You have to send courier by your self.";

    // grid.draw(
    //   page: page,
    //   bounds: Rect.fromLTWH(0, 110, page.size.width - 80, 600),
    // );

    page.graphics.drawString(
      "SRN : ${result["serviceRequestNumber"]}",
      PdfStandardFont(
        PdfFontFamily.helvetica,
        14,
        style: PdfFontStyle.bold,
      ),
      bounds: Rect.fromLTWH(0, 40, page.size.width / 2 - 70, 250),
    );

    page.graphics.drawString(
      "SKU : ${result["productSKU"]}",
      PdfStandardFont(
        PdfFontFamily.helvetica,
        14,
        style: PdfFontStyle.bold,
      ),
      bounds: Rect.fromLTWH(0, 60, page.size.width / 2 - 70, 250),
    );

    page.graphics.drawString(
      "To. \n${result["vendorName"]} \nPhone: ${result["vendorPhoneNumber"]} \n${result["vendorAddress"]} \n${result["vendorCity"]} \n${result["vendorState"]} \n${result["vendorPostalCode"]}",
      PdfStandardFont(
        PdfFontFamily.helvetica,
        14,
      ),
      bounds: Rect.fromLTWH(0, 90, page.size.width / 2 - 70, 250),
    );
    page.graphics.drawString(
      "From. \n${result["customerName"]} \nPhone: ${result["customerPhoneNumber"]} \n${result["customerAddress"]} \n${result["customerCity"]} \n${result["customerState"]} \n${result["customerPostalCode"]}",
      PdfStandardFont(
        PdfFontFamily.helvetica,
        14,
      ),
      bounds: Rect.fromLTWH(0, 240, page.size.width / 2 - 40, 250),
    );

// bounds: Rect.fromLTWH(page.size.width / 2 - 50, 160, page.size.width / 2 - 40, 250), for side by side
    page.graphics.drawLine(
      PdfPens.black,
      Offset(0, 400),
      Offset(page.size.width / 2 - 110, 400),
    );

    page.graphics.drawString(
      "TEAR FROM HERE",
      PdfStandardFont(
        PdfFontFamily.helvetica,
        14,
        style: PdfFontStyle.bold,
      ),
      bounds: Rect.fromLTWH(page.size.width / 2 - 105, 392, 130, 20),
    );

    page.graphics.drawLine(
      PdfPens.black,
      Offset(page.size.width / 2 + 25, 400),
      Offset(page.size.width, 400),
    );

    page.graphics.drawString(
      result["courierArranged"]
          ? "Take print out of this page or write with a pen on a plain paper in the following format and stick on the box: \n1) Service Request Number\n2) To Address\n3) From Address"
          : "Your Product Repair request has been generated successfully. \n\nYour PIN Code is NOT serviceable for Reverse Pickup, we request you to kindly pack the product safely (to avoid physical damage during transit else warranty would void) & ship it to our warehouse. CLICK the \"PRINT SHIPPING LABEL\" button to get our address details.\n\nNote:\n\n1. Pack all accessories of the product - in case of LED foglights pack both lights, switch etc.\n2. After packing, paste Shipping Label on the outer package.\n3. If print is not available, you can write the address & stick on the parcel",
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
      bounds: result["courierArranged"]
          ? Rect.fromLTWH(220, 680, page.size.width / 2, 250)
          : Rect.fromLTWH(220, 530, page.size.width / 2, 250),
    );

    List<int> bytes = pdfDocument.save();
    await saveAndLunchFile(bytes, "${result["productSKU"]}.pdf");
    pdfDocument.dispose();
  }

  Future<Uint8List> _readImageData() async {
    final data = await rootBundle.load("assets/autofy.png");
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
