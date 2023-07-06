// To parse this JSON data, do
//
//     final dia = diaFromJson(jsonString);

import 'dart:convert';
List<Dia> mesesFromJson(String str) => List<Dia>.from(json.decode(str).map((x) => Dia.fromJson(x)));

Dia diaFromJson(String str) => Dia.fromJson(json.decode(str));

String diaToJson(Dia data) => json.encode(data.toJson());

class Dia {
    String? dia;

    Dia({
        this.dia,
    });

    factory Dia.fromJson(Map<String, dynamic> json) => Dia(
        dia: json["DIA"],
    );

    static List<Dia> fromJsonList(List<dynamic> jsonList){
      List<Dia> toList = [];
      jsonList.forEach((day) {
        Dia da = Dia.fromJson(day);
        toList.add(da);
      });
      return toList;
    }

    Map<String, dynamic> toJson() => {
        "dia": dia,
    };
}