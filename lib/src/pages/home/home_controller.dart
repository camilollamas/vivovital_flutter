import "package:http/http.dart" as http;
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vivovital_app/src/models/user.dart';
import 'package:vivovital_app/src/models/planes.dart';
import 'package:load/load.dart';
import 'package:signature/signature.dart';

import 'package:vivovital_app/src/providers/json_provider.dart';
import 'package:vivovital_app/src/models/json.dart';
import 'package:vivovital_app/src/models/response_api.dart';

import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:money2/money2.dart';
import 'package:vivovital_app/src/enviroment/enviroment.dart';


class EstadoUser {
  String? IDAFILIADO;
  String? PASO;
  int? ESTADOPASO;
  String? FECHA;
  String? DESCRIPCION;

  EstadoUser(this.IDAFILIADO, this.PASO, this.ESTADOPASO, this.FECHA, this.DESCRIPCION);

  @override
  String toString() {
    return 'IDAFILIADO: $IDAFILIADO, PASO: $PASO, ESTADOPASO: $ESTADOPASO, FECHA: $FECHA, DESCRIPCION: $DESCRIPCION';
  }
}

class HomeController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});
  JsonProvider jsonProvider = JsonProvider();
  String api_url = '${Enviroment.API_URL}';

  // Variables de procesos
  var habeasData = {}.obs;
  var datosPersonales = {}.obs;
  var citaValoracion = {}.obs;



  var p1ConsInf = '';
  var statusUser = {};
  var refWompi = ''.obs;
  var tratDatos = '2'.obs;
  var keyPublic = ''.obs;
  var keyPrivated = ''.obs;

  var consInf = '2'.obs;
  var showPlanes = false.obs;
  List<Planes> planes = [];

  String p1Pln1 = 'Incluye 2 consultas médicas, 3 teleorientaciones nutricionales, más de 100 actividades diseñadas y dirigidas por diferentes profesionales y el servicio de comunicación directa vía WhatsApp para que puedas solucionar tus dudas al instante.';
  String p2Pln1 = 'Adicionalmente recibirás nuestra VITAL-BOX, en la que te incluimos si costo adicional los instrumentos que te permitirán hacer seguimiento a tu evolución, desarrollar tus propios planes alimentarios, mejorar tu condición física y los nutracéuticos (alimentos con fines terapéuticos) para alcanzar tu regulación metabólica.';
  HomeController(){
    GetStorage().write('paid', {});
    changeValue('2');
    p1ConsInf = '${user.pnombre}';

    // GetStatusUser();
    // print('Home_Controller -> User : ${user.toJson()}');
    // update();

  }

  SignatureController signatureController = SignatureController(
      penColor: Color(0xff243588)
  );
  void changeValue(String dato){
    tratDatos.value = dato;
    update(["tratDatos"]);
    super.refresh();
    // Get.offAndToNamed('/home');
  }
  void confirmSignature (context, String? document) {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
          contentPadding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
          title:
          Container(
              margin: const EdgeInsets.only(bottom: 20),
              child:
              const Text('Confirmación',
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
                const Text('¿Confirma que desea continuar?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'AvenirReg'
                    ),
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
                              color: Colors.redAccent,
                              fontSize: 18,
                              fontFamily: 'AvenirReg',
                            ),
                          )
                      ),
                      ElevatedButton(
                          onPressed: () => {
                            saveSignature(document),
                            Navigator.pop(context, true)
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 15)
                          ),
                          child: const Text(
                            'Continuar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'AvenirReg',
                            ),
                          )
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        )
    );
  }
  void saveSignature (String? document) async{
    showLoadingDialog();
    var usuario = user.toJson();

    final signature = await exportSignature();

    var request = http.MultipartRequest('POST', Uri.parse('${api_url}upload/archivoMpld'));
    request.fields['DocTipo'] = document == 'HABEASDATA' ? 'HABEASDATA' : 'TRATAMIENTO';
    request.fields['DocCnsAuxiliar'] = '${usuario['IDAFILIADO']}';
    request.fields['DocConsecutivo'] = '${usuario['IDAFILIADO']}';
    request.fields['DocUsuario'] = 'AFIAPP';

    request.files.add(http.MultipartFile.fromBytes(
      'files',
      signature,
      filename: 'some-file-name.jpg',
      contentType: MediaType("image", "jpg"),
    )
    );

    dynamic response = await request.send();
    final respStr = await response.stream.bytesToString();
    hideLoadingDialog();
    var jsonData = jsonDecode(respStr);
    if (response.statusCode == 200) {
      print('sucess => ${jsonData['result']}');
      getFirma(jsonData['result'], document);


    } else {
      print('No sucess => ${jsonData}');
    }
    return;
  }
  
  void getFirma(idFirma, String? document) async{
    showLoadingDialog();
    var usuario = user.toJson();

    Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'GETFIRMA',
        parametros: {
          'IDFIRMA': '$idFirma',
          'IDAFILIADO': '${usuario['IDAFILIADO']}',
          'DOCUMENTO': '$document'
        }
    );

    ResponseApi res = await jsonProvider.json(json);
    hideLoadingDialog();
    print('Respuesta => ${res.result?.recordsets!}');
    // var datos = {
    //   'MODELO': 'VIVO_AFI_APP',
    //   'METODO': 'FIRMARDOCUMENTO',
    //   'PARAMETROS':{
    //     'DOCUMENTOID': '${idFirma}',
    //     'IDAFILIADO': '${usuario['IDAFILIADO']}',
    //     'NOADMISION': '${usuario['NOADMISION']}',
    //     'DOCUMENTO': '${document}'
    //   }
    // };

    // var dio = Dio();
    // var response = await dio.post('${api_url}json', data: datos);

    // print('response DIO : ${response}');
    changeValue('1');
    Get.snackbar(
        'Aviso: ',
        'Firma guardada',
        colorText: Colors.white,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.check)
    );
    Get.toNamed('/home');
    // Get.back();
    GetStatusUser();
    // Get.back();
  }
  
  void SedImage(data) async{
    Dio dio = new Dio();
    dio.post('${api_url}upload/archivoMpld', data: data).then((response) {
      var jsonResponse = jsonDecode(response.toString());
      // print(jsonResponse);
      // var testData = jsonResponse['histogram_counts'].cast<double>();
      // var averageGrindSize = jsonResponse['average_particle_size'];

    }).catchError((error) => print(error));
  }
  Future exportSignature() async {
    final exportController = SignatureController(
        penStrokeWidth: 2,
        penColor: Colors.black,
        exportBackgroundColor: Colors.white,
        points: signatureController.points
    );
    final signature = await exportController.toPngBytes();
    exportController.dispose();
    return signature;
  }


  void LogOut(){
    GetStorage().write('user', {});
    goToLoginPage();
  }
  void goToLoginPage() {
    Get.toNamed('/');
  }
  void GetStatusUser() async{
    showLoadingDialog();
    planes.clear();
    showPlanes.value = false;
    consInf = '2'.obs;
    // changeValue('0');

    var idafiliado = user.toJson();
    // print('idafiliado -> ${idafiliado['IDAFILIADO']}');
    // showLoadingDialog();
    Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'GETSTATUS',
        parametros: {
          "IDAFILIADO": '${idafiliado['IDAFILIADO']}'
        });
    //
    ResponseApi res = await jsonProvider.json(json);
    // dynamic res = await jsonProvider.json(json);
    // hideLoadingDialog();
    // print('Respuesta res  -> ${res}');
    // print('Respuesta res  -> ${res.result?.recordsets}');

    List<dynamic> estadoUser = res.result?.recordsets![0];

    print('Estado USER =======>>>> $estadoUser');
    

    // List<Map<String, dynamic>> listaObjetos = res.result?.recordsets![0][0];

    // Habeas Data
    var hD = estadoUser.where((objeto) => objeto['PASO'] == '0010').toList();
    habeasData.value = hD[0];

    // Datos Personales
    var dP = estadoUser.where((objeto) => objeto['PASO'] == '0020').toList();
    datosPersonales.value = dP[0];

    // Cita Valoración
    var cV = estadoUser.where((objeto) => objeto['PASO'] == '0030').toList();
    citaValoracion.value = cV[0];


    print('Estado->0010->FIRMA HABEAS DATA  -> $habeasData');

    if(habeasData['ESTADOPASO'] == 0){
      // print('Mostrar Dialog Habeas Data');
      onSignatureHabeasData(Get.context!);
    }

    // Completar Datos Personales
    if(datosPersonales['ESTADOPASO'] == 0){

    }


    hideLoadingDialog();



    // print('[0] cos_inf - Trat  => ${res.result?.recordsets![0]}');
    // print('[4] pagos - PAgos => ${res.result?.recordsets![4]}');
    // print('[5] planes - Planes => ${res.result?.recordsets![5]}');
    // planes = res.result?.recordsets![5];
    
    
    // var result = Planes.fromJsonList(res.result?.recordsets![5]);
    // planes.addAll(result);


    // var pagos = {};
    // var preConInf = res.result?.recordsets![0];
    // var prepagos = res.result?.recordsets![4];

    // statusUser = preConInf[0];

    // pagos = prepagos[0];

    // refWompi.value = pagos['REF_WOMPI'];


    // tratDatos.value = '2'; //statusUser['TRAT_DATOS'].toString();
    //tratDatos.value = 'Valor 2';
    // changeValue('${statusUser['TRAT_DATOS']}');
    // consInf.value = '${statusUser['CONS_INF']}';

    // print('TRAT_DATOS[TRAT_DATOS] =>>  ${statusUser['TRAT_DATOS']} ');
    // print('CONS_INF[CONS_INF] =>>  ${statusUser['CONS_INF']} ');
    // print('PAGOS[ESTADO]          =>> ${pagos['ESTADO']} ');


    // if(statusUser['TRAT_DATOS'] == 1 && pagos['ESTADO'] == 'PENDIENTE'){
    //   print('Mostrar Planes ${planes}');
    //   showPlanes.value = true;
    // }


    // Get.toNamed('/home');
    // update(["tratDatos"]);
    super.refresh();

    // print('[1] Envio =>  ${res.result?.recordsets![1]}');
    // print('[2] Recep =>  ${res.result?.recordsets![2]}');
    //
    // print('[3] HistoriaIni =>  ${res.result?.recordsets![3]}');
    // print('[4] Pagos =>  ${res.result?.recordsets![4]}');
    // print('[5] Planes =>  ${res.result?.recordsets![5]}');




  }

  void onSignatureHabeasData(context) {
    signatureController.clear();
    
    Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (BuildContext context ) => 
          Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff243588),
              foregroundColor: Colors.white,
              title: const Text (
                  'Tratamiento de datos personales',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'AvenirReg',
                ),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                // padding: EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        const Text('Autorización para el tratamiento de datos personales de',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff243588),
                            fontSize: 18,
                            fontFamily: 'AvenirBold',
                          ),
                        ),
                        const Text('CONCIENCIA PURA SAS.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff243588),
                            fontSize: 18,
                            fontFamily: 'AvenirBold',
                          ),
                        ),
                        const Text('Declaro que he sido informado que CONCIENCIA PURA S.A.S es el responsable del tratamiento de mis datos personales que estoy proveyendo a través del diligenciamiento del presente formulario, chat, correo electrónico o a través de cualquier contacto verbal, escrito o telefónico con dicha empresa, y declaro que he leído las Políticas de Tratamiento de Datos Personales disponibles en el sitio web www.vivovital.com.co',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'AvenirReg',
                          ),
                        ),
                        const Text('Por ello, consiento y autorizo de manera previa, expresa e inequívoca que mis datos personales sean tratados con sujeción a lo establecido en sus Políticas de Protección de Datos Personales, atendiendo a las finalidades allí señaladas según mi vinculación con la empresa.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'AvenirReg',
                          ),
                        ),
                        const Text('Como Titular de esta información tengo derecho a conocer, actualizar y rectificar mis datos personales, solicitar prueba de la autorización otorgada para su tratamiento, ser informado sobre el uso que se ha dado a los mismos, presentar quejas ante la SIC por infracción a la ley, revocar la autorización y/o solicitar la supresión de mis datos en los casos en que sea procedente y acceder en forma gratuita a los mismos mediante solicitud por escrito dirigida a CONCIENCIA PURA S.A.S al correo electrónico: servicioalcliente@vivovital.com.co',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'AvenirReg',
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                          child: Column(
                            children: [
                              const Text('Firmar: ',
                                // textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xff243588),
                                  fontSize: 16,
                                  fontFamily: 'AvenirReg',
                                ),
                              ),
                              Signature(
                                controller: signatureController,
                                backgroundColor: Colors.grey.withAlpha(50),
                                height: 200,
                                // width: 200,
                              ),
                                //Buttons:
                                Container(
                                  color: Color(0xff243588),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        iconSize: 36,
                                        onPressed: () async {
                                          if (signatureController.isNotEmpty){
                                            confirmSignature(context,'TRATAMIENTO');
                                          }else{
                                            Get.snackbar(
                                                'Aviso: ',
                                                'Debe Firmar',
                                                colorText: Colors.white,
                                                backgroundColor: Colors.red,
                                                icon: const Icon(Icons.error_outline, color: Colors.white)
                                            );
                                          }
                                        },
                                        icon: Icon(Icons.check, color: Colors.green)
                                      ),
                                      IconButton(
                                        iconSize: 36,
                                        onPressed: () => signatureController.clear(),
                                        icon: Icon(Icons.clear , color: Colors.red)
                                      )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                ),
              )
            ),
          ),
          fullscreenDialog: true,
      ),
    );
    // print('Firma Habeas Data');
    // Get.toNamed('/home');  
  }

  Future<List<Planes>> getPlanes() async {
    print('Devolviendo planes=> ${planes.toString()}');
    return planes;
  }
  // Consentimiento Informado

  String p1ConInf = 'El objetivo del programa para alcanzar tu peso ideal, es la FORMACIÓN de hábitos de alimentación adecuada y estilos de vida saludable, a partir de varias HERRAMIENTAS PRÁCTICAS que te entregaremos durante 90 días. Inicialmente, en la primera etapa, alcanzarás bajar de peso y mejorar algunos indicadores claves. En la segunda etapa (que es opcional), durante 270 días conseguirás un resultado optimo y disminuirás el riego de efecto rebote. En ambas etapas se ofrece una experiencia interactiva con el acompañamiento de profesionales de la salud y de disciplinas complementarias, a través de una plataforma digital, en tiempo sincrónico y asincrónico. El éxito del tratamiento depende de tu DECISIÓN y tu COMPROMISO, actitudes que se requieren para realizar e incorporar a tu vida nuestras recomendaciones. El componente presencial está dado por consultas de Medicina Externa, las cuales determinarán (junto con tus exámenes clínicos), las posibles causas que te llevaron al sobrepeso u obesidad. Con base en esa información recibirás unas recomendaciones y tu diagnóstico. A partir de ese momento de verdad iniciarás tu acompañamiento en nuestra plataforma digital, con componentes de medicina, nutrición, psicología, terapia de sueño, fisioterapia, actividad física, manejo de emociones, motivadores y gastronomía.';
  String p2ConInf = 'También tendrás acceso a planes alimentarios variados y diseñados de acuerdo con tus necesidades y preferencias, complementados con videos gastronómicos que harán más fácil tu adaptación.';
  String p3ConInf = 'Ten en cuenta que al inicio del programa, mientras tu cuerpo logra la asimilación del tratamiento, podrías presentar irritabilidad, dolor de cabeza y mareos entre otras reacciones leves, propias de un cambio de alimentación, evita alarmarte. Por ello una de nuestras fortalezas es que todo tu tratamiento será realizado bajo la supervisión de profesionales de la salud, quienes realizarán las acciones necesarias para reducir eventuales efectos secundarios. Adicional a lo anterior, contarás con un chat interactivo donde podrás resolver tus dudas y recibirás recomendaciones propias del programa.';
  String p4ConInf = 'Durante el proceso harás parte de varias evaluaciones y encuestas que nos ayudarán a conocer o identificar algunos aspectos que pueden estar interfiriendo (NO SON DIAGNÓSTICOS) en el buen desarrollo de tu tratamiento y servirán de guías para los diferentes profesionales que te estarán acompañando. Las recomendaciones de los profesionales se harán a MODO ASINCRÓNICO con videos direccionados desde de la plataforma digital.';
  String p5ConInf = 'Los controles nutricionales (TELEORIENTACIÓN - SINCRÓNICA) serán mensuales y, si se paga la membresía, cada 3 meses después de los 90 días. Hay una segunda consulta con medicina externa a los 90 días y otras dos si se continua con la membresía. Estará disponible un chat para solucionar inquietudes durante los 90 días que dura el programa VITAL-PLUS. También se incluye la primera VITAL-BOX, que se entregará sin costo adicional en el lugar que se acuerde o especifique.';
  String p6ConInf = 'En caso de necesitar la atención extra con algunos de nuestros profesionales, el servicio tendrá un costo adicional, VivoVital sólo se encargará de la logística requerida para que se realice la atención.';
  String p7ConInf = 'Podrás cancelar las citas de Medicina o Teleorientación nutricional con 12 horas de anticipación, en caso contrario serán descontadas de las adquiridas en tu PLAN, pero podrás cancelar un valor adicional para acceder nuevamente a ese servicio.';
  String p8ConInf = 'Declaro que no presento ninguna de las enfermedades de los criterios de exclusión absolutos y en caso de presentar algunos de los criterios de exclusión relativos o alguna enfermedad que el profesional considere es de especial vigilancia, me comprometo a presentar los soportes médicos solicitados.';
  String p9ConInf = 'Comprendo el propósito del tratamiento. Me han sido explicados los posibles beneficios y riesgos del programa de adelgazamiento. Acepto que no me han sido garantizados los resultados del tratamiento, en el sentido que la intervención se constituye en una práctica de medios y no de resultados. En consecuencia, libre y voluntaria autorizo a ser intervenido en el programa que ofrece CONCIENCIA PURA S.A.S. para el adelgazar y firmo a continuación a los 18 días del mes Enero del año 2023.';
  String p10ConInf = 'RECUERDA QUE TU COMPROMISO CON TODAS LAS ACTIVIDADES PROGRAMADAS ASEGURAN UN MEJOR RESULTADO';

  void onPagar(String? idplan, dynamic valor, String descplan) async{


    var idafiliado = user.toJson();
    print('idafiliado -> ${idafiliado}');
    showLoadingDialog();
    Json json = Json(
      modelo: 'VIVO_AFI_APP',
      metodo: 'ACTUALIZAR_PAGO',
      parametros: {
        "IDAFILIADO": '${idafiliado['IDAFILIADO']}',
        "REF_WOMPI": '${refWompi.value}',
        "IDPLAN": '${idplan}',
        "NOADMISION": '${idafiliado['NOADMISION']}',
      }
    );
    //
    ResponseApi res = await jsonProvider.json(json);
    // dynamic res = await jsonProvider.json(json);
    hideLoadingDialog();
    // print('Respuesta res  -> ${res}');
    var respuesta = res.result?.recordsets[0];

    keyPublic.value = respuesta[0]['DATO'];
    keyPrivated.value = 'prv_test_Ik81BFUW6lp1UMtP398YxT5HDuksqguL';



    Map<dynamic, dynamic> paid = {
      "refWompi": refWompi.value,
      "pubKey": 'pub_test_Uq7PKLNPHuj9074IHfqVNsHnH7JMSF4E',//keyPublic.value,
      "keyPrivated": 'prv_test_Ik81BFUW6lp1UMtP398YxT5HDuksqguL', //keyPrivated.value,
      "PlanCost": valor,
      "descPlan": descplan
    };
    GetStorage().write('paid', paid);


    print('Respuesta res  -> ${respuesta[0]['DATO']}');
    Get.toNamed('/paid');
    // update();
  }


}