import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vivovital_app/src/models/json.dart';
import 'package:vivovital_app/src/models/response_api.dart';
import 'package:vivovital_app/src/providers/json_provider.dart';
import 'package:load/load.dart';
import 'package:vivovital_app/src/models/user.dart';

class LoginController extends GetxController {
  // User user = User.fromJson(GetStorage().read('user') ?? {});

  LoginController(){
    GetStorage().write('user', {});
    print('=====>>>> LoginController');
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  JsonProvider jsonProvider = JsonProvider();

  //
  void goToRegisterPage(){
    Get.toNamed('/register');
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
          'EMAIL': '${email}',
          'CLAVE': '${password}'
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
              icon: const Icon(Icons.error_outline)
          );
        }
      }else{
        hideLoadingDialog();
        Get.snackbar('Error: ', 'Hubo un problema con el servidor');
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
