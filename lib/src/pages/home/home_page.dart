import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:url_launcher/link.dart';
import 'package:vitalhelp_app/src/pages/home/home_controller.dart';
import 'package:vitalhelp_app/src/utils/drawer_menu.dart';
import 'package:signature/signature.dart';
import 'package:vitalhelp_app/src/models/planes.dart';
import 'package:intl/intl.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/alerta.dart';
import '../../presentation/blocs/notifications/notifications_bloc.dart';
import 'package:vitalhelp_app/src/models/user.dart';
import 'package:get_storage/get_storage.dart';


class HomePage extends StatelessWidget {
  HomeController con = Get.put(HomeController());
  Future<void>? _launched;

  User user = User.fromJson(GetStorage().read('user') ?? {});

  HomePage({super.key});
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
          con.getDay();
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
                            _nameUser(context),
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
                                              return const Text('  ');
                                            }
                                          }
                                      )
                                    ]
                                  )
                            )
                            ,_textNotificaciones(context)
                            ,Visibility(
                              // ignore: unrelated_type_equality_checks
                              visible: con.showNotify == true,
                              child: _listView(), 
                            )
                            ,Visibility(
                              // ignore: unrelated_type_equality_checks
                              visible: con.notify.isEmpty,
                              child: _noNotificaciones(context), 
                            )
                            
                            ,_notificacionesButton(context)
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

  Widget _nameUser(BuildContext context){
    return 
    Container(
      // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: const EdgeInsets.only(left: 0, top: 10, bottom: 0),
      alignment: Alignment.topLeft,
      child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row (
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: user.sexo == 'Masculino'
                        ? const AssetImage('assets/img/avatars/male.png')
                        : const AssetImage('assets/img/avatars/female.png'),
                    //child: FlutterLogo(size: 42.0),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        'Hola,',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF243588),
                          fontFamily: 'AvenirReg',
                        )
                    ),
                    RichText(
                      softWrap: true,
                      maxLines: 2,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF243588),
                          fontFamily: 'AvenirReg',
                        ),
                        children: <TextSpan>[
                          TextSpan(text: '${con.user.pnombre} ${con.user.snombre} \n'),
                          TextSpan(text: '${con.user.papellido} ${con.user.sapellido}')
                          // TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
                        ]
                        )
                    ),
                    // Divider(),
                ],),
              ],
            ),
            Divider(),
            Visibility(
              visible: con.programaPagado.value['ESTADOPASO'] == 1 ? true : false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _imageLogo(),
                      Container(
                        margin: const EdgeInsets.only(left: 10, top: 0, bottom: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                                'Tu plan actual es:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF243588),
                                  fontFamily: 'AvenirReg',
                                )
                            ),
                            Text('${con.programaSeleccioando['DESCPLAN']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF243588),
                                  fontFamily: 'AvenirReg',
                                )
                            ),
                            const Divider()
                        ],)
                      ),
                    ],
                  ),
                ]
              )
            ),
          ],
        ),
    );
  }
  Widget _imageLogo(){
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 0),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/icon/app-icon-2.png',
          width: 50,
        )
      ),
    );
  }
  Widget _planesCard2(Planes plan, context){
    final numberFormat = NumberFormat.currency(locale: 'es_MX', symbol:"\$");
    return Container(
      margin: const EdgeInsets.only(top: 20),
      alignment: Alignment.topLeft,
      child: Card(
        color: const Color(0xFFe3f2fd),
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
  Widget _planesCard(Planes plan, context) {
  final numberFormat = NumberFormat.currency(locale: 'es_MX', symbol: "\$");
  return Container(
    margin: const EdgeInsets.only(top: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(width: 1, color: Colors.grey), // Borde de 1px
    ),
    child: Card(
      color: const Color(0xFFe3f2fd),
      margin: const EdgeInsets.all(0), // Sin margen para evitar superposiciones
      clipBehavior: Clip.hardEdge,
      child: Container(
        padding: const EdgeInsets.all(10), // Padding interno
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Plan Asignado:',
              style: TextStyle(
                fontSize: 19,
                color: Color(0xFF243588),
                fontFamily: 'AvenirReg',
              ),
            ),
            Text(
              '${plan.descplan ?? ''} ${plan.idplan ?? ''}',
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: Color(0xFF243588),
                fontFamily: 'AvenirReg',
              ),
            ),
            Text(
              'Inversión: ${numberFormat.format(plan.valor)}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Color(0xFF243588),
                fontFamily: 'AvenirBold',
              ),
            ),

            const Divider(),
            const Text(
              'Enlace de pago:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Color(0xFF243588),
                fontFamily: 'AvenirReg',
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextButton(
                onPressed: () {
                  final Uri toLaunch = Uri(
                    scheme: 'https',
                    host: 'checkout.wompi.co',
                    path: '/l/${plan.link}',
                  );
                  _launched = _launchInBrowser(toLaunch);
                },
                child: const Text(
                  'Abrir enlace de pago',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'AvenirReg',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _textNotificaciones(BuildContext context){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      alignment: Alignment.topLeft,
      child: 
      const Column(
          children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications,
                  color: Color(0xff72246c),
                  size: 30,
                ),
                Text('Notificaciones de hoy',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Color(0xff72246c),
                    fontFamily: 'AvenirReg',
                  )
                ),
              ]
            ),
          ]
      )
    );

  }
  Widget _noNotificaciones(BuildContext context){
    return Container(
      margin: const EdgeInsets.only(left: 0, top: 20, bottom: 0),
      child: 
      const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off,
              color: Color.fromARGB(255, 200, 200, 200),
              size: 100,
            ),
            Text('Sin Notificaciones',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Color.fromARGB(255, 200, 200, 200),
                fontFamily: 'AvenirReg',
              )
            ),
          ]
      )
    );
  }
  Widget _notificacionesButton(BuildContext context){
    return
    //Button notifications
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: 
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              con.goToRoute('notifications');
            },
            child: const Text('Ir a Notificaciones.',
                style: TextStyle(
                  color: Color(0xff243588),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'AvenirReg',
                )
            ),
          )
        ]
      )
    );

  }
  Widget _listView(){
    return FutureBuilder(
        future: con.sendNotify(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return
              Column(
                children: [
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (_, index){
                        print('index => $index context => ${context.toString()}');
                        return _notifyCards(snapshot.data![index], context);
                      }
                  ),
                ],
              );
          }else{
            return const Text('Sin Notificaciones');
          }
        }
    );
  }
  Widget _notifyCards(Alerta alerta, BuildContext context){
    return Container(
        margin: const EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        child: Card(
          color: const Color(0xFFc1f4cd),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          clipBehavior: Clip.hardEdge,
          child: 
          Container(
            decoration: const BoxDecoration(
              border: Border.symmetric(
                  vertical: BorderSide(
                      color: Color(0xFF21ba45),
                      width: 5
                  )
              ),
            ),
            child: 
            Container(
              margin: const EdgeInsets.only(top: 10, right: 10, bottom: 0, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 0, right: 10),
                              child: Ink(
                                decoration: _colorNotify(alerta.tipo),
                                child: InkWell(
                                  onTap: () {
                                    // con.chooseDate();
                                  },
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: _iconNotify(alerta.tipo),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child:Text('${alerta.titulo ?? ''} ',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    // fontWeight: FontWeight.w300,
                                    color: Color(0xFF243588),
                                    fontFamily: 'AvenirBold',
                                  )
                              ),
                            )
                          ],
                        ),
                        const Divider(),
                        Container(
                          margin: const EdgeInsets.only(left: 0, right: 0),
                          alignment: Alignment.centerLeft,
                          child: Text('${alerta.descripcion ?? ''} ',
                              style: const TextStyle(
                                fontSize: 14,
                                // fontWeight: FontWeight.w300,
                                color: Color(0xFF243588),
                                fontFamily: 'AvenirReg',
                              )
                          ),
                        ),
                        Visibility( visible: alerta.tipo  == 'Video',
                            child: FloatingActionButton.extended(
                                onPressed: () => {
                                  // con.getVideo(context,alerta.iddocs, alerta.titulo, alerta.descripcion),
                                  // showLoadingDialog(),
                                  // setState(() {
                                  //   setVideoController(alerta.iddocs);
                                  //   Future.delayed(const Duration(seconds: 3), (){
                                  //     hideLoadingDialog();
                                  //     // con.getVideo(context,alerta.iddocs, alerta.titulo, alerta.descripcion);
                                  //     _tabController.index = 1;
                                  //     _videoPlayerController.play();

                                  //   });
                                  // })

                                },
                                icon: const Icon(Icons.play_arrow, color: Colors.white),
                                backgroundColor: const Color(0xFF03a9f4),
                                label: const Text(
                                  'Ver',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'AvenirReg',
                                  ),
                                )
                            )
                        ),
                        Visibility( visible: alerta.tipo  == 'Enlace',
                            child: Container(
                              alignment: Alignment.bottomRight,
                              child: Link(
                                      uri: Uri.parse(alerta.enlace ?? '' ),
                                      target: LinkTarget.blank,
                                      builder: (BuildContext ctx, FollowLink? openLink) {
                                        return TextButton.icon(
                                          onPressed: openLink,
                                          label: const Text('Abrir enlace'),
                                          icon: const Icon(Icons.chevron_right_sharp),
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                                            alignment: Alignment.centerRight, // Alinea el contenido a la derecha
                                          ),
                                        );
                                      },
                                    ),
                            )
                        )
                      ],
                    ),
                ],
              )
            ),
          )
        )
    );
  }
  Decoration _colorNotify(String? type){
    if(type == 'Video' ){
      return BoxDecoration(
          border: Border.all(color: const Color(0xFF03a9f4), width: 2),
          color: const Color(0xFF03a9f4), //Colors.white,
          borderRadius: BorderRadius.circular(50.0)
      );
    }
    if(type == 'Recordatorio'){
      return BoxDecoration(
          border: Border.all(color: const Color(0xFFff9800), width: 2),
          color: const Color(0xFFff9800), //Colors.white,
          borderRadius: BorderRadius.circular(50.0)
      );
    }
    if(type == 'Audio'){
      return BoxDecoration(
          border: Border.all(color: const Color(0xFF21ba45), width: 2),
          color: const Color(0xFF21ba45), //Colors.white,
          borderRadius: BorderRadius.circular(50.0)
      );
    }

    return BoxDecoration(
        border: Border.all(color: const Color(0xFFff9800), width: 2),
        color: const Color(0xFFff9800), //Colors.white,
        borderRadius: BorderRadius.circular(50.0)
    );
  }

  Widget _iconNotify(String? type){
    if(type == 'Video' ){
      return const Icon(
          Icons.video_camera_front,
          size: 20.0,
          color: Colors.white// Color(0xFF243588),
      );
    }
    if(type == 'Recordatorio'){
      return const Icon(
          Icons.notifications_active,
          size: 20.0,
          color: Colors.white// Color(0xFF243588),
      );
    }
    if(type == 'Audio'){
      return const Icon(
          Icons.headphones,
          size: 20.0,
          color: Colors.white// Color(0xFF243588),
      );
    }

    return const Icon(
        Icons.notifications_active,
        size: 20.0,
        color: Colors.white// Color(0xFF243588),
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
      margin: const EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Card(
        color: const Color(0xFFe3f2fd),
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
  Widget _cardDatosPersonales(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(top: 20),
    alignment: Alignment.center,
    child: Card(
      color: const Color(0xFFe3f2fd),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Color(0xFF243588),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Es hora de completar tus datos personales',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF243588),
                fontFamily: 'AvenirReg',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.toNamed('/profile'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                primary: const Color(0xFF243588),
              ),
              child: const Text(
                'Ir al perfil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'AvenirReg',
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _cardCitaValoracion(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(top: 20),
    alignment: Alignment.center,
    child: Card(
      color: const Color(0xFFe3f2fd),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Color(0xFF243588),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Para continuar debes agendar una cita virtual sin costo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF243588),
                fontFamily: 'AvenirReg',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.toNamed('/dates'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                primary: const Color(0xFF243588),
              ),
              child: const Text(
                'Agendar Cita',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'AvenirReg',
                ),
              ),
            ),
          ],
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

  FullScreenDialog({super.key});
  @override
  Widget build(BuildContext context){
    return 
    Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff243588),
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
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
      color: const Color(0xff243588),
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
      icon: const Icon(Icons.check, color: Colors.green)
    );
  }
  Widget buildClear(){
    return IconButton(
        iconSize: 36,
        onPressed: () => con.signatureController.clear(),
        icon: const Icon(Icons.clear , color: Colors.red)
    );
  }

}

class ConInfDialog extends StatelessWidget{
  HomeController con = Get.put(HomeController());
  // TODO: implement key tipo
  var tipo =  '';

  ConInfDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff243588),
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
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  Text(con.p1ConInf ?? '',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text(con.p2ConInf ?? '',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text(con.p3ConInf ?? '',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text(con.p4ConInf ?? '',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text(con.p5ConInf ?? '',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text(con.p6ConInf ?? '',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text(con.p7ConInf ?? '',
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
                  Text(con.p8ConInf ?? '',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text(con.p9ConInf ?? '',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'AvenirReg',
                    ),
                  ),
                  Text(con.p10ConInf ?? '',
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
      color: const Color(0xff243588),
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
        icon: const Icon(Icons.clear , color: Colors.red)
    );
  }
}