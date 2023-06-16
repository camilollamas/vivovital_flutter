import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivovital_app/src/pages/home/home_controller.dart';
import 'package:vivovital_app/src/utils/drawer_menu.dart';
import 'package:signature/signature.dart';
import 'package:vivovital_app/src/models/planes.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  HomeController con = Get.put(HomeController());

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override

  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: con,
        initState: (_) {
          con.GetStatusUser();
        },
      builder: (_) {
      return
        Stack(
            children: [
              _imageBgWhite(),
              Positioned.fill(
                child:
                  _imageBg(context)
              ),
              _bgDegrade(context),
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                        leading: IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Color(0xFFFFFFFF),
                            size: 30,
                          ),
                          onPressed: () => { scaffoldKey.currentState?.openDrawer() },
                        ),
                        title: Text(
                            'VivoVital App',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFFFFFFFF),
                              fontFamily: 'AvenirReg',
                            )
                        ),
                      ),
                body: Stack(
                  children: [
                    Column(
                          children: [
                            Text('tratDatos =>  ${con.tratDatos.value}'),
                            Text('consInf =>  ${con.consInf.value}'),
                            Text('refWompi =>  ${con.refWompi.value}'),
                            Text('keyPublic =>  ${con.keyPublic.value}'),
                            // ElevatedButton(
                            //     onPressed: () => {
                            //     con.GetStatusUser()
                            //       // , con.changeValue('desde el boton')
                            //     },
                            //     child: Text('Cambiar Valor',
                            //         style: TextStyle(color: Colors.white)
                            //     )
                            // ),
                            Visibility(
                                visible: con.tratDatos.value == '0' ? true : false,
                                child: _cardSignature(context)
                            ),
                            Visibility(
                                visible: con.showPlanes.value,
                                child:
                                Column(
                                  children: con.planes.map((_) => FutureBuilder(
                                          future: con.getPlanes(),
                                          builder: (context, snapshot){
                                           if(snapshot.hasData){
                                              print('snapshot.hasData => ${snapshot}');
                                              return
                                               ListView.builder(
                                                 scrollDirection: Axis.vertical,
                                                 shrinkWrap: true,
                                                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                   itemCount: snapshot.data?.length ?? 0,
                                                   itemBuilder: (_, index) {
                                                     return _planesCard(snapshot.data![index], context);
                                                   }
                                               );


                                              /*  ListView.builder(
                                                itemCount: snapshot.data?.length ?? 0,
                                                itemBuilder: (_, index) {
                                                  return ListTile(
                                                  );
                                                  // return _Test(snapshot.data![index]);
                                                },
                                              );*/
                                            }else{
                                              return Text('Sin PLanes');
                                            }
                                          }
                                      )
                                    ).toList(),
                                  )
                            )
                          ],
                        )
                  ],
                ),
                key: scaffoldKey,
                drawer: Drawer(
                    child: _drawerList(),
                ),
              )
            ]
        );
      }
    );
  }

  Widget _planesCard(Planes plan, context){
    final numberFormat = NumberFormat.currency(locale: 'es_MX', symbol:"\$");

    return Container(
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Card(
        color: Color(0xFFe3f2fd),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Color(0xFF243588),
                    width: 5
                )
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('${plan.descplan ?? ''} ${plan.idplan ?? ''}',
                    style: const TextStyle(
                      fontSize: 19,
                      // fontWeight: FontWeight.w300,
                      color: Color(0xFF243588),
                      fontFamily: 'AvenirBold',
                    )
                ),
                Text( '${plan.idplan == 'VV90D' ? con.p1Pln1 : ''}',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF243588),
                      fontFamily: 'AvenirReg',
                    )
                ),
                Text( '${plan.idplan == 'VV90D' ? con.p2Pln1 : ''}',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF243588),
                    fontFamily: 'AvenirReg',
                  )
              ),
                // Text( 'Inversión: ${con.numberToMoney(plan.valor) ?? ''}',
                Text('Inversión: ${numberFormat.format(plan.valor)}',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF243588),
                      fontFamily: 'AvenirBold',
                    )
                ),
                Text( '${ con.consInf == '0' ? 'Para continuar debe firmar el consentimiento informado': 'Continuar con el Pago.'}' , // '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF243588),
                      fontFamily: 'AvenirReg',
                    )
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () => {

                                if(con.consInf == '0'){
                                  print('Firmar'),
                                  con.signatureController.clear(),
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context ) => ConInfDialog(),
                                      fullscreenDialog: true,
                                    ),
                                  )
                                },
                                if(con.consInf == '1'){
                                  print('Pagar'),
                                  con.onPagar(plan.idplan, plan.valor, plan.descplan),
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 15)
                              ),
                              child: Text(
                                '${ con.consInf == '0' ? 'Continuar': 'Pagar'}' ,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'AvenirReg',
                                ),
                              )
                          )
                        ]
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );

  }
  Widget _cardSignature(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Card(
        color: Color(0xFFe3f2fd),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Color(0xFF243588),
                    width: 5
                )
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                    'Para continuar debe diligenciar el siguiente documento:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF243588),
                      fontFamily: 'AvenirReg',
                    )
                ),
                const Text('Autorización para el tratamiento de datos personales de CONCIENCIA PURA SAS.',
                    style: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.w300,
                      color: Color(0xFF243588),
                      fontFamily: 'AvenirBold',
                    )
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () => {
                          print('On signature Document'),
                          con.signatureController.clear(),
                          // _showDialogTrat(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context ) => FullScreenDialog(),
                                fullscreenDialog: true,
                              ),
                          )
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 15)
                        ),
                        child: Text(
                          'Ver documento',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'AvenirReg',
                          ),
                        )
                    )
                  ]
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bgDegrade(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.white,
                blurRadius: 10,
                offset: Offset(0, 0)
            )
          ]
      ),
    );
  }
  Widget _imageBg(BuildContext context){
    return  Image.asset(
      'assets/img/background.png',
      fit: BoxFit.cover,
    );
  }
  Widget _imageBgWhite(){
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
    );
  }

  Future<void> _showDialogTrat (BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Dialog(
            backgroundColor: Colors.blue,
            insetAnimationDuration: Duration.zero,
            insetAnimationCurve: Curves.decelerate,
            child: Text('Esto e sun dialogo.'),
          );
          //   AlertDialog(
          //   title: const Text('Tratamiento de Datos Personales'),
          //   content: const Text('Contenideo del tratamiento de datos personales'),
          //   actions: <Widget>[
          //     TextButton(
          //         onPressed: ()=>{
          //           Navigator.of(context).pop()
          //         },
          //         child: const Text('Cerrar')
          //     )
          //   ],
          // );
        }
    );
  }
  Widget _drawerList(){
    return CustomDrawerMenu();
  }
}

class FullScreenDialog extends StatelessWidget {
  HomeController con = Get.put(HomeController());
  @override
  Widget build(BuildContext context){
    return Scaffold(
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
                          controller: con.signatureController,
                          backgroundColor: Colors.grey.withAlpha(50),
                          height: 200,
                          // width: 200,
                        ),
                        _buildButtons(context)
                      ],
                    ),
                  )

                ],
              ),
          ),
        )
      ),
    );
  }

  //Widgets
  Widget _buildButtons(BuildContext context){
    return Container(
      color: Color(0xff243588),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildCheck(context),
          buildClear()
        ],
      ),
    );
  }
  Widget buildCheck(BuildContext context){
    return IconButton(
      iconSize: 36,
      onPressed: () async {
        if (con.signatureController.isNotEmpty){
          con.confirmSignature(context,'TRATAMIENTO');
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
    );
  }
  Widget buildClear(){
    return IconButton(
        iconSize: 36,
        onPressed: () => con.signatureController.clear(),
        icon: Icon(Icons.clear , color: Colors.red)
    );
  }

}

class ConInfDialog extends StatelessWidget{
  HomeController con = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff243588),
        foregroundColor: Colors.white,
        title: const Text (
          'Consentimiento Informado',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'AvenirReg',
          ),
        ),

      ),
      body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  const Text('CONSENTIMIENTO INFORMADO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff243588),
                      fontSize: 18,
                      fontFamily: 'AvenirBold',
                    ),
                  ),
                  const Text('PROGRAMA DE INTERVENCIÓN VIVOVITAL VITAL-PLUS.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff243588),
                      fontSize: 18,
                      fontFamily: 'AvenirBold',
                    ),
                  ),
                  Text('${con.p1ConInf ?? ''}',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text('${con.p2ConInf ?? ''}',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text('${con.p3ConInf ?? ''}',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text('${con.p4ConInf ?? ''}',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text('${con.p5ConInf ?? ''}',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text('${con.p6ConInf ?? ''}',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text('${con.p7ConInf ?? ''}',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text('Yo: ${con.user.pnombre ?? ''} '
                      '${con.user.snombre ?? ''} '
                      '${con.user.papellido ?? ''} '
                      '${con.user.sapellido ?? ''} ',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text('Con ${con.user.ndocumento ?? ''}',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text('${con.p8ConInf ?? ''}',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text('${con.p9ConInf ?? ''}',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text('${con.p10ConInf ?? ''}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Color(0xff243588),
                      fontSize: 18,
                      fontFamily: 'AvenirBold',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
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
                          controller: con.signatureController,
                          backgroundColor: Colors.grey.withAlpha(50),
                          height: 200,
                          // width: 200,
                        ),
                        _singButtos(context)
                      ],
                    ),
                  )


                ],
              ),
            ),
          ),
      )
    );
  }

  Widget _singButtos(BuildContext context){
    return Container(
      color: Color(0xff243588),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildCheck(context),
          buildClear()
        ],
      ),
    );
  }
  Widget buildCheck(BuildContext context){
    return IconButton(
        iconSize: 36,
        onPressed: () async {
          if (con.signatureController.isNotEmpty){
            con.confirmSignature(context, 'CONSENTIMIENTO' );
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
    );
  }
  Widget buildClear(){
    return IconButton(
        iconSize: 36,
        onPressed: () => con.signatureController.clear(),
        icon: Icon(Icons.clear , color: Colors.red)
    );
  }
}