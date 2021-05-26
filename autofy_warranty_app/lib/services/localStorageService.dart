import 'package:hive/hive.dart';

final kUserDataBoxName = "UserData";

enum UserField {
  Id,
  Name,
  Email,
  Phone,
  Address,
  State,
  City,
  PostalCode,
  Token,
}

extension UserFieldExtension on UserField {
  String get asString {
    switch (this) {
      case UserField.Id:
        return "id";
      case UserField.Name:
        return "name";
      case UserField.Email:
        return "email";
      case UserField.Phone:
        return "phone";
      case UserField.Address:
        return "address";
      case UserField.State:
        return "state";
      case UserField.City:
        return "city";
      case UserField.PostalCode:
        return "postalCode";
      case UserField.Token:
        return "token";
      default:
        return "";
    }
  }
}

class LocalStoragaeService {
  static var userDataBox = Hive.box(kUserDataBoxName);

  static void updateUserData(Map<String, dynamic> userData) {
    userData.forEach((key, value) async {
      await userDataBox.put(key, value ?? "");
    });
  }

  static dynamic getUserValue(UserField userField) {
    return userDataBox.get(userField.asString);
  }
}
