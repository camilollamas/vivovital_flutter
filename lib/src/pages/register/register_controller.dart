import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';

import 'package:vitalhelp_app/src/models/json.dart';
import 'package:vitalhelp_app/src/models/response_api.dart';
import 'package:vitalhelp_app/src/providers/json_provider.dart';
import 'package:vitalhelp_app/src/models/departamentos.dart';
import 'package:vitalhelp_app/src/models/ciudad.dart';
import 'package:vitalhelp_app/src/models/mes.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterController extends GetxController {
  JsonProvider jsonProvider = JsonProvider();

  List documentTypes=['CC','PS','CE'];
  var docType = ''.obs;

  List genders=['Femenino','Masculino'];
  var gender = ''.obs;


  List birdDay = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31'];

  var dayBird=''.obs;

  List<Mes> birtMonth = Mes.fromJsonList(
    [{ "id": '1', "Nombre": "Enero"},
    { "id": '2', "Nombre": "Febrero"},
    { "id": '3', "Nombre": "Marzo"},
    { "id": '4', "Nombre": "Abril"},
    { "id": '5', "Nombre": "Mayo"},
    { "id": '6', "Nombre": "Junio"},
    { "id": '7', "Nombre": "Julio"},
    { "id": '8', "Nombre": "Agosto"},
    { "id": '9', "Nombre": "Septiembre"},
    { "id": '10', "Nombre": "Octubre"},
    { "id": '11', "Nombre": "Noviembre"},
    { "id": '12', "Nombre": "Diciembre"}]
  );
  var MontBird=''.obs;

  List<String> birtYear = List.generate(57, (int index) => (1950+index).toString() );
  var yearBird=''.obs;

  var idDepartamento= ''.obs;
  List<Departamentos> deptos = <Departamentos>[].obs;

  var idCiudad= ''.obs;
  List<Ciudad> ciuOpt = <Ciudad>[].obs;

  var terms=false.obs;
  var exclusion=false.obs;

  var mostrarCodigo='NO';
  var validationCodeInput= '';
  var validationCodeGen= '12345';

  var urlPath=''.obs;
  var urlHost=''.obs;
  var urlTerminos= ''.obs;
  var urlCriterios= ''.obs;

  Map userData = {};

  RegisterController (){
    getCountries();
    getUrls();

  }
  void getUrls() async{
    Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'URLS'
    );
    ResponseApi res = await jsonProvider.json(json);

    if(res.res == 'ok'){
      var result = res.result?.recordsets![0];
      Map detail = result[0];
      urlTerminos.value = detail['TERMINOS'];
      urlCriterios.value = detail['CRITERIOS'];
      urlPath.value = detail['PATHURL'];
      urlHost.value = detail['HOST'];
    }
  }
  void goToUrl(String urlString) async{
    Uri url = Uri.parse(urlString);
    if (!await launchUrl(
      url
      // mode: LaunchMode.inAppWebView,
      // webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
      )
    ) {
      throw Exception('Could not launch $url');
    }
  }
  
  void getCountries() async{
    idCiudad= ''.obs;
    ciuOpt.clear();

    deptos.clear();

    Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'DEPARTAMENTOS',
        parametros: {}
    );
    ResponseApi res = await jsonProvider.json(json);

    if(res.res == 'ok'){
      var result = Departamentos.fromJsonList(res.result?.recordsets![0]);
      deptos.addAll(result);
    }
  }
  void getCityes(depto) async{
    showLoadingDialog();
    idCiudad= ''.obs;
    ciuOpt.clear();
    Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'CIUDADES',
        parametros: {
          "DEPARTAMENTO":"$depto"
        }
    );
    ResponseApi res = await jsonProvider.json(json);
    hideLoadingDialog();

    if(res.res == 'ok'){
      var result = Ciudad.fromJsonList(res.result?.recordsets![0]);
      ciuOpt.addAll(result);
    }
  }

  TextEditingController inputCodeController  = TextEditingController();

  TextEditingController firstNameController   = TextEditingController();
  TextEditingController secNameController     = TextEditingController();
  TextEditingController lastController        = TextEditingController();
  TextEditingController secondLastController  = TextEditingController();

  TextEditingController numberDocumentController  = TextEditingController();
  TextEditingController phoneController  = TextEditingController();
  TextEditingController otherPhoneController  = TextEditingController();

  TextEditingController emailController  = TextEditingController();
  TextEditingController confirmEmailController  = TextEditingController();

  TextEditingController addressController  = TextEditingController();
  TextEditingController passwordController  = TextEditingController();
  TextEditingController confirmPasswordController  = TextEditingController();

  TextEditingController codeValidationController  = TextEditingController();

  String? countryDefault = 'Colombia';

  void register(BuildContext context) {
    String firstName = firstNameController.text.trim();
    String secName = secNameController.text.trim();
    String lastName = lastController.text.trim();
    String secondLastname = secondLastController.text.trim();
    String numberDocument = numberDocumentController.text.trim();
    String phone = phoneController.text.trim();
    String otherPhone = otherPhoneController.text.trim();
    String email = emailController.text.trim();
    String confirmEmail = confirmEmailController.text.trim();
    String address = addressController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    userData = {
      'TIPO_DOC':      '$docType ',
      'DOCIDAFILIADO': numberDocument,
      'PNOMBRE':       firstName,
      'SNOMBRE':       secName,
      'PAPELLIDO':     lastName,
      'SAPELLIDO':     secondLastname,
      'SEXO':          '$gender',
      'FDIA':          '$dayBird',
      'FMES':          '$MontBird',
      'FANIO':         '$yearBird',
      'EMAIL':         email,
      'CELULAR':       phone,
      'CELULAR2':      otherPhone,
      'PAIS':          'CO',
      'DEPARTAMENTO':  '$idDepartamento',
      'CIUDAD':        '$idCiudad',
      'DIRECCION':     address,
      'CLAVE':         password
    };

    if(
    ValidateForm(
        firstName,
        lastName,
        docType,
        numberDocument,
        gender,
        dayBird,
        MontBird,
        yearBird,
        phone,
        email,
        confirmEmail,
        idDepartamento,
        idCiudad,
        address,
        password,
        confirmPassword,
        terms,
        exclusion
    )
    ){
      //Account Validate
      ValidateAccount(docType,numberDocument,email,phone, context);
    }

  }

  bool ValidateForm(
      String firstName,
      String lastName,
      docType,
      String numberDocument,
      gender,
      dayBird,
      MontBird,
      yearBird,
      phone,
      String email,
      String confirmEmail,
      idDepartamento,
      idCiudad,
      address,
      password,
      confirmPassword,
      terms, exclusion
      ){

   if(firstName == '' || firstName.isEmpty) {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar el primer Nombre.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }
   if(lastName == '' || lastName.isEmpty) {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar el primer Apellido.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }
   if(docType == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar el tipo de documento.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }
   if(numberDocument == '' || numberDocument.isEmpty) {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar el número de documento.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }
   if(gender == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar el genero.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }
   if(dayBird == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar el día de nacimiento.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }
   if(MontBird == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar mes de nacimiento.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }
   if(yearBird == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar el año de nacimiento.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }
   if(phone == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar teléfono.',
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
         'Debe diligenciar un Email.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }
   if(!GetUtils.isEmail(email)){
     Get.snackbar(
         'Aviso: ',
         'Debe ingresar un Email válido.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }
   if(confirmEmail.isEmpty){
     Get.snackbar(
         'Aviso: ',
         'Debe confirmar el Email.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }
   if(email != confirmEmail){
     Get.snackbar(
         'Aviso: ',
         'Los Emails no coinciden.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }

   if(idDepartamento == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Seleccionar un departamento.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }
   if(idCiudad == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Seleccionar una Ciudad.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }
   if(address == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe ingresar una direccion.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }

   if(password == ''){
     Get.snackbar(
         'Aviso: ',
         'Debe ingresar una contraseña.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }
   if(confirmPassword == ''){
     Get.snackbar(
         'Aviso: ',
         'Debe ingresar una contraseña.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }

   if(password != confirmPassword){
     Get.snackbar(
         'Aviso: ',
         'Las contraseñas deben coincidir.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }

   if(terms == false){
     Get.snackbar(
       'Aviso: ',
       'Debe aceptar los términos y condiciones.',
       colorText: Colors.white,
       backgroundColor: Colors.red,
       icon: const Icon(
            Icons.error_outline,
            color: Colors.white
          )
     );
     return false;
   }
   if(exclusion == false){
     Get.snackbar(
         'Aviso: ',
         'Debe aceptar los criterios de exclusión.',
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

  void ValidateAccount (docType, numberDocument, email, phone, context) async{
    showLoadingDialog();
    inputCodeController.text = '';

    Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'VALIDAR',
        parametros: {
          'TIPO_DOC': '$docType',
          'DOCIDAFILIADO': '$numberDocument',
          'EMAIL': '$email',
          'CELULAR': '$phone'
        }
    );

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
        showConfirmDialog(email, phone, context);
      }else{
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
      if (kDebugMode) {
        print('Ha Error API');
      }
    }
  }
  void showConfirmDialog(email, phone, context){
    String codeInput = '';
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
              const Text('También por mensaje de texto al número:'),
              Text('$phone',
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
      saveUser();
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
  void saveUser() async{
    showLoadingDialog();
    Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'REGISTRAR',
        parametros: userData
    );

    ResponseApi res = await jsonProvider.json(json);
    hideLoadingDialog();
    if(res.res == 'ok') {
      if(res.result?.recordset![0].ok == 'OK'){
        Get.toNamed('/');
      }else{
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
      if (kDebugMode) {
        print('Ha ocurrido un error en la API');
      }
    }


  }
}


