import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vitalhelp_app/src/models/json.dart';
import 'package:vitalhelp_app/src/models/response_api.dart';
import 'package:vitalhelp_app/src/providers/json_provider.dart';
import 'package:load/load.dart';

class RememberController extends GetxController {
  // User user = User.fromJson(GetStorage().read('user') ?? {});

  var mostrarCodigo='NO';
  var validationCodeGen= '12345';
  var validationCodeInput= '';
  var showPassInputs = false.obs;

  RememberController(){
    GetStorage().write('user', {});
    if(kDebugMode){
      print('=====>>>> RememberController');
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController inputCodeController  = TextEditingController();

  TextEditingController passwordController  = TextEditingController();
  TextEditingController confirmPasswordController  = TextEditingController();

  JsonProvider jsonProvider = JsonProvider();

  //
  void goToRegisterPage(){
    Get.toNamed('/register');
  }
  void validateEmail(BuildContext context) async{
    FocusManager.instance.primaryFocus?.unfocus();
    showLoadingDialog();

    String email = emailController.text.trim();
    // String password = passwordController.text.trim();

    // print('Email: ${email}');
    // print('Pass: ${password}');

    if(isValidForm(email)){

      Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'RECUPERAR_CONTRASENA',
        parametros: {
          'EMAIL': email,
          }
      );
      //print('json:  ${json}');
      // processDialog.close();
      ResponseApi res = await jsonProvider.json(json);
      hideLoadingDialog();

      if(res.res == 'ok') {

        if(res.result?.recordset![0].ok == 'OK'){
          Get.snackbar(
              'Aviso: ',
              'Código enviado',
              colorText: Colors.white,
              backgroundColor: Colors.green,
              icon: const Icon(
                Icons.done,
                color: Colors.white
              )
          );
          List code = res.result?.recordsets![1];
          Map validateCode = code[0];
          validationCodeGen = validateCode['CODIGO'];
          mostrarCodigo = validateCode['MOSTRAR'];

          if(mostrarCodigo == 'SI'){
            inputCodeController.text = validationCodeGen;
            validationCodeInput = validateCode['CODIGO'];
          }
          showConfirmDialog(email, context);
        }else{
          List error = res.result?.recordsets![1];
          Map detail = error[0];
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
      }
      
    }else{
      hideLoadingDialog();
    }
  }

  void showConfirmDialog(email, context){
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        contentPadding: const EdgeInsets.only(left: 30, right: 30),
        title:
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child:
            const Text('Código de validación:',
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFF243588),
                fontFamily: 'AvenirBold',
              )
            )
        ),
        children: [
          Column(
            children: [
              const Text('Se ha enviado un código de validación al siguiente correo electrónico:'),
              Text('$email',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF243588),
                    fontFamily: 'AvenirReg',
                  )
              ),
              TextField(
                  keyboardType: TextInputType.number,
                  controller: inputCodeController,
                  onChanged: (value){
                    validationCodeInput = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Ingresar código',
                    // prefixIcon: Icon(Icons.val)
                  )
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              shadowColor: Colors.transparent
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontFamily: 'AvenirReg',
                            ),
                          )
                      ),
                      ElevatedButton(
                          onPressed: () => validateCode(),
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 15)
                          ),
                          child: const Text(
                            'Validar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'AvenirReg',
                            ),
                          )
                      )
                    ]
                ),
              ),
            ],
          )

        ]
      ),
    );

  }
  void validateCode(){
    if(validationCodeGen == validationCodeInput){
      Get.snackbar(
          'Aviso: ',
          'Código correcto',
          colorText: Colors.white,
          backgroundColor: Colors.green,
          icon: const Icon(
            Icons.done,
            color: Colors.white
          )
      );
      showPassinputs();
    }else{
      Get.snackbar(
          'Aviso: ',
          'Código incorrecto',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
      );
    }
  }
  void showPassinputs(){
    showPassInputs.value = true;
  }
  void savePassword(BuildContext context) async{
    FocusManager.instance.primaryFocus?.unfocus();
    showLoadingDialog();

    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if(isValidForm(email)){
      if(password == confirmPassword){
        Json json = Json(
            modelo: 'VIVO_AFI_APP',
            metodo: 'CAMBIAR_CONTRASENA',
            parametros: {
              'EMAIL': email,
              'CLAVE': password,
            }
        ); 
        ResponseApi res = await jsonProvider.json(json);
        hideLoadingDialog();

        if(res.res == 'ok') {
          if(res.result?.recordset![0].ok == 'OK'){
            Get.snackbar(
                'Aviso: ',
                'Contraseña actualizada',
                colorText: Colors.white,
                backgroundColor: Colors.green,
                icon: const Icon(Icons.done,
                  color: Colors.white
                )
            );
            Navigator.pop(context);
          }else{
            List error = res.result?.recordsets![1];
            Map detail = error[0];
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
        }
      }else{
        Get.snackbar(
        'Aviso: ',
        'Las contraseñas no coinciden',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white) // Color del icono)
        );
        hideLoadingDialog();
      }
    }else{
      hideLoadingDialog();
    }
  }
  void goToHomePage() {
    // Get.toNamed('/home');
    Get.offNamed('/home');
  }
  bool isValidForm(String email){

    if(!GetUtils.isEmail(email)){
      Get.snackbar(
        'Aviso: ',
        'El Email no es válido',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white
        ) // Color del icono)
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
        ) // Color del icono)
      );
      return false;
    }

    return true;
  }
}