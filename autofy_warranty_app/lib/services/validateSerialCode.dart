import 'package:autofy_warranty_app/services/localStorageService.dart';
import 'package:dio/dio.dart';

class ValidateSerialCode {
  static final Dio dio = Dio();

  static Future<String> validateSerialCode({String code = ""}) async {
    String token = LocalStoragaeService.getUserValue(UserField.Token);
    int userId = LocalStoragaeService.getUserValue(UserField.Id);

    FormData formData = FormData.fromMap({"code": code, "user_id": userId});

    Response<Map<String, dynamic>> response;
    try {
      response = await dio.post(
        "https://wapi.autofystore.com/api/v1/warranty/validate",
        options: Options(
          headers: {
            "Authorization": "Bearer " + token,
          },
        ),
        data: formData,
      );
      if (response.statusCode == 200) {
        return response.data!["message"];
      }
    } on DioError catch (e) {
      return e.response!.data["message"];
    } catch (e) {
      return "Validation Failed";
    }
    return "";
  }
}
