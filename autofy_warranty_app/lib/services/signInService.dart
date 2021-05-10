import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class SignInServices {
  static final Dio dio = Dio();

  static Future<String> authenticateUser(
      {required String email, required String password}) async {
    Hive.box('userData');
    var userBox = Hive.box('userData');
    Response<Map<String, dynamic>> response;
    try {
      response = await dio.post(
        "https://wapi.autofystore.com/api/v1/authenticate",
        data: {"username": email, "password": password},
      );
      if (response.statusCode == 200) {
        userBox.put("token", response.data!["token"]);
        return "SuccessFully Logged in";
      }
    } catch (e) {
      String res = e.toString().substring(53, 56);
      print(e.toString());
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
