// To parse this JSON data, do
//
//     final mes = mesFromJson(jsonString);

import 'dart:convert';

List<Mes> mesesFromJson(String str) => List<Mes>.from(json.decode(str).map((x) => Mes.fromJson(x)));


Mes mesFromJson(String str) => Mes.fromJson(json.decode(str));

String mesToJson(Mes data) => json.encode(data.toJson());

class Mes {
    String? valor;
    String? nombre;

    Mes({
        this.valor,
        this.nombre,
    });

    factory Mes.fromJson(Map<String, dynamic> json) => Mes(
        valor: json["valor"],
        nombre: json["nombre"],
    );

    static List<Mes> fromJsonList(List<dynamic> jsonList){
      List<Mes> toList = [];
      jsonList.forEach((me) {
        Mes mes = Mes.fromJson(me);
        toList.add(mes);
      });

      return toList;
    }

    Map<String, dynamic> toJson() => {
        "valor": valor,
        "nombre": nombre,
    };
}