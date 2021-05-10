import 'package:autofy_warranty_app/pages/forgotPassword/forgotPassword.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class ResetPasswordService {
  static final Dio dio = Dio();
  static Future<String> sendOtp({String phoneNo = ""}) async {
    Hive.box('userData');
    var userBox = Hive.box('userData');
    try {
      FormData formData = FormData.fromMap({"phone_number": phoneNo});
      userBox.put("phoneNoForResetPassword", phoneNo);
      Response<Map<String, dynamic>> response = await dio.post(
        "https://wapi.autofystore.com/api/v1/otp/send",
        data: formData,
      );
      if (response.statusCode == 200) {
        if (response.data!["smssent"]) {
          print(response.data!["otp"]);
          userBox.put("userIdForResetPassword", response.data!["userId"]);
          return "OTP Send Successfully";
        }
        return "Something Want wrong";
      }
    } catch (e) {
      String res = e.toString().substring(53, 56);
      if (res == "400") {
        return "mobile number is not registered";
      } else {
        return "Something Want wrong";
      }
    }
    return "Something Want wrong";
  }

  static Future<String> authenticateOtp(
      {String userId = "", String otp = ""}) async {
    try {
      Response<Map<String, dynamic>> response = await dio.get(
        "https://wapi.autofystore.com/api/v1/otp/validate",
        queryParameters: {
          "user_id": userId,
          "otp": otp,
        },
      );
      print(response.data.toString());
      if (response.data!["message"] == "true") {
        return "You are verified";
      } else {
        return "Invalid OTP";
      }
    } catch (e) {
      print(e);
      return "Something Want wrong";
    }
  }

  static Future<String> resetPasswordService(
      {String userId = "", String password = ""}) async {
    Hive.box('userData');
    try {
      FormData formData =
          FormData.fromMap({"userId": userId, "password": password});
      Response<Map<String, dynamic>> response = await dio.post(
        "https://wapi.autofystore.com/api/v1/user/changePassword",
        data: formData,
      );
      if (response.statusCode == 200) {
        print(response.data.toString());
        return "Password changed";
      }
    } catch (e) {
      print(e);
      return "Something Want wrong";
    }
    return "Something Want wrong";
  }
}
