import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:load/load.dart';
import 'package:vitalhelp_app/src/models/user.dart';
import 'package:vitalhelp_app/src/providers/json_provider.dart';


import '../../../models/ciudad.dart';
import '../../../models/departamentos.dart';
import '../../../models/json.dart';
import '../../../models/mes.dart';
import '../../../models/response_api.dart';
import '../../../models/tgensel.dart';


class UpdatePropfileController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});
  JsonProvider jsonProvider = JsonProvider();

  List documentTypes=['CC','PS','CE'];
  var docType = ''.obs;
  List genders=['Femenino','Masculino'];
  var gender = ''.obs;
  var dayBird=''.obs;
  var MontBird=''.obs;
  var yearBird=''.obs;
  List birdDay = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31'];
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
  List<String> birtYear = List.generate(57, (int index) => (1950+index).toString() );

  var idDepartamento= ''.obs;
  List<Departamentos> deptos = <Departamentos>[].obs;
  var idCiudad= ''.obs;
  List<Ciudad> ciuOpt = <Ciudad>[].obs;

  String civilStat = '';
  List<String> civilStatus = ['Soltero', 'Casado', 'Viudo', 'Union Libre'];

  var ocupation= ''.obs;
  List<Tgensel> ocupations =<Tgensel>[].obs;

  var school= ''.obs;
  List<Tgensel> schools =<Tgensel>[].obs;

  var eps= ''.obs;
  var prepaidEps= ''.obs;
  List<Tgensel> epss =<Tgensel>[].obs;

  var typeAfi= ''.obs;
  List<Tgensel> typesAfi =<Tgensel>[].obs;

  var prepaid = ''.obs;
  List<String> prep = ['Si','No'];

  Map userData = {};


  TextEditingController pnombreController   = TextEditingController();
  TextEditingController snombreController   = TextEditingController();
  TextEditingController papellidoController   = TextEditingController();
  TextEditingController sapellidoController   = TextEditingController();
  TextEditingController numberDocumentController   = TextEditingController();
  TextEditingController phoneController   = TextEditingController();
  TextEditingController otherPhoneController   = TextEditingController();
  TextEditingController emailController   = TextEditingController();
  TextEditingController addressController   = TextEditingController();
  TextEditingController companyController   = TextEditingController();

  UpdatePropfileController(){
    if(kDebugMode){
      print('Update Profile Controller -> User -> : ${user.toJson()}');
    }
  }

  void setValues(){
    if(kDebugMode){
      print('SetValues => ${user.toJson()}');
    }
    pnombreController.text = user.pnombre!;
    snombreController.text = user.snombre!;
    papellidoController.text = user.papellido!;
    sapellidoController.text = user.sapellido!;
    docType.value = user.tipoDoc!.trim();
    numberDocumentController.text = user.docidafiliado!;
    gender.value = user.sexo!.trim();

    int day = int.parse(user.fnacimiento!.substring(8,10));
    int month = int.parse(user.fnacimiento!.substring(5, 7));
    int year = int.parse(user.fnacimiento!.substring(0,4));

    dayBird.value= '$day';
    yearBird.value= '$year';
    var mesSel = birtMonth[month-1];
    MontBird.value = mesSel.id!;

    phoneController.text= user.celular!;
    otherPhoneController.text= user.telefonores!;
    emailController.text= user.email!;
    idDepartamento.value= user.dpto!;
    getCityes(user.dpto!, user.ciudad!);
    addressController.text= user.direccion!;
    civilStat = user.estadoCivil ?? '';


    companyController.text = user.empresa ?? '';

    if(user.idclaseafiliacion != null) {
      prepaid.value = user.idclaseafiliacion ?? '';
    }




    updateValues();
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
      updateValues();
    }
  }
  void getCityes(depto,dynamic ciudad) async{
    showLoadingDialog();
    if(ciudad != null){
      idCiudad.value = ciudad;
    }else{
      idCiudad= ''.obs;
    }
    ciuOpt.clear();
    Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'CIUDADES',
        parametros: {
          "DEPARTAMENTO":"$depto"
        }
    );
    //print('json:  ${json}');
    ResponseApi res = await jsonProvider.json(json);
    hideLoadingDialog();

    if(res.res == 'ok'){
      if(kDebugMode){
        print('Respuesta res  -> ${res.result?.recordsets![0]}');
      }
      var ciu = res.result?.recordsets![0];
      var result = Ciudad.fromJsonList(res.result?.recordsets![0]);
      ciuOpt.addAll(result);
      updateValues();
    }
  }
  void getOcupations() async{
    ocupations.clear();
    Json json = Json(
      modelo:'SELKRY',
      metodo:'TGEN',
      parametros:{
        "WHERES":"TABLA = 'AFI' AND CAMPO ='OCUPACION'"
      }
    );
    ResponseApi res = await jsonProvider.json(json);
    if(res.res == 'ok'){
      if(kDebugMode){
        print('Respuesta res  -> ${res.result?.recordsets![0]}');
      }
      var result = Tgensel.fromJsonList(res.result?.recordsets![0]);
      ocupations.addAll(result);
      if(user.ocupacion != null) {
        ocupation.value = user.idocupacion!;
      }
      updateValues();
    }

  }
  void getSchool() async{
    schools.clear();
    Json json = Json(
        modelo:'SELKRY',
        metodo:'TGEN',
        parametros:{
          "WHERES":"TABLA = 'AFI' AND CAMPO ='ESCOLARIDAD'"
        }
    );
    ResponseApi res = await jsonProvider.json(json);
    if(res.res == 'ok'){
      if(kDebugMode){
        print('Respuesta res  -> ${res.result?.recordsets![0]}');
      }
      var result = Tgensel.fromJsonList(res.result?.recordsets![0]);
      schools.addAll(result);
      if(user.idescolaridad != null) {
        school.value = user.idescolaridad!;
      }
      updateValues();
    }

  }
  void getEPS() async{
    epss.clear();
    Json json = Json(
        modelo:'SELKRY',
        metodo:'TGEN',
        parametros:{
          "WHERES":"TABLA = 'AFI' AND CAMPO ='EPS'"
        }
    );
    ResponseApi res = await jsonProvider.json(json);
    if(res.res == 'ok'){
      if(kDebugMode){
        print('Respuesta res  -> ${res.result?.recordsets![0]}');
      }
      var result = Tgensel.fromJsonList(res.result?.recordsets![0]);
      epss.addAll(result);
      if(user.aseguradora != null) {
        eps.value = user.aseguradora!;
      }
      if(user.coberturaSalud != null) {
        prepaidEps.value = user.coberturaSalud!;
      }

      updateValues();
    }

  }
  void getTypeAfi() async{
    typesAfi.clear();
    Json json = Json(
        modelo:'SELKRY',
        metodo:'TGEN',
        parametros:{
          "WHERES":"TABLA = 'AFI' AND CAMPO ='TIPOAFILIACION'"
        }
    );
    ResponseApi res = await jsonProvider.json(json);
    if(res.res == 'ok'){
      if(kDebugMode){
        print('Respuesta res  -> ${res.result?.recordsets![0]}');
      }
      var result = Tgensel.fromJsonList(res.result?.recordsets![0]);
      typesAfi.addAll(result);
      if(user.idtipoafiliacion != null) {
        typeAfi.value = user.idtipoafiliacion!;
      }
      updateValues();
    }

  }

  void onUpdateProfile(){
    if(kDebugMode){
      print(' =====>>>> onUpdateProfile <<<<==== ');
    }

    String firstName = pnombreController.text.trim();
    String secName = snombreController.text.trim();
    String lastName = papellidoController.text.trim();
    String secondLastname = sapellidoController.text.trim();
    String numberDocument = numberDocumentController.text.trim();
    String phone = phoneController.text.trim();
    String otherPhone = otherPhoneController.text.trim();
    String email = emailController.text.trim();
    String address = addressController.text.trim();
    String company = companyController.text.trim();

    String mes = MontBird.value.length == 1 ? '0${MontBird.value}' : MontBird.value;

    userData = {
      'IDAFILIADO':    '${user.idafiliado} ',
      'TIPO_DOC':      '${docType.trim()} ',
      'DOCIDAFILIADO': numberDocument,
      'PNOMBRE':       firstName,
      'SNOMBRE':       secName,
      'PAPELLIDO':     lastName,
      'SAPELLIDO':     secondLastname,
      'SEXO':          '$gender',

      'FNACIMIENTO':   '$yearBird-$mes-${dayBird.value}',
      'CELULAR':       phone,
      'TELEFONORES':   otherPhone,
      'EMAIL':         email,

      'PAIS':          'CO',
      'DEPARTAMENTO':  '$idDepartamento',
      'CIUDAD':        '$idCiudad',
      'DIRECCION':     address,

      'ESTADOCIVIL':    civilStat,
      'OCUPACION':      ocupation.value,
      'EMPRESAINST':    company,
      'ESCOLARIDAD':    school.value,
      'EPS':            eps.value,
      'TIPOVIN_EPS':    typeAfi.value,
      'PREPAGADA':      prepaid.value,
      'TIPO_PREPAGADA': prepaidEps.value,
    };
    if(
      validateForm(
        firstName,
        lastName,
        numberDocument,
        phone,
        email,
        address,
        company

      )
    ){
      onSaveUser();
      Get.snackbar(
          'Aviso: ',
          'Formulario correcto.',
          colorText: Colors.white,
          backgroundColor: Colors.green,
          icon: const Icon(
            Icons.done,
            color: Colors.white
          )
      );

    }else{
      // Get.snackbar(
      //     'Aviso: ',
      //     'Formulario Incorrecto.',
      //     colorText: Colors.white,
      //     backgroundColor: Colors.red,
      //     icon: const Icon(Icons.error_outline)
      // );

    }

  }

  bool validateForm(
      String firstName,
      String lastName,
      String numberDocument,
      phone,
      String email,
      address,
      company
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
              'Debe ingresar una dirección.',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              icon: const Icon(
                Icons.error_outline,
                color: Colors.white
              )
          );
          return false;
        }
        if(civilStat == '') {
          Get.snackbar(
              'Aviso: ',
              'Debe Seleccionar su estado civil.',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              icon: const Icon(
                Icons.error_outline,
                color: Colors.white
              )
          );
          return false;
        }
        if(ocupation == '') {
          Get.snackbar(
              'Aviso: ',
              'Debe Seleccionar su Ocupación.',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              icon: const Icon(
                Icons.error_outline,
                color: Colors.white
              )
          );
          return false;
        }
        if(company == '') {
          Get.snackbar(
              'Aviso: ',
              'Debe ingresar Empresa o Institución.',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              icon: const Icon(
                Icons.error_outline,
                color: Colors.white
              )
          );
          return false;
        }
        if(school == '') {
          Get.snackbar(
              'Aviso: ',
              'Debe seleccionar Escolaridad.',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              icon: const Icon(
                Icons.error_outline,
                color: Colors.white
              )
          );
          return false;
        }
        if(eps == '') {
          Get.snackbar(
              'Aviso: ',
              'Debe seleccionar EPS.',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              icon: const Icon(
                Icons.error_outline,
                color: Colors.white
              )
          );
          return false;
        }
        if(typeAfi == '') {
          Get.snackbar(
              'Aviso: ',
              'Debe seleccionar Tipo Afiliación.',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              icon: const Icon(
                Icons.error_outline,
                color: Colors.white
              )
          );
          return false;
        }
        if(prepaid == '') {
          Get.snackbar(
              'Aviso: ',
              'Debe seleccionar si tiene Prepagada/Póliza/Plan Complementario.',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              icon: const Icon(
                Icons.error_outline,
                color: Colors.white
              )
          );
          return false;
        }
        if(prepaid == 'Si'){
          if(prepaidEps == ''){
            Get.snackbar(
                'Aviso: ',
                'Debe Seleccioanr su Prepagada/Póliza/Plan Complementario.',
                colorText: Colors.white,
                backgroundColor: Colors.red,
                icon: const Icon(
                Icons.error_outline,
                color: Colors.white
              )
            );
            return false;
          }
        }
    return true;
  }

  void onSaveUser() async {
    showLoadingDialog();
    Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'ACTUALIZAR_AFI',
        parametros: userData
    );

    ResponseApi res = await jsonProvider.json(json);
    // print('Respuesta => ${res.result?.recordsets!}');
    hideLoadingDialog();
    if(res.res == 'ok') {
      if(res.result?.recordset![0].ok == 'OK'){
        List Afiliado = res.result?.recordsets![1];
        Map afi = Afiliado[0];
        GetStorage().write('user', afi);
        // print('Respuesta => ${res.result?.recordsets!}');

        Get.offNamedUntil('/profile', (route) => false);
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
      if(kDebugMode){
        print('Ha Error API');
      }
    }


  }

  void updateValues (){
    // print('prepaid=> $prepaid');
    super.refresh();
  }
}