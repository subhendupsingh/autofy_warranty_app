import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WarrentyCodeTextField extends StatelessWidget {
  final TextEditingController? textFieldController;
  final String? lableText;
  final void Function(String)? onChanged;
  final int? maxLength;
  final FocusNode? focusNode;
  final bool border;

  WarrentyCodeTextField({
    this.textFieldController,
    this.focusNode,
    this.lableText,
    this.maxLength,
    this.onChanged,
    this.border = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12, bottom: 0),
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 9,
            color: Colors.grey.withAlpha(80),
            offset: Offset(-1, 5),
          ),
        ],
        border: Border.all(
          color: border ? AppColors.successColor : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Center(
        child: TextFormField(
          controller: textFieldController,
          maxLength: maxLength,
          focusNode: focusNode,
          onChanged: onChanged,
          inputFormatters: [UpperCaseTextFormatter()],
          cursorColor: AppColors.primaryColor,
          decoration: InputDecoration(
              hintText: lableText,
              border: InputBorder.none,
              counterText: "",
              hintStyle: TextStyle(fontSize: 19)),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
