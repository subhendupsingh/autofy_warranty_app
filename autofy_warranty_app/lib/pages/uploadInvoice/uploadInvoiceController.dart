import 'dart:io';

import 'package:autofy_warranty_app/controllers/ocrController.dart';
import 'package:autofy_warranty_app/services/scanImageService.dart';
import 'package:autofy_warranty_app/services/uploadFile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class UploadInvoiceController extends GetxController {
  bool _isLoading = false,
      _isFileSizeExceed = false,
      _isFileIncorrect = false,
      _isFileUploaded = false,
      _isFileUploading = false,
      _isFileSelected = true,
      _validatedSuccessfully = false,
      _isCodeLenError = false,
      _showValidateFileMsg = false,
      _showValidateWarrantyMsg = false;

  late Map<String, String> invoiceData = {};
  String _warrantyCode = "";

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
      if (platformFile.size < 10000000) {
        invoiceFile = File(result.files.single.path!);
        String msg;
        if (platformFile.extension == "jpg" ||
            platformFile.extension == "png" ||
            platformFile.extension == "jpeg") {
          msg = await callUploadService(
              invoiceFile, warrantyCode, 'api/v1/file/upload');
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
          msg = await callUploadService(
              invoiceFile, warrantyCode, 'api/v1/file/upload');
          if (msg == "File uploaded sucessfully") {
            OcrController ocrController = Get.find<OcrController>();

            invoiceData = await ocrController.extractionLogicForPdf(
                filePath: platformFile.path);
            isFileUploaded = true;
          } else if (msg ==
              "Only JPG, JPEG, PNG & PDF file types are allowed") {
            isFileIncorrect = true;
          } else {
            isFileUploaded = false;
          }
          print("PDF file");
          print("File Uploaded Successfully");
        } else {
          isFileIncorrect = true;
        }
      } else
        isFileSizeExceed = true;
    } else
      isFileSelected = false;

    isFileUploading = false;
  }

  Future<String> callUploadService(
      File file, String warrantyCode, String url) async {
    late MediaType contentType;
    String fileName = path.basename(file.path);
    List<String> tm = fileName.split('.');
    if (tm[tm.length - 1] == "jpg" || tm[tm.length - 1] == "jpeg") {
      contentType = MediaType("image", "jpeg");
    } else if (tm[tm.length - 1] == "png") {
      contentType = MediaType("image", "jpeg");
    } else if (tm[tm.length - 1] == "pdf") {
      contentType = MediaType("application", "pdf");
    }
    String msg = "";
    var formData = dio.FormData.fromMap(
      {
        "warranty_code": warrantyCode,
        "file": await dio.MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: contentType,
        ),
      },
    );
    msg = await UploadFile.uploadInvoice('api/v1/file/upload', formData);
    print("kunj" + msg);
    return msg;
  }

  bool get showValidateFileMsg => _showValidateFileMsg;

  set showValidateFileMsg(bool val) {
    _showValidateFileMsg = val;
    update();
  }

  bool get isFileSelected => _isFileSelected;

  set isFileSelected(bool val) {
    _isFileSelected = val;
    update();
  }

  bool get isCodeLenError => _isCodeLenError;

  set isCodeLenError(bool val) {
    _isCodeLenError = val;
    update();
  }

  bool get showValidateWarrantyMsg => _showValidateWarrantyMsg;

  set showValidateWarrantyMsg(bool val) {
    _showValidateWarrantyMsg = val;
    update();
  }

  String get warrantyCode => _warrantyCode;

  set warrantyCode(String val) {
    _warrantyCode = val;
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
