import 'dart:convert';

List<Departamentos> departamentosFromJson(String str) => List<Departamentos>.from(json.decode(str).map((x) => Departamentos.fromJson(x)));



String departamentosToJson(List<Departamentos> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// "cod_pais": "CO",
// "cod_departamento": "05",
// "nombre_departamento": "ANTIOQUIA",
class Departamentos {
  Departamentos({
    this.cod_departamento,
    this.nombre_departamento,
  });

  String? cod_departamento;
  String? nombre_departamento;

  factory Departamentos.fromJson(Map<String, dynamic> json) => Departamentos(
    cod_departamento: json["cod_departamento"],
    nombre_departamento: json["nombre_departamento"],
  );

  static List<Departamentos> fromJsonList(List<dynamic> jsonList){
    List<Departamentos> toList = [];
    jsonList.forEach((dep) {
      Departamentos departamento = Departamentos.fromJson(dep);
      toList.add(departamento);
    });

    return toList;
  }

  Map<String, dynamic> toJson() => {
    "cod_departamento": cod_departamento,
    "nombre_departamento": nombre_departamento,
  };
}