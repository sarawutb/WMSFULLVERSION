import 'dart:convert';

class Locations {
  Locations({
    this.location,
  });

  String? location;

  factory Locations.fromRawJson(String str) =>
      Locations.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Locations.fromJson(Map<String, dynamic> json) => Locations(
        location: json["location"] == null ? null : json["location"],
      );

  Map<String, dynamic> toJson() => {
        "location": location == null ? null : location,
      };
}
