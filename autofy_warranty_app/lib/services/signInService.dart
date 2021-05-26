import 'package:autofy_warranty_app/services/localStorageService.dart';
import 'package:dio/dio.dart';

class SignInServices {
  static final Dio dio = Dio();

  static Future<String> authenticateUser(
      {required String email, required String password}) async {
    Response response;
    try {
      response = await dio.post(
        "https://wapi.autofystore.com/api/v1/authenticate",
        data: {"username": email, "password": password},
      );
      print(response.data);
      if (response.statusCode == 200) {
        LocalStoragaeService.updateUserData(response.data);
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
