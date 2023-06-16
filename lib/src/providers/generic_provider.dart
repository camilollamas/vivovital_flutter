import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vivovital_app/src/enviroment/enviroment.dart';
import 'package:flutter/material.dart';
// import '../models/json.dart';
// import '../models/response_api.dart';

// import "package:http/http.dart" as http;

class GenericProvider extends GetConnect {
  String url = '${Enviroment.API_URL}';
  String url2 = '${Enviroment.API_URL}read_docs';
  //String url = 'https://108.175.10.79/api/json';

  Future<dynamic> generic(Object data, String path) async {
    print('Provider generic_provider => data ${data}');
    print('Provider generic_provider => url/path ${url}${path}');
    dynamic response = await post(
        "$url$path",
        data,
        headers: {
          'Content-Type': 'application/json'
        }
    );
    Map body = response.body ?? "error";
    print('generic_provider => body ${body}');

    if(body == 'error'){
      Get.snackbar(
         'Error: ',
         'Ha ocurriedo un error, vuelva a intentarlo.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
      return body;
    }

    // valida que el body no sea null
    if(body != null && body['status'] == 'ko'){
      Get.snackbar(
         'Error: ',
         body['msg'],
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
      return 'error';
    }
    return body;
  }
}