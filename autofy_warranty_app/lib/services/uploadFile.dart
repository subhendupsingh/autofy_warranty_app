import 'dart:io';

import 'package:autofy_warranty_app/services/localStorageService.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class UploadFile {
  static String baseURL = "https://wapi.autofystore.com/";
  static Dio dio = Dio();
  static String token = LocalStoragaeService.getUserValue(UserField.Token);
  static Future uploadInvoice(File invoiceFile, String warrantyCode) async {
    try {
      late MediaType contentType;
      String fileName = path.basename(invoiceFile.path);
      List<String> tm = fileName.split('.');
      if (tm[tm.length - 1] == "jpg" || tm[tm.length - 1] == "jpeg") {
        contentType = MediaType("image", "jpeg");
      } else if (tm[tm.length - 1] == "png") {
        contentType = MediaType("image", "jpeg");
      } else if (tm[tm.length - 1] == "pdf") {
        contentType = MediaType("application", "pdf");
      }

      var formData = FormData.fromMap(
        {
          "warranty_code": warrantyCode,
          "file": await MultipartFile.fromFile(
            invoiceFile.path,
            filename: fileName,
            contentType: contentType,
          ),
        },
      );
      // print("1) " +
      //     invoiceFile.path +
      //     "\n" +
      //     "2) " +
      //     path.basename(invoiceFile.path));

      Response response = await dio.post(
        baseURL + 'api/v1/file/upload',
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer " + token, "Accept": "*/*"},
        ),
      );

      if (response.statusCode == 200) {
        return response.data!["message"];
      }
    } on DioError catch (e) {
      return e.response!.data["message"];
    } catch (e) {
      return "Something went";
    }
  }
}
