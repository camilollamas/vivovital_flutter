import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vitalhelp_app/src/pages/login/login_controller.dart';



class LoginPage extends StatefulWidget {
   const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}


// class LoginPage extends StatelessWidget {
class _LoginState extends State<LoginPage> {
  LoginController con = Get.put(LoginController());

  // LoginPage({super.key});

  @override
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
            body: Stack(
              children: [
                _boxForm(context),
                Column(
                  children:[
                    _imageLogo(),
                    _imageLines(),
                    _textLogin(),
                  ]
                )
              ]
            )
          )
        ]
      );
  }

  //Métodos Privados
  Widget _imageLogo(){
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
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

  Widget _textLogin(){
    return const Text(
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
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: Center( // Aquí envolvemos el Row con un Center
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Alinear los hijos al centro horizontalmente
        children:[
          const Text(
            '¿No tienes cuenta?',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'AvenirReg',
            )
          ),
          const SizedBox(width: 7),
          GestureDetector(
            onTap: () => con.goToRegisterPage(),
            child: const Text(
              'Regístrate aquí',
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
    ),
  );
}


  Widget _textRemmemberPass(BuildContext context){
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    child: Center( // Aquí envolvemos el Row con un Center
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Alinear los hijos al centro horizontalmente
        children:[
          const SizedBox(width: 7),
          GestureDetector(
            onTap: () => con.goToRememberPage(),
            child: const Text(
              'Recuperar contraseña',
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
            _textDontHaveAccount(),
            _textRemmemberPass(context)
          ]
        ),
      )
    );
  }

  Widget _textFieldEmail(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: TextField(
        controller: con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: 'Correo Electrónico',
          prefixIcon: Icon(Icons.email)
        )
      ),
    );
  }
  bool hidePassword = true;
  Widget _textFieldPassword(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: TextField(
          controller: con.passwordController,
          keyboardType: TextInputType.text,
          obscureText: hidePassword,
          decoration: InputDecoration(
              // border: OutlineInputBorder(),
              labelText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock),
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
      ),
    );
  }
  Widget _buttonLogin(BuildContext context){
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
          onPressed: () =>
          {
            // _showLoading(context)
          con.login(context),
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 5)
          ),
          child: const Text(
            'Iniciar Sesión',
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

}
