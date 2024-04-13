import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vitalhelp_app/src/enviroment/enviroment.dart';
import '../models/json.dart';
import '../models/response_api.dart';

// import "package:http/http.dart" as http;

class JsonProvider extends GetConnect {
  String url = '${Enviroment.API_URL}json';
  String url2 = '${Enviroment.API_URL}read_docs';
  //String url = 'https://108.175.10.79/api/json';

  Future<Response> create(Json json) async {
    Response response = await post(
        url,
        json.toJson(),
        headers: {
          'Content-Type': 'application/json'
        }
    );
    return response;
  }

  Future<ResponseApi> json(Json json) async {
    if(kDebugMode){
      print('====> URL  => $url');
      print('====> JSON => ${json.toJson()}');
    }
    // print('====> JSON-METODO => ${json.metodo}');
    // print('====> JSON-PARAMETROS => ${json.parametros}');
    Response response = await post(
        url,
        json.toJson(),
        headers: {
          'Content-Type': 'application/json'
        }
    );
    if(kDebugMode){
      print('json_provider => response $response');
    }
    if(response.body == null){
      Get.snackbar(
        'Aviso: ',
        'Revise su conexión a internet y vuelva a intentarlo.',
        colorText: Colors.white,
        backgroundColor: const Color.fromARGB(255, 255, 94, 0),
        icon: const Icon(
          Icons.priority_high,
          color: Colors.white
        )
      );
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<dynamic> readDocs(Map json) async {
    if(kDebugMode){
      print('====> URL  => $url2');
      print('====> JSON => $json');
    }
    // print('====> JSON-METODO => ${json.metodo}');
    // print('====> JSON-PARAMETROS => ${json.parametros}');
    Response response = await post(
        url2,
        json,
        headers: {
          'Content-Type': 'application/json'
        }
    );
    if(kDebugMode){
      print('json_provider => response ${response.statusCode}');
      print('json_provider => body ${response.body}');
    }
    if(response.body == null){
      Get.snackbar(
        'Aviso: ',
        'Revise su conexión a internet y vuelva a intentarlo.',
        colorText: Colors.white,
        backgroundColor: const Color.fromARGB(255, 255, 94, 0),
        icon: const Icon(
          Icons.priority_high,
          color: Colors.white
        )
      );
      return ResponseApi();
    }
    // ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return response.body;
  }


}