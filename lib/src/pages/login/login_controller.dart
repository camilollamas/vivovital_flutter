import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vitalhelp_app/src/models/json.dart';
import 'package:vitalhelp_app/src/models/response_api.dart';
import 'package:vitalhelp_app/src/providers/json_provider.dart';
import 'package:load/load.dart';

class LoginController extends GetxController {
  // User user = User.fromJson(GetStorage().read('user') ?? {});

  LoginController(){
    GetStorage().write('user', {});
    if(kDebugMode){
      print('=====>>>> LoginController');
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  JsonProvider jsonProvider = JsonProvider();

  //
  void goToRegisterPage(){
    Get.toNamed('/register');
  }
  void goToRememberPage(){
    Get.toNamed('/remember');
  }
  void login(BuildContext context) async{
    FocusManager.instance.primaryFocus?.unfocus();
    showLoadingDialog();

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // print('Email: ${email}');
    // print('Pass: ${password}');

    if(isValidForm(email, password)){

      // Get.snackbar('Válido: ', 'Iniciando Sesión...');
      Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'LOGIN',
        parametros: {
          'EMAIL': email,
          'CLAVE': password
        }
      );
      //print('json:  ${json}');
      // processDialog.close();
      ResponseApi res = await jsonProvider.json(json);
      hideLoadingDialog();

      if(res.res == 'ok'){

        if(res.result?.recordset![0].ok == 'OK'){

          List Afiliado = res.result?.recordsets![1];
          Map afi = Afiliado[0];
          // print('Afiliado: ${afi}');

          GetStorage().write('user', afi);
          // Get.snackbar('Hola ${afi['PNOMBRE']}', 'Bienvenido!');
          goToHomePage();
        }else{
          hideLoadingDialog();
          List Error = res.result?.recordsets![1];
          Map detail = Error[0];
          Get.snackbar(
            'Aviso: ',
            detail['ERROR'],
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.error_outline,
              color: Colors.white
            )
          );
        }
      }else{
        hideLoadingDialog();
        Get.snackbar(
          'Aviso: ',
          'Revise su conexión a internet y vuelva a intentarlo.',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
        );
      }
    }else{
      hideLoadingDialog();
    }
  }
  void goToHomePage() {
    // Get.toNamed('/home');
    Get.offNamed('/home');
  }
  bool isValidForm(String email, String password){

    if(!GetUtils.isEmail(email)){
      Get.snackbar(
        'Aviso: ',
        'El Email no es válido',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white
        )
      );
      return false;
    }

    if(email.isEmpty){
      Get.snackbar(
        'Aviso: ',
        'Debe ingresar el Email',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white
        )
      );
      return false;
    }
    if(password.isEmpty){
      Get.snackbar(
        'Aviso: ',
        'Debe ingresar la contraseña.',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white
        )
      );
      return false;
    }
    return true;
  }
}
