import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vivovital_app/src/models/user.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
// import 'package:permission_handler/permission_handler.dart';


class MonitoringController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});


  MonitoringController(){
    print('Monitoring Controller -> User -> : ${user.toJson()}');
  }

  void genPDfLabs() async {
    _requestPermission(Permission.storage);

      print('====>  genPDfLabs <====');
      final font = await rootBundle.load("assets/fonts/AvenirNextRoundedStd-Reg.ttf");
      final ttf = pw.Font.ttf(font);
      final pw.Document doc = pw.Document();

       // Add one page with centered text "Hello World"
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.ConstrainedBox(
              constraints: pw.BoxConstraints.expand(),
              child: pw.FittedBox(
                child: pw.Text(
                  'Hello World',
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 48,
                  ),
                  ),
              ),
            );
          },
        ),
      );

      final file = File('example.pdf');
      await doc.save();

  }

  //permission to save file in device 
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
 

}