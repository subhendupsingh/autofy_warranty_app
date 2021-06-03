import 'package:autofy_warranty_app/Model/userProductModelForHive.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
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
  static Box<UserProductModelForHive> userProductBox =
      Hive.box(BoxNames.userProductBoxName);

  static Future<bool> deleteUserData() async {
    bool isDone = false;
    try {
      await userDataBox.clear();
      await userProductBox.clear();
      isDone = true;
    } catch (e) {
      print(e);
    }
    return isDone;
  }

  static void updateUserData(Map<dynamic, dynamic> userData) {
    userData.forEach((key, value) async {
      await userDataBox.put(key, value);
    });
  }

  static dynamic getUserValue(UserField userField) {
    return userDataBox.get(userField.asString);
  }

  static Future addUserProductData(
      {List<dynamic>? userProductsResponce}) async {
    await userProductBox.clear();
    userProductsResponce!.forEach(
      (element) async {
        Map<String, dynamic> userProductRecord =
            element as Map<String, dynamic>;
        UserProductModelForHive userProductModel = UserProductModelForHive(
          productName: userProductRecord["productName"],
          productSKU: userProductRecord["productSKU"],
          productImageURL: userProductRecord["productImageURL"],
          warrantyCode: userProductRecord["warrantyCode"],
          warrantyExpiryDate: userProductRecord["warrantyExpiryDate"],
          warrantyStatus: userProductRecord["warrantyStatus"],
          numberOfRepairRequestsLeft:
              userProductRecord["numberOfRepairRequestsLeft"],
          showRepairButton: userProductRecord["showRepairButton"],
        );
        await userProductBox.add(userProductModel);
      },
    );
    print("Total Items: " + userProductBox.length.toString());
  }
}
