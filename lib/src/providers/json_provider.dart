import 'package:get/get.dart';
import 'package:vivovital_app/src/enviroment/enviroment.dart';

import '../models/json.dart';
import '../models/response_api.dart';

class JsonProvider extends GetConnect {
  String url = '${Enviroment.API_URL}json';

Future<Response> create(Json json) async {
  print('JSONProvider ${json}');
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
    print('JSONProvider ${json}');
    Response response = await post(
        url,
        json.toJson(),
        headers: {
          'Content-Type': 'application/json'
        }
    );

    if(response.body == null){
      Get.snackbar('Erorr', 'No se pudo ejecutar la peticion');
      return ResponseApi();
    }
  ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }


}