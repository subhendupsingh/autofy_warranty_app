import 'dart:io';

import 'package:autofy_warranty_app/controllers/ocrController.dart';
import 'package:autofy_warranty_app/services/scanImageService.dart';
import 'package:autofy_warranty_app/services/uploadFile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class UploadInvoiceController extends GetxController {
  bool _isLoading = false,
      _isFileSizeExceed = false,
      _isFileIncorrect = false,
      _isFileUploaded = false,
      _isFileUploading = false,
      _validatedSuccessfully = false,
      _showValidateFileMsg = false,
      _showValidateWarrentyMsg = false;

  late Map<String, String> invoiceData = {};
  String _warrentyCode = "";

  late File _invoiceFile;

  File get invoiceFile => _invoiceFile;

  set invoiceFile(File val) {
    _invoiceFile = val;
    update();
  }

  Future filePicker(ScanImageServices imageServices) async {
    isFileUploading = true;
    FilePickerResult result = await FilePicker.platform.pickFiles(
          allowedExtensions: ["jpg", "jpeg", "png", "pdf"],
          type: FileType.custom,
        ) ??
        FilePickerResult([]);
    if (result.count == 1) {
      PlatformFile platformFile = result.files.first;
      if (platformFile.size! < 10000000) {
        invoiceFile = File(result.files.single.path!);
        String msg;
        if (platformFile.extension == "jpg" ||
            platformFile.extension == "png" ||
            platformFile.extension == "jpeg") {
          msg = await UploadFile.uploadInvoice(invoiceFile, warrentyCode);
          if (msg == "File uploaded sucessfully") {
            invoiceData = await imageServices.scanInvoice(invoiceFile);
            isFileUploaded = true;
          } else if (msg ==
              "Only JPG, JPEG, PNG & PDF file types are allowed") {
            isFileIncorrect = true;
          } else {
            isFileUploaded = false;
          }
        } else if (platformFile.extension == "pdf") {
          //@Vamsi PDF READER FUNCTION CALL FROM HERE AND DATA WILL BE STORE IN INVOICEDATA MAP
          OcrController ocrController = Get.find<OcrController>();

          invoiceData = await ocrController.extractionLogicForPdf(
              filePath: platformFile.path);

          isFileUploaded = true;
          print("PDF file");
          print("File Uploaded Successfully");
        } else {
          isFileIncorrect = true;
        }
      } else
        isFileSizeExceed = true;
    } else
      isFileUploaded = false;

    isFileUploading = false;
  }

  bool get showValidateFileMsg => _showValidateFileMsg;

  set showValidateFileMsg(bool val) {
    _showValidateFileMsg = val;
    update();
  }

  bool get showValidateWarrentyMsg => _showValidateWarrentyMsg;

  set showValidateWarrentyMsg(bool val) {
    _showValidateWarrentyMsg = val;
    update();
  }

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

  bool get isLoading => _isLoading;

  set isLoading(bool val) {
    _isLoading = val;
    update();
  }

  bool get isFileSizeExceed => _isFileSizeExceed;

  set isFileSizeExceed(bool val) {
    _isFileSizeExceed = val;
    update();
  }

  bool get isFileIncorrect => _isFileIncorrect;

  set isFileIncorrect(bool val) {
    _isFileIncorrect = val;
    update();
  }

  bool get isFileUploading => _isFileUploading;

  set isFileUploading(bool val) {
    _isFileUploading = val;
    update();
  }

  bool get isFileUploaded => _isFileUploaded;

  set isFileUploaded(bool val) {
    _isFileUploaded = val;
    update();
  }
}
