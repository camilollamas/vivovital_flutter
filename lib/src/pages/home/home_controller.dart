import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:load/load.dart';
import 'package:vivovital_app/src/models/admision.dart';
import 'package:vivovital_app/src/models/user.dart';
import 'package:vivovital_app/src/models/procesos.dart';

import 'package:vivovital_app/src/models/json.dart';
import 'dart:convert';


class HomeController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});
  Admision admision = Admision.fromJson(GetStorage().read('admision') ?? {});
  List<dynamic> proceso = GetStorage().read('procesos') ?? [];

  var habeasData = 2.obs;
  var consInformado = 2.obs;
  var datosPersonales = 2.obs;
  var agendaValoracion = 2.obs;
  var programa = 2.obs;
  var pagoPrograma = 2.obs;
  var antecedentes = 2.obs;
  var vitalHelpEnviada = 0.obs;
  var vitalHelpAceptada = 0.obs;
  var primeraCitaPrograma = 0.obs;
  
  HomeController(){
    GetStorage().write('paid', {});
    setValuesVariables();
    // GetStatusUser();Habeas Data
    print('Home_Controller -> User : ${user.toJson()}');
    print('Home_Controller -> admision : ${admision.toJson()}');
    print('Home_Controller -> proceso1 : ${proceso}');
    print('Home_Controller -> habeasData : ${habeasData}');
    print('Home_Controller -> consInformado : $consInformado');
    print('Home_Controller -> datosPersonales : $datosPersonales');
    print('Home_Controller -> agendaValoracion : $agendaValoracion');
    print('Home_Controller -> programa : $programa');
    print('Home_Controller -> pagoPrograma : $pagoPrograma');
    print('Home_Controller -> antecedentes : $antecedentes');
    print('Home_Controller -> vitalHelpEnviada : $vitalHelpEnviada');
    print('Home_Controller -> vitalHelpAceptada : $vitalHelpAceptada');
    print('Home_Controller -> primeraCitaPrograma : $primeraCitaPrograma');
    // update();

    // filter proceso by idproceso
    // habeasData = proceso.where((element) => element['Habeas Data'] == '').toList(); // 1
    // print('habeasData -> ${habeasData}');
  }


  void setValuesVariables(){
    Map hD = proceso.where((element) => element['proceso'] == 'Habeas Data').toList()[0]; // 1
    habeasData = hD['estado'] == '1' ? 1.obs : 0.obs;

    Map cI = proceso.where((element) => element['proceso'] == 'Consentimiento informado').toList()[0]; // 1
    consInformado = cI['estado'] == '1' ? 1.obs : 0.obs;

    Map dP = proceso.where((element) => element['proceso'] == 'Datos personales').toList()[0]; // 1
    datosPersonales = dP['estado'] == '1' ? 1.obs : 0.obs;

    Map aV = proceso.where((element) => element['proceso'] == 'Agenda valoración').toList()[0]; // 1
    agendaValoracion = aV['estado'] == '1' ? 1.obs : 0.obs;

    Map p = proceso.where((element) => element['proceso'] == 'Programa').toList()[0]; // 1
    programa = p['estado'] == '1' ? 1.obs : 0.obs;

    Map pP = proceso.where((element) => element['proceso'] == 'Pago de programa').toList()[0]; // 1
    pagoPrograma = pP['estado'] == '1' ? 1.obs : 0.obs;

    Map an = proceso.where((element) => element['proceso'] == 'Antecedentes').toList()[0]; // 1
    antecedentes = an['estado'] == '1' ? 1.obs : 0.obs;

    Map vHE = proceso.where((element) => element['proceso'] == 'VitalBox enviada').toList()[0]; // 1
    vitalHelpEnviada = vHE['estado'] == '1' ? 1.obs : 0.obs;

    Map vHR = proceso.where((element) => element['proceso'] == 'VitalBox recibida').toList()[0]; // 1
    vitalHelpAceptada = vHR['estado'] == '1' ? 1.obs : 0.obs;

    Map pCP = proceso.where((element) => element['proceso'] == 'Primera cita de programa').toList()[0]; // 1
    primeraCitaPrograma = pCP['estado'] == '1' ? 1.obs : 0.obs;
  }

  void logOut(){
    GetStorage().write('user', {});
    goToLoginPage();
  }
  void goToLoginPage() {
    Get.toNamed('/');
  }
  void getStatusUser() async{
  }
  void onPagar(String? idplan, dynamic valor, String descplan) async{
    var idafiliado = user.toJson();
    print('idafiliado -> ${idafiliado}');
    showLoadingDialog();
    Json json = Json(
      modelo: 'VIVO_AFI_APP',
      metodo: 'ACTUALIZAR_PAGO',
      parametros: {
        "IDAFILIADO": '${idafiliado['IDAFILIADO']}',
        // "REF_WOMPI": '${refWompi.value}',
        "IDPLAN": '${idplan}',
        "NOADMISION": '${idafiliado['NOADMISION']}',
      }
    );
    //
    // ResponseApi res = await jsonProvider.json(json);
    // dynamic res = await jsonProvider.json(json);
    hideLoadingDialog();
    // print('Respuesta res  -> ${res}');
    // var respuesta = res.result?.recordsets[0];

    // keyPublic.value = respuesta[0]['DATO'];
    // keyPrivated.value = 'prv_test_Ik81BFUW6lp1UMtP398YxT5HDuksqguL';



    Map<dynamic, dynamic> paid = {
      // "refWompi": refWompi.value,
      "pubKey": 'pub_test_Uq7PKLNPHuj9074IHfqVNsHnH7JMSF4E',//keyPublic.value,
      "keyPrivated": 'prv_test_Ik81BFUW6lp1UMtP398YxT5HDuksqguL', //keyPrivated.value,
      "PlanCost": valor,
      "descPlan": descplan
    };
    GetStorage().write('paid', paid);


    // print('Respuesta res  -> ${respuesta[0]['DATO']}');
    Get.toNamed('/paid');
    // update();
  }
}