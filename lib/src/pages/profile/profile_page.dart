import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivovital_app/src/pages/profile/profile_controller.dart';
import 'package:vivovital_app/src/utils/drawer_menu.dart';

class ProfilePage extends StatelessWidget {
  ProfileController con = Get.put(ProfileController());
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Color(0xFFFFFFFF),
            size: 30,
          ),
          onPressed: () => {scaffoldKey.currentState?.openDrawer()},
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
        children:[
          _boxDataPerson(context),
          Column(
            children: [
              _imageAvatar(),
              _fistName(),
              _document(),
            ],
          ),

        ]

      ),
      key: scaffoldKey,
      drawer: Drawer(
        child: _drawerList(),
      ),

    );
  }

  Widget _imageAvatar(){
    return SafeArea(
      child: Container(
          margin: EdgeInsets.only(top: 20),
          alignment: Alignment.center,
          child: Image.asset(
            'assets/img/avatars/male.png',
            width: 100,
          )
      ),
    );
  }
  Widget _fistName(){
    return SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          alignment: Alignment.center,
          child: Text(
              '${con.user.pnombre} ${con.user.snombre} ${con.user.papellido} ${con.user.sapellido}',
              style: TextStyle(
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
          margin: EdgeInsets.only(top: 0),
          alignment: Alignment.center,
          child: Text(
              '${con.user.tipoDoc} ${con.user.docidafiliado}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Color(0xFF243588),
                fontFamily: 'AvenirReg',
              )
          ),
        )
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
      leading: Icon(Icons.person_outline),
      title: Text('${con.user.estadoCivil}',
          style: TextStyle(
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
      title: Text('${con.user.ocupacion}',
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
      title: Text('${con.user.empresa}',
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
      title: Text('${con.user.escolaridad}',
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
      title: Text('${con.user.aseguradora}',
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
      title: Text('${con.user.tipoafiliacion}',
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
      title: Text('${con.user.idclaseafiliacion}',
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
      title: Text('${con.user.coberturaSalud}',
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


  Widget _boxDataPerson(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height * 2.0,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.23, left: 30, right: 30, bottom: 10 ),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xFF243588),
                  blurRadius: 5,
                  offset: Offset(0, 0)
              )
            ]
        ),
        child: SingleChildScrollView(
        child: Column(
          children: [
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
          ]
        )
      )
    );
  }

  Widget _drawerList(){
    return CustomDrawerMenu();
  }

}
