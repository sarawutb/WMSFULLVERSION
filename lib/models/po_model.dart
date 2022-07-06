import 'dart:convert';

class Po {
  Po({
    this.supplier,
    this.poLists,
  });

  Supplier? supplier;
  List<String>? poLists;

  factory Po.fromRawJson(String str) => Po.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Po.fromJson(Map<String, dynamic> json) => Po(
        supplier: json["supplier"] == null
            ? null
            : Supplier.fromJson(json["supplier"]),
        poLists: json["poLists"] == null
            ? null
            : List<String>.from(json["poLists"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "supplier": supplier == null ? null : supplier!.toJson(),
        "poLists":
            poLists == null ? null : List<dynamic>.from(poLists!.map((x) => x)),
      };
}

class Supplier {
  Supplier({
    this.code,
    this.name,
  });

  String? code;
  String? name;

  factory Supplier.fromRawJson(String str) =>
      Supplier.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "name": name == null ? null : name,
      };
}
