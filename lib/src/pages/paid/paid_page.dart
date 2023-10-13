import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:get/get.dart';
import 'package:vitalhelp_app/src/pages/paid/paid_controller.dart';
import 'package:vitalhelp_app/src/utils/drawer_menu.dart';
import 'package:intl/intl.dart';

class PaidPage extends StatelessWidget {
  PaidController con = Get.put(PaidController());
  var scaffoldKey = GlobalKey<ScaffoldState>();

  PaidPage({super.key});


  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'es_MX', symbol:"\$");
    return GetBuilder<PaidController>(
        init: con,
        initState: (_) {
        },
        builder: (_) {
          return Scaffold(
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
                  'vitalhelp App',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'AvenirReg',
                  )
              ),
            ),
            body: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text( '${con.paid['descPlan'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF243588),
                          fontFamily: 'AvenirReg',
                        )
                    ),
                    Text('Inversión: ${numberFormat.format(con.paid['PlanCost'])  ?? ''}',
                        style: const TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.w300,
                          color: Color(0xFF243588),
                          fontFamily: 'AvenirBold',
                        )
                    )
                  ],
                ),
                CreditCardWidget(
                  cardNumber: con.cardNumber.value,
                  expiryDate: con.expiryDate.value,
                  cardHolderName: con.cardHolderName.value,
                  cvvCode: con.cvvCode.value,
                  showBackView: con.isCvvFocused.value,
                  // cardBgColor: Colors.black,
                  labelCardHolder: 'NOMBRE Y APELLIDO',
                  labelExpiredDate: 'MM/YY',
                  // labelExpiredDate: 'FV',
                  // glassmorphismConfig: Glassmorphism.defaultConfig(),
                  // backgroundImage: 'assets/card_bg.png',
                  // backgroundImage: 'assets/img/card_bg.png',
                  backCardBorder: Border.all(color: Colors.grey),
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  height: 175,
                  // textStyle: TextStyle(color: Colors.white60),
                  width: MediaQuery.of(context).size.width,
                  isChipVisible: true,
                  isSwipeGestureEnabled: true,
                  animationDuration: const Duration(milliseconds: 1000),
                  frontCardBorder: Border.all(color: Colors.grey),
                  // backCardBorder: Border.all(color: Colors.grey),
                  onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'assets/img/mastercard.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ],
                  // customCardIcons: <CustomCardTypeImage>[
                  //   CustomCardTypeImage(
                  //     cardType: CardType.mastercard,
                  //     cardImage: Image.asset(
                  //       'assets/mastercard.png',
                  //       height: 48,
                  //       width: 48,
                  //     ),
                  //   ),
                  // ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: CreditCardForm(
                    formKey: con.keyForm, // Required
                    onCreditCardModelChange: con.onCreditCardModelChange, // Required
                    themeColor: Colors.red,
                    obscureCvv: true,
                    obscureNumber: true,
                    isHolderNameVisible: true,
                    // isCardNumberVisible: false,
                    isExpiryDateVisible: true,
                    cardNumberValidator: (String? cardNumber){
                      return null;
                    },
                    expiryDateValidator: (String? expiryDate){
                      return null;
                    },
                    cvvValidator: (String? cvv) {
                      return null;
                    },
                    cardHolderValidator: (String? cardHolderName){
                      return null;
                    },
                    onFormComplete: () {
                      // callback to execute at the end of filling card data
                    },
                    cardNumberDecoration: const InputDecoration(
                      // border: OutlineInputBorder(),
                      isDense: true,
                      suffixIcon: Icon(Icons.credit_card),
                      labelText: 'Número de la tarjeta',
                      hintText: 'XXXX XXXX XXXX XXXX',
                    ),
                    expiryDateDecoration: const InputDecoration(
                      // border: OutlineInputBorder(),
                      isDense: true,
                      suffixIcon: Icon(Icons.date_range),
                      labelText: 'Expiración',
                      hintText: 'MM/YY',
                    ),
                    cvvCodeDecoration: const InputDecoration(
                      // border: OutlineInputBorder(),
                      isDense: true,
                      suffixIcon: Icon(Icons.lock),
                      labelText: 'CVV',
                      hintText: 'XXX',
                    ),
                    cardHolderDecoration: const InputDecoration(
                      // border: OutlineInputBorder(),
                      isDense: true,
                      suffixIcon: Icon(Icons.person),
                      labelText: 'Titular de la tarjeta',
                    ),
                    cardNumber: '',
                    expiryDate: '',
                    cardHolderName: '',
                    cvvCode: '',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _textInstallments(context),
                        _inputInstallments(context)
                    ]
                  )
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _inputDocumentType(context),
                      _inputNumberDocument(context)
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child:
                      Row(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.height * 0.2,
                              child: _buttonCancel(context)
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.height * 0.2,
                            child: _buttonPaid(context),
                          )
                        ],
                      )

                )
              ],
            ),
            // Stack(
            //     children: [
            //       _imageBg(),
            //       _bgDegrade(context),
            //       Column(
            //           children: [
            //             Text('Paid Page'),
            //             Text('User ${con.user.toJson()}'),
            //             Text('paid ${con.paid}'),
            //             ElevatedButton(
            //                 onPressed: () => {
            //                   con.onPaid()
            //                 },
            //                 child: Text('Iniciar')
            //             )
            //
            //           ]
            //       )
            //     ]
            // ),
            key: scaffoldKey,
            drawer: Drawer(
              child: _drawerList(),
            ),

          );
        }
    );
  }

  Widget _drawerList(){
    return CustomDrawerMenu();
  }
  Widget _imageBg(){
    return Container(

        child: Image.asset(
            'assets/img/background.png'
        )
    );
  }
  Widget _bgDegrade(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.white,
                blurRadius: 90,
                offset: Offset(0, 110.0)
            )
          ]
      ),
    );
  }
  Widget _textInstallments(BuildContext context){
    return Container(
        width: MediaQuery.of(context).size.width * 0.4,
        margin: const EdgeInsets.only( top: 15 , left: 20, right: 0),
        child: const Text('Número de cuotas:')
    );
  }
  Widget _inputInstallments(BuildContext context){
    return Container(
        width: MediaQuery.of(context).size.width * 0.2,
        margin: const EdgeInsets.only( top: 15 , left: 0, right: 5),
        child: DropdownButton(
          hint: const Text('Cuotas'),
          isExpanded: true,
          items: con.listInstallments.map((value) {
            return DropdownMenuItem(
                value: value,
                child: Text(value.toString())
            );
          }).toList(),
          value: con.InstallmentsController.value,
          onChanged: (value) {
            print('================ value $value');
            con.InstallmentsController.value = value as int;
            con.updateValues();
          },
        )
    );
  }
  Widget _inputDocumentType(BuildContext context){
    return Container(
        width: MediaQuery.of(context).size.height * 0.1,
        margin: const EdgeInsets.only( top: 15 , left: 20, right: 5),
        child: DropdownButton(
          hint: const Text('Tipo'),
          isExpanded: true,
          items: con.documentTypes.map((value) {
            return DropdownMenuItem(
                value: value,
                child: Text(value)
            );
          }).toList(),
          value: con.docType.value == '' ? null : con.docType.value,
          onChanged: (value) {
            con.docType.value = value.toString();
            con.updateValues();
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
        onChanged: (value){
          con.numberDocumentController.value = value.toString();
          con.updateValues();
        },
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'N° de documento',
          // prefixIcon: Icon(Icons.account_circle)
        )
      ),
    );
  }
  Widget _buttonPaid(BuildContext context){
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ElevatedButton(
          onPressed: () => con.confirmPaid(context),
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 0)
          ),
          child: const Text(
            'Pagar',
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
  Widget _buttonCancel(BuildContext context){
    return Container(
      child: ElevatedButton(
          onPressed: () =>{
            con.onCancel()
            // con.messagePostPaid(context)
          }
          // Navigator.pop(context, true)
        ,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              shadowColor: Colors.transparent
          ),
          child: const Text('Cancelar',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 18,
              fontFamily: 'AvenirReg',
            ),
          )
      ),
    );
  }

}
