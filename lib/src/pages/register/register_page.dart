import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivovital_app/src/pages/register/register_controller.dart';

bool isChecked = false;

const List<String> list = <String>['One', 'CC', 'PS', 'CE'];

class RegisterPage extends StatelessWidget {

  RegisterController con = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            _imageBgWhite(),
            _imageBg(),
            _bgDegrade(context),
            _boxFormRegister(context),
            _buttonBack(),
            Column(
                children:[
                  _imageLogo(),
                  _textLogin()

            //      _imageLines()
                ]
            )
          ]
      ),
    );
  }


  String dropdownValue = list.first;
  // String dropdownValue = 'two';

  //Métodos Privados
  Widget _DocumentType(){
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      //style: const TextStyle(color: Colors.primaries),
      underline: Container(
      height: 2,
      color: const Color(0xFF243588),
    ),
    onChanged: (String? value) {
      // This is called when the user selects an item.
    // setState(() {
    //  dropdownValue = value!;
    //  });
    },
    items: list.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    );
  }

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

  Widget _imageLogo(){
    return SafeArea(
      child: Container(
          margin: EdgeInsets.only(top: 20),
          alignment: Alignment.center,
          child: Image.asset(
            'assets/img/LogoLogin.png',
            width: 100,
          )
      ),
    );
  }
  Widget _imageLines(){
    return Container(
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
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.white,
                blurRadius: 30,
                offset: Offset(0, 1.75)
            )
          ]
      ),
    );
  }
  Widget _imageBg(){
    return Container(

        child: Image.asset(
            'assets/img/background.png'
        )
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
        height: MediaQuery.of(context).size.height * 2.0,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.23, left: 50, right: 50 ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 15,
              offset: Offset(0, 0.75)
            )
          ]
        ),
        child: SingleChildScrollView(
          child: Column(
              children: [
               // _textFieldEmail(),
               // _textFieldPassword(),
                _inputFirstname()
                ,_inputSecondname()
                ,_inputLastName()
                ,_inputSecondLastName()

                //,_DocumentType()
                ,_inputDocumentType()
                ,_inputNumberDocument()
                ,_inputGender()
                ,_inputDate()
                ,_inputPhone()
                ,_inputOtherPhone()
                ,_inputEmail()
                ,_inputConfirmEmail()
                ,_inputCountry()
                ,_inputRegion()
                ,_inputCity()
                ,_inputAddress()
                ,_inputFirsPassword()
                ,_inputConfirmPassword()
                ,_checkTest(context)


                ,_buttonRegister()
              ]
          ),
        )
    );
  }


  Widget _buttonRegister(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
          onPressed: () => con.register(),
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
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextField(
        controller: con.firstNameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'Primer Nombre',
             // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }
  Widget _inputSecondname(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextField(
          controller: con.secondNameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Segundo nombre',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }
  Widget _inputLastName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextField(
          controller: con.lastController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Primer Apellido',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }
  Widget _inputSecondLastName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextField(
          controller: con.secondLastController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Segundo Apellido',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }
  Widget _inputDocumentType(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextField(
          //controller: con.firstNameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Tipo de documento',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }
  Widget _inputNumberDocument(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextField(
          controller: con.numberDocumentController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'N° de documento',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }
  Widget _inputGender(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextField(
          controller: con.genderController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Genero',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }
  Widget _inputDate(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextField(
          controller: con.dateController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Fecha de Nacimiento',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }
  Widget _inputPhone(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
  Widget _inputOtherPhone(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
  Widget _inputCountry(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextField(
          controller: con.countryController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Pais de residencia',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }
  Widget _inputRegion(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextField(
          controller: con.regionController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Departamento',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }
  Widget _inputCity(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextField(
          controller: con.cityController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Ciudad',
            // prefixIcon: Icon(Icons.account_circle)
          )
      ),
    );
  }
  Widget _inputAddress(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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


  Widget _inputFirsPassword(){
    return Container(
      child: TextField(
          controller: con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
         // border: OutlineInputBorder(),
          labelText: 'Contraseña',
        )
      )
    );
  }
  Widget _inputConfirmPassword(){
    return Container(
        child: TextField(
            controller: con.confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
            //  border: OutlineInputBorder(),
              labelText: 'Confirmar contraseña',
            )
        )
    );
  }

  Widget _checkTest(BuildContext context) {
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
        //margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child:
          Column(
            children:[
              Row(
                children: [
                  Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isChecked,
                      onChanged: (bool? value) {},
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
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: isChecked,
                    onChanged: (bool? value) {},
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

}

