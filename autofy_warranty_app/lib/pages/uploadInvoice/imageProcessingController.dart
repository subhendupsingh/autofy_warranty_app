import 'dart:io';

import 'package:get/get.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

class ImageProcessingController extends GetxController {
  bool _capturingImage = false;
  String _warrentyCode = "";
  bool _validatedSuccessfully = false;

  final ImagePicker picker = ImagePicker();

  String get warrentyCode => _warrentyCode;

  set warrentyCode(String val) {
    _warrentyCode = val;
    update();
  }

  bool get validatedSuccessfully => _validatedSuccessfully;

  set validatedSuccessfully(bool val) {
    _validatedSuccessfully = val;
    update();
  }

  bool get capturingImage => _capturingImage;

  set capturingImage(bool val) {
    _capturingImage = val;
    update();
  }

  Future captureAndProcessImage(String imageType) async {
    capturingImage = true;
    try {
      File image = await getImage();
      VisionText scanText = await scanImage(image);
      String txt = scanTextFromVisionText(scanText);
      String result = "";
      if (imageType == "warrentyCard") {
        result = scanWarrentyCode(txt);
      }

      capturingImage = false;
      if (result.isEmpty) {
        return "Not Found";
      } else {
        warrentyCode = result;
        return "Please Check Your Code";
      }
    } catch (e) {
      capturingImage = false;
      return "No Image Selected";
    }
  }

  Future<File> getImage() async {
    var pickedImage = await picker.getImage(source: ImageSource.camera);
    File image = File(pickedImage!.path);
    return image;
  }

  Future<VisionText> scanImage(File imageFile) async {
    GoogleVisionImage visionImage = GoogleVisionImage.fromFile(imageFile);
    TextRecognizer textRecognizer = GoogleVision.instance.textRecognizer();
    VisionText visionText = await textRecognizer.processImage(visionImage);
    textRecognizer.close();
    return visionText;
  }

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

  String scanWarrentyCode(String scanText) {
    String myCode;
    RegExp regExp = RegExp(
      r"[a-zA-Z0-9]{4}[\-][a-zA-Z0-9]{4}[\-][a-zA-Z0-9]{4}[\-][a-zA-Z0-9]{4}",
      caseSensitive: false,
      multiLine: false,
    );
    myCode = regExp.stringMatch(scanText.replaceAll(' ', '')) ?? '';
    return myCode;
  }
}
