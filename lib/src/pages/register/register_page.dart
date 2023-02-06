import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivovital_app/src/pages/register/register_controller.dart';

import '../../models/departamentos.dart';
import '../../models/ciudad.dart';
import '../../models/mes.dart';

bool isChecked = false;

class RegisterPage extends StatefulWidget {

  @override
  State<RegisterPage> createState() => _RegisterState();
}
class _RegisterState extends State<RegisterPage> {
  RegisterController con = Get.put(RegisterController());

  Widget build(BuildContext context) {
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
              body: Obx(() => Stack(
                children: [
                  _boxFormRegister(context),
                  _buttonBack(),
                  Column(
                      children:[

                        // _imageLogo(),
                        // _textLogin()

                  //      _imageLines()
                      ]
                  )
                ]
            ))
            )
          ]
      );
  }

  //Métodos Privados
  Widget _buttonBack() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF243588),
              size: 30,
          ),
        )
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
  Widget _imageLogo(){
    return SafeArea(
      child: Container(
          margin: EdgeInsets.only(top: 0),
          alignment: Alignment.center,
          child: Image.asset(
            'assets/img/LogoLogin.png',
            width: 200,
          )
      ),
    );
  }
  Widget _imageLines(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
        alignment: Alignment.center,
        width: double.infinity,
        height: 100,
        child: Image.asset(
            'assets/img/LineasLogin.png'
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

  Widget _textLogin(){
    return Text(
        'Formulario de registro',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w300,
          color: Color(0xFF243588),
          fontFamily: 'AvenirReg',
        )
    );
  }

  // BoxForm
  Widget _boxFormRegister(BuildContext context){
    return Container(
        //height: MediaQuery.of(context).size.height * 2.0,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08, left: 0, right: 0, bottom: 0),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 0,
              offset: Offset(0, 0.75)
            )
          ]
        ),
        child: SingleChildScrollView(
          //margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08, left: 10, right: 0, bottom: 0),
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Column(
              children: [
               // _textFieldEmail(),
               // _textFieldPassword(),
                _imageLogo(),
                // _imageLines(context),
                _textLogin(),
                _divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _inputFirstname(),
                    _inputSecondname(),
                    // _inputSecondname()
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
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _inputDocumentType(),
                    _inputNumberDocument(context)
                  ],
                ),
                Row(
                  children: [
                    _textGender(),
                    _inputGender()
                  ]
                ),
                Column(
                  children: [
                    _textBirdDate(context)
                  ],
                ),
                Row(
                  children: [
                    //_textDayBird(context),
                    _inputDayBird(context),
                  //  _textDayMont(context),
                    _inputDayMont(context,con.birtMonth),
                   // _textDayYear(context),
                    _inputDayYear(context),

                  ],
                ),
                Row(
                  children: [
                    _inputPhone(context)
                    ,_inputOtherPhone(context)
                  ],
                ),
                _inputEmail(),
                _inputConfirmEmail(),
                Row(
                  children: [
                    _textCountry(context),
                    _inputCountry(context)
                  ],
                ),
                Row(
                  children: [
                    _textRegion(context),
                    _inputRegion(con.deptos)
                  ],
                ),
                Row(
                  children: [
                    _textCity(context),
                    _inputCity(con.ciuOpt)
                  ],
                ),
                _inputAddress(),

                _inputPassword(),
                _inputConfirmPassword(),
                _checkTerms(context),


                _buttonRegister(context)
              ]
          ),
        )
    );
  }

  Widget _buttonRegister(BuildContext context){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
          onPressed: () => con.register(context),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 5)
          ),
          child: Text(
            'Registrarse',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w300,
              fontFamily: 'AvenirReg',
            ),
          )
      ),
    );
  }

  Widget _inputFirstname(){
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: TextField(
        controller: con.firstNameController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
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
          controller: con.secNameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
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
          controller: con.lastController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
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
          controller: con.secondLastController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Segundo Apellido'
          )
      ),
    );
  }

  Widget _inputDocumentType(){
    return Container(
      width: MediaQuery.of(context).size.height * 0.1,
      margin: EdgeInsets.only( top: 15 , left: 11, right: 5),
      child: DropdownButton(
        hint: Text('Tipo'),
        isExpanded: true,
        items: con.documentTypes.map((value) {
          return DropdownMenuItem(
              value: value,
              child: Text(value)
          );
        }).toList(),
        value: con.docType.value == '' ? null : con.docType.value,
        onChanged: (value) {
          setState((){
            con.docType.value = value.toString();
          });
        },
      )
    );
  }
  Widget _inputNumberDocument(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 47,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.0, left: 5, right: 0, bottom: 0 ),
      child: TextField(
          controller: con.numberDocumentController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'N° de documento',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }

  Widget _textGender(){
    return Container(
      width: 100,
      margin: EdgeInsets.only( top: 20 , left: 0, right: 0),
      child: Text(
          'Genero:',
        style: TextStyle(
          fontSize: 17
        ),
      )
    );
  }
  Widget _inputGender(){
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
        width: MediaQuery.of(context).size.width * 1,
        margin: EdgeInsets.only( top: 20 , left: 0, right: 0),
        child: Text(
          'Fecha de nacimiento: '
              '${con.dayBird == '' ? 'dd' : con.dayBird}'
              '/${con.MontBird == '' ? 'mm' : con.MontBird}'
              '/${con.yearBird == '' ? 'aaaa' : con.yearBird}',
          style: TextStyle(
            color: Colors.black,
              fontSize: 17
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
              print('Mes seleccionado -> ${opt}'),
              con.MontBird.value = opt.toString()
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
              setState(() {
                con.yearBird.value = value.toString();
              });
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
      width: MediaQuery.of(context).size.width * 0.4,
      margin: EdgeInsets.only( top: 10 , left: 0, right: 10),
      child: TextField(
          controller: con.phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Número celular',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }
  Widget _inputOtherPhone(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      margin: EdgeInsets.only( top: 10 , left: 0, right: 8),
      child: TextField(
          controller: con.otherPhoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Otro número celular',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }

  Widget _inputEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextField(
          controller: con.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Correo electrónico',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }
  Widget _inputConfirmEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextField(
          controller: con.confirmEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Confirmar correo electrónico',
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
        width: MediaQuery.of(context).size.width * 0.35,
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
      width: MediaQuery.of(context).size.width * 0.4,
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
              setState(() {
                Country = value as String;
              });
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
  Widget _inputRegion(List<Departamentos> departamentos){
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
          con.getCityes(opt.toString())
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
  Widget _inputCity(List<Ciudad> ciudades){
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
          con.idCiudad.value = opt.toString()
        },
      ),
    );
  }

  Widget _inputAddress(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
      child: TextField(
          controller: con.addressController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Dirección de residencia',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }

  bool hidePassword = true;
  Widget _inputPassword(){
    return Container(
        child: TextField(
            controller: con.passwordController,
            obscureText: hidePassword,
            decoration: InputDecoration(
              // border: OutlineInputBorder(),
              labelText: 'Contraseña',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                hoverColor: Colors.transparent,
                icon: Icon(
                  hidePassword ? Icons.visibility : Icons.visibility_off,
                )
              )
            )
        )
    );
  }
  Widget _inputConfirmPassword(){
    return Container(
        child: TextField(
            controller: con.confirmPasswordController,
            obscureText: hidePassword,
            decoration: InputDecoration(
            //  border: OutlineInputBorder(),
              labelText: 'Confirmar contraseña',
            )
        )
    );
  }

  Widget _checkTerms(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }
    return Container(
        margin: EdgeInsets.only(top: 10),
        child:
          Column(
            children:[
              Row(
                children: [
                  Checkbox(
                    value: con.terms.value,
                    onChanged: (value) {
                      setState(() {
                        con.terms.value = value!;
                      });
                    },
                  ),
                  Text('Acepto ',
                    style: TextStyle(
                        fontFamily: 'AvenirReg'
                    )
                  ),
                  Text('Terminos y condiciones',
                      style: TextStyle(
                        color: Color(0xff243588),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'AvenirReg',
                      )
                  )
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: con.exclusion.value,
                    onChanged: (value) {
                      setState(() {
                        con.exclusion.value = value!;
                      });
                    },
                  ),
                  Text('Acepto ',
                    style: TextStyle(
                      fontFamily: 'AvenirReg'
                    )
                  ),
                  Text('Criterios de exclusión',
                    style: TextStyle(
                      color: Color(0xff243588),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'AvenirReg',
                    ),
                  )
                ],
              )
            ]
          )
    );
  }
  Widget _codeDialog(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context)=>AlertDialog(
            title: Text('Dialogo'),
            content: Text('Contenido'),
            actions: [
              TextButton(
                  onPressed: ()=>Navigator.pop(context, 'Cancelar'),
                  child: Text('Cancela')
              )
            ],
          ),
      ),
      child: Text('Mostrar Dialog'),
    );
  }

}

