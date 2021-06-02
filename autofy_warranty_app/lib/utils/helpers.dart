import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

emptyVerticalBox({double height = 20}) => SizedBox(height: height);
emptyHorizontalBox({double width = 20}) => SizedBox(width: width);
String formatDate(DateTime? dateTime) {
  final template = DateFormat('dd-MM-yyyy');
  return template.format(dateTime!);
}
