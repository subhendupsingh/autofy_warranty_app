import 'dart:convert';

TrackerResponse trackerResponseFromJson(String str) =>
    TrackerResponse.fromJson(json.decode(str));

String trackerResponseToJson(TrackerResponse data) =>
    json.encode(data.toJson());

class TrackerResponse {
  TrackerResponse({
    this.trackingResOne,
    this.trackingResThree,
    required this.statusCode,
    required this.status,
  });

  TrackingResOne? trackingResOne;
  TrackingResThree? trackingResThree;
  int statusCode;
  String status;

  factory TrackerResponse.fromJson(Map<String, dynamic> json) =>
      TrackerResponse(
        trackingResThree: json["tracking"] == null
            ? null
            : TrackingResThree.fromRawJson(
                json["tracking"],
              ),
        statusCode: json["statusCode"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "tracking": trackingResOne == null
            ? trackingResThree.toString()
            : trackingResOne.toString(),
        "statusCode": statusCode,
        "status": status,
      };
}

class TrackingResOne {
  TrackingResOne({
    this.awbNo,
    this.carrierName,
    this.allData,
    this.events,
  });

  String? awbNo;
  String? carrierName;
  AllData? allData;
  List<EventOne>? events;

  factory TrackingResOne.fromRawJson(String str) =>
      TrackingResOne.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TrackingResOne.fromJson(Map<String, dynamic> json) => TrackingResOne(
        awbNo: json["awbNo"] == null ? null : json["awbNo"],
        carrierName: json["carrierName"] == null ? null : json["carrierName"],
        allData:
            json["allData"] == null ? null : AllData.fromJson(json["allData"]),
        events: json["events"] == null
            ? null
            : List<EventOne>.from(
                json["events"].map((x) => EventOne.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "awbNo": awbNo == null ? null : awbNo,
        "carrierName": carrierName == null ? null : carrierName,
        "allData": allData == null ? null : allData?.toJson(),
        "events": events == null
            ? null
            : List<dynamic>.from(events!.map((x) => x.toJson())),
      };
}

class TrackingResThree {
  TrackingResThree({
    this.data,
  });

  Data? data;

  factory TrackingResThree.fromRawJson(String str) =>
      TrackingResThree.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TrackingResThree.fromJson(Map<String, dynamic> json) =>
      TrackingResThree(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data?.toJson(),
      };
}

class Data {
  Data({
    this.awbNo,
    this.carrierName,
    this.allData,
    this.events,
  });

  String? awbNo;
  String? carrierName;
  AllData? allData;
  List<EventThree>? events;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        awbNo: json["awbNo"] == null ? null : json["awbNo"],
        carrierName: json["carrierName"] == null ? null : json["carrierName"],
        allData:
            json["allData"] == null ? null : AllData.fromJson(json["allData"]),
        events: json["events"] == null
            ? null
            : List<EventThree>.from(
                json["events"].map((x) => EventThree.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "awbNo": awbNo == null ? null : awbNo,
        "carrierName": carrierName == null ? null : carrierName,
        "allData": allData == null ? null : allData?.toJson(),
        "events": events == null
            ? null
            : List<dynamic>.from(events!.map((x) => x.toJson())),
      };
}

class AllData {
  AllData({
    this.id,
    this.awbNo,
    this.childAwbId,
    this.returnOrReverse,
    this.expectedDeliveryDate,
    this.updated,
    this.carrierName,
    this.cancelled,
  });

  int? id;
  String? awbNo;
  dynamic? childAwbId;
  bool? returnOrReverse;
  DateTime? expectedDeliveryDate;
  DateTime? updated;
  String? carrierName;
  bool? cancelled;

  factory AllData.fromRawJson(String str) => AllData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllData.fromJson(Map<String, dynamic> json) => AllData(
        id: json["id"] == null ? null : json["id"],
        awbNo: json["awbNo"] == null ? null : json["awbNo"],
        childAwbId: json["childAwbID"],
        returnOrReverse:
            json["returnOrReverse"] == null ? null : json["returnOrReverse"],
        expectedDeliveryDate: json["expectedDeliveryDate"] == null
            ? null
            : DateTime.parse(json["expectedDeliveryDate"]),
        updated:
            json["updated"] == null ? null : DateTime.parse(json["updated"]),
        carrierName: json["carrierName"] == null ? null : json["carrierName"],
        cancelled: json["cancelled"] == null ? null : json["cancelled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "awbNo": awbNo == null ? null : awbNo,
        "childAwbID": childAwbId,
        "returnOrReverse": returnOrReverse == null ? null : returnOrReverse,
        "expectedDeliveryDate": expectedDeliveryDate == null
            ? null
            : expectedDeliveryDate?.toIso8601String(),
        "updated": updated == null ? null : updated?.toIso8601String(),
        "carrierName": carrierName == null ? null : carrierName,
        "cancelled": cancelled == null ? null : cancelled,
      };
}

class EventOne {
  EventOne({
    this.status,
    this.remarks,
    this.location,
    this.time,
  });

  String? status;
  String? remarks;
  String? location;
  DateTime? time;

  factory EventOne.fromRawJson(String str) =>
      EventOne.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventOne.fromJson(Map<String, dynamic> json) => EventOne(
        status: json["status"] == null ? null : json["status"],
        remarks: json["remarks"] == null ? null : json["remarks"],
        location: json["location"] == null ? null : json["location"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "remarks": remarks == null ? null : remarks,
        "location": location == null ? null : location,
        "time": time == null ? null : time?.toIso8601String(),
      };
}

class EventThree {
  EventThree({
    this.status,
    this.remarks,
    this.location,
    this.time,
  });

  String? status;
  String? remarks;
  String? location;
  DateTime? time;

  factory EventThree.fromRawJson(String str) =>
      EventThree.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventThree.fromJson(Map<String, dynamic> json) => EventThree(
        status: json["status"] == null ? null : json["status"],
        remarks: json["Remarks"] == null ? null : json["Remarks"],
        location: json["Location"] == null ? null : json["Location"],
        time: json["Time"] == null ? null : DateTime.parse(json["Time"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "Remarks": remarks == null ? null : remarks,
        "Location": location == null ? null : location,
        "Time": time == null ? null : time?.toIso8601String(),
      };
}
