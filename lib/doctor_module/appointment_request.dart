// ignore_for_file: unused_local_variable, non_constant_identifier_names, prefer_interpolation_to_compose_strings, avoid_print, deprecated_member_use, use_build_context_synchronously

import 'dart:developer';

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/doctor_module/user_review.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/functions/print_function.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/custom_circular_image.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../pages/add_icd_notes.dart';
import '../pages/addsick.dart';
import '../pages/bookingDetail.dart';
import '../pages/chat.dart';
import '../pages/consultation_notes.dart';
import '../pages/prescriptions_doctor.dart';
import '../pages/referral_letter.dart';
import '../pages/videocall.dart';
import '../services/api_urls.dart';
import '../services/auth.dart';
import '../services/webservices.dart';
import '../widgets/buttons.dart';
import '../widgets/custom_confirmation_dialog.dart';
import 'notification.dart';

class AppointmentRequest extends StatefulWidget {
  const AppointmentRequest({Key? key}) : super(key: key);

  @override
  State<AppointmentRequest> createState() => _AppointmentRequestState();
}

class _AppointmentRequestState extends State<AppointmentRequest> with TickerProviderStateMixin{
  TextEditingController email = TextEditingController();
  TextEditingController reason = TextEditingController();
  late TabController _tabcontroller;

  bool load = false;
  List incoming = [];
  List accpeted = [];
  List confirms = [];
  List completeds = [];
  List rejects = [];
  Map current_user = {};

  TabBar get _tabBar => TabBar(
        controller: _tabcontroller,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 0),
        tabs: const <Widget>[
          Tab(
            child: MainHeadingText(
              text: 'Incoming',
              color: MyColors.onsurfacevarient,
              fontSize: 11,
            ),
          ),
          Tab(
            child: MainHeadingText(
              text: 'Accepted',
              color: MyColors.onsurfacevarient,
              fontSize: 11,
            ),
          ),
          Tab(
            child: MainHeadingText(
              text: 'Confirmed',
              color: MyColors.onsurfacevarient,
              fontSize: 11,
            ),
          ),
          Tab(
            child: MainHeadingText(
              text: 'Completed',
              color: MyColors.onsurfacevarient,
              fontSize: 11,
            ),
          ),
          Tab(
            child: MainHeadingText(
              text: 'Rejected',
              color: MyColors.onsurfacevarient,
              fontSize: 11,
            ),
          ),
        ],
      );

  get_lists() async {
    current_user = await getUserDetails();
    setState(() {
      load = true;
    });
    var res = await Webservices.get('${ApiUrls.booking_list}?user_id=' +
        await getCurrentUserId() +
        '&user_type=1');
    print('res-----$res');
    if (res['status'].toString() == '1') {
      incoming = res['data']['pending'];
      accpeted = res['data']['accepted'];
      confirms = res['data']['confirmed'];
      completeds = res['data']['completed'];
      rejects = res['data']['rejected'];
      setState(() {});
    }
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    _tabcontroller = TabController(length:5, vsync: this,initialIndex: 0);
    super.initState();
    get_lists();
  }
  ismarkascomlete(String date_time) {
    DateTime dt1 = DateTime.parse(date_time);
    DateTime dt2 = DateTime.now();
    Duration d = dt1.difference(dt2);
    print('comprea************${d.inMinutes}');
    if (d.inMinutes < -120) {
      return true;
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const MainHeadingText(
            text: 'Appointments',
            fontSize: 26,
            fontFamily: 'light',
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DoctorNotificationPage())),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.notifications,
                  size: 24,
                ),
              ),
            ),
          ],
          backgroundColor: MyColors.BgColor,
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color: MyColors.lightBlue.withOpacity(0.11),
              child: _tabBar,
            ),
          ),
        ),
        body: load
            ? const CustomLoader()
            : TabBarView(
              controller: _tabcontroller,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: MyColors.BgColor,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var i = 0; i < incoming.length; i++)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => bookingdetail(
                                              booking_id:
                                                  incoming[i]['id'].toString(),
                                            )));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  // color: MyColors.lightBlue.withOpacity(0.11),
                                  color: MyColors.surface3,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Image.asset('assets/images/23.png', width: 50,),
                                          CustomCircularImage(
                                              imageUrl: incoming[i]['user_data']
                                                  ['profile_image']),
                                          hSizedBox2,
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: MainHeadingText(
                                                      text:
                                                          '${incoming[i]['user_data']['first_name']}',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  MainHeadingText(
                                                    color: MyColors.black,
                                                    text:
                                                        '${incoming[i]['price']} ZAR',
                                                    fontSize: 15,
                                                  ),
                                                ],
                                              ),
                                              // MainHeadingText(
                                              //   text:
                                              //       'symptoms: ${incoming[i]['symptoms'] ?? '-'}',
                                              //   overflow: TextOverflow.ellipsis,
                                              //   fontFamily: 'light',
                                              //   fontSize: 14,
                                              // ),
                                              Row(
                                                children: [
                                                  MainHeadingText(
                                                    text:
                                                        '${incoming[i]['slot_data']['date']}',
                                                    fontSize: 14,
                                                    fontFamily: 'bold',
                                                    color: MyColors.bordercolor,
                                                  ),
                                                  hSizedBox,
                                                  MainHeadingText(
                                                    text:
                                                        '${DateFormat.jm().format(DateFormat('hh:mm').parse(incoming[i]['slot_data']['start_time']))} - ${DateFormat.jm().format(DateFormat('hh:mm').parse(incoming[i]['slot_data']['end_time']))}',
                                                    fontSize: 11,
                                                    fontFamily: 'medium',
                                                    color:
                                                        MyColors.primaryColor,
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  vSizedBox2,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      RoundEdgedButton(
                                                        text: 'Reject',
                                                        borderRadius: 100,
                                                        width: 70,
                                                        height: 35,
                                                        horizontalPadding: 0,
                                                        verticalPadding: 0,
                                                        color: Colors
                                                            .transparent,
                                                        textColor: MyColors
                                                            .primaryColor,
                                                        bordercolor: MyColors
                                                            .primaryColor,
                                                        onTap: () async {
                                                          _displayTextInputDialog(
                                                              context,
                                                              incoming[i]
                                                                      ['id']
                                                                  .toString(),
                                                              incoming[i][
                                                                      'slot_id']
                                                                  .toString(),
                                                              incoming[i][
                                                                      'user_id']
                                                                  .toString());
                                                        },
                                                      ),
                                                      hSizedBox,
                                                      RoundEdgedButton(
                                                        text: 'Accept',
                                                        borderRadius: 100,
                                                        width: 80,
                                                        height: 35,
                                                        horizontalPadding: 0,
                                                        verticalPadding: 0,
                                                        onTap: () async {
                                                          acceptpopup(
                                                              context,
                                                              incoming[i]
                                                                      ['id']
                                                                  .toString(),
                                                              incoming[i][
                                                                      'slot_id']
                                                                  .toString(),
                                                              incoming[i][
                                                                      'user_id']
                                                                  .toString());
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (incoming.isEmpty)
                            const Center(
                              child: Text('No data found.'),
                            ),
                          vSizedBox8,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: MyColors.BgColor,
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var i = 0; i < accpeted.length; i++)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => bookingdetail(
                                              booking_id:
                                                  accpeted[i]['id'].toString(),
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: MyColors.lightBlue
                                              .withOpacity(0.11)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Image.asset('assets/images/23.png', width: 50,),
                                          CustomCircularImage(
                                              imageUrl: accpeted[i]['user_data']
                                                  ['profile_image']),
                                          hSizedBox,
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: MainHeadingText(
                                                      text:
                                                          '${accpeted[i]['user_data']['first_name']}',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  MainHeadingText(
                                                    text:
                                                        '${accpeted[i]['price']} ZAR',
                                                    fontSize: 15,
                                                  ),
                                                ],
                                              ),
                                              // MainHeadingText(
                                              //   text:
                                              //   'symptoms: ${accpeted[i]['symptoms'] ?? '-'}',
                                              //   overflow: TextOverflow.ellipsis,
                                              //   fontFamily: 'light',
                                              //   fontSize: 14,
                                              // ),
                                              Row(
                                                children: [
                                                  MainHeadingText(
                                                    text:
                                                        '${accpeted[i]['slot_data']['date']}',
                                                    fontSize: 14,
                                                    fontFamily: 'bold',
                                                    color: MyColors.bordercolor,
                                                  ),
                                                  hSizedBox,
                                                  MainHeadingText(
                                                    text:
                                                        '${DateFormat.jm().format(DateFormat('hh:mm').parse(accpeted[i]['slot_data']['start_time']))} - ${DateFormat.jm().format(DateFormat('hh:mm').parse(accpeted[i]['slot_data']['end_time']))}',
                                                    fontSize: 14,
                                                    fontFamily: 'light',
                                                    color: MyColors.bordercolor,
                                                  )
                                                ],
                                              ),
                                              const MainHeadingText(
                                                text: 'Waiting for payment',
                                                fontSize: 10,
                                                color: Colors.green,
                                              ),
                                               Column(
                                                children: [
                                                  vSizedBox2,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                       RoundEdgedButton(
                                                      width: 120,
                                                      height: 40,
                                                      text: 'Cancel',
                                                      color: Colors.red,
                                                      // width: 50,
                                                      // isSolid: false,
                                                      onTap: () async {
                                                       
                                                        bool? result =
                                                            await showCustomConfirmationDialog(
                                                          headingMessage:
                                                              'Are you sure you want to cancel this booking?',
                                                          // description: 'You want to delete'
                                                        );
                                                        if (result == true) {
                                                          EasyLoading.show();
                                                          var data = {
                                                            "booking_id":
                                                                accpeted[
                                                                        i]['id']
                                                                    .toString(),
                                                            "user_id":await getCurrentUserId()
                                                            //  accpeted[i]['user_id']
                                                               
                                                          };
                                                          var res = await Webservices
                                                              .postData(
                                                                  apiUrl: ApiUrls
                                                                      .make_booking_cancel,
                                                                  body: data,
                                                                  context:
                                                                      context);
                                                          EasyLoading.dismiss();
                                                          if (res['status']
                                                                  .toString() ==
                                                              '1') {
                                                            accpeted
                                                                .removeAt(i);
                                                            setState(() {});
                                                          }
                                                        }
                                                      },
                                                    ),
                                                      // RoundEdgedButton(
                                                      //   text: 'Start',
                                                      //   borderRadius: 100,
                                                      //   width: 70,
                                                      //   height: 35,
                                                      //   horizontalPadding: 0,
                                                      //   verticalPadding: 0,
                                                      //   color: Colors
                                                      //       .transparent,
                                                      //   textColor: MyColors
                                                      //       .primaryColor,
                                                      //   bordercolor: MyColors
                                                      //       .primaryColor,
                                                      //   onTap: () async{
                                                      //     showSnackbar( 'Comming Soon.');
                                                      //   },
                                                      // ),
                                                      // hSizedBox,
                                                      // RoundEdgedButton(
                                                      //   text: 'Chat',
                                                      //   borderRadius: 100,
                                                      //   width: 70,
                                                      //   height: 35,
                                                      //   horizontalPadding: 0,
                                                      //   verticalPadding: 0,
                                                      //   color: Colors
                                                      //       .transparent,
                                                      //   textColor: MyColors
                                                      //       .primaryColor,
                                                      //   bordercolor: MyColors
                                                      //       .primaryColor,
                                                      //   onTap: () async{
                                                      //     push(context: context, screen:
                                                      //     ChatPage
                                                      //       (other_user_id: current_user['type'].toString()=='1'?accpeted[i]['user_data']['id'].toString():
                                                      //         accpeted[i]['doctor_data']['id'].toString(),booking_id: accpeted[i]['id'].toString(),));
                                                      //   // showSnackbar( 'Comming Soon.');
                                                      //   },
                                                      // ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (accpeted.isEmpty)
                            const Center(
                              child: Text('No data found.'),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: MyColors.BgColor,
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          for (var i = 0; i < confirms.length; i++)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => bookingdetail(
                                              booking_id:
                                                  confirms[i]['id'].toString(),
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: MyColors.lightBlue
                                              .withOpacity(0.11)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Image.asset('assets/images/23.png', width: 50,),
                                          CustomCircularImage(
                                              imageUrl: confirms[i]['user_data']
                                                  ['profile_image']),
                                          hSizedBox,
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: MainHeadingText(
                                                      text:
                                                          '${confirms[i]['user_data']['first_name']}',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: MainHeadingText(
                                                      text:
                                                          '${confirms[i]['price']} ZAR',
                                                      fontSize: 15,
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              // MainHeadingText(
                                              //   text:
                                              //   'symptoms: ${confirms[i]['symptoms'] ?? '-'}',
                                              //   overflow: TextOverflow.ellipsis,
                                              //   fontFamily: 'light',
                                              //   fontSize: 14,
                                              // ),
                                              Row(
                                                children: [
                                                  MainHeadingText(
                                                    text:
                                                        '${confirms[i]['slot_data']['date']}',
                                                    fontSize: 14,
                                                    fontFamily: 'bold',
                                                    color: MyColors.bordercolor,
                                                  ),
                                                  hSizedBox,
                                                  MainHeadingText(
                                                    text:
                                                        '${DateFormat.jm().format(DateFormat('hh:mm').parse(confirms[i]['slot_data']['start_time']))} - ${DateFormat.jm().format(DateFormat('hh:mm').parse(confirms[i]['slot_data']['end_time']))}',
                                                    fontSize: 14,
                                                    fontFamily: 'light',
                                                    color: MyColors.bordercolor,
                                                  )
                                                ],
                                              ),
                                              // MainHeadingText(text: 'Waiting for payment',fontSize: 10,color: Colors.green,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  vSizedBox2,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      if (confirms[i]['is_join'].toString() == '0' &&
                                                          compare_time(confirms[i]['slot_data']['date'] + ' ' +
                                                                  confirms[i]['slot_data']['start_time']))
                                                        RoundEdgedButton(
                                                          text: 'Start',
                                                          borderRadius: 100,
                                                          width: 70,
                                                          height: 35,
                                                          horizontalPadding:
                                                              0,
                                                          verticalPadding: 0,
                                                          color: Colors
                                                              .transparent,
                                                          textColor: MyColors
                                                              .primaryColor,
                                                          bordercolor: MyColors
                                                              .primaryColor,
                                                          onTap: () async {
                                                            // showSnackbar('sdfsd ${confirms[i]['id']}');
                                                            // return;
                                                            // return;
                                                            push(
                                                                context: context,
                                                                screen: VideoCallScreen(
                                                                  name: confirms[i]['user_data']['first_name'],
                                                                  bookingId: confirms[i]['id'].toString(),
                                                                  userId: confirms[i]['user_data']['id'].toString(),
                                                                ));
                                                            // showSnackbar( 'Comming Soon.');
                                                          },
                                                        ),
                                                      if (confirms[i]['is_join'].toString() == '0' &&
                                                          ismarkascomlete(confirms[i]['slot_data']['date'] + ' ' + confirms[i]['slot_data']
                                                              ['start_time']) == true)
                                                        Expanded(
                                                          child: RoundEdgedButton(
                                                            height: 35,
                                                            text: 'Mark as Complete',
                                                            color: Colors.transparent,
                                                            textColor: MyColors.primaryColor,
                                                            bordercolor: MyColors.primaryColor,
                                                            borderRadius: 100,
                                                            horizontalPadding: 0.0,
                                                            onTap: () async {
                                                              EasyLoading.show(
                                                                  status: null,
                                                                  maskType:
                                                                  EasyLoadingMaskType.black);
                                                              var res = await Webservices.get(ApiUrls .mark_as_complete + confirms[i]['id'].toString());
                                                              print('booking complete   $res');
                                                              await EasyLoading.dismiss();
                                                              get_lists();
                                                            },
                                                          ),
                                                        ),
                                                      hSizedBox,
                                                      RoundEdgedButton(
                                                        text: 'Chat',
                                                        borderRadius: 100,
                                                        width: 70,
                                                        height: 35,
                                                        horizontalPadding: 0,
                                                        verticalPadding: 0,
                                                        color: Colors
                                                            .transparent,
                                                        textColor: MyColors
                                                            .primaryColor,
                                                        bordercolor: MyColors
                                                            .primaryColor,
                                                        onTap: () async {
                                                          push(
                                                              context:
                                                                  context,
                                                              screen:
                                                                  ChatPage(
                                                                other_user_id: current_user['type']
                                                                            .toString() ==
                                                                        '1'
                                                                    ? confirms[i]['user_data']
                                                                            [
                                                                            'id']
                                                                        .toString()
                                                                    : confirms[i]['doctor_data']
                                                                            [
                                                                            'id']
                                                                        .toString(),
                                                                booking_id: confirms[
                                                                            i]
                                                                        ['id']
                                                                    .toString(),
                                                              ));
                                                          // showSnackbar( 'Comming Soon.');
                                                        },
                                                      ),
                                                      hSizedBox,
                                                    ],
                                                  ),
                                                  vSizedBox,
                                                PopupMenuButton<int>(
                                                  clipBehavior: Clip.none,
                                                  itemBuilder: (context) => [
                                                    // PopupMenuItem 1
                                                    const PopupMenuItem(
                                                      value: 1,
                                                      // row with 2 children
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text("Prescription")
                                                        ],
                                                      ),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: 2,
                                                      // row with two children
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text("Sick note")
                                                        ],
                                                      ),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: 3,
                                                      // row with two children
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text("Referral Letter")
                                                        ],
                                                      ),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: 4,
                                                      // row with two children
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text("My Consultation notes")
                                                        ],
                                                      ),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: 5,
                                                      // row with 2 children
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text("Add ICD-10 codes to statement"),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                  offset: const Offset(0, 58),
                                                  color: MyColors.white,
                                                  elevation: 0,
                                                  // on selected we show the dialog box
                                                  onSelected: (value) {
                                                    // if value 1 show dialog
                                                    if (value == 1) {
                                                      push(context: context, screen: Prescriptions_Doctor_Page(
                                                        booking_id: confirms[i]['id'].toString(),
                                                      ));
                                                    } else if (value == 2) {
                                                      log('sfs ${confirms[i]}');
                                                      // return;
                                                      push(context: context, screen: Add_sicknote(
                                                        booking_id: confirms[i]['id'].toString(),
                                                        doctorName: '${confirms[i][
                                                        'user_data']
                                                        [
                                                        'first_name']}',
                                                      ));
                                                    } else if (value == 3) {
                                                      push(
                                                          context: context,
                                                          screen:Referral_Letter_Page(
                                                            booking_id: confirms[i]
                                                            ['id']
                                                                .toString(),
                                                            doctorName: '${confirms[i][
                                                            'user_data']
                                                            [
                                                            'first_name']}',
                                                          ));
                                                    }else if (value == 4) {
                                                      push(
                                                          context: context,
                                                          screen:Consultation_Notes_Page(
                                                            booking_id: confirms[i]
                                                            ['id']
                                                                .toString(),
                                                          ));
                                                    }
                                                    else if (value == 5) {
                                                      print('skjdfkldas ${confirms[i]['user_data']['first_name']}');
                                                      // return;
                                                      push(
                                                          context: context,
                                                          screen:AddIcdNotes(
                                                            booking_id: confirms[i]
                                                            ['id']
                                                                .toString(),
                                                            doctorName: '${confirms[i][
                                                            'user_data']
                                                            [
                                                            'first_name']}',
                                                          ),
                                                      );
                                                    }
                                                  },
                                                  child:Container(
                                                    padding: const EdgeInsets.all(10.0),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: MyColors.primaryColor),
                                                      borderRadius: BorderRadius.circular(20.0),
                                                    ),
                                                    child: const Text('Add Consultation Documents',style: TextStyle(
                                                      color: MyColors.primaryColor
                                                    ),),
                                                  ),
                                                ),
                                                ],
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (confirms.isEmpty)
                            const Center(
                              child: Text('No data found.'),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: MyColors.BgColor,
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var i = 0; i < completeds.length; i++)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => bookingdetail(
                                              booking_id: completeds[i]['id']
                                                  .toString(),
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: MyColors.lightBlue
                                              .withOpacity(0.11)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Image.asset('assets/images/23.png', width: 50,),
                                          CustomCircularImage(
                                              imageUrl: completeds[i]
                                                      ['user_data']
                                                  ['profile_image']),
                                          hSizedBox,
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: MainHeadingText(
                                                      text:
                                                          '${completeds[i]['user_data']['first_name']}',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: MainHeadingText(
                                                      text:
                                                          '${completeds[i]['price']} ZAR',
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  PopupMenuButton<int>(
                                                    itemBuilder: (context) => [
                                                      // PopupMenuItem 1
                                                      const PopupMenuItem(
                                                        value: 1,
                                                        // row with 2 children
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text("Prescription")
                                                          ],
                                                        ),
                                                      ),
                                                      const PopupMenuItem(
                                                        value: 2,
                                                        // row with two children
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text("Sick note")
                                                          ],
                                                        ),
                                                      ),
                                                      const PopupMenuItem(
                                                        value: 3,
                                                        // row with two children
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text("Referral Letter")
                                                          ],
                                                        ),
                                                      ),
                                                      const PopupMenuItem(
                                                        value: 4,
                                                        // row with two children
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text("My Consultation notes")
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                    offset: const Offset(0, 58),
                                                    color: MyColors.white,
                                                    elevation: 0,
                                                    // on selected we show the dialog box
                                                    onSelected: (value) {
                                                      // if value 1 show dialog
                                                      if (value == 1) {
                                                        push(context: context, screen: Prescriptions_Doctor_Page(
                                                          booking_id: completeds[i]['id'].toString(),
                                                        ));
                                                      } else if (value == 2) {
                                                        push(context: context, screen: Add_sicknote(
                                                          booking_id: completeds[i]['id'].toString(),
                                                        ));
                                                      } else if (value == 3) {
                                                        push(
                                                            context: context,
                                                            screen:Referral_Letter_Page(
                                                              booking_id: completeds[i]
                                                              ['id']
                                                                  .toString(),
                                                            ));
                                                      }else if (value == 4) {
                                                        push(
                                                            context: context,
                                                            screen:Consultation_Notes_Page(
                                                              booking_id: completeds[i]
                                                              ['id']
                                                                  .toString(),
                                                            ));
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                              // MainHeadingText(
                                              //   text:
                                              //   'symptoms: ${confirms[i]['symptoms'] ?? '-'}',
                                              //   overflow: TextOverflow.ellipsis,
                                              //   fontFamily: 'light',
                                              //   fontSize: 14,
                                              // ),
                                              Row(
                                                children: [
                                                  MainHeadingText(
                                                    text:
                                                        '${completeds[i]['slot_data']['date']}',
                                                    fontSize: 14,
                                                    fontFamily: 'bold',
                                                    color: MyColors.bordercolor,
                                                  ),
                                                  hSizedBox,
                                                  MainHeadingText(
                                                    text:
                                                        '${DateFormat.jm().format(DateFormat('hh:mm').parse(completeds[i]['slot_data']['start_time']))} - ${DateFormat.jm().format(DateFormat('hh:mm').parse(completeds[i]['slot_data']['end_time']))}',
                                                    fontSize: 14,
                                                    fontFamily: 'light',
                                                    color: MyColors.bordercolor,
                                                  )
                                                ],
                                              ),
                                              vSizedBox2,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  RoundEdgedButton(
                                                    text: 'Rating',
                                                    borderRadius: 100,
                                                    width: 70,
                                                    height: 35,
                                                    horizontalPadding: 0,
                                                    verticalPadding: 0,
                                                    horizontalMargin: 10,
                                                    color: Colors
                                                        .transparent,
                                                    textColor: MyColors
                                                        .primaryColor,
                                                    bordercolor: MyColors
                                                        .primaryColor,
                                                    onTap: () async {
                                                      push(
                                                          context:
                                                          context,
                                                          screen: UserReviewPage(
                                                              booking_id: completeds[i]
                                                              [
                                                              'id']
                                                                  .toString()));
                                                    },
                                                  ),
                                                  RoundEdgedButton(
                                                    text: 'Delete',
                                                    borderRadius: 100,
                                                    width: 70,
                                                    height: 35,
                                                    verticalPadding: 0,
                                                    color: Colors
                                                        .transparent,
                                                    textColor: MyColors
                                                        .primaryColor,
                                                    bordercolor: MyColors
                                                        .primaryColor,
                                                    horizontalPadding: 0,

                                                    verticalMargin: 05,
                                                    onTap: () async {
                                                      Map<String, dynamic> data = {
                                                        'booking_id': completeds[i]['id'],
                                                        'type': '1',
                                                      };
                                                      bool? result= await showCustomConfirmationDialog(
                                                          headingMessage: 'Are you sure you want to delete?',
                                                          // description: 'You want to delete'
                                                      ) ;
                                                      if(result==true){
                                                        setState(() {
                                                          load = true;
                                                        });
                                                        var res = await Webservices.postData(
                                                            apiUrl: ApiUrls.deleteBooking,
                                                            body: data,
                                                            context: context).then((value) => get_lists());
                                                      }
                                                    },
                                                  ),


                                                ],
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (completeds.isEmpty)
                            const Center(
                              child: Text('No data found.'),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: MyColors.BgColor,
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var i = 0; i < rejects.length; i++)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => bookingdetail(
                                              booking_id:
                                                  rejects[i]['id'].toString(),
                                            )));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: MyColors.lightBlue.withOpacity(0.11),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    CustomCircularImage(
                                        imageUrl: rejects[i]['doctor_data']
                                            ['profile_image']),
                                    hSizedBox2,
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: MainHeadingText(
                                                text:
                                                    '${rejects[i]['doctor_data']['first_name']}',
                                                fontSize: 14,
                                              ),
                                            ),
                                            MainHeadingText(
                                              text:
                                                  '${rejects[i]['price']} ZAR',
                                              fontSize: 15,
                                            ),
                                          ],
                                        ),
                                        // MainHeadingText(
                                        //   text:
                                        //   'symptoms: ${rejects[i]['symptoms'] ?? '-'}',
                                        //   overflow: TextOverflow.ellipsis,
                                        //   fontFamily: 'light',
                                        //   fontSize: 14,
                                        // ),
                                        Row(
                                          children: [
                                            MainHeadingText(
                                              text:
                                                  '${rejects[i]['slot_data']['date']}',
                                              fontSize: 14,
                                              fontFamily: 'bold',
                                              color: MyColors.bordercolor,
                                            ),
                                            hSizedBox,
                                            MainHeadingText(
                                              text:
                                                  '${DateFormat.jm().format(DateFormat('hh:mm').parse(rejects[i]['slot_data']['start_time']))} - ${DateFormat.jm().format(DateFormat('hh:mm').parse(rejects[i]['slot_data']['end_time']))}',
                                              fontSize: 14,
                                              fontFamily: 'light',
                                              color: MyColors.bordercolor,
                                            )
                                          ],
                                        ),
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            MainHeadingText(
                                              text:
                                                  'Reason: ${rejects[i]['reject_reason'] ?? '-'}',
                                              fontSize: 10,
                                              color: Colors.green,
                                            ),
                                            RoundEdgedButton(
                                              text: 'Delete',
                                              borderRadius: 100,
                                              width: 70,
                                              height: 25,
                                              verticalPadding: 0,
                                              color: Colors.transparent,
                                              textColor: MyColors.primaryColor,
                                              bordercolor: MyColors.primaryColor,
                                              horizontalPadding: 0,
                                              horizontalMargin: 10,
                                              verticalMargin: 05,
                                              onTap: () async {
                                                Map<String, dynamic> data = {
                                                  'booking_id': rejects[i]['id'],
                                                  'type': '1',
                                                };
                                                bool? result= await showCustomConfirmationDialog(
                                                    headingMessage: 'Are you sure you want to delete?',
                                                    // description: 'You want to delete'
                                                ) ;
                                                if(result==true){
                                                  setState(() {
                                                    load = true;
                                                  });
                                                  var res = await Webservices.postData(
                                                      apiUrl: ApiUrls.deleteBooking,
                                                      body: data,
                                                      context: context).then((value) => get_lists());
                                                }
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          if (rejects.isEmpty)
                            const Center(
                              child: Text('No Data Found.'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  acceptpopup(BuildContext context, String b_id, String s_id, p_id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text(
        "No",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        setState(() {
          Navigator.pop(context);
        });
      },
    );
    Widget continueButton = TextButton(
      child: const Text(
        "Yes",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () async {
        Map<String, dynamic> data = {
          'booking_id': b_id.toString(),
          'specialist_id': await getCurrentUserId(),
          'slot_id': s_id.toString(),
          'paitent_id': p_id.toString(),
        };
        EasyLoading.show(status: null, maskType: EasyLoadingMaskType.black);
        var res = await Webservices.postData(
            apiUrl: ApiUrls.acceptBooking, body: data,);
        print('res--------$res');
        EasyLoading.dismiss();
        if (res['status'].toString() == '1') {
          get_lists();
          _tabcontroller.animateTo(1);
          setState(() {
            Navigator.pop(context);
          });
          showSnackbar( res['message']);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Accept"),
      content: const Text("Are you sure?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _displayTextInputDialog(
      BuildContext context, String b_id, String s_id, String p_id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Reject'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  // valueText = value;
                });
              },
              controller: reason,
              decoration: const InputDecoration(hintText: "Reject Reason..."),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),

              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () async {
                  if (reason.text.isEmpty) {
                    showSnackbar( 'Please Enter Reason.');
                  } else {
                    Map<String, dynamic> data = {
                      'booking_id': b_id.toString(),
                      'specialist_id': await getCurrentUserId(),
                      'slot_id': s_id.toString(),
                      'paitent_id': p_id.toString(),
                      'reject_reason': reason.text,
                    };
                    EasyLoading.show(
                        status: null, maskType: EasyLoadingMaskType.black);
                    var res = await Webservices.postData(
                        apiUrl: ApiUrls.rejectBooking,
                        body: data,
                        );
                    print('res--------$res');
                    EasyLoading.dismiss();
                    if (res['status'].toString() == '1') {
                      reason.text = '';
                      get_lists();
                      setState(() {
                        Navigator.pop(context);
                      });
                      showSnackbar( res['message']);
                    }
                  }
                  // setState(() {
                  //   Navigator.pop(context);
                  // });
                },
              ),

              // RoundEdgedButton(text: 'No', color: MyColors.red,
              //     onTap: () {
              //   setState(() {
              //     Navigator.pop(context);
              //   });
              // }, textColor: MyColors.white),

              // RoundEdgedButton(text: 'Yes', color: MyColors.red,
              //     onTap: () async{
              //   if(reason.text.length==0){
              //     showSnackbar( 'Please Enter Reason.');
              //   } else {
              //     Map<String,dynamic> data = {
              //       'booking_id':b_id.toString(),
              //       'specialist_id':await getCurrentUserId(),
              //       'slot_id':s_id.toString(),
              //       'paitent_id':p_id.toString(),
              //       'reject_reason':reason.text,
              //     };
              //     EasyLoading.show(
              //         status: null,
              //         maskType: EasyLoadingMaskType.black
              //     );
              //     var res = await Webservices.postData(apiUrl: ApiUrls.rejectBooking, body: data, context: context);
              //     print('res--------$res');
              //     EasyLoading.dismiss();
              //     if(res['status'].toString()=='1'){
              //       reason.text='';
              //       get_lists();
              //       setState(() {
              //         Navigator.pop(context);
              //       });
              //       showSnackbar( res['message']);
              //     }
              //   }
              // }, textColor: MyColors.white),
            ],
          );
        });
  }

  compare_time(String date_time) {
    DateTime dt1 = DateTime.parse(date_time);
    DateTime dt2 = DateTime.now();
      Duration d = dt1.difference(dt2);
      print('diffrence&&&&&&&&&& ${d.inMinutes}');
    if (d.inMinutes >= -120 || d.inMinutes >= 120) {
      return true;
    }
      return false;
  }
}
