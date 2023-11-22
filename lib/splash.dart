import 'dart:convert';

import 'package:ecare/doctor_module/pending_verification.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/pages/booked_visit.dart';
import 'package:ecare/pages/chat.dart';
import 'package:ecare/pages/create-profile.dart';
import 'package:ecare/pages/messages.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/firebase_push_notifications.dart';
import 'package:ecare/services/onesignal.dart';
import 'package:ecare/services/pay_stack/flutter_paystack_services.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/tabs.dart';
import 'package:ecare/tabs_doctor.dart';
import 'package:ecare/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../constants/image_urls.dart';
import 'Services/api_urls.dart';
import 'constants/global_keys.dart';
import 'constants/navigation.dart';
import 'doctor_module/hpcsa-form.dart';
import 'package:flutter/foundation.dart';

class SplashScreenPage extends StatefulWidget {
  static const String id = "splash";
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    // if(!kIsWeb)

    initializeEverything();

  }

  initializeEverything()async{
    var response = await Webservices.getData(ApiUrls.adminCommission);
    var jsonResponse = jsonDecode(response.body);
    percentageCharge = double.parse(jsonResponse['data'].toString());
    setState(() {

    });
    print('the percentage charge is $percentageCharge');
    await check();
  }



  check() async {
    // await logout();
    if (await isUserLoggedIn()) {
      print('isUserLoggedIn');
      var id = await getCurrentUserId();
      Webservices.get('${ApiUrls.get_user_by_id}?user_id=${id}')
          .then((value) async {
        print('the status is ${value}');
        if (value['status'].toString() == '1') {
          user_Data = value['data'];
          setState(() {});
          String? token = await get_device_id();
          print('splash-----$token');
          await Webservices.updateDeviceToken(
              user_id: user_Data!['id'].toString(), token: token!);
          if (value['data'] != null) {
            if (value['data']['is_verified'].toString() == '1') {
              if (value['data']['type'].toString() == '1') {
                if(value['data']['is_email'].toString() == '1'){
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                        return tabs_third_page(
                          selectedIndex: 0,
                        );
                      }), (route) {
                    return false;
                  });
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PendingVerificationPage(id: id)));
                }
              } else if (value['data']['type'].toString() == '2') {
                if (value['data']['is_health_profile'].toString() == '0') {
                  // step 1
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfile(hide_show: true,)));
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return tabs_second_page(
                      selectedIndex: 0,
                    );
                  }), (route) {
                    return false;
                  });
                } else {

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return tabs_second_page(
                      selectedIndex: 0,
                    );
                  }), (route) {
                    return false;
                  });
                }
              }
            }
            else if (value['data']['is_verified'].toString() == '0') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PendingVerificationPage(id: id)));
            }
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Welcome_Page()));
          }
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Welcome_Page()));
        }
      });
    } else {
      print('not logged');
      push(context: context, screen: Welcome_Page());
    }
  }

  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        MyImages.splash,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }
}
