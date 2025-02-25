// ignore_for_file: unused_local_variable, unused_field, prefer_final_fields, non_constant_identifier_names, camel_case_types, library_private_types_in_public_api, must_be_immutable, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:ecare/pages/booked_visit.dart';
import 'package:ecare/pages/create-profile.dart';
import 'package:ecare/pages/get_care.dart';
import 'package:ecare/pages/homepage.dart';
import 'package:ecare/pages/myecare.dart';
import 'package:ecare/pages/patient_home.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/onesignal.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/welcome.dart';
import 'package:flutter/material.dart';

import 'Services/api_urls.dart';
import 'constants/colors.dart';
import 'functions/global_Var.dart';

class tabs_second_page extends StatefulWidget {
  int selectedIndex;
  tabs_second_page({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  _tabs_second_pageState createState() => _tabs_second_pageState();
}

class _tabs_second_pageState extends State<tabs_second_page> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  Timer? timer;
  bool ontime_health_profile = false;

  static final List<Widget> _widgetOptions = <Widget>[
    const Homepage(),
    const PatientHomePage(),
    const GetCare(),
    const BookedVisit(),
    const MyECare(),
    // DoctorInvitePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  @override
  void initState() {
    
    setNotificationHandler(context);
    super.initState();
    interval();
  }

  @override
  void dispose() {
    super.dispose();
    // timer!.cancel();
  }

  static Future<String> getApiData(String userId) async {
    print('coming from the isolate server .....manish');
    return jsonEncode(
        await Webservices.get('${ApiUrls.interval}?user_id=${userId}'));
  }

  static void isolateEntryPoint(Map<String, dynamic> params) async {
    SendPort sendPort = params['sendPort'];
    String userId = params['userId'];
    // Perform API call in the isolate
    // String userId = await getCurrentUserId();
    // String userId = user_Data?['id'];
    print(
        'coming from the isolate entry point  server .....with user id $userId');

    String result = await getApiData(userId);

    // Send the result back to the main thread
    sendPort.send(result);
    await Future.delayed(const Duration(seconds: 10));
    isolateEntryPoint(params);
  }

  interval() async {
    print('starting the interval');
    ReceivePort receivePort = ReceivePort();

    // receivePort.
    receivePort.listen((message) {
      // Handle the result from the isolate
      print('Received result from isolate: $message');
     try{
       Map<String, dynamic> value = jsonDecode(message);
       print('the status is ${value}');
       if (value['status'].toString() == '1') {
         if (value['data']['block'].toString() == '1') {
           if (value['data']['is_health_profile'].toString() == '0' &&
               !ontime_health_profile) {
             ontime_health_profile = true;
             try{
               setState(() {});
             }catch(e){
               print('Could not set state');
             }
             // ModalRoute.of(context).cre
             Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (context) => const CreateProfile(
                       hide_show: true,
                     )));
             // timer.cancel();
           }
         } else {
           globel_timer!.cancel();
           logout().then((value) {
             Navigator.of(context).pushAndRemoveUntil(
                 MaterialPageRoute(builder: (context) => const Welcome_Page()),
                     (Route<dynamic> route) => false);
           });
         }
       } else {
         // Navigator.push(
         //     context, MaterialPageRoute(builder: (context) => Welcome_Page()));
         // timer!.cancel();
       }
     }catch(e){
       print("Error in catch block 34562");
     }
    });
    String userId = await getCurrentUserId();
    Isolate isolate = await Isolate.spawn<Map<String,dynamic>>(
      isolateEntryPoint,
      {
        'sendPort': receivePort.sendPort,
        'userId': userId,
      },
    );

    // String user_id = await getCurrentUserId();
    // globel_timer = Timer.periodic(Duration(seconds: 3), (timer) {
    //   Webservices.get('${ApiUrls.interval}?user_id=${user_id}')
    //       .then((value) async {
    //     print('the status is ${value}');
    //     if (value['status'].toString() == '1') {
    //       if (value['data']['block'].toString() == '1') {
    //         if (value['data']['is_health_profile'].toString() == '0'&&!ontime_health_profile) {
    //           ontime_health_profile=true;
    //           setState(() {
    //           });
    //           // ModalRoute.of(context).cre
    //           Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfile(hide_show: true,)));
    //           // timer.cancel();
    //         }
    //       } else {
    //         globel_timer!.cancel();
    //         await logout();
    //         // Navigator.of(context).pushReplacementNamed('/pre-login');
    //         Navigator.of(context).pushAndRemoveUntil(
    //             MaterialPageRoute(
    //                 builder: (context) =>
    //                     Welcome_Page()),
    //                 (Route<dynamic> route) => false);
    //         // showSnackbar( 'Blocked By Admin.');
    //       }
    //     } else {
    //       // Navigator.push(
    //       //     context, MaterialPageRoute(builder: (context) => Welcome_Page()));
    //       // timer!.cancel();
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      body: Center(
        child: _widgetOptions.elementAt(widget.selectedIndex),
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
          selectedFontSize: 8,
          selectedLabelStyle: const TextStyle(
              fontFamily: 'bold',
              fontWeight: FontWeight.bold,
              color: Color(0xFE999999)),
          unselectedFontSize: 8,
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'bold',
            fontWeight: FontWeight.bold,
          ),
          unselectedItemColor: const Color(0xFE999999),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Transform.translate(
                offset: const Offset(0, 0),
                child: const ImageIcon(
                  AssetImage("assets/images/howitworks.png"),
                  size: 22,
                ),
              ),
              activeIcon: const ImageIcon(
                AssetImage("assets/images/howitworks.png"),
                size: 22,
              ),
              label: 'How to',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Transform.translate(
                offset: const Offset(0, 0),
                child: const ImageIcon(
                  AssetImage("assets/images/home.png"),
                  size: 22,
                ),
              ),
              activeIcon: const ImageIcon(
                AssetImage("assets/images/home.png"),
                size: 22,
              ),
              label: 'Home',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Transform.translate(
                offset: const Offset(0, 0),
                child: const ImageIcon(
                  AssetImage("assets/images/care.png"),
                  size: 22,
                ),
              ),
              activeIcon: const ImageIcon(
                AssetImage("assets/images/care.png"),
                size: 22,
              ),
              label: 'Get Care',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Transform.translate(
                offset: const Offset(0, 0),
                child: const ImageIcon(
                  AssetImage("assets/images/care.png"),
                  size: 22,
                ),
              ),
              activeIcon: const ImageIcon(
                AssetImage("assets/images/care.png"),
                size: 22,
              ),
              label: 'My Consultation',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Transform.translate(
                offset: const Offset(0, 0),
                child: const ImageIcon(
                  AssetImage("assets/images/heart.png"),
                  size: 22,
                ),
              ),
              activeIcon: const ImageIcon(
                AssetImage("assets/images/heart.png"),
                size: 22,
              ),
              label: 'My E-Care',
              backgroundColor: Colors.white,
            ),
            // BottomNavigationBarItem(
            //   icon: Transform.translate(
            //     offset: Offset(0, 0),
            //     child: ImageIcon(
            //       AssetImage("assets/images/invite.png"),
            //       size: 22,
            //     ),
            //   ),
            //   activeIcon: ImageIcon(
            //     AssetImage("assets/images/invite.png"),
            //     size: 22,
            //   ),
            //   label: 'Invite',
            //   backgroundColor: Colors.white,
            // ),
          ],
          currentIndex: widget.selectedIndex,
          selectedItemColor: MyColors.primaryColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
