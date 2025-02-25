// ignore_for_file: unused_field, must_be_immutable, camel_case_types, library_private_types_in_public_api, avoid_print

import 'dart:async';

import 'package:ecare/doctor_module/appointment_request.dart';
import 'package:ecare/doctor_module/how_it_works.dart';
import 'package:ecare/doctor_module/myecare.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/onesignal.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/welcome.dart';
import 'package:flutter/material.dart';

import 'Services/api_urls.dart';
import 'constants/colors.dart';
import 'doctor_module/homepage.dart';
import 'functions/global_Var.dart';

class tabs_third_page extends StatefulWidget {
  int initialIndex;
  tabs_third_page({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _tabs_third_pageState createState() => _tabs_third_pageState();
}

class _tabs_third_pageState extends State<tabs_third_page> {
  int selectedIndex = 0;
  Timer? timer;
  bool healthprofile=false;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static final List<Widget> _widgetOptions = <Widget>[
    const DoctorHowItWorks(),
    const DoctorHomePage(),
    const AppointmentRequest(),
    const DoctorMyECare(),
    // DoctorInvitePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    
    _onItemTapped(widget.initialIndex);
    setNotificationHandler(context);
    super.initState();
    interval();
  }

  interval() async {
    // ignore: non_constant_identifier_names
    String user_id = await getCurrentUserId();
    globel_timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      Webservices.get('${ApiUrls.interval}?user_id=${user_id}&t=1')
          .then((value) async {
        print('the status is ${value}');
        if (value['status'].toString() == '1') {
          unread_noti_count = int.parse(value['data']['unread_count']);
          try {
            setState(() {

            });
          } catch(e) {
            print('not update');
          }

          if (value['data']['block'].toString() == '1') {
            if (value['data']['is_health_profile'].toString() == '0') {
            //   healthprofile=true;
            //   setState(() {
            //
            //   });
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfile()));
            //   timer.cancel();
            }
          } else {
            globel_timer!.cancel();
            await logout();
            // Navigator.of(context).pushReplacementNamed('/pre-login');
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        const Welcome_Page()),
                    (Route<dynamic> route) => false);
            //showSnackbar( 'Blocked By Admin.');
          }
        } else {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Welcome_Page()));
          // timer!.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBody: true,
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            color: Color(0xFEF6F6F6),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFEE8F0F6),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          // showSelectedLabels: false,
          // showUnselectedLabels: false,
          selectedFontSize: 10,
          selectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontFamily: 'bold',
            fontWeight: FontWeight.bold,
            color: Color(0xFE999999)
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
              fontFamily: 'bold',
              fontWeight: FontWeight.bold,
              color: Color(0xFE999999)
          ),
          unselectedFontSize: 10,
          unselectedItemColor: const Color(0xFE999999),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Transform.translate(
                offset: const Offset(0,0),
                child: const ImageIcon(
                  AssetImage("assets/images/howitworks.png"),
                  size: 22,
                ),
              ),
              activeIcon:  const ImageIcon(
                AssetImage("assets/images/howitworks.png"),
                size: 22,
              ),
              label: 'How it works',
              backgroundColor: Colors.white,
            ),

            BottomNavigationBarItem(
              icon: Transform.translate(
                offset: const Offset(0,0),
                child: const ImageIcon(
                  AssetImage("assets/images/home.png"),
                  size: 22,
                ),
              ),
              activeIcon:  const ImageIcon(
                AssetImage("assets/images/home.png"),
                size: 22,
              ),
              label: 'Home',
              backgroundColor: Colors.white,
            ),

            BottomNavigationBarItem(
              icon: Transform.translate(
                offset: const Offset(0,0),
                child: const ImageIcon(
                  AssetImage("assets/images/care.png"),
                  size: 22,
                ),
              ),
              activeIcon:  const ImageIcon(
                AssetImage("assets/images/care.png"),
                size: 22,
              ),
              label: 'My Consultation',
              backgroundColor: Colors.white,
            ),

            BottomNavigationBarItem(
              icon: Transform.translate(
                offset: const Offset(0,0),
                child: const ImageIcon(
                  AssetImage("assets/images/heart.png"),
                  size: 22,
                ),
              ),
              activeIcon:  const ImageIcon(
                AssetImage("assets/images/heart.png"),
                size: 22,
              ),
              label: 'My E-Care',
              backgroundColor: Colors.white,
            ),

            // BottomNavigationBarItem(
            //   icon: Transform.translate(
            //     offset: Offset(0,0),
            //     child: ImageIcon(
            //       AssetImage("assets/images/invite.png"),
            //       size: 22,
            //     ),
            //   ),
            //   activeIcon:  ImageIcon(
            //     AssetImage("assets/images/invite.png"),
            //     size: 22,
            //   ),
            //   label: 'Invite',
            //   backgroundColor: Colors.white,
            // ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: MyColors.primaryColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}