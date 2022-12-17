import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vivovital_app/src/models/json.dart';
import 'package:vivovital_app/src/providers/json_provider.dart';
import 'dart:convert';

class LoginController extends GetxController {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  JsonProvider jsonProvider = JsonProvider();

  //
  void goToRegisterPage(){
    Get.toNamed('/register');
  }

  void login() async{
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print('Email: ${email}');
    print('Pass: ${password}');

   /*
    Get.snackbar('Email', email);
    Get.snackbar('Password', password);

   */
    if(isValidForm(email, password)){
      Get.snackbar('Válido: ', 'Iniciando Sesión...');
      Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'LOGIN',
        parametros: {
          'EMAIL': '${email}',
          'CLAVE': '${password}'
        }
      );

      print('json:  ${json}');

      Response res = await jsonProvider.create(json);
      print('RESPONSE: ${res}');
      String datos = jsonDecode(res.body);

      //print('RESPONSE: ${body}');
      // if(res.body.res == 'ok'){
      //   print('RESULTADO : ok');
      // }

      //
      // if(res.body.res == 'ok'){
      //   print('> Respuesta Válida');
      //   if(res.body.result.recordset.OK == 'KO' ){
      //   //  String error = res.body.result.recordsets[1][0];
      //     print('RESPONSE: ${res.body}');
      //   }
      //
      //
      // }


    }
  }

  bool isValidForm(String email, String password){

    if(!GetUtils.isEmail(email)){
      Get.snackbar('Error: ', 'El Email no es válido');
      return false;
    }

    if(email.isEmpty){
      Get.snackbar('Error: ', 'Debe ingresar el Email.');
      return false;
    }
    if(password.isEmpty){
      Get.snackbar('Error: ', 'Debe ingresar la contraseña.');
      return false;
    }
    return true;
  }
}