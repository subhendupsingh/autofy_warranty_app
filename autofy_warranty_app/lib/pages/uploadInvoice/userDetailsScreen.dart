import 'package:autofy_warranty_app/pages/widgets/btn.dart';
import 'package:autofy_warranty_app/pages/widgets/textField.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      phoneNumberController = TextEditingController(),
      portalController = TextEditingController(),
      orderController = TextEditingController(),
      addressController = TextEditingController(),
      invoiceDateController = TextEditingController(),
      postalCodeController = TextEditingController();
  final dropDownKey = GlobalKey();

  String portal = "Amazon";
  String product = "Product 1";
  DateTime invoiceDate = DateTime.now();

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
                  hintText: portal,
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
                      setState(() {
                        portal = newValue!;
                      });
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
          title: Stack(
            children: [
              TextFormField(
                controller: portalController,
                decoration: InputDecoration(
                  hintText: product,
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
                      setState(() {
                        product = newValue!;
                      });
                    },
                    items: <String>[
                      'Product 1',
                      'Product 2',
                      'Product 3',
                      'Product 4'
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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: invoiceDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != invoiceDate)
      setState(() {
        invoiceDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                    validatorFun: (value) {}),
                GetTextField(
                    textFieldController: emailController,
                    lableText: "Email",
                    validatorFun: (value) {}),
                GetTextField(
                    textFieldController: phoneNumberController,
                    lableText: "Phone Number",
                    validatorFun: (value) {}),
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
                    validatorFun: (value) {}),
                GestureDetector(
                  onTap: () {
                    unfocusTextField();
                    _selectDate();
                  },
                  child: GetTextField(
                      textFieldController: invoiceDateController,
                      suffixIcon: Icons.calendar_today_rounded,
                      lableText: "Select Date",
                      isEnabled: false,
                      validatorFun: (value) {}),
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
                    validatorFun: (value) {}),
                GetTextField(
                    textFieldController: postalCodeController,
                    lableText: "Postal Code",
                    validatorFun: (value) {}),
                emptyVerticalBox(),
                Center(
                  child: GetBtn(
                    btnText: "Submit",
                    onPressed: () {},
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
    );
  }
}
