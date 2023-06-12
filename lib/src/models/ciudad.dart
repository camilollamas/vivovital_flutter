import 'dart:convert';

List<Ciudad> ciudadFromJson(String str) => List<Ciudad>.from(json.decode(str).map((x) => Ciudad.fromJson(x)));

String ciudadToJson(List<Ciudad> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


// "cod_ciudad": "11001",
// "nombre_ciudad": "Bogotá D.C.",

class Ciudad {
  Ciudad({
    this.cod_ciudad,
    this.nombre_ciudad,
  });

  String? cod_ciudad;
  String? nombre_ciudad;

  factory Ciudad.fromJson(Map<String, dynamic> json) => Ciudad(
    cod_ciudad: json["cod_ciudad"],
    nombre_ciudad: json["nombre_ciudad"],
  );

  static List<Ciudad> fromJsonList(List<dynamic> jsonList){
    List<Ciudad> toList = [];
    jsonList.forEach((ciu) {
      Ciudad ciudad = Ciudad.fromJson(ciu);
      toList.add(ciudad);
    });

    return toList;
  }

  Map<String, dynamic> toJson() => {
    "cod_ciudad": cod_ciudad,
    "nombre_ciudad": nombre_ciudad,
  };
}