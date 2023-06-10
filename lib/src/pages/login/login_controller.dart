import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vivovital_app/src/models/json.dart';
import 'package:vivovital_app/src/models/response_api.dart';
import 'package:vivovital_app/src/providers/json_provider.dart';
import 'package:vivovital_app/src/providers/login_provider.dart';
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
  LoginProvider loginProvider = LoginProvider();

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
      Object json2 = {
          'email': '${email}',
          'clave': '${password}',
          'roll': 'Paciente'
      };
      Object res = await loginProvider.login(json2);
      hideLoadingDialog();
      


      if(res != 'error'){
        dynamic afi = res;
        print('resdesde login_controller afi: ${afi['usuario']}');

        GetStorage().write('user', afi['usuario']);
        // Get.snackbar('Hola ${afi['pnombre']}', 'Bienvenido!');
        goToHomePage();
        // }
      }else{
        hideLoadingDialog();
        // Get.snackbar('Error: ', 'Hubo un problema con el servidor');
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
