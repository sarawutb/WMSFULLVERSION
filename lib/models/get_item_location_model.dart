import 'dart:convert';

List<GetltemLocation> getltemLocationFromJson(String str) =>
    List<GetltemLocation>.from(
        json.decode(str).map((x) => GetltemLocation.fromJson(x)));

String getltemLocationToJson(List<GetltemLocation> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetltemLocation {
  GetltemLocation({
    this.rowOrder,
    this.branchCode,
    this.itemCode,
    this.unitCode,
    this.locationName,
    this.lineNumber,
    this.itemName,
    this.creatorCode,
    this.createDate,
  });

  final String? rowOrder;
  final String? branchCode;
  final String? itemCode;
  final String? unitCode;
  final String? locationName;
  final String? lineNumber;
  final String? itemName;
  final String? creatorCode;
  final DateTime? createDate;

  factory GetltemLocation.fromJson(Map<String, dynamic> json) =>
      GetltemLocation(
        rowOrder: json["rowOrder"] == null ? null : json["rowOrder"],
        branchCode: json["branchCode"] == null ? null : json["branchCode"],
        itemCode: json["itemCode"] == null ? null : json["itemCode"],
        unitCode: json["unitCode"] == null ? null : json["unitCode"],
        locationName:
            json["locationName"] == null ? null : json["locationName"],
        lineNumber: json["lineNumber"] == null ? null : json["lineNumber"],
        itemName: json["itemName"] == null ? null : json["itemName"],
        creatorCode: json["creatorCode"] == null ? null : json["creatorCode"],
        createDate: json["createDate"] == null
            ? null
            : DateTime.parse(json["createDate"]),
      );

  Map<String, dynamic> toJson() => {
        "rowOrder": rowOrder == null ? null : rowOrder,
        "branchCode": branchCode == null ? null : branchCode,
        "itemCode": itemCode == null ? null : itemCode,
        "unitCode": unitCode == null ? null : unitCode,
        "locationName": locationName == null ? null : locationName,
        "lineNumber": lineNumber == null ? null : lineNumber,
        "itemName": itemName == null ? null : itemName,
        "creatorCode": creatorCode == null ? null : creatorCode,
        "createDate": createDate == null ? null : createDate!.toIso8601String(),
      };
}
