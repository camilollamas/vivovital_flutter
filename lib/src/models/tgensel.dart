import 'dart:convert';

List<Tgensel> tgenselFromJson(String str) => List<Tgensel>.from(json.decode(str).map((x) => Tgensel.fromJson(x)));

String tgenselToJson(List<Tgensel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tgensel {
  Tgensel({
    this.value,
    this.label,
  });

  String? value;
  String? label;

  factory Tgensel.fromJson(Map<String, dynamic> json) => Tgensel(
    value: json["value"],
    label: json["label"],
  );

  static List<Tgensel> fromJsonList(List<dynamic> jsonList){
    List<Tgensel> toList = [];
    for (var tgensel in jsonList) {
      Tgensel tgen = Tgensel.fromJson(tgensel);
      toList.add(tgen);
    }

    return toList;
  }

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
  };
}