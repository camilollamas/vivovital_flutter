import 'dart:convert';

List<Ciudad> ciudadFromJson(String str) => List<Ciudad>.from(json.decode(str).map((x) => Ciudad.fromJson(x)));

String ciudadToJson(List<Ciudad> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ciudad {
  Ciudad({
    this.ciudad,
    this.nombre,
  });

  String? ciudad;
  String? nombre;

  factory Ciudad.fromJson(Map<String, dynamic> json) => Ciudad(
    ciudad: json["CIUDAD"],
    nombre: json["NOMBRE"],
  );

  static List<Ciudad> fromJsonList(List<dynamic> jsonList){
    List<Ciudad> toList = [];
    for (var ciu in jsonList) {
      Ciudad ciudad = Ciudad.fromJson(ciu);
      toList.add(ciudad);
    }

    return toList;
  }

  Map<String, dynamic> toJson() => {
    "CIUDAD": ciudad,
    "NOMBRE": nombre,
  };
}