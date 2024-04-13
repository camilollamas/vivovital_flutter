import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vitalhelp_app/src/pages/rememberPassword/remember_controller.dart';


class RememberPage extends StatefulWidget {
  const RememberPage({super.key});


  @override
  State<RememberPage> createState() => _RememberState();
}




class _RememberState extends State<RememberPage>  {
  RememberController con = Get.put(RememberController());


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
            body: Obx(() => Stack(
              children: [
                _boxForm(context),
                _buttonBack(),
                Column(
                  children:[
                    _imageLogo(),
                    _imageLines(),
                    _textLogin(),
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
        margin: const EdgeInsets.only(left: 20),
        child: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
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
      'Recuperar Contraseña',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w300,
        color: Color(0xFF243588),
        fontFamily: 'AvenirReg',
      )
    );
  }

  Widget _textMessageInformation(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: const Center(
        child: Text(
          'Se enviará un código de validación al correo electrónico registrado.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'AvenirReg',
          ),
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
            onTap: () => con.goToRegisterPage(),
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
            Visibility(
                visible: con.showPassInputs.value ? false : true,
                child: Column(
                  children: [
                    _textFieldEmail(),
                    _textMessageInformation(),  
                    _buttonValidate(context),
                  ],
                ),
            ),
            // _textFieldPassword(),
            Visibility(
                visible: con.showPassInputs.value ? true : false,
                child: 
                  Column(
                    children: [
                      _inputPassword(),
                      _inputConfirmPassword(),
                      _buttonSavePass(context),
                    ]
                  )

            )
            // _textRemmemberPass(context)
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

  Widget _buttonValidate(BuildContext context){
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
          onPressed: () =>
          {
          con.validateEmail(context),
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 5)
          ),
          child: const Text(
            'Solicitar código',
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
  
  bool hidePassword = true;
  Widget _inputPassword(){
    return Container(
        child: TextField(
            controller: con.passwordController,
            obscureText: hidePassword,
            decoration: InputDecoration(
              // border: OutlineInputBorder(),
              labelText: 'Nueva Contraseña',
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
            decoration: const InputDecoration(
            //  border: OutlineInputBorder(),
              labelText: 'Confirmar contraseña',
            )
        )
    );
  }
  Widget _buttonSavePass(BuildContext context){
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
          onPressed: () =>
          {
            con.savePassword(context),
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 5)
          ),
          child: const Text(
            'Guardar',
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
