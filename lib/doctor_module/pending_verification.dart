// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unnecessary_brace_in_string_interps, avoid_print, await_only_futures

import 'dart:async';

import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/material.dart';

import '../Services/api_urls.dart';
import '../constants/colors.dart';
import '../functions/global_Var.dart';
import '../services/auth.dart';
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
    
    super.initState();
    interval();
  }

  interval() async {
    globel_timer = Timer.periodic(const Duration(seconds: 3), (timer) {
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
                  MaterialPageRoute(builder: (context) => const Welcome_Page()),
                  (Route<dynamic> route) => false);
              showSnackbar( 'Rejected By Admin.');
            }
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Welcome_Page()));
            timer.cancel();
          }
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Welcome_Page()));
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
            ),
            vSizedBox4,
            const MainHeadingText(
              text: 'Thank You!',
              color: MyColors.primaryColor,
              fontSize: 30,
            ),
            vSizedBox2,
            const Center(
                child: Text(
              'The verification process may take up to 3 days.'
              '\n You will receive a notification once you are verified. Please email admin@e-care.co.za should you have any queries.',
              style: TextStyle(fontSize: 15),
            )),

            vSizedBox2,
            if(is_email_verifyed!=null&&!is_email_verifyed!)
              const Center(
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
                        title: const Text(
                          'Logout',
                        ),
                        content: const Text('Are you sure, want to logout?'),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                // timer!.cancel();
                                await logout();
                                // Navigator.of(context).pushReplacementNamed('/pre-login');
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const Welcome_Page()),
                                    (Route<dynamic> route) => false);
                              },
                              child: const Text('logout')),
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context1);
                              },
                              child: const Text('cancel')),
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
