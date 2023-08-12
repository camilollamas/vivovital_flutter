import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vitalhelp_app/src/pages/home/home_controller.dart';
import 'package:vitalhelp_app/src/utils/drawer_menu.dart';
import 'package:signature/signature.dart';
import 'package:vitalhelp_app/src/models/planes.dart';
import 'package:intl/intl.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../presentation/blocs/notifications/notifications_bloc.dart';


class HomePage extends StatelessWidget {
  HomeController con = Get.put(HomeController());
  Future<void>? _launched;
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool webView = true;
  bool webViewJs = true;

  static const html = '''
    <h1>Introducing Flutter</h1>
    <h3>Google Developers</h3>
    <p>Get started at <a href="https://flutter.io">https://flutter.io</a> today.</p>

    <p>Flutter is Google’s mobile UI framework for crafting high-quality native interfaces on iOS and Android in record time. Flutter works with existing code, is used by developers and organizations around the world, and is free and open source.</p>

    <iframe width="560" height="315" src="https://www.youtube.com/embed/fq4N0hgOWzU"></iframe>

    <h1>Filler text below</h1>
    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent neque nibh, interdum bibendum enim ut, varius pretium lacus. Sed ut hendrerit eros, blandit lacinia risus. Maecenas sit amet ullamcorper arcu, vitae bibendum eros. Morbi ipsum urna, elementum non dui eu, tristique hendrerit ipsum. Donec ullamcorper neque libero, eu fermentum purus ultrices ac. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nullam dictum justo vel urna viverra maximus.</p>
    <p>Donec porttitor vulputate diam, eu accumsan diam. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nunc egestas pellentesque molestie. Donec vitae vestibulum turpis. Mauris sodales lacus ac porttitor placerat. Nunc feugiat lorem et ultrices tincidunt. Nam vehicula efficitur leo eget dapibus. Sed id enim est.</p>
    <p>Nam velit enim, elementum in egestas ac, faucibus non elit. Curabitur ac ultrices sem. Interdum et malesuada fames ac ante ipsum primis in faucibus. Proin mattis quis felis a maximus. Nulla diam ligula, tincidunt id viverra ut, consectetur eu odio. Quisque id nunc sed dui interdum tristique. Curabitur faucibus, lorem sit amet tempus porttitor, justo felis mollis justo, sit amet tempus massa nulla et mauris. Nulla viverra tortor sed velit malesuada, sed bibendum justo elementum. Quisque id nisl tristique, venenatis eros vitae, fermentum elit. Ut nec faucibus lacus. Proin nisl quam, ullamcorper id tellus at, mattis convallis orci. Maecenas viverra mollis ullamcorper. Donec tincidunt, elit id placerat consequat, nisi purus tincidunt erat, sed aliquet justo leo a felis.</p>
    <p>Quisque sodales dui nec dictum bibendum. Aenean pellentesque efficitur elit, ut tincidunt leo laoreet ut. Aenean ac molestie dui, at fringilla mi. Vivamus mollis, ipsum ut suscipit molestie, augue nisl maximus lectus, id condimentum dui leo ac lectus. Donec arcu velit, pellentesque ut rutrum pharetra, convallis at ligula. Cras vel justo a nulla gravida porta. Sed vestibulum eget ipsum a scelerisque.</p>
    <p>Ut venenatis et mauris at venenatis. Proin vitae lacus sagittis, ultrices lorem non, tincidunt enim. Mauris sit amet odio et sapien tristique sollicitudin vel ut nisl. Nulla mauris diam, commodo quis ex porta, ornare auctor eros. Aliquam egestas felis non libero sodales condimentum ac sed magna. Morbi vitae ante in ligula faucibus aliquam. Vivamus nec gravida odio. Duis pharetra diam a malesuada gravida. Curabitur sit amet tincidunt dui. In sagittis augue at nibh fringilla fringilla. Curabitur volutpat in leo id fringilla.</p>
  ''';
  
  Widget? get builder => null;

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
                          icon: const Icon(
                            Icons.menu,
                            color: Color(0xFFFFFFFF),
                            size: 30,
                          ),
                          onPressed: () => { scaffoldKey.currentState?.openDrawer() },
                        ),
                        title: const Text(
                            'VitalHelp App',
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
                            Visibility(
                              visible: con.habeasData.value['ESTADOPASO'] == 0 ? true : false,
                              child: _cardSignature(context)
                            ),
                            Visibility(
                                visible: con.habeasData.value['ESTADOPASO'] == 1 && con.datosPersonales.value['ESTADOPASO'] == 0 ? true : false,
                                child: _cardDatosPersonales(context)
                            ),
                            Visibility(
                                visible: con.datosPersonales.value['ESTADOPASO'] == 1 && con.citaValoracion.value['ESTADOPASO'] == 0 ? true : false,
                                child: _cardCitaValoracion(context)
                            ),
                            // Visibility(
                            //     child: Text('Consultar planes')
                            // ),
                            Visibility(
                              visible: con.programaPagado.value['ESTADOPASO'] == 1 ? true : false,
                              child: _cardPlanPagado(context)
                            ),
                            Visibility(
                              visible: con.showButtonNotify.value, 
                              child: _notificacionAcivated(context),
                            ),
                            // _notificacionAcivated(context),
                            // _getStatusNotify(context),
                            Visibility(
                                visible: con.tratDatos.value == '0' ? true : false,
                                child: _cardSignature(context)
                            ),
                            Visibility(
                                visible: con.showPlanes.value,
                                child:
                                Column(
                                  children: [ FutureBuilder(
                                          future: con.getPlanes(),
                                          builder: (context, snapshot){
                                           if(snapshot.hasData){
                                              return
                                               ListView.builder(
                                                 scrollDirection: Axis.vertical,
                                                 shrinkWrap: true,
                                                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                   itemCount: snapshot.data?.length ?? 0,
                                                   itemBuilder: (_, index) {
                                                     return _planesCard(snapshot.data![index], context);
                                                   }
                                               );
                                            }else{
                                              return Text('Sin PLanes');
                                            }
                                          }
                                      )
                                    ]
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
      margin: const EdgeInsets.only(top: 20),
      alignment: Alignment.topLeft,
      child: Card(
        color: Color(0xFFe3f2fd),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: const BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Color(0xFF243588),
                    width: 5
                )
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Plan Asignado:',
                    style: TextStyle(
                      fontSize: 19,
                      // fontWeight: FontWeight.w300,
                      color: Color(0xFF243588),
                      fontFamily: 'AvenirReg',
                    )
                ),
                Text('${plan.descplan ?? ''} ${plan.idplan ?? ''}',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF243588),
                      fontFamily: 'AvenirReg',
                    )
                
                ),
                Text('Inversión: ${numberFormat.format(plan.valor)}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF243588),
                      fontFamily: 'AvenirBold',
                    )
                ),
                const Divider(),
                // Text( '${ con.programaSeleccioando['CONS_INF'] == 0 ? 'Para continuar debe firmar el consentimiento informado': 'Continuar con el Pago.'}' , // '',
                const Text( 'Continuar con el pago:' , // '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF243588),
                      fontFamily: 'AvenirBold',
                    )
                ),
                const Divider(),
                const Text( 'Enlace de pago:' , // '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF243588),
                      fontFamily: 'AvenirReg',
                    )
                ),
                // Text(plan.link),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          final Uri toLaunch = Uri(scheme: 'https', host: 'checkout.wompi.co', path: '/l/${plan.link}');
                          _launched = _launchInBrowser(toLaunch);
                        },
                        child: 
                        const Text('Abrir enlace de pago',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'AvenirReg',
                                ),)
                      ),
                    ]
                  )
                ),
                // const Divider(),
                // const Text( 'Pago con tarjeta:' , // '',
                //     textAlign: TextAlign.justify,
                //     style: TextStyle(
                //       fontSize: 14,
                //       fontWeight: FontWeight.w300,
                //       color: Color(0xFF243588),
                //       fontFamily: 'AvenirReg',
                //     )
                // ),
                // Container(
                //     margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                //     child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           // TextButton(
                //           //   onPressed: () {
                //           //     print('Pagar IDPLAN: ${plan.idplan}, VALOR: ${plan.valor}, DESC: ${plan.descplan}, REF_WOMPI: ${plan.refWompi}');
                //           //     con.onPagar(plan);
                //           //   },
                //           //   child: 
                //           //   const Text('Continuar con el pago',
                //           //           style: TextStyle(
                //           //             fontSize: 18,
                //           //             fontWeight: FontWeight.w300,
                //           //             fontFamily: 'AvenirReg',
                //           //           ),
                //           //         )
                //           // ),

                //           // ElevatedButton(
                //           //     onPressed: () => {
                //           //       con.onPagar(plan),
                //           //     },
                //           //     style: ElevatedButton.styleFrom(
                //           //         padding: EdgeInsets.symmetric(horizontal: 15)
                //           //     ),
                //           //     child: Text(
                //           //       '${ con.programaSeleccioando['CONS_INF'] == 0 ? 'Pagar con Tarjeta': 'Pagar'}' ,
                //           //       style: const TextStyle(
                //           //         color: Colors.white,
                //           //         fontSize: 18,
                //           //         fontWeight: FontWeight.w300,
                //           //         fontFamily: 'AvenirReg',
                //           //       ),
                //           //     )
                //           // )
                //         ]
                //     )
                // ),
              ]
            ),
          ),
        ),
      ),
    );

  }


  Widget _inputEmail(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: const TextField(
          // controller: '',
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Correo electrónico',
            // prefixIcon: Icon(Icons.account_circle)
          )
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
          decoration: const BoxDecoration(
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
                        onPressed: () => { con.onSignatureHabeasData(context) },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 15)
                        ),
                        child: const Text(
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
  Widget _cardDatosPersonales(BuildContext context){
    return Container(
      margin: const EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Card(
        color: Color(0xFFe3f2fd),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: const BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Color(0xFF243588),
                    width: 5
                )
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                    'Es hora de actualizar tus datos personales:',
                    style: TextStyle(
                      fontSize: 18,
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
                                Get.toNamed('/profile')
                                // con.onSignatureHabeasData(context) 
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 15)
                              ),
                              child: const Text(
                                'Ir al perfil',
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
  Widget _cardCitaValoracion(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Card(
        color: Color(0xFFe3f2fd),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: const BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Color(0xFF243588),
                    width: 5
                )
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                    'Agenda tu cita de Valoración para establecer el programa que mejor se adapte a tus necesidades.',
                    style: TextStyle(
                      fontSize: 18,
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
                                Get.toNamed('/dates')
                                // con.onSignatureHabeasData(context) 
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 15)
                              ),
                              child: const Text(
                                'Ir a Citas',
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
  Widget _cardPlanPagado(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Card(
        color: Color(0xFFe3f2fd),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: const BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Color(0xFF243588),
                    width: 5
                )
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                    'Gracias por ser parte de VitalHelp tu plan actual es.',
                    style: TextStyle(
                      fontSize: 18,
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
                          Text('${con.programaPagado.value['DESCPLAN']}',
                            style: const TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.w300,
                              color: Color(0xFF243588),
                              fontFamily: 'AvenirBold',
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
  
  Widget _notificacionAcivated(BuildContext context){
    return
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Activar Notificaciones: '),
        IconButton(
                icon: const Icon(Icons.notifications),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  iconColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  context.read<NotificationsBloc>().requestPermission();
                },
              ),
      ],
    );
  }
  Widget _getStatusNotify(BuildContext context){
    return Text('${con.notificationsBloc.state.status}');
  }


  Widget _bgDegrade(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
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

class _WidgetFactory extends WidgetFactory {
  @override
  final bool webView;

  @override
  final bool webViewJs;

  _WidgetFactory({
    required this.webView,
    required this.webViewJs,
  });
}

class FullScreenDialog extends StatelessWidget {
  HomeController con = Get.put(HomeController());
  @override
  Widget build(BuildContext context){
    return 
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
                  const Text('Declaro que he sido informado que CONCIENCIA PURA S.A.S es el responsable del tratamiento de mis datos personales que estoy proveyendo a través del diligenciamiento del presente formulario, chat, correo electrónico o a través de cualquier contacto verbal, escrito o telefónico con dicha empresa, y declaro que he leído las Políticas de Tratamiento de Datos Personales disponibles en el sitio web www.vitalhelp.com.co',
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
                  const Text('Como Titular de esta información tengo derecho a conocer, actualizar y rectificar mis datos personales, solicitar prueba de la autorización otorgada para su tratamiento, ser informado sobre el uso que se ha dado a los mismos, presentar quejas ante la SIC por infracción a la ley, revocar la autorización y/o solicitar la supresión de mis datos en los casos en que sea procedente y acceder en forma gratuita a los mismos mediante solicitud por escrito dirigida a CONCIENCIA PURA S.A.S al correo electrónico: servicioalcliente@vitalhelp.com.co',
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
  // TODO: implement key tipo
  var tipo =  '';
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
                  const Text('PROGRAMA DE INTERVENCIÓN vitalhelp VITAL-PLUS.',
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
                  Text('Con ${con.user.documentocompleto ?? ''}',
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
                        _singButtos(context, tipo)
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

  Widget _singButtos(BuildContext context, String tipo){
    return Container(
      color: Color(0xff243588),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildCheck(context, tipo),
          buildClear()
        ],
      ),
    );
  }
  Widget buildCheck(BuildContext context, String tipo){
    return IconButton(
        iconSize: 36,
        onPressed: () async {
          if (con.signatureController.isNotEmpty){
            con.confirmSignature(context, tipo  ); //'HABEASDATA'
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
        icon: const Icon(Icons.check, color: Colors.green)
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