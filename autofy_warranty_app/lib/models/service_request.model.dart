// To parse this JSON data, do
//
//     final serviceRequestModel = serviceRequestModelFromJson(jsonString);

import 'dart:convert';

class ServiceRequestModel {
  ServiceRequestModel({
    required this.serviceRequestNumber,
    required this.created,
    required this.warrantyCode,
    required this.productSku,
    required this.productName,
    required this.productImageUrl,
    required this.reversePickupCreated,
    required this.statusCode,
  });

  String serviceRequestNumber;
  String created;
  String warrantyCode;
  String productSku;
  String productName;
  String productImageUrl;
  bool reversePickupCreated;
  int statusCode;

  factory ServiceRequestModel.fromRawJson(String str) =>
      ServiceRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) =>
      ServiceRequestModel(
          serviceRequestNumber: json["serviceRequestNumber"],
          created: json["created"],
          warrantyCode: json["warrantyCode"],
          productSku: json["productSKU"],
          productName: json["productName"],
          productImageUrl: json["productImageURL"],
          reversePickupCreated: json["reversePickupCreated"],
          statusCode: json["statusCode"]);

  Map<String, dynamic> toJson() => {
        "serviceRequestNumber": serviceRequestNumber,
        "created": created,
        "warrantyCode": warrantyCode,
        "productSKU": productSku,
        "productName": productName,
        "productImageURL": productImageUrl,
        "reversePickupCreated": reversePickupCreated,
        "statusCode": statusCode,
      };
}
