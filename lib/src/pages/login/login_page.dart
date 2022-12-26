import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivovital_app/src/pages/login/login_controller.dart';

class LoginPage extends StatelessWidget {
  
  LoginController con = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //bottomNavigationBar: Container(
        //    height: 50,
        //    child: _textDontHaveAccount()
        //),
        body: Stack(
        children: [
          _imageBgWhite(),
          _imageBg(),
          _bgDegrade(context),
          _boxForm(context),


          Column(
            children:[
              _imageLogo(),
              _imageLines(),
              _textLogin()
          ]

          )
        ]
      )
    );
  }

  //Métodos Privados
  Widget _imageLogo(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/img/LogoLogin.png',
          width: 200,
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
      'Iniciar Sesión',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w300,
        color: Color(0xFF243588),
        fontFamily: 'AvenirReg',
      )
    );
  }

  Widget _textDontHaveAccount(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children:[
          Text(
              '¿No tienes cuenta?',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'AvenirReg',
              )
          ),
          SizedBox(width: 7),
          GestureDetector(
           onTap: () => con.goToRegisterPage(),
            child: Text(
              'Registrate aquí',
              style: TextStyle(
                color: Color(0xff243588),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'AvenirReg',
              )
            ),
          )

        ]
      ),
    );

  }

  Widget _boxForm(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.45, left: 50, right: 50 ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textFieldEmail(),
            _textFieldPassword(),
            _buttonLogin(context),
            _textDontHaveAccount()
          ]
        ),
      )
    );
  }

  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: TextField(
        controller: con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Correo Electrónico',
          prefixIcon: Icon(Icons.email)
        )
      ),
    );
  }
  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0),
      child: TextField(
          controller: con.passwordController,
          keyboardType: TextInputType.text,
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'Contraseña',
              prefixIcon: Icon(Icons.lock)
          )
      ),
    );
  }
  Widget _buttonLogin(BuildContext context){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
          onPressed: () => con.login(context),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 5)
          ),
          child: Text(
            'Ingresar',
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

}
