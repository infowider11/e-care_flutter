import 'dart:async';

import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/material.dart';

import '../Services/api_urls.dart';
import '../constants/colors.dart';
import '../functions/global_Var.dart';
import '../services/auth.dart';
import '../services/firebase_push_notifications.dart';
import '../services/onesignal.dart';
import '../services/webservices.dart';
import '../tabs_doctor.dart';
import '../welcome.dart';
import '../widgets/CustomTexts.dart';
import '../widgets/buttons.dart';

class PendingVerificationPage extends StatefulWidget {
  final String id;
  const PendingVerificationPage({Key? key, required this.id}) : super(key: key);

  @override
  State<PendingVerificationPage> createState() =>
      _PendingVerificationPageState();
}

class _PendingVerificationPageState extends State<PendingVerificationPage> {
  Timer? timer;
  bool? is_email_verifyed;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    interval();
  }

  interval() async {
    globel_timer = Timer.periodic(Duration(seconds: 3), (timer) {
      Webservices.get('${ApiUrls.get_user_by_id}?user_id=${widget.id}')
          .then((value) async {
        print('the status is ${value}');
        if (value['status'].toString() == '1') {
          if (value['data'] != null) {
            if (value['data']['is_verified'].toString() == '1') {
              if (value['data']['is_email'].toString() == '1') {
                setState(() {
                  is_email_verifyed = true;
                });
                String? token = await get_device_id();
                print('token-----$token');
                await Webservices.updateDeviceToken(
                    user_id: widget.id.toString(), token: token!);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return tabs_third_page(
                    initialIndex: 0,
                  );
                }), (route) {
                  return false;
                });
                timer.cancel();
              } else {
                setState(() {
                  is_email_verifyed = false;
                });
              }
            } else if (value['data']['is_verified'].toString() == '2') {
              await logout();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Welcome_Page()),
                  (Route<dynamic> route) => false);
              showSnackbar( 'Rejected By Admin.');
            }
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Welcome_Page()));
            timer!.cancel();
          }
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Welcome_Page()));
          timer!.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
            ),
            vSizedBox4,
            MainHeadingText(
              text: 'Thank You!',
              color: MyColors.primaryColor,
              fontSize: 30,
            ),
            vSizedBox2,
            Center(
                child: Text(
              'The verification process may take up to 3 days.'
              '\n You will receive a notification once you are verified. Please email admin@e-care.co.za should you have any queries.',
              style: TextStyle(fontSize: 15),
            )),

            vSizedBox2,
            if(is_email_verifyed!=null&&!is_email_verifyed!)
              Center(
                  child: Text(
                    'Please verify your email,Check your mail.',
                    style: TextStyle(fontSize: 15),
                  )),
            vSizedBox4,
            RoundEdgedButton(
              text: 'Log Out',
              width: 250,
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context1) {
                      return AlertDialog(
                        title: Text(
                          'Logout',
                        ),
                        content: Text('Are you sure, want to logout?'),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                // timer!.cancel();
                                await logout();
                                // Navigator.of(context).pushReplacementNamed('/pre-login');
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => Welcome_Page()),
                                    (Route<dynamic> route) => false);
                              },
                              child: Text('logout')),
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context1);
                              },
                              child: Text('cancel')),
                        ],
                      );
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
