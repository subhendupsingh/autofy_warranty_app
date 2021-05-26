import 'package:autofy_warranty_app/services/localStorageService.dart';
import 'package:dio/dio.dart';

class UploadFile {
  static String baseURL = "https://wapi.autofystore.com/";
  static Dio dio = Dio();
  static String token = LocalStoragaeService.getUserValue(UserField.Token);
  static Future uploadInvoice(String url, FormData formData) async {
    try {
      Response response = await dio.post(
        baseURL + url,
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
