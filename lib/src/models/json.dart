// To parse this JSON data, do
//
//     final json = jsonFromJson(jsonString);

import 'dart:convert';

Json jsonFromJson(String str) => Json.fromJson(json.decode(str));

String jsonToJson(Json data) => json.encode(data.toJson());

class Json {

  String? modelo;
  String? metodo;
  Object? parametros;

  Json({
    this.modelo,
    this.metodo,
    this.parametros,
  });


  factory Json.fromJson(Map<String, dynamic> json) => Json(
    modelo: json["MODELO"],
    metodo: json["METODO"],
    parametros: json["PARAMETROS"],
  );

  Map<String, dynamic> toJson() => {
    "MODELO": modelo,
    "METODO": metodo,
    "PARAMETROS": parametros,
  };
}
