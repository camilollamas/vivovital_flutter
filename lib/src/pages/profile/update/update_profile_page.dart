import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:vitalhelp_app/src/models/tgensel.dart';
import 'package:vitalhelp_app/src/pages/profile/update/update_profile_controller.dart';
import 'package:vitalhelp_app/src/utils/drawer_menu.dart';

import '../../../models/ciudad.dart';
import '../../../models/tgensel.dart';
import '../../../models/departamentos.dart';
import '../../../models/mes.dart';

class UpdateProfilePage extends StatelessWidget {
  UpdatePropfileController con = Get.put(UpdatePropfileController());
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdatePropfileController>(
        init: con,
        initState: (_) {
          // con.GetStatusUser();
          con.getEPS();
          con.getTypeAfi();
          con.getOcupations();
          con.getSchool();
          con.getCountries();
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
                  // Image.network(
                  //   'https://i.pinimg.com/564x/b1/31/0a/b1310a301398dc8c87f59e5dc9b37f40.jpg',
                  //   fit: BoxFit.cover,
                  // ),
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
                    onPressed: () => {scaffoldKey.currentState?.openDrawer()},
                    ),
                    title: Text('vitalhelp App',
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
                      _boxFormUpdate(context),
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
  Widget _buttonBack() {
    return SafeArea(
        child: Container(
            margin: EdgeInsets.only(left: 20),
            child: IconButton(
              onPressed: () => Get.offNamed('/profile'),
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
        'Editar información',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Color(0xFF243588),
          fontFamily: 'AvenirReg',
        )
    );
  }

  Widget _boxFormUpdate(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06, left: 0, right: 0, bottom: 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _inputFirstname(),
                _inputSecondname()
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _inputLastName(),
                _inputSecondLastName()
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _inputDocumentType(context),
                _inputNumberDocument(context)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _textGender(),
                _inputGender(context)

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _textBirdDate(context)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _inputDayBird(context),
                _inputDayMont(context,con.birtMonth),
                _inputDayYear(context),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _inputPhone(context),
                _inputOtherPhone(context)
              ],
            ),
            _inputEmail(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _textCountry(context),
                _inputCountry(context)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _textRegion(context),
                _inputRegion(con.deptos, context)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _textCity(context),
                _inputCity(con.ciuOpt, context)
              ],
            ),
            _inputAddress(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _textCivilStatus(context),
                _inputCivilStatus(context)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _textOcupation(context),
                _inputOcupation(con.ocupations, context)
              ],
            ),
            _inputCompnay(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _textSchool(context),
                _inputSchool(con.schools, context)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _textEps(context),
                _inputEps(con.epss, context)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _textTypeAfi(context),
                _inputTypeAfi(con.typesAfi, context)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _textPrepaid(context),
                _inputPrepaid(context)
              ],
            ),
            Visibility(
                visible: con.prepaid.value == 'Si' ? true : false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _textPrepaidEps(context),
                    _inputPrepaidEps(con.epss, context)
                  ],
                )
            ),
            _buttonRegister(context)
          ],
        ),
      ),
    );
  }

  Widget _divider(){
    return Divider(
        color: Colors.black54,
        height: 10,
        thickness: 0,
        indent: 10,
        endIndent: 10,
      );
  }

  Widget _inputFirstname(){
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: TextField(
          // onChanged: (value){
          //   // con.numberDocumentController.value =value.toString();
          //   con.updateValues();
          // },
          controller: con.pnombreController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'Primer Nombre',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }
  Widget _inputSecondname(){
    return Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: TextField(
          controller: con.snombreController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            isDense: true,
            labelText: 'Segundo Nombre',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }

  Widget _inputLastName(){
    return Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextField(
          controller: con.papellidoController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            isDense: true,
            labelText: 'Primer Apellido',
          )
      ),
    );
  }
  Widget _inputSecondLastName(){
    return Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextField(
          controller: con.sapellidoController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            isDense: true,
            labelText: 'Segundo Apellido'
          )
      ),
    );
  }

  Widget _inputDocumentType(BuildContext context){
    return Container(
        width: 150,//MediaQuery.of(context).size.height * 0.1,
        margin: EdgeInsets.only( top: 0 , left: 0, right: 0),
        padding: EdgeInsets.only(top: 25),
        child: DropdownButton(
          hint: Text('Tipo'),
          isDense: true,
          isExpanded: true,
          items: con.documentTypes.map((value) {
            return DropdownMenuItem(
                value: value,
                child: Text(value)
            );
          }).toList(),
          value: con.docType.value, // == '' ? null : con.docType.value,
          onChanged: (value) {
            // setState((){
              con.docType.value = value.toString();
              con.updateValues();
            // });
          },
        )
    );
  }
  Widget _inputNumberDocument(BuildContext context){
    return Container(
      width: 150,//MediaQuery.of(context).size.width * 0.5,
      // height: 47,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),//EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.0, left: 5, right: 0, bottom: 0 ),
      child: TextField(
          controller: con.numberDocumentController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            isDense: true,
            labelText: 'N° de documento',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }

  Widget _textGender(){
    return Container(
        width: 65,
        margin: EdgeInsets.only( top: 20 , left: 30, right: 10),
        child: Text(
          'Genero:',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF243588),
            fontFamily: 'AvenirReg',
          ),
        )
    );
  }
  Widget _inputGender(BuildContext context){
    return Container(
      width: 140,
      margin: EdgeInsets.only( top: 20 , left: 0, right: 0),
      child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            hint: Text('Seleccionar...',
                style: TextStyle(
                  fontSize: 17,
                  color: Theme
                      .of(context)
                      .hintColor,
                )
            ),
            items: con.genders.map((item) =>
                DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                        fontSize: 17,
                        height: 1
                    ),
                  ),
                ))
                .toList(),
            value: con.gender.value == '' ? null : con.gender.value,
            onChanged: (value) {
              con.gender.value = value.toString();
              con.updateValues();
            },
            buttonHeight: 40,
            buttonWidth: 40,
            itemPadding: const EdgeInsets.only(left: 15, right: 24),
            itemHeight: 40,
          )
      ),

    );
  }

  Widget _textBirdDate(BuildContext context){
    return Container(
        width: 280,//MediaQuery.of(context).size.width * 1,
        margin: EdgeInsets.only( top: 0 , left: 30, right: 0),
        child: Text(
          'Fecha de nacimiento: '
              '${con.dayBird == '' ? 'dd' : con.dayBird}'
              '/${con.MontBird == '' ? 'mm' : con.MontBird}'
              '/${con.yearBird == '' ? 'aaaa' : con.yearBird}',
          style: TextStyle(
            fontSize: 17,
            color: Color(0xFF243588),
            fontFamily: 'AvenirReg',
          ),
        )
    );
  }

  Widget _inputDayBird(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width * 0.13,
      margin: EdgeInsets.only( top: 0 , left: 0, right: 10),
      child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            hint: Text('Día',
                style: TextStyle(
                  fontSize: 17,
                  color: Theme
                      .of(context)
                      .hintColor,
                )
            ),

            items: con.birdDay.map((item) =>
                DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ))
                .toList(),
            value: con.dayBird.value == '' ? null : con.dayBird.value,
            onChanged: (value) {
              con.dayBird.value = value.toString();
              con.updateValues();
            },
            buttonHeight: 40,
            buttonWidth: 100,
            itemPadding: const EdgeInsets.only(left: 15, right: 0),
            itemHeight: 40,
          )
      ),

    );
  }

  List<DropdownMenuItem<String?>> _dropDownItemsMeses(List<Mes> meses){
    List<DropdownMenuItem<String>> list = [];
    meses.forEach((mes) {
      list.add(DropdownMenuItem(
        child: Text(mes.nombre ?? ''),
        value: mes.id,
      ));
    });
    return list;
  }
  Widget _inputDayMont(BuildContext context, List<Mes> meses){
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      margin: EdgeInsets.only( top: 0 , left: 0, right: 30),
      child: DropdownButtonHideUnderline(
          child: DropdownButton(
            hint: Text('Mes',
                style: TextStyle(
                  fontSize: 17,
                  color: Theme
                      .of(context)
                      .hintColor,
                )
            ),
            items: _dropDownItemsMeses(meses),
            value: con.MontBird.value == '' ? null : con.MontBird.value,
            onChanged: (opt)=>{
              print('opt=> ${opt}'),
              con.MontBird.value = opt.toString(),
              con.updateValues()
            },
          )
      ),

    );
  }
  Widget _inputDayYear(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width * 0.17,
      child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            hint: Text('Año',
                style: TextStyle(
                  fontSize: 17,
                  color: Theme
                      .of(context)
                      .hintColor,
                )
            ),
            items: con.birtYear.map((item) =>
                DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ))
                .toList(),
            value: con.yearBird.value == '' ? null : con.yearBird.value,
            onChanged: (value){
                con.yearBird.value = value.toString();
                con.updateValues();
            },
            buttonHeight: 40,
            buttonWidth: 100,
            itemPadding: const EdgeInsets.only(left: 15, right: 0),
            itemHeight: 40,
          )
      ),

    );
  }

  Widget _inputPhone(BuildContext context){
    return Container(
      width: 150,//MediaQuery.of(context).size.width * 0.4,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),//EdgeInsets.only( top: 10 , left: 0, right: 10),
      child: TextField(
          controller: con.phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Número celular',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }
  Widget _inputOtherPhone(BuildContext context){
    return Container(
      width: 150,//MediaQuery.of(context).size.width * 0.4,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),//EdgeInsets.only( top: 10 , left: 0, right: 8),
      child: TextField(
          controller: con.otherPhoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Otro número celular',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }

  Widget _inputEmail(BuildContext context){
    return Container(
      // width: MediaQuery.of(context).size.width * 0.4,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: TextField(
          controller: con.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }

  List<String> countries = [ 'Colombia'];
  String? Country = 'Colombia';
  Widget _textCountry(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 15),
        width: MediaQuery.of(context).size.width * 0.30,
        child: Text(
          'País:',
          style: TextStyle(
              fontSize: 17,
              color: Colors.black
          ),
        )
    );
  }
  Widget _inputCountry(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 15),
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButton(
          underline: Container(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_drop_down_outlined,
              color: Color(0xff243588),
            ),
          ),
          elevation: 3,
          isExpanded: true,
          hint: Text('',
              style: TextStyle(
                fontSize: 17,
                color: Theme
                    .of(context)
                    .hintColor,
              )
          ),
          items: countries.map((item) =>
              DropdownMenuItem(
                value: item,
                child:
                Text(
                  item,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              )
          )
              .toList(),
          value: Country,
          onChanged: (value){
              Country = value as String;
              con.updateValues();
          },
        )
    );
  }

  List<DropdownMenuItem<String?>> _dropDownItems(List<Departamentos> departamentos){
    List<DropdownMenuItem<String>> list = [];
    departamentos.forEach((dep) {
      list.add(DropdownMenuItem(
        child: Text(dep.nombre ?? ''),
        value: dep.dpto,
      ));
    });
    return list;
  }
  Widget _textRegion(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 0),
        width: MediaQuery.of(context).size.width * 0.30,
        child: Text(
          'Departamento:',
          style: TextStyle(
              fontSize: 17,
              color: Colors.black
          ),
        )
    );
  }
  Widget _inputRegion(List<Departamentos> departamentos, BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 0),
      width: MediaQuery.of(context).size.width * 0.50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_outlined,
            color: Color(0xff243588),
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text('Seleccionar...',
          style: TextStyle(
              color: Colors.black38,
              fontSize: 16
          ),
        ),
        items:_dropDownItems(departamentos),
        value: con.idDepartamento.value == '' ? null : con.idDepartamento.value,
        onChanged: (opt)=>{
          print('Opcion seleccionada -> ${opt}'),
          con.idDepartamento.value = opt.toString(),
          con.getCityes(opt.toString(), null),
          con.updateValues()
        },
      ),
    );
  }

  List<DropdownMenuItem<String?>> _dropDownCiudades(List<Ciudad> ciudades){
    List<DropdownMenuItem<String>> list = [];
    ciudades.forEach((dep) {
      list.add(DropdownMenuItem(
        child: Text(dep.nombre ?? ''),
        value: dep.ciudad,
      ));
    });
    return list;
  }
  Widget _textCity(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 0),
        width: MediaQuery.of(context).size.width * 0.30,
        child: Text(
          'Ciudad:',
          style: TextStyle(
              fontSize: 17,
              color: Colors.black
          ),
        )
    );
  }
  Widget _inputCity(List<Ciudad> ciudades, BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 0),
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_outlined,
            color: Color(0xff243588),
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text('Seleccionar...',
          style: TextStyle(
              color: Colors.black38,
              fontSize: 16
          ),
        ),
        items: _dropDownCiudades(ciudades),
        value: con.idCiudad.value == '' ? null : con.idCiudad.value,
        onChanged: (opt)=>{
          print('Ciudad seleccionada -> ${opt}'),
          con.idCiudad.value = opt.toString(),
          con.updateValues()

        },
      ),
    );
  }

  Widget _inputAddress(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: TextField(
          controller: con.addressController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Dirección de residencia',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }

  Widget _textCivilStatus(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 15),
        width: MediaQuery.of(context).size.width * 0.30,
        child: Text(
          'Estado Civil:',
          style: TextStyle(
              fontSize: 17,
              color: Colors.black
          ),
        )
    );
  }
  Widget _inputCivilStatus(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 15),
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButton(
          underline: Container(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_drop_down_outlined,
              color: Color(0xff243588),
            ),
          ),
          elevation: 3,
          isExpanded: true,
          hint: Text('Seleccionar...',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 16
              )
          ),
          items: con.civilStatus.map((item) =>
              DropdownMenuItem(
                value: item,
                child:
                Text(
                  item,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              )
          )
              .toList(),
          value: con.civilStat == '' ? null : con.civilStat,// con.civilStat,
          onChanged: (value){
            con.civilStat = value as String;
            con.updateValues();
          },
        )
    );
  }

  List<DropdownMenuItem<String?>> _dropDownOccupation(List<Tgensel> registros){
    List<DropdownMenuItem<String>> list = [];
    registros.forEach((reg) {
      list.add(DropdownMenuItem(
        child: Text(reg.label ?? ''),
        value: reg.value,
      ));
    });
    return list;
  }
  Widget _textOcupation(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 0),
        width: MediaQuery.of(context).size.width * 0.30,
        child: Text(
          'Ocupación:',
          style: TextStyle(
              fontSize: 17,
              color: Colors.black
          ),
        )
    );
  }
  Widget _inputOcupation(List<Tgensel> valores, BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 0),
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_outlined,
            color: Color(0xff243588),
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text('Seleccionar...',
          style: TextStyle(
              color: Colors.black38,
              fontSize: 16
          ),
        ),
        items: _dropDownOccupation(valores),
        value: con.ocupation.value == '' ? null : con.ocupation.value,
        onChanged: (opt)=>{
          print('Ciudad seleccionada -> ${opt}'),
          con.ocupation.value = opt.toString(),
          con.updateValues()
        },
      ),
    );
  }

  Widget _inputCompnay(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: TextField(
          controller: con.companyController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Empresa o Institución',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }

  List<DropdownMenuItem<String?>> _dropDownSchool(List<Tgensel> registros){
    List<DropdownMenuItem<String>> list = [];
    registros.forEach((reg) {
      list.add(DropdownMenuItem(
        child: Text(reg.label ?? ''),
        value: reg.value,
      ));
    });
    return list;
  }
  Widget _textSchool(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 0),
        width: MediaQuery.of(context).size.width * 0.30,
        child: Text(
          'Escolaridad:',
          style: TextStyle(
              fontSize: 17,
              color: Colors.black
          ),
        )
    );
  }
  Widget _inputSchool(List<Tgensel> valores, BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 0),
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_outlined,
            color: Color(0xff243588),
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text('Seleccionar...',
          style: TextStyle(
              color: Colors.black38,
              fontSize: 16
          ),
        ),
        items: _dropDownSchool(valores),
        value: con.school.value == '' ? null : con.school.value,
        onChanged: (opt)=>{
          print('Ciudad seleccionada -> ${opt}'),
          con.school.value = opt.toString(),
          con.updateValues()
        },
      ),
    );
  }

  List<DropdownMenuItem<String?>> _dropDownEps(List<Tgensel> registros){
    List<DropdownMenuItem<String>> list = [];
    registros.forEach((reg) {
      list.add(DropdownMenuItem(
        child: Text(reg.label ?? ''),
        value: reg.value,
      ));
    });
    return list;
  }
  Widget _textEps(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 0),
        width: MediaQuery.of(context).size.width * 0.30,
        child: Text(
          'EPS:',
          style: TextStyle(
              fontSize: 17,
              color: Colors.black
          ),
        )
    );
  }
  Widget _inputEps(List<Tgensel> valores, BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 0),
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_outlined,
            color: Color(0xff243588),
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text('Seleccionar...',
          style: TextStyle(
              color: Colors.black38,
              fontSize: 16
          ),
        ),
        items: _dropDownEps(valores),
        value: con.eps.value == '' ? null : con.eps.value,
        onChanged: (opt)=>{
          print('eps seleccionada -> ${opt}'),
          con.eps.value = opt.toString(),
          con.updateValues()
        },
      ),
    );
  }

  List<DropdownMenuItem<String?>> _dropDownTypeAfi(List<Tgensel> registros){
    List<DropdownMenuItem<String>> list = [];
    registros.forEach((reg) {
      list.add(DropdownMenuItem(
        child: Text(reg.label ?? ''),
        value: reg.value,
      ));
    });
    return list;
  }
  Widget _textTypeAfi(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 0),
        width: MediaQuery.of(context).size.width * 0.30,
        child: Text(
          'Tipo Afiliación:',
          style: TextStyle(
              fontSize: 17,
              color: Colors.black
          ),
        )
    );
  }
  Widget _inputTypeAfi(List<Tgensel> valores, BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 0),
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_outlined,
            color: Color(0xff243588),
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text('Seleccionar...',
          style: TextStyle(
              color: Colors.black38,
              fontSize: 16
          ),
        ),
        items: _dropDownTypeAfi(valores),
        value: con.typeAfi.value == '' ? null : con.typeAfi.value,
        onChanged: (opt)=>{
          print('typeAfi seleccionada -> ${opt}'),
          con.typeAfi.value = opt.toString(),
          con.updateValues()
        },
      ),
    );
  }

  Widget _textPrepaid(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 15),
        width: MediaQuery.of(context).size.width * 0.30,
        child: Text(
          'Prepagada/Póliza/Plan Complementario:',
          style: TextStyle(
              fontSize: 12,
              color: Colors.black
          ),
        )
    );
  }
  Widget _inputPrepaid(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 15),
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButton(
          underline: Container(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_drop_down_outlined,
              color: Color(0xff243588),
            ),
          ),
          elevation: 3,
          isExpanded: true,
          hint: Text('Seleccionar...',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 16
              )
          ),
          items: con.prep.map((item) =>
              DropdownMenuItem(
                value: item,
                child:
                Text(
                  item,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              )
          )
              .toList(),
          value: con.prepaid.value == '' ? null : con.prepaid.value,// con.civilStat,
          onChanged: (value){
            con.prepaid.value = value.toString();
            con.updateValues();
          },
        )
    );
  }

  Widget _textPrepaidEps(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 0),
        width: MediaQuery.of(context).size.width * 0.30,
        child: Text(
          '¿Cuál Prepagada/Poliza/Plan Complemantario?:',
          style: TextStyle(
              fontSize: 12,
              color: Colors.black
          ),
        )
    );
  }
  Widget _inputPrepaidEps(List<Tgensel> valores, BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 0),
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_outlined,
            color: Color(0xff243588),
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text('Seleccionar...',
          style: TextStyle(
              color: Colors.black38,
              fontSize: 16
          ),
        ),
        items: _dropDownEps(valores),
        value: con.prepaidEps.value == '' ? null : con.prepaidEps.value,
        onChanged: (opt)=>{
          print('prepaidEps seleccionada -> ${opt}'),
          con.prepaidEps.value = opt.toString(),
          con.updateValues()
        },
      ),
    );
  }

  Widget _buttonRegister(BuildContext context){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10, left: 80, right: 80, bottom: 15 ),
      child: FloatingActionButton.extended(
          onPressed: () => con.onUpdateProfile(),
          icon: Icon(Icons.save, color: Colors.white),
          backgroundColor: Color(0xFF243588),
          label: Text(
            'Actualizar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w300,
              fontFamily: 'AvenirReg',
            ),
          )
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

  Widget _drawerList(){
    return CustomDrawerMenu();
  }

}
