import 'package:autofy_warranty_app/controllers/apiController.dart';
import 'package:autofy_warranty_app/pages/widgets/btn.dart';
import 'package:autofy_warranty_app/pages/widgets/textField.dart';
import 'package:autofy_warranty_app/services/localStorageService.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController nameController = TextEditingController(
        text: LocalStoragaeService.getUserValue(UserField.Name),
      ),
      emailController = TextEditingController(
        text: LocalStoragaeService.getUserValue(UserField.Email),
      ),
      phoneController = TextEditingController(
        text: LocalStoragaeService.getUserValue(UserField.Phone),
      ),
      addressController = TextEditingController(
        text: LocalStoragaeService.getUserValue(UserField.Address),
      ),
      cityController = TextEditingController(
        text: LocalStoragaeService.getUserValue(UserField.City),
      ),
      stateController = TextEditingController(
        text: LocalStoragaeService.getUserValue(UserField.State),
      ),
      postalController = TextEditingController(
        text: LocalStoragaeService.getUserValue(UserField.PostalCode),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text('Update profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor,
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          emptyVerticalBox(height: 30),
                          Text(
                            '   Your Information:',
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
                              if (value!.trim().isEmpty) {
                                return "Name can't be emtpy";
                              }
                              return null;
                            },
                          ),
                          GetTextField(
                            textFieldController: emailController,
                            lableText: "Email",
                            isEnabled: false,
                            validatorFun: (value) {
                              if (value!.isEmpty) {
                                return "Email can't be emtpy";
                              }
                              return null;
                            },
                          ),
                          GetTextField(
                            textFieldController: phoneController,
                            lableText: "Phone",
                            validatorFun: (value) {
                              if (value!.trim().isEmpty) {
                                return "Phone number can't be emtpy";
                              } else if (value.trim().length != 10)
                                return "Invalid Mobile No";
                              return null;
                            },
                          ),
                          GetTextField(
                            textFieldController: addressController,
                            lableText: "Address",
                            height: 125,
                            maxLines: 5,
                            validatorFun: (value) {
                              if (value!.trim().isEmpty) {
                                return "Address can't be emtpy";
                              }
                              return null;
                            },
                          ),
                          GetTextField(
                            textFieldController: cityController,
                            lableText: "City",
                            validatorFun: (value) {
                              if (value!.trim().isEmpty) {
                                return "City can't be emtpy";
                              } else if (value.trim().length < 2)
                                return "Invalid City";
                              return null;
                            },
                          ),
                          GetTextField(
                            textFieldController: stateController,
                            lableText: "State",
                            validatorFun: (value) {
                              if (value!.trim().isEmpty) {
                                return "State can't be emtpy";
                              } else if (value.trim().length < 2)
                                return "Invalid state";
                              return null;
                            },
                          ),
                          GetTextField(
                            textFieldController: postalController,
                            lableText: "Postal Code",
                            validatorFun: (value) {
                              if (value!.trim().isEmpty) {
                                return "Postal Code can't be emtpy";
                              } else if (value.trim().length < 6)
                                return "Invalid Postal Code";
                              return null;
                            },
                          ),
                          emptyVerticalBox(),
                          GetBtn(
                            btnText: "Update Details",
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                ApiController apiController = ApiController();
                                Map<dynamic, dynamic> updatedData = {
                                  UserField.Id.asString:
                                      LocalStoragaeService.getUserValue(
                                          UserField.Id),
                                  UserField.Name.asString:
                                      nameController.text.trim(),
                                  UserField.Phone.asString:
                                      phoneController.text.trim(),
                                  UserField.Address.asString:
                                      addressController.text.trim(),
                                  UserField.City.asString:
                                      cityController.text.trim(),
                                  UserField.State.asString:
                                      stateController.text.trim(),
                                  UserField.PostalCode.asString:
                                      postalController.text.trim(),
                                };
                                Map<dynamic, dynamic> result =
                                    await apiController
                                        .updateProfile(updatedData);
                                if (result["success"]) {
                                  Get.snackbar("Profile Updated",
                                      result["message"] ?? "");
                                  LocalStoragaeService.updateUserData(
                                      updatedData);
                                } else {
                                  Get.snackbar("Profile Not Updated",
                                      result["message"] ?? "");
                                }
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            },
                          )
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
