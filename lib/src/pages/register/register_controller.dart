// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';

// import 'package:vivovital_app/src/models/json.dart';
// import 'package:vivovital_app/src/models/response_api.dart';
import 'package:vivovital_app/src/providers/json_provider.dart';
import 'package:vivovital_app/src/providers/generic_provider.dart';
import 'package:vivovital_app/src/models/departamentos.dart';
import 'package:vivovital_app/src/models/ciudad.dart';
import 'package:vivovital_app/src/models/mes.dart';

class RegisterController extends GetxController {
  JsonProvider jsonProvider = JsonProvider();
  GenericProvider genericProvider = GenericProvider();

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

  List<String> birtYear = List.generate(57, (int index) => "${(1950+index).toString()}" );
  var yearBird=''.obs;

  var idDepartamento= ''.obs;
  List<Departamentos> deptos = <Departamentos>[].obs;

  var idCiudad= ''.obs;
  List<Ciudad> ciuOpt = <Ciudad>[].obs;

  var terms=false.obs;
  var exclusion=false.obs;

  var validationCodeInput= '';
  var validationCodeGen= '12345';

  Map userData = {};

  RegisterController (){
    getCountries();
  }
  void getCountries() async{
    idCiudad= ''.obs;
    ciuOpt.clear();
    deptos.clear();

    Object resDeptos = await genericProvider.generic({"cod_pais":"CO"},'users/departamentos');
    if(resDeptos != 'error'){
      dynamic dep = resDeptos;
      var result = Departamentos.fromJsonList(dep['departamentos']);
      deptos.addAll(result);
    }
  }
  void getCityes(depto) async{
    showLoadingDialog();
    idCiudad= ''.obs;
    ciuOpt.clear();
    Object resCius = await genericProvider.generic({"cod_departamento":"$depto"},'users/ciudades');
    if(resCius != 'error'){
      dynamic ciu = resCius;
      var resultCiu = Ciudad.fromJsonList(ciu['ciudades']);
      ciuOpt.addAll(resultCiu);
    }
    hideLoadingDialog();
  }

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
      'tipodoc':       '${docType} ',
      'ndocumento':    '${numberDocument}',
      'pnombre':       '${firstName}',
      'snombre':       '${secName}',
      'papellido':     '${lastName}',
      'sapellido':     '${secondLastname}',
      'genero':        '${gender}',

      'fdia':          '$dayBird',
      'fmes':          '$MontBird',
      'fanio':         '$yearBird',

      'email':         '${email}',
      'celular':       '${phone}',
      'telefono':      '${otherPhone}',
      'pais':          'CO',
      'departamento':  '${idDepartamento}',
      'ciudad':        '${idCiudad}',
      'direccion':     '${address}',
      'clave':         '${password}',
      'roll':          'Paciente'
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
      )
    {

   if(firstName == '' || firstName.isEmpty) {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar el primer Nombre.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(lastName == '' || lastName.isEmpty) {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar el primer Apellido.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(docType == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar el tipo de documento.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(numberDocument == '' || numberDocument.isEmpty) {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar el número de documento.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(gender == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar el genero.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(dayBird == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar el día de nacimiento.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(MontBird == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar mes de nacimiento.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(yearBird == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar el año de nacimiento.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(phone == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Diligenciar teléfono.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(email.isEmpty){
     Get.snackbar(
         'Aviso: ',
         'Debe diligenciar un Email.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(!GetUtils.isEmail(email)){
     Get.snackbar(
         'Aviso: ',
         'Debe ingresar un Email válido.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(confirmEmail.isEmpty){
     Get.snackbar(
         'Aviso: ',
         'Debe confirmar el Email.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(email != confirmEmail){
     Get.snackbar(
         'Aviso: ',
         'Los Emails no coinciden.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }

   if(idDepartamento == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Seleccionar un departamento.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(idCiudad == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe Seleccionar una Ciudad.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(address == '') {
     Get.snackbar(
         'Aviso: ',
         'Debe ingresar una direccion.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }

   if(password == ''){
     Get.snackbar(
         'Aviso: ',
         'Debe ingresar una contraseña.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(confirmPassword == ''){
     Get.snackbar(
         'Aviso: ',
         'Debe ingresar una contraseña.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }

   if(password != confirmPassword){
     Get.snackbar(
         'Aviso: ',
         'Las contraseñas deben coincidir.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }

   if(terms == false){
     Get.snackbar(
       'Aviso: ',
       'Debe aceptar los términos y condiciones.',
       colorText: Colors.white,
       backgroundColor: Colors.red,
       icon: const Icon(Icons.error_outline)
     );
     return false;
   }
   if(exclusion == false){
     Get.snackbar(
         'Aviso: ',
         'Debe aceptar los criterios de exclusión.',
         colorText: Colors.white,
         backgroundColor: Colors.red,
         icon: const Icon(Icons.error_outline)
     );
     return false;
   }

    return true;
  }

  void ValidateAccount (docType, numberDocument, email, phone, context) async{
    showLoadingDialog();
    dynamic resCode = await genericProvider.generic(
      {
        "email":"$email",
        "tipodoc":"$docType",
        "ndocumento":"$numberDocument"
      },
      'login/validacion'
      );
    hideLoadingDialog();
    if(resCode != 'error'){
      Get.snackbar(
          'Aviso: ',
          'Código enviado',
          colorText: Colors.white,
          backgroundColor: Colors.green,
          icon: const Icon(Icons.send)
      );
      validationCodeGen = resCode['codigo'];
      print('CODIGO DE VALIDACIÓN =====>>>>>>> : ${resCode['codigo']}');
      showConfirmDialog(email, phone, context);
    }
  }
  void showConfirmDialog(email, phone, context){
    String codeInput = '';
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        contentPadding: EdgeInsets.only(left: 30, right: 30),
        title:
        Container(
          margin: EdgeInsets.only(bottom: 20),
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
              Text('${phone}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF243588),
                    fontFamily: 'AvenirReg',
                  )
              ),
              TextField(
                  keyboardType: TextInputType.number,
                  // controller: codeInput,
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
                              padding: EdgeInsets.symmetric(horizontal: 15),
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
                              padding: EdgeInsets.symmetric(horizontal: 15)
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
    print('Validando Código');
    print('Código Válido ${validationCodeGen}');
    print('Código Ingresado ${validationCodeInput}');

    if(validationCodeGen == validationCodeInput){
      Get.snackbar(
          'Aviso: ',
          'Código correcto',
          colorText: Colors.white,
          backgroundColor: Colors.green,
          icon: const Icon(Icons.check_circle_outline_outlined)
      );
      print('Enviando datos de usuario ${userData}');
      saveUser();
    }else{
      Get.snackbar(
          'Aviso: ',
          'Código incorrecto',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error_outline)
      );
    }
  }
  void saveUser() async{
    showLoadingDialog();
    dynamic onLogin = await genericProvider.generic(
      userData,
      'login/registrar'
    );
    hideLoadingDialog();
    if(onLogin != 'error'){
      Get.snackbar(
          'Aviso: ',
          'Usuario registrado correctamente',
          colorText: Colors.white,
          backgroundColor: Colors.green,
          icon: const Icon(Icons.check_circle_outline_outlined)
      );
      Get.toNamed('/');
    }
  }
}


