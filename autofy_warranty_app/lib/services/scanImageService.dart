import 'dart:io';
import 'package:autofy_warranty_app/pages/uploadInvoice/uploadInvoiceController.dart';
import 'package:autofy_warranty_app/services/validateSerialCode.dart';
import 'package:get/get.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

class ScanImageServices {
  UploadInvoiceController _uploadInvoiceController = Get.find();
  Map<String, String> invoiceData = {};
  // this two methods is use for capture warranty code from image and validate it.
  // Method 1 :
  Future captureAndProcessImage() async {
    _uploadInvoiceController.isLoading = true;
    try {
      print("First Call Success");
      File image = await getInvoiceImage();
      int len = await image.length();
      print("Image len: " + len.toString());
      VisionText scanText = await scanImage(image);
      String txt = scanTextFromVisionText(scanText);
      String result = scanWarrantyCode(txt);
      _uploadInvoiceController.isLoading = false;

      if (result.isNotEmpty) {
        _uploadInvoiceController.warrantyCode = result;
        String res = await ValidateSerialCode.validateSerialCode(
          code: _uploadInvoiceController.warrantyCode,
        );
        return res;
      } else {
        return "Not Found";
      }
    } catch (e) {
      print(e.toString());
      _uploadInvoiceController.isLoading = false;
      return "No Image Selected";
    }
  }

  // This method access the camera and fetch image from it.
  // Method 2 :
  Future<File> getInvoiceImage() async {
    ImagePicker picker = ImagePicker();
    var pickedImage = await picker.getImage(source: ImageSource.camera);
    print("second Call Success");
    File image = File(pickedImage!.path);
    return image;
  }

  Future scanInvoice(File invoiceImage) async {
    invoiceData = {};
    VisionText visionText = await scanImage(invoiceImage);
    String invoiceText = scanTextFromVisionText(visionText);
    scanInvoiceData(invoiceText);
    return invoiceData;
  }

  // In this method we have to pass file for recognize vision text.
  Future<VisionText> scanImage(File imageFile) async {
    GoogleVisionImage visionImage = GoogleVisionImage.fromFile(imageFile);
    TextRecognizer textRecognizer = GoogleVision.instance.textRecognizer();
    VisionText visionText = await textRecognizer.processImage(visionImage);
    textRecognizer.close();
    return visionText;
  }

  // In this method we have to pass VisionText and it will return String of result.
  String scanTextFromVisionText(VisionText visionText) {
    String text = "";
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          text = text + word.text! + " ";
        }
        text = text + "\n";
      }
    }

    return text;
  }

  //In this method we have to pass our string and it will check if warranty code exists or not.
  String scanWarrantyCode(String scanText) {
    String myCode;
    RegExp regExp = RegExp(
      r"[a-zA-Z0-9]{4}[\-][a-zA-Z0-9]{4}[\-][a-zA-Z0-9]{4}[\-][a-zA-Z0-9]{4}",
      caseSensitive: false,
      multiLine: false,
    );
    myCode = regExp.stringMatch(scanText.replaceAll(' ', '')) ?? '';
    return myCode;
  }

  void scanInvoiceData(String invoiceText) {
    if (invoiceText.contains("amazon")) {
      scanAsAmazonBill(invoiceText);
    } else {
      scanAsFlipcartBill(invoiceText);
    }
  }

  void scanAsAmazonBill(String invoiceText) {
    invoiceText = invoiceText.replaceAll('\n', '');
    invoiceText = invoiceText.replaceAll(':', '');
    invoiceText = invoiceText.toLowerCase();

    RegExp regExpForShippingAddress = RegExp(
      r"shipping address.*[1-9][0-9]{2}[0-9]{3} in",
      caseSensitive: false,
      multiLine: false,
    );

    RegExp regExpForOrderNo = RegExp(
      r"[0-9]{3}[\-][0-9]{7}[\-][0-9]{7}",
      caseSensitive: false,
      multiLine: false,
    );

    RegExp regExpForInvoiceDate = RegExp(
      r"invoicedate[0-9]{2}.[0-9]{2}.[0-9]{4}",
      caseSensitive: false,
      multiLine: false,
    );

    RegExp regExpForPincode = RegExp(
      r"[1-9]{1}[0-9]{2}[0-9]{3}",
      caseSensitive: false,
      multiLine: false,
    );

    try {
      invoiceData.addAll(
        {"orderNumber": regExpForOrderNo.stringMatch(invoiceText) ?? ""},
      );

      String forDate = invoiceText.replaceAll(' ', '');
      forDate = regExpForInvoiceDate.stringMatch(forDate) ?? "";
      invoiceData.addAll(
        {"invoiceDate": forDate.replaceAll("invoicedate", "")},
      );

      String shippingAdd =
          regExpForShippingAddress.stringMatch(invoiceText) ?? "";
      shippingAdd = shippingAdd.substring(17);

      if (shippingAdd.contains("gst registration")) {
        shippingAdd = shippingAdd.replaceAll(
          RegExp(r"gst registration no [a-zA-Z0-9]{0,15}"),
          "",
        );
      }

      List<String> spiltAddress = shippingAdd.split(",");

      invoiceData.addAll({
        "shippingAddress": shippingAdd,
      });

      invoiceData.addAll(
        {"state": spiltAddress.elementAt(spiltAddress.length - 2).trim()},
      );

      invoiceData.addAll(
        {"postalCode": regExpForPincode.stringMatch(shippingAdd) ?? ""},
      );
    } catch (e) {
      invoiceData = {};
    }
  }

  void scanAsFlipcartBill(String invoiceText) {
    invoiceText = invoiceText.replaceAll('\n', '');
    invoiceText = invoiceText.replaceAll(':', '');
    invoiceText = invoiceText.replaceAll(' ', '');
    invoiceText = invoiceText.toLowerCase();
    // leg:20

    RegExp regExpForInvoiceDate = RegExp(
      r"invoicedate[0-9]{2}-[0-9]{2}-[0-9]{4}",
      caseSensitive: false,
      multiLine: false,
    );
    RegExp regExpForOrderNoWithI = RegExp(
      r"orderid[A-Za-z0-9]{20}",
      caseSensitive: false,
      multiLine: false,
    );
    // This is because OCR not able to differciet L and I
    RegExp regExpForOrderNoWithL = RegExp(
      r"orderld[A-Za-z0-9]{20}",
      caseSensitive: false,
      multiLine: false,
    );

    String forDate = "";
    forDate = regExpForInvoiceDate.stringMatch(invoiceText) ?? "";

    invoiceData.addAll(
      {"invoiceDate": forDate.replaceAll("invoicedate", "")},
    );

    String forOderId = regExpForOrderNoWithI.stringMatch(invoiceText) ?? "";
    forOderId = forOderId.replaceAll("orderid", "");
    if (forOderId.isEmpty) {
      forOderId = regExpForOrderNoWithL.stringMatch(invoiceText) ?? "";
      forOderId = forOderId.replaceAll("orderld", "");
    }

    invoiceData.addAll(
      {"orderNumber": forOderId},
    );
  }
}
