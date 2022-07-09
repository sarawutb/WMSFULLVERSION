// To parse this JSON data, do
//
//     final listItem = listItemFromJson(jsonString);

import 'dart:convert';

class ListItem {
  ListItem({
    this.value,
    this.name,
  });

  String? value;
  String? name;

  factory ListItem.fromRawJson(String str) =>
      ListItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListItem.fromJson(Map<String, dynamic> json) => ListItem(
        value: json["value"] == null ? null : json["value"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "value": value == null ? null : value,
        "name": name == null ? null : name,
      };
}
