import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path/path.dart' as p;

class OcrController extends GetxController {
  // To pick file from the device
  // Future<List<dynamic>> pickFileFromDevice() async {
  //   List<dynamic> result = [];
  //   FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ["pdf", "jpg", "png", "jpeg"],
  //   );
  //   if (pickedFile != null) {
  //     PlatformFile file = pickedFile.files.first;
  //     print(file.extension);
  //     if (file.size! < 10000000) {
  //       //checking if size is less than 10MB
  //       File myFile = File(file.path!);
  //       result.add(myFile);
  //       result.add(myFile.path);
  //     } else {
  //       Get.snackbar(
  //           "PDF size is greater than 10MB", "Please select another file",
  //           colorText: Colors.red, backgroundColor: Colors.white);
  //     }
  //   }
  //   return result;
  // }

  // extractDataFromFile({List<dynamic>? fileData}) async {
  //   extractionLogicForPdf(file: fileData?[1]);
  // }

  extractionLogicForPdf({String? filePath}) {
    print("what????");
    //final results
    String? portal;
    String? orderNumber;
    String? address;
    String? pinCode;
    String? name;
    String? invoiceDate;
    String? state;
    //Regex
    String? fkOIRegex = r"OD[0-9]{18}";
    String? aOIRegex = r"[0-9]{3}[\-][0-9]{7}[\-][0-9]{7}";
    String? shippingRegex = r"shippingaddress(.*?)([1-9]{1}[0-9]{2}[0-9]{3})";
    String? amaPortalRegex = r"amazon";
    String? fkPortalRegex = r"flipkart";
    String? fkDateReg = r"invoicedate([0-9]{2}\-[0-9]{2}\-[0-9]{4})";
    String? amaDateReg = r"invoicedate([0-9]{2}\.[0-9]{2}\.[0-9]{4})";
    String? shippingIfFailsRegex = r"shipto(.*?)([1-9]{1}[0-9]{2}[0-9]{3})";
    String? kNotFound = "NOTFOUND";

    //logic
    File myFile = File(filePath!);
    print(p.extension(filePath));
    if (p.extension(filePath) != ".pdf") return {};
    PdfDocument pdfDocument = PdfDocument(inputBytes: myFile.readAsBytesSync());

    PdfTextExtractor extractor = PdfTextExtractor(pdfDocument);

    String text = extractor.extractText();
    text = text.replaceAll(":", "");
    text = text.replaceAll(RegExp(r"\s+"), "");
    text = text.replaceAll("\n", "");
    text = text.trim();
    portal = findStringMatch(regex: amaPortalRegex, text: text) ??
        findStringMatch(regex: fkPortalRegex, text: text);
    // ? findStringMatch(regex: fkPortalRegex, text: text)
    // : findStringMatch(regex: amaPortalRegex, text: text);

    //if portal is amazon
    if (portal?.toLowerCase() == "amazon") {
      orderNumber = findStringMatch(regex: aOIRegex, text: text);

      invoiceDate = findFirstMatch(regex: amaDateReg, text: text)?.group(1);

      address = findFirstMatch(regex: shippingRegex, text: text)?.group(1);
      pinCode = findFirstMatch(regex: shippingRegex, text: text)?.group(2);
      name = findFirstMatch(regex: shippingRegex, text: text)
          ?.group(1)
          ?.split(',')
          ?.first;
    }

    //if portal is flipkart
    if (portal?.toLowerCase() == "flipkart") {
      orderNumber = findStringMatch(regex: fkOIRegex, text: text);
      invoiceDate = findFirstMatch(regex: fkDateReg, text: text)?.group(1);
      address =
          address = findFirstMatch(regex: shippingRegex, text: text)?.group(1);
      if (address != null) {
        pinCode = findFirstMatch(regex: shippingRegex, text: text)?.group(2);
        name = findFirstMatch(regex: shippingRegex, text: text)
            ?.group(1)
            ?.split(',')
            ?.first;
      } else {
        address =
            findFirstMatch(regex: shippingIfFailsRegex, text: text)?.group(1);
        pinCode =
            findFirstMatch(regex: shippingIfFailsRegex, text: text)?.group(2);
        name = findFirstMatch(regex: shippingIfFailsRegex, text: text)
            ?.group(1)
            ?.split(',')
            ?.first;
      }
    }

    var result = {
      "portal": portal ?? kNotFound,
      "invoiceDate": invoiceDate ?? kNotFound,
      "orderNumber": orderNumber ?? kNotFound,
      "postalCode": pinCode ?? kNotFound,
      "name": name ?? kNotFound,
      "shippingAddress": address ?? kNotFound,
      "state": state ?? kNotFound,
    };
    return result;
  }

  findStringMatch({String? regex, String? text}) {
    return RegExp(
      regex!,
      multiLine: false,
      caseSensitive: false,
    ).stringMatch(text!);
  }

  findFirstMatch({String? regex, String? text}) {
    return RegExp(
      regex!,
      multiLine: false,
      caseSensitive: false,
    ).firstMatch(text!);
  }
}
