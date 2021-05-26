import 'package:autofy_warranty_app/controllers/apiController.dart';
import 'package:autofy_warranty_app/pages/uploadInvoice/productSearchScreen.dart';
import 'package:autofy_warranty_app/pages/uploadInvoice/productTileWidget.dart';
import 'package:autofy_warranty_app/pages/uploadInvoice/uploadInvoiceController.dart';
import 'package:autofy_warranty_app/pages/widgets/btn.dart';
import 'package:autofy_warranty_app/pages/widgets/textField.dart';
import 'package:autofy_warranty_app/services/localStorageService.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  void initState() {
    super.initState();
    fetchInvoiceData();
  }

  final _formKey = GlobalKey<FormState>();

  fetchInvoiceData() {
    phoneNumberController.text =
        LocalStoragaeService.getUserValue(UserField.Phone) ?? "";
    emailController.text =
        LocalStoragaeService.getUserValue(UserField.Email) ?? "";
    String kNotFound = "NOTFOUND";
    UploadInvoiceController invoiceController =
        Get.find<UploadInvoiceController>();
    warrantyCode = invoiceController.warrentyCode;
    Map<String, dynamic> extractedData = invoiceController.invoiceData;
    if (extractedData == {}) return;
    for (String key in extractedData.keys) {
      print(key);
      if (key.contains("name")) {
        nameController.text =
            extractedData[key] == kNotFound ? "" : extractedData[key];
      } else if (key.contains("shippingAddress")) {
        addressController.text =
            extractedData[key] == kNotFound ? "" : extractedData[key];
      } else if (key.contains("postalCode")) {
        postalCodeController.text =
            extractedData[key] == kNotFound ? "" : extractedData[key];
      } else if (key.contains("portal")) {
        portalController.text =
            extractedData[key] == kNotFound ? "" : extractedData[key];
      } else if (key.contains("invoiceDate")) {
        invoiceDate =
            extractedData[key] == kNotFound ? null : extractedData[key];
        print(invoiceDate);
      } else if (key.contains("orderNumber")) {
        orderController.text =
            extractedData[key] == kNotFound ? "" : extractedData[key];
      } else if (key.contains("state")) {
        stateController.text =
            extractedData[key] == kNotFound ? "" : extractedData[key];
      }
    }
  }

  final TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      phoneNumberController = TextEditingController(),
      portalController = TextEditingController(),
      orderController = TextEditingController(),
      addressController = TextEditingController(),
      invoiceDateController = TextEditingController(),
      postalCodeController = TextEditingController(),
      stateController = TextEditingController(),
      cityController = TextEditingController(),
      productController = TextEditingController();
  final dropDownKey = GlobalKey();

  String? portal;
  Map<String, dynamic>? product;
  String? invoiceDate = "";
  String? warrantyCode;

  void unfocusTextField() => FocusScope.of(context).unfocus();

  buildDropDownForPortal() {
    return SizedBox(
      height: 65,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.commonRadius),
        ),
        shadowColor: Colors.white70,
        child: ListTile(
          title: Stack(
            children: [
              TextFormField(
                controller: portalController,
                decoration: InputDecoration(
                  hintText: portal ?? "Select Portal",
                  border: InputBorder.none,
                  counterText: "",
                  enabled: false,
                  hintStyle: TextStyle(
                    fontSize: AppTexts.inputFieldTextSize,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    onTap: () {
                      unfocusTextField();
                    },
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.grey[700]),
                    onChanged: (String? newValue) {
                      portalController.text = newValue!;
                    },
                    items: <String>[
                      'Amazon',
                      'Flipkart',
                      'Autofy Store',
                      'Offline Store'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildDropDownForProducts() {
    return SizedBox(
      height: 65,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.commonRadius),
        ),
        shadowColor: Colors.white70,
        child: ListTile(
          title: GestureDetector(
            onTap: () async {
              var selectedProduct = await Get.to(() => ProductSearchScreen());
              if (selectedProduct != null) {
                product = selectedProduct;
                productController.text = product!["title"];
              }
            },
            child: TextFormField(
              validator: (value) {
                if (product == null) {
                  Get.snackbar("No Product Selected",
                      "Please select a product to proceed further",
                      colorText: Colors.red, backgroundColor: Colors.white);
                  // return "";
                  return;
                }

                return null;
              },
              controller: productController,
              enabled: false,
              decoration: InputDecoration(
                enabled: false,
                hintText: "Tap to select product",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: AppTexts.inputFieldTextSize,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      invoiceDate = formatDate(picked);
      setState(() {});
    }
  }

  String formatDate(DateTime dateTime) {
    final template = DateFormat('dd-MM-yyyy');
    return template.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  emptyVerticalBox(height: 40),
                  Text(
                    'Activate Warranty',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  emptyVerticalBox(height: 30),
                  emptyVerticalBox(),
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
                      validatorFun: (value) {
                        if (value!.isEmpty) {
                          return "Name can't be emtpy";
                        }
                        return null;
                      }),
                  GetTextField(
                      textFieldController: emailController,
                      lableText: "Email",
                      validatorFun: (value) {
                        if (!value!.isEmail) {
                          return "Please enter a valid email";
                        }
                        return null;
                      }),
                  GetTextField(
                      textFieldController: phoneNumberController,
                      lableText: "Phone Number",
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
                  buildDropDownForProducts(),
                  buildDropDownForPortal(),
                  GetTextField(
                      textFieldController: orderController,
                      lableText: "Order Number",
                      validatorFun: (value) {
                        if (value!.isEmpty) {
                          return "Please fill in the order number";
                        }
                        return null;
                      }),
                  GestureDetector(
                    onTap: () {
                      unfocusTextField();
                      _selectDate();
                    },
                    child: GetTextField(
                        textFieldController: invoiceDateController,
                        suffixIcon: Icons.calendar_today_rounded,
                        lableText: invoiceDate ?? "Invoice Date",
                        isEnabled: false,
                        validatorFun: (value) {
                          if (invoiceDate == null) {
                            return "Please fill in the invoice date";
                          }
                          return null;
                        }),
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
                      height: 125,
                      maxLines: 5,
                      validatorFun: (value) {
                        if (value!.isEmpty) {
                          return "Please fill in your address";
                        }
                        return null;
                      }),
                  GetTextField(
                      textFieldController: cityController,
                      lableText: "City",
                      validatorFun: (value) {
                        if (value!.isEmpty) {
                          return "Please fill in your city name";
                        }
                        return null;
                      }),
                  GetTextField(
                      textFieldController: stateController,
                      lableText: "State",
                      validatorFun: (value) {
                        if (value!.isEmpty) {
                          return "Please fill in your state name";
                        }
                        return null;
                      }),
                  GetTextField(
                      textFieldController: postalCodeController,
                      lableText: "Postal Code",
                      validatorFun: (value) {
                        if (value!.isEmpty) {
                          return "Please fill in your postal code";
                        }
                        return null;
                      }),
                  emptyVerticalBox(),
                  Center(
                    child: GetBtn(
                      btnText: "Submit",
                      onPressed: () {
                        print(warrantyCode);
                        if (_formKey.currentState!.validate()) {
                          ApiController apiController =
                              Get.find<ApiController>();
                          apiController.activateWarranty(data: {
                            "name": nameController.text.trim().toString(),
                            "email": emailController.text.trim().toString(),
                            "phone":
                                phoneNumberController.text.trim().toString(),
                            "orderNumber":
                                orderController.text.trim().toString(),
                            "portal": portalController.text.trim().toString(),
                            "address": addressController.text.trim().toString(),
                            "city": cityController.text.trim().toString(),
                            "state": stateController.text.trim().toString(),
                            "invoiceDate": formatDate(
                                DateTime.now()), //TODO: Change this asap
                            "postalCode":
                                postalCodeController.text.trim().toString(),
                            "validWarrantyCode": warrantyCode,
                            "product": product!["id"],
                          });
                        }
                      },
                      height: 40,
                      width: 100,
                    ),
                  ),
                  emptyVerticalBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
