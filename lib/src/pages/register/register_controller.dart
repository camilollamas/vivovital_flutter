import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController secondLastController = TextEditingController();
  TextEditingController numberDocumentController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otherPhoneController = TextEditingController();

  TextEditingController countryController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //  TextEditingController checkTermsController = CheckboxInputElement();
  TextEditingController checkTermsController = TextEditingController();
  TextEditingController checkCriteriusController = TextEditingController();


  void register(){
    String firstName = firstNameController.text.trim();
    String secondName = secondNameController.text.trim();
    String lastName = lastController.text.trim();
    String secondLastname = secondLastController.text.trim();
    String numDocument = numberDocumentController.text.trim();
    String gender = genderController.text.trim();
    String date = dateController.text.trim();
    String phone = phoneController.text.trim();
    String otherPhone = otherPhoneController.text.trim();

    String country = countryController.text.trim();
    String region = regionController.text.trim();
    String city = cityController.text.trim();
    String address = addressController.text.trim();

    String email = emailController.text.trim();
    String confirmEmail = confirmEmailController.text.trim();

    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    String checkTerms = checkTermsController.text;

    String checkCrit = checkCriteriusController.text.trim();
    //print('checkTerms: ${checkTerms}');



    // Get.snackbar('check: ', ${checkTerms} );
    //print('Pass: ${password}');

    /*
      Get.snackbar('Email', email);
      Get.snackbar('Password', password);

     */
    // if(isValidForm(checkTerms, password)){
    //   Get.snackbar('Válido: ', 'Enviar peticion HTTP');
    // }
  }

  bool isValidForm(){


    return true;
  }
}

