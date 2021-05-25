import 'package:autofy_warranty_app/services/localStorageService.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class SignInServices {
  static final Dio dio = Dio();

  static Future<String> authenticateUser(
      {required String email, required String password}) async {
    Response<Map<String, dynamic>> response;
    try {
      response = await dio.post(
        "https://wapi.autofystore.com/api/v1/authenticate",
        data: {"username": email, "password": password},
      );
      if (response.statusCode == 200) {
        LocalStoragaeService.updateUserData(
          {
            UserField.Token: response.data!["token"],
            UserField.Id: response.data!["id"].toString(),
            UserField.Address: response.data!["email"],
            UserField.Phone: response.data!["phone"],
          },
        );
        return "SuccessFully Logged in";
      }
    } catch (e) {
      String res = e.toString().substring(53, 56);
      if (res == "401") {
        return "Invalid email or password";
      } else if (res == "500") {
        return "Internal server error";
      } else {
        return "Something want wrong";
      }
    }
    return "";
  }
}
