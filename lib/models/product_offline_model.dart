import 'dart:convert';

class ProductLocal {
  ProductLocal({
    this.id,
    this.location,
    this.productcode,
    this.count,
    this.createCurrent,
    this.productname,
  });

  int? id;
  String? location;
  String? productcode;
  String? count;
  DateTime? createCurrent;
  String? productname;

  factory ProductLocal.fromRawJson(String str) =>
      ProductLocal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductLocal.fromJson(Map<String, dynamic> json) => ProductLocal(
        id: json["id"] ?? null,
        location: json["location"] ?? null,
        productcode: json["productcode"] ?? null,
        count: json["count"] ?? null,
        createCurrent: json["create_current"] == null
            ? null
            : DateTime.parse(json["create_current"]),
        productname: json["productname"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "location": location ?? null,
        "productcode": productcode ?? null,
        "count": count ?? null,
        "create_current":
            createCurrent == null ? null : createCurrent?.toIso8601String(),
        "productname": productname ?? null,
      };
}
