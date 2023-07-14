import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vitalhelp_app/src/pages/profile/profile_controller.dart';
import 'package:vitalhelp_app/src/utils/drawer_menu.dart';

class ProfilePage extends StatelessWidget {
  ProfileController con = Get.put(ProfileController());
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: con,
      initState: (_) {
        con.setValues();
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
                    title: const Text('VitalHelp App',
                      style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w300,
                        color: Color(0xFFFFFFFF), fontFamily: 'AvenirReg',
                      )
                    ),
                ),
                  body: Stack(
                    children:[
                      _boxDataPerson(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buttonBack(),
                          _textEditForm(),
                        ],
                      ),
                    ]
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

  Widget _bannerInfo(){
    return MaterialBanner(
        padding: EdgeInsets.all(5),
        leading: Icon(Icons.add_alert_outlined, color: Colors.white,),
        backgroundColor: Colors.red,
        content: const Text(
            'Completa tus datos personales para continuar con el proceso.',
            style: TextStyle(
                fontSize: 14,
              // fontWeight: FontWeight.w300,
              color: Colors.white,
              fontFamily: 'AvenirReg',
            )
          ),
        actions: <Widget>[
          ElevatedButton(
              onPressed: () {
                con.onEditProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 0)
              ),
              child: Text(
                'Editar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'AvenirBold',
                ),
              )
          ),
        ]
    );
  }
  Widget _textTilte(){
    return const Text(
        'Perfil',
      style: TextStyle(
        fontSize: 20,
        color: Color(0xFF243588),
        fontFamily: 'AvenirReg'
      ),
    );
  }
  Widget _imageAvatar(){
    return SafeArea(
      child: Container(
          margin: const EdgeInsets.only(top: 20),
          alignment: Alignment.center,
          child: Image.asset(
            con.user.sexo == 'Masculino' ?
            'assets/img/avatars/male.png' : 
            'assets/img/avatars/female.png',
            width: 100,
          )
      ),
    );
  }
  Widget _fistName(){
    return SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          alignment: Alignment.center,
          child: Text(
              '${con.user.pnombre} ${con.user.snombre} ${con.user.papellido} ${con.user.sapellido}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Color(0xFF243588),
                fontFamily: 'AvenirBold',
              )
          ),
        )
    );
  }
  Widget _document(){
    return SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          alignment: Alignment.center,
          child: Text(
              '${con.user.tipoDoc} ${con.user.docidafiliado}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Color(0xFF243588),
                fontFamily: 'AvenirReg',
              )
          ),
        )
    );
  }
  Widget _divider(){
    return
        Divider(
          color: Colors.black54,
          height: 10,
          thickness: 0,
          indent: 10,
          endIndent: 10,
        );
  }
  Widget _gender(){
    return ListTile(
      leading: Icon(con.user.sexo == 'Masculino' ? Icons.male : Icons.female),
      title: Text('${con.user.sexo}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
      ),
      subtitle: Text('Genero'),
    );
  }
  Widget _yearOld(){
    return ListTile(
              leading: Icon(Icons.cake_outlined),
              title: Text('${con.user.edad}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w100,
                    color: Color(0xFF243588),
                    fontFamily: 'AvenirBold',
                  )
              ),
              subtitle: Text('Edad'),
          );
  }
  Widget _birtDay(){
    return ListTile(
      leading: Icon(Icons.date_range_sharp),
      title: Text('${con.user.fnacimiento}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
      ),
      subtitle: Text('Fecha de Nacimiento'),
    );
  }
  Widget _phone(){
    return ListTile(
      leading: Icon(Icons.phone_android),
      title: Text('${con.user.celular}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
      ),
      subtitle: Text('Teléfono'),
    );
  }
  Widget _email(){
    return ListTile(
      leading: Icon(Icons.email_outlined),
      title: Text('${con.user.email}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
      ),
      subtitle: Text('Email'),
    );
  }
  Widget _region(){
    return ListTile(
      leading: Icon(Icons.location_city),
      title: Text('${con.user.departamento}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
      ),
      subtitle: Text('Departamento'),
    );
  }
  Widget _city(){
    return ListTile(
      leading: Icon(Icons.location_city_outlined),
      title: Text('${con.user.nombreciu}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
      ),
      subtitle: Text('Ciudad'),
    );
  }
  Widget _address(){
    return ListTile(
      leading: Icon(Icons.directions),
      title: Text('${con.user.direccion}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
      ),
      subtitle: Text('Dirección'),
    );
  }
  Widget _civilStatus(){
    return ListTile(
      leading: const Icon(Icons.person_outline),
      title: Text('${con.user.estadoCivil ?? ''}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
      ),
      subtitle: Text('Estado Civil'),
    );
  }
  Widget _ocupations(){
    return ListTile(
      leading: Icon(Icons.work),
      title: Text('${con.user.ocupacion ?? ''}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
      ),
      subtitle: Text('Ocupación'),
    );
  }
  Widget _enterprice(){
    return ListTile(
      leading: Icon(Icons.location_city),
      title: Text('${con.user.empresa ?? ''}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
      ),
      subtitle: Text('Empresa o Institución'),
    );
  }
  Widget _education(){
    return ListTile(
      leading: Icon(Icons.school_outlined),
      title: Text('${con.user.escolaridad ?? ''}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
      ),
      subtitle: Text('Grado de Escolaridad'),
    );
  }
  Widget _eps(){
    return ListTile(
      leading: Icon(Icons.health_and_safety_outlined),
      title: Text('${con.user.aseguradora != null ? con.Aseguradora.label : ''}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
      ),
      subtitle: Text('EPS'),
    );
  }
  Widget _epsType(){
    return ListTile(
      leading: Icon(Icons.healing),
      title: Text('${con.user.tipoafiliacion ?? ''}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
      ),
      subtitle: Text('Tipo de vinculación EPS'),
    );
  }
  Widget _prepaid(){
    return ListTile(
      leading: Icon(Icons.attach_money),
      title: Text('${con.user.idclaseafiliacion ?? ''}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
      ),
      subtitle: Text('Prepagada/Póliza/Plan Complementario'),
    );
  }
  Widget _whoPrepaid(){
    return ListTile(
      leading: Icon(Icons.question_answer),
      title: Text('${con.user.idclaseafiliacion == 'Si' ? con.prepagada.label : ''}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Color(0xFF243588),
            fontFamily: 'AvenirBold',
          )
      ),
      subtitle: Text('¿Cuál Prepagada/Póliza/Plan Complementario? '),
    );
  }
  Widget _btnEdit(){
    return Container(
        margin: EdgeInsets.only(top: 10, left: 5, right: 0, bottom: 15 ),
        child: FloatingActionButton.extended(
          onPressed: () {  con.onEditProfile(); },
          backgroundColor: Color(0xFF243588),
          icon: Icon(Icons.edit, color: Colors.white),
          label: Text(
              'Editar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                fontFamily: 'AvenirReg',
              )
          ),
        )
    );
  }

  Widget _boxDataPerson(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height * 2.0,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06, left: 00, right: 0, bottom: 0 ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Text('okbd=> ${con.user.okbd ?? ''}'),

            Visibility(
              visible: con.user.okbd == '0',
                child: _bannerInfo(),
            ),
            _imageAvatar(),
            _fistName(),
            _document(),
            _divider(),

            _gender(),
            _yearOld(),
            _birtDay(),
            _phone(),
            _email(),
            _region(),
            _city(),
            _address(),
            _civilStatus(),
            _ocupations(),
            _enterprice(),
            _education(),
            _eps(),
            _epsType(),
            _prepaid(),
            _whoPrepaid(),
            _btnEdit(),
          ]
        )
      )
    );
  }
  Widget _buttonBack() {
    return SafeArea(
        child: Container(
            margin: EdgeInsets.only(left: 20),
            child: IconButton(
              onPressed: () => Get.offNamed('/home'),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF243588),
                size: 20,
              ),
            )
        )
    );
  }
  Widget _textEditForm(){
    return const Text(
        'Perfil',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Color(0xFF243588),
          fontFamily: 'AvenirReg',
        )
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


  Widget _drawerList(){
    return CustomDrawerMenu();
  }
}
