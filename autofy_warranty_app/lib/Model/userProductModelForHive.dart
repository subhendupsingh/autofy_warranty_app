import 'package:hive/hive.dart';

part 'userProductModelForHive.g.dart';

@HiveType(typeId: 0)
class UserProductModelForHive {
  @HiveField(0)
  String? productName;

  @HiveField(1)
  String? productSKU;

  @HiveField(2)
  String? productImageURL;

  @HiveField(3)
  String? warrantyCode;

  @HiveField(4)
  String? warrantyExpiryDate;

  @HiveField(5)
  String? warrantyStatus;

  @HiveField(6)
  int? numberOfRepairRequestsLeft;

  @HiveField(7)
  bool? showRepairButton;

  @HiveField(8)
  String? purchaseDate;

  UserProductModelForHive({
    this.productName,
    this.productSKU,
    this.productImageURL,
    this.warrantyCode,
    this.warrantyExpiryDate,
    this.warrantyStatus,
    this.numberOfRepairRequestsLeft,
    this.showRepairButton,
    this.purchaseDate,
  });
}
