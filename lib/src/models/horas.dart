// To parse this JSON data, do
//
//     final hora = horaFromJson(jsonString);

import 'dart:convert';

List<Hora> mesesFromJson(String str) => List<Hora>.from(json.decode(str).map((x) => Hora.fromJson(x)));


Hora horaFromJson(String str) => Hora.fromJson(json.decode(str));

String horaToJson(Hora data) => json.encode(data.toJson());

class Hora {
    String? hora;
    String? consecutivo;

    Hora({
        this.hora,
        this.consecutivo,
    });

    factory Hora.fromJson(Map<String, dynamic> json) => Hora(
        hora: json["hora"],
        consecutivo: json["consecutivo"],
    );
    static List<Hora> fromJsonList(List<dynamic> jsonList){
      List<Hora> toList = [];
      jsonList.forEach((hora) {
        Hora hor = Hora.fromJson(hora);
        toList.add(hor);
      });

      return toList;
    }

    Map<String, dynamic> toJson() => {
        "hora": hora,
        "consecutivo": consecutivo,
    };
}
