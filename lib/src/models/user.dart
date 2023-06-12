// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {

    User({
        this.id,
        this.email,
        this.tipodoc,
        this.ndocumento,
        this.pnombre,
        this.snombre,
        this.papellido,
        this.sapellido,
        this.fnacimiento,
        this.genero,
        this.pais,
        this.ciudad,
        this.departamento,
        this.direccion,
        this.telefono,
        this.celular,
        this.estadoCivil,
        this.ocupacion,
        this.empresa,
        this.escolaridad,
        this.eps,
        this.tipoeps,
        this.prepagada,
        this.roll,
        this.estado,
        // this.createdAt,
        // this.updatedAt,
        this.nombrePais,
        this.codigoTelefonico,
        this.nombreDepartamento,
        this.nombreCiudad,
        this.token,
    });

    int? id;
    String? email;
    String? tipodoc;
    String? ndocumento;
    String? pnombre;
    String? snombre;
    String? papellido;
    String? sapellido;
    String? fnacimiento;
    // DateTime? fnacimiento;
    String? genero;
    String? pais;
    String? ciudad;
    String? departamento;
    String? direccion;
    String? telefono;
    String? celular;
    String? estadoCivil;
    String? ocupacion;
    String? empresa;
    String? escolaridad;
    String? eps;
    String? tipoeps;
    String? prepagada;
    String? roll;
    String? estado;
    // DateTime? createdAt;
    // DateTime? updatedAt;
    String? nombrePais;
    String? codigoTelefonico;
    String? nombreDepartamento;
    String? nombreCiudad;
    String? token;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        tipodoc: json["tipodoc"],
        ndocumento: json["ndocumento"],
        pnombre: json["pnombre"],
        snombre: json["snombre"],
        papellido: json["papellido"],
        sapellido: json["sapellido"],
        fnacimiento: json["fnacimiento"],
        // fnacimiento: DateTime.parse(json["fnacimiento"]),
        genero: json["genero"],
        pais: json["pais"],
        ciudad: json["ciudad"],
        departamento: json["departamento"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        celular: json["celular"],
        estadoCivil: json["estado_civil"],
        ocupacion: json["ocupacion"],
        empresa: json["empresa"],
        escolaridad: json["escolaridad"],
        eps: json["eps"],
        tipoeps: json["tipoeps"],
        prepagada: json["prepagada"],
        roll: json["roll"],
        estado: json["estado"],
        // createdAt: DateTime.parse(json["createdAt"]),
        // updatedAt: DateTime.parse(json["updatedAt"]),
        nombrePais: json["nombre_pais"],
        codigoTelefonico: json["codigo_telefonico"],
        nombreDepartamento: json["nombre_departamento"],
        nombreCiudad: json["nombre_ciudad"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "tipodoc": tipodoc,
        "ndocumento": ndocumento,
        "pnombre": pnombre,
        "snombre": snombre,
        "papellido": papellido,
        "sapellido": sapellido,
        "fnacimiento": fnacimiento,
        // "fnacimiento": "${fnacimiento!.year.toString().padLeft(4, '0')}-${fnacimiento!.month.toString().padLeft(2, '0')}-${fnacimiento!.day.toString().padLeft(2, '0')}",
        "genero": genero,
        "pais": pais,
        "ciudad": ciudad,
        "departamento": departamento,
        "direccion": direccion,
        "telefono": telefono,
        "celular": celular,
        "estado_civil": estadoCivil,
        "ocupacion": ocupacion,
        "empresa": empresa,
        "escolaridad": escolaridad,
        "eps": eps,
        "tipoeps": tipoeps,
        "prepagada": prepagada,
        "roll": roll,
        "estado": estado,
        // "createdAt": createdAt!.toIso8601String(),
        // "updatedAt": updatedAt!.toIso8601String(),
        "nombre_pais": nombrePais,
        "codigo_telefonico": codigoTelefonico,
        "nombre_departamento": nombreDepartamento,
        "nombre_ciudad": nombreCiudad,
        "token": token,
    };
}