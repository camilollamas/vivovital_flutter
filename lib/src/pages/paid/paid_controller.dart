
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:load/load.dart';
import 'package:vitalhelp_app/src/models/user.dart';
import 'package:vitalhelp_app/src/providers/wompi_provider.dart';
import 'package:vitalhelp_app/src/providers/json_provider.dart';
import 'package:vitalhelp_app/src/models/json.dart';
import 'package:vitalhelp_app/src/models/response_api.dart';

class PaidController extends GetxController {

  WompiProvider wompiProvider = WompiProvider();
  JsonProvider jsonProvider = JsonProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});
  Map paid = GetStorage().read('paid') ?? {};
  List documentTypes=['CC','PS','CE'];
  var docType = ''.obs;
  var numberDocumentController = ''.obs;

  // TextEditingController numberDocumentController  = TextEditingController();

  List listInstallments=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36];
  var InstallmentsController = 1.obs;

  var cardNumber = ''.obs;
  var expiryDate = ''.obs;
  var cardHolderName = ''.obs;
  var cvvCode = ''.obs;
  var isCvvFocused = false.obs;
  GlobalKey<FormState> keyForm = GlobalKey();
  dynamic dataTransaction = '';

  String wompiURL = '';

  PaidController(){
    // print('Paid Controller -> User -> : ${user.toJson()}');
    // print('Paid Controller -> Paid -> : ${paid}');
    getURLWompi();

  }
  bool validatePaid(){

    // print('cardNumber => ${cardNumber} ');
    // print('expiryDate => ${expiryDate} ');

    String cardNum = cardNumber.value.replaceAll(' ', '');
    if(cardNum == '' ||  cardNum.length != 16){
      Get.snackbar(
          'Formulario no válido: ',
          'Error en los números de la tarjeta.',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error_outline)
      );
      return false;
    }
    if(expiryDate.value.isEmpty){
      Get.snackbar(
          'Formulario no válido: ',
          'Error en la fecha de expiración.',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error_outline)
      );
      return false;
    }
    if(cardHolderName.value.isEmpty){
      Get.snackbar(
          'Formulario no válido: ',
          'Error en el nombre del titular.',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error_outline)
      );
      return false;
    }
    if(cvvCode.value.isEmpty){
      Get.snackbar(
          'Formulario no válido: ',
          'Error en el código de seguridad.',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error_outline)
      );
      return false;
    }
    if(docType.value == '' ){
      Get.snackbar(
          'Formulario no válido: ',
          'Error en el tipo de documento del titular.',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error_outline)
      );
      return false;
    }
    if(numberDocumentController.value == '' ){
      Get.snackbar(
          'Formulario no válido: ',
          'Error en el número de documento del titular.',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error_outline)
      );
      return false;
    }

    return true;
  }

  void confirmPaid(context){
    if(validatePaid()){
      showDialog(
          context: context,
          builder: (_) => SimpleDialog(
            contentPadding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
            title:
            Container(
                margin: const EdgeInsets.only(bottom: 20),
                child:
                const Text('Confirmación de pago',
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
                  const Text('¿Confirma que desea continuar con el pago?',
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
                              onPaid(context),
                              Navigator.pop(context, true)
                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 15)
                            ),
                            child: const Text(
                              'Pagar',
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
    else{

    }
  }

  void updateValues (){
    super.refresh();
  }
  void onCreditCardModelChange(CreditCardModel creditCardModel){
    cardNumber.value = creditCardModel.cardNumber;
    expiryDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName;
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
    super.refresh();
  }
  void onPaid(context) async{
    showLoadingDialog();
    FocusManager.instance.primaryFocus?.unfocus();
    var accToken = '';
    var cardId = '';
    var paySourceId = 0;
    var idTransaction = '';
    
    String refWompi = paid['refWompi'];
    int plnCost = paid['PlanCost'];
    String pubkey = paid['pubKey'];
    String prvkey = paid['keyPrivated'];

    // acceptance_token
    print('================= acceptance_token =========================');
    print('wompiURL == $wompiURL');
    print('pubkey == $pubkey');
    print('prvkey == $prvkey');
    print('plnCost == $plnCost');
    print('refWompi == $refWompi');

    dynamic res = await wompiProvider.acceptance_token(wompiURL, pubkey);

    print('=> acceptance_token -> ${res['data']['presigned_acceptance']['acceptance_token']}');
    accToken = res['data']['presigned_acceptance']['acceptance_token'];

    //Create  Card
      print('================= Create  Card =========================');
      List<String> list = expiryDate.split('/');
      String year = list[1];
      int month = int.parse(list[0]);

      Map<String, String> card = {
        "number": cardNumber.value.replaceAll(' ', ''),
        "cvc": cvvCode.value,
        "exp_month": getMonth(month),
        "exp_year": year,
        "card_holder": cardHolderName.value
      };

      dynamic resp = await wompiProvider.create_card(wompiURL,card, pubkey);
      if(resp["status"] == 'ERROR'){
        hideLoadingDialog();
        Get.snackbar(
            'Aviso - create_card: ',
            'Ha ocurrido un error, vuelva a intentar.',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.error_outline)
        );
        return;
      }
      cardId = resp['data']['id'];
    print('cardId : $cardId');

    //Create payment source create_pay_source
    print('================= Create payment source =========================');

      Map<String, String> paymentSource = {
        "type": "CARD",
        "token": cardId,
        "acceptance_token": accToken,
        "customer_email": '${user.email}'
      };

      dynamic respo = await wompiProvider.create_pay_source(wompiURL,paymentSource, prvkey);
      if(respo["status"] == 'ERROR'){
        hideLoadingDialog();
        Get.snackbar(
            'Aviso - create_pay_source: ',
            'Ha ocurrido un error, vuelva a intentar.',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.error_outline)
        );
        return;
      }
    print('=> create_pay_source id -> ${respo['data']}');
      paySourceId = respo['data']['id'] as int;


      //Create Transactions
    print('================= Create Transactions =========================');
      Map<String, dynamic> transaction = {
        "acceptance_token": accToken,
        "amount_in_cents": plnCost*100,
        "currency": "COP",
        "customer_email": "${user.email}",
        "payment_method": {
          "type": "CARD",
          "token": cardId,
          "installments": InstallmentsController.value
        },
        "payment_source_id": paySourceId,
        "redirect_url": "https://mitienda.com.co/pago/resultado",
        "reference": '${refWompi}_$paySourceId',
        "customer_data": {
          "phone_number": "57${user.celular}",
          "full_name": "${user.pnombre} ${user.snombre ?? ''} ${user.papellido ?? ''} ${user.sapellido ?? ''}",
          "legal_id": "${user.docidafiliado}",
          "legal_id_type": user.tipoDoc!.trim()
        },
        "shipping_address": {
          "address_line_1": "${user.direccion}",
          "address_line_2": "${user.direccion}",
          "country": "CO",
          "region": "${user.departamento}",
          "city": "${user.nombreciu}",
          "name": "${user.pnombre} ${user.snombre} ${user.papellido} ${user.sapellido}",
          "phone_number": "57${user.celular}",
          "postal_code": "250001"
        }
      };
      print(transaction);

      dynamic respon = await wompiProvider.create_transaction(wompiURL, transaction, prvkey);
      if(respo["status"] == 'ERROR'){
        hideLoadingDialog();
        Get.snackbar(
            'Aviso - create_transaction: ',
            'Ha ocurrido un error, vuelva a intentar.',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.error_outline)
        );
        return;
      }
      print('=> create_transaction id -> ${respon['data']}');
      // paySourceId = respo['data']['id'];
      idTransaction = respon['data']['id'];

      // print('=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> entra delay');
      await Future.delayed(const Duration(seconds: 5));
      print('=======================================> sale delay');
      // get transaction
      print('================= Get Transactions =========================');
      dynamic response = await wompiProvider.get_transactions(wompiURL, idTransaction);
      if(response["status"] == 'ERROR'){
        hideLoadingDialog();
        Get.snackbar(
            'Aviso - get_transactions 1: ',
            'Ha ocurrido un error, vuelva a intentar.',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.error_outline)
        );
        return;
      }
      print('=> get_transactions data -> $response');
      dataTransaction = response;
      if(response['data']['status'] == 'APPROVED' ){
        print('======================> transaccion aprobada');

        var afi = user.toJson();
        // print('idafiliado -> ${idafiliado['IDAFILIADO']}');
        // showLoadingDialog();
        Json json = Json(
            modelo: 'VIVO_AFI_APP',
            metodo: 'PROCESAR_PAGO',
            parametros: {
              "IDENTIFICADOR": idTransaction,
              "REF_WOMPI": paid['refWompi'],
              "IDAFILIADO": '${afi['IDAFILIADO']}'
            });
        //
        ResponseApi res = await jsonProvider.json(json);
        // print('res=>>>> ${res}');
        Get.snackbar(
            'Aviso: ',
            'Pago procesado correctamente!',
            colorText: Colors.white,
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check)
        );
        // Get.toNamed('/home');
        hideLoadingDialog();
        messagePostPaid(context);
      }
      if(response['data']['status'] == 'DECLINED' ){
        print('======================> transaccion rechazada');
        Get.snackbar(
            'Transacción declinada! ',
            'Intenta nuevamente o prueba con otra tarjeta.',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.error_outline)
        );
        hideLoadingDialog();
      }

    hideLoadingDialog();
  }

  void getURLWompi () async {
    Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'URLWOMPI'
      );
    //
    ResponseApi res = await jsonProvider.json(json);
    // print('res=>>>> ${res.result?.recordsets!}');
    List<dynamic> list = res.result?.recordsets![0];

    // print('list => ${list[0]['URL_WOMPI']}');
    wompiURL = list[0]['URL_WOMPI'];
  }

  void messagePostPaid(context){
    // print('messagePostPaid');
    showDialog(
      useSafeArea: false,
      barrierDismissible: false,
        context: context,
        builder: (_) => SimpleDialog(
          contentPadding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
          title:
          Container(
              margin: const EdgeInsets.only(bottom: 20),
              child:
              const Text('Pago Aprobado!',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFF289D01),
                    fontFamily: 'AvenirBold',
                  )
              )
          ),
          children: [
            Column(
              children: [
                const Text('Tu pago ha sido aprobado y has quedado vinculado al programa:',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'AvenirReg'
                  ),
                ),
                Text('${paid['descPlan']}',
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'AvenirBold'
                  ),
                ),
                const Text('Comenzarás recibir notificaciones.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'AvenirReg'
                  ),
                ),
                // Row(
                //   children: [
                //     Icon(Icons.chevron_right_outlined, color: Color(0xFF243588)),
                //     Text('Datos personales.',
                //       textAlign: TextAlign.justify,
                //       style: TextStyle(
                //           fontSize: 16,
                //           color: Color(0xFF243588),
                //           fontFamily: 'AvenirReg'
                //       ),
                //     ),
                //   ],
                // ),
                // Row(
                //   children: [
                //     Icon(Icons.chevron_right_outlined, color: Color(0xFF243588)),
                //     Text('Antecedentes Iniciales.',
                //       textAlign: TextAlign.justify,
                //       style: TextStyle(
                //           fontSize: 16,
                //           color: Color(0xFF243588),
                //           fontFamily: 'AvenirReg'
                //       ),
                //     ),
                //   ],
                // ),
                // Row(
                //   children: [
                //     Icon(Icons.chevron_right_outlined, color: Color(0xFF243588)),
                //     Text('Anamnesis Alimentaria.',
                //       textAlign: TextAlign.justify,
                //       style: TextStyle(
                //           fontSize: 16,
                //           color: Color(0xFF243588),
                //           fontFamily: 'AvenirReg'
                //       ),
                //     ),
                //   ]
                // ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () => {
                            Navigator.pop(context, true),
                            goToProfile()
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 15)
                          ),
                          child: const Text(
                            'Continuar ',
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
  void goToProfile(){
    Get.offNamed('/profile');
  }
  void onCancel(){
    // Get.toNamed('/home');
    // Get.removeRoute('paid');
    // Get.offUntil('paid', (route) => false);
    // Get.offNamed('/home');
    Get.offAllNamed('/home');
  }

  String getMonth(int month){
    if(month < 10){
      return '0$month';
    }else{
      return '$month';
    }

  }
}