import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vitalhelp_app/src/pages/dates/dates_controller.dart';
import 'package:vitalhelp_app/src/utils/drawer_menu.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/citas.dart';
import '../../models/horas.dart';

class DatesPage extends StatefulWidget {
  const DatesPage({super.key});

  @override
  State<DatesPage> createState() => _DatesPageState();
}

class _DatesPageState extends State<DatesPage> {
  DatesController con = Get.put(DatesController());

  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  String fechaFormateada = '';
  String horaFormateada = '';

  Future<void>? _launched;
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }





  void _selectDate(BuildContext context) async {
    List<DateTime> dates = con.diasDisponibles;

    bool _decideWhichDayToEnable(DateTime day) {
      if (dates.contains(day)) {
        return true;
      }
      return false;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      locale: const Locale("es", "ES"),
      initialDate: con.diasDisponibles[0], //con.currentDate, //DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      // initialDatePickerMode: DatePickerMode.day,
      selectableDayPredicate: _decideWhichDayToEnable,
      helpText: 'Selecionar el día', // Can be used as title
      cancelText: 'Cancelar',
      confirmText: 'Seleccionar',
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            // primaryColor:const Color(0xff243588),
            colorScheme: const ColorScheme(
                primary: Color(0xff243588),
                secondary: Color(0xff72246c),
                error: Color(0xffC10015),
                brightness: Brightness.light,
                onPrimary: Colors.white,
                onSecondary: Color(0xff72246c),
                onError: Colors.grey,
                background: Colors.red,
                onBackground: Colors.grey,
                surface: Colors.red,
                onSurface: Colors.black
            )
          ), // This will change to light theme.
          child:
          child ?? const Text('No se pudo seleccionar la fecha'), 
        );
      },
    );
    con.getHoras(pickedDate);
    if (pickedDate != null && pickedDate != con.currentDate) {
      setState(() {
        con.currentDate = pickedDate;
        fechaFormateada = dateFormat.format(pickedDate);
      });
    }
  }
  
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DatesController>(
        init: con,
        initState: (_) {
          con.getStatus();
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
                        onPressed: () => {scaffoldKey.currentState?.openDrawer()},
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
                    body: Obx(() => Stack(
                        children:[
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _buttonBack(),
                                  _textTitlePage()
                                ],
                              ),
                              _divider(),
                              Visibility(
                                visible: con.mostrarAgenda.value == '1' ? true : false,
                                child: 
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _textDateD(),
                                      _divider(),
                                      _selectDay(context),
                                      _textHora(),
                                      _inputHour(con.horasOpt, context),
                                      _buttonAgendar()
                                    ],
                                  ),
                              ),
                              Visibility(
                                visible: con.showCitas.value,
                                child: 
                                  Column(
                                    children: [
                                      FutureBuilder(
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
                                                    return _citasCard(snapshot.data![index], context);
                                                  }
                                              );
                                          }else{
                                            return const Text('Sin Citas');
                                          }
                                        }

                                      )
                                    ],
                                  )
                              )
                            ]
                          )
                        ]
                    )),
                    // Stack(
                      // children: [
                    //   ],
                    // ),
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

  Widget _buttonBack() {
    return Container(
            margin: const EdgeInsets.only(left: 20),
            child: IconButton(
              onPressed: () => Get.offNamed('/home'),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF243588),
                size: 20,
              ),
            )
    );
  }
  Widget _textTitlePage(){
    return const Text(
        'Citas Médicas',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Color(0xFF243588),
          fontFamily: 'AvenirReg',
        )
    );
  }

  Widget _divider(){
    return
      const Divider(
        color: Colors.black54,
        height: 10,
        thickness: 0,
        indent: 10,
        endIndent: 10,
      );
  }
  Widget _textDateD(){
    return const Text(
        'Para continuar con tu proceso por favor agenda tu cita de valoración.',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Color(0xFF243588),
          fontFamily: 'AvenirReg',
        )
    );
  }
  
  //seleccionar hora
   Widget _textHora(){
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width * 0.55,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: 
        Text('Día: $fechaFormateada',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
        )
    );
  }
  
  Widget _inputHour(List<Hora> horas, BuildContext context){
    return Container(
      margin: const EdgeInsets.only(top: 0),
      width: MediaQuery.of(context).size.width * 0.60,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: OutlinedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(200, 40)),
          side: MaterialStateProperty.all(
            const BorderSide(
              color: Color(0xff243588),
              width: 1,
            ),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ), 
        // OutlinedButton.styleFrom(primary: Color(0xff243588)),
        onPressed: (){}, //make onPressed callback empty
        child: 
        DropdownButton(
          autofocus: true,
          borderRadius: BorderRadius.circular(10),
          underline: Container(
            alignment: Alignment.centerRight,
              child: const Icon(
                Icons.arrow_drop_down_outlined,
                color: Color(0xff243588),
              ),
          ),
          elevation: 3,
          isExpanded: true,
          hint: const Text('Seleccionar Hora:',
            style: TextStyle(
              color: Colors.black38,
              fontSize: 16
            ),
          ),
          items: _dropDownHoras(horas),
          value: con.idHora.value == '' ? null : con.idHora.value,
          onChanged: (opt)=>{
            con.idHora.value = opt.toString(),
            //find in list
            con.horasOpt.forEach((element) {
              if(element.consecutivo == opt){
                horaFormateada = element.hora ?? '';
              }
            }),
        },
      ),
      )
    );
  }
  List<DropdownMenuItem<String?>> _dropDownHoras(List<Hora> horas){
    List<DropdownMenuItem<String>> list = [];
    for (var ho in horas) {
      list.add(DropdownMenuItem(
          value: ho.consecutivo,
          child: Text(ho.hora ?? ''),
      ));
    }
    return list;
  }

  Widget _buttonAgendar(){
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width * 0.60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff243588),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onPressed: () => {
          // print('asdasdas ${con.idHora.value}'),
          if(con.idHora.value == ''){
            Get.snackbar('Error',
              'Debe seleccionar una hora para agendar su cita.',
              colorText: const Color.fromARGB(255, 253, 252, 252),
              backgroundColor: const Color.fromARGB(255, 247, 0, 0),
              icon: const Icon(Icons.error)
            )
          }else{
            _dialogBuilder(context)
          }
          // _dialogBuilder(context),
        }, 
        child: const Text('Agendar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Color(0xFFFFFFFF),
            fontFamily: 'AvenirReg',
          ),
        )
      )
    );
  }
  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación de cita'),
          content: Text(
            'Confirma que desea agendar la cita de valoración:\n'
            'Fecha: $fechaFormateada \n'
            'Hora: $horaFormateada \n'
            'Para confirmar presione aceptar.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const 
              Text('Cancelar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Color.fromARGB(255, 218, 3, 3),
                  fontFamily: 'AvenirReg',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Aceptar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Color(0xff243588),
                  fontFamily: 'AvenirReg',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                con.onAgendar();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _selectDay(BuildContext context){
    return 
    Container(
      margin: const EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width * 0.60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 39, 156, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onPressed: () => _selectDate(context),
        child: const Text('Seleccionar Día',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Color(0xFFFFFFFF),
            fontFamily: 'AvenirReg',
          ),
        )
      )
    );
  }

  Widget _citasCard(Cita cit, context){
    //final numberFormat = NumberFormat.currency(locale: 'es_MX', symbol:"\$");

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Fecha: ${cit.fecha}',
                        style: const TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.w300,
                          color: Color(0xFF243588),
                          fontFamily: 'AvenirReg',
                        )
                    ),
                    Text('${cit.estadocit ?? ''} ',
                        style: const TextStyle(
                          fontSize: 18,
                          // fontWeight: FontWeight.w300,
                          color: Color(0xFF243588),
                          fontFamily: 'AvenirReg',
                        )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Servicio:',
                        style: TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.w300,
                          color: Color(0xFF243588),
                          fontFamily: 'AvenirReg',
                        )
                    ),
                    Text(' ${cit.descservicio}',
                        style: const TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.w300,
                          color: Color(0xFF243588),
                          fontFamily: 'AvenirReg',
                        )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Especialista:',
                        style: TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.w300,
                          color: Color(0xFF243588),
                          fontFamily: 'AvenirReg',
                        )
                    ),
                    Text(' ${cit.nombre}',
                        style: const TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.w300,
                          color: Color(0xFF243588),
                          fontFamily: 'AvenirReg',
                        )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Muestra enlace :',
                        style: TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.w300,
                          color: Color(0xFF243588),
                          fontFamily: 'AvenirReg',
                        )
                    ),
                    Text(' ${cit.verenlace}',
                        style: const TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.w300,
                          color: Color(0xFF243588),
                          fontFamily: 'AvenirReg',
                        )
                    ),
                  ],
                ),
                Visibility(
                  visible: cit.verenlace == 'SI' ? true : false,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              final Uri toLaunch = Uri(scheme: 'https', host: 'meet.jit.si', path: '${cit.enlace}');
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
                Visibility(
                  visible: cit.cancela == 'SI' ? true : false,
                  child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () => _dialogCancelDate(context, cit),
                            child: const Text('Cancelar Cita',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFFFFFFFF),
                                fontFamily: 'AvenirReg',
                              ),
                            )
                          )
                        ],
                      )
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
  Future<void> _dialogCancelDate(BuildContext context, Cita cit) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirma Cancelación'),
          content: const Text(
            '¿Confirma que desea cancelar la cita de valoración?:\n'
            'Para confirmar presione aceptar.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const 
              Text('No Cancelar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Color.fromARGB(255, 218, 3, 3),
                  fontFamily: 'AvenirReg',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Si Aceptar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Color(0xff243588),
                  fontFamily: 'AvenirReg',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                con.onCancelarCita(cit);
              },
            ),
          ],
        );
      },
    );
  }



  Widget _drawerList(){
    return CustomDrawerMenu();
  }
}

