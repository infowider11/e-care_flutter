// ignore_for_file: deprecated_member_use, avoid_print, prefer_interpolation_to_compose_strings, non_constant_identifier_names, prefer_is_empty

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/global_keys.dart';
import 'package:ecare/constants/navigation.dart';
import 'package:ecare/doctor_module/create_bulk_slot.dart';
import 'package:ecare/doctor_module/create_slot.dart';
import 'package:ecare/doctor_module/notification.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/pages/add_bank_account_page.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../pages/add_icd_notes.dart';
import '../pages/addsick.dart';
import '../pages/chat.dart';
import '../pages/consultation_notes.dart';
import '../pages/messages.dart';
import '../pages/prescriptions_doctor.dart';
import '../pages/referral_letter.dart';
import '../pages/videocall.dart';
import '../services/api_urls.dart';
import '../constants/sized_box.dart';
import '../pages/bookingDetail.dart';
import '../services/auth.dart';
import '../services/webservices.dart';
import '../widgets/custom_circular_image.dart';
import '../widgets/showSnackbar.dart';
import 'package:badges/badges.dart' as badges;


class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({Key? key}) : super(key: key);

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  TextEditingController reason = TextEditingController();
  // Map userData = {};
  List incoming = [];
  List accpeted = [];
  List confirms = [];
  List completeds = [];
  List rejects = [];
  List todays_app = [];

  bool load = false;
  bool load2 = false;
  bool status = false;

  @override
  void initState() {
    
    super.initState();
    get_appointment();
    gettoday_appointment();
    getDetail();
    get_lists();
  }

  get_lists() async {
    // current_user = await getUserDetails();
    setState(() {
      load = true;
    });
    var res = await Webservices.get('${ApiUrls.booking_list}?user_id=' +
        await getCurrentUserId() +
        '&user_type=1');
    print('res-----$res');
    if (res['status'].toString() == '1') {
      // incoming = res['data']['pending'];
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

  get_appointment() async {
    setState(() {
      load = true;
    });
    var res = await Webservices.get('${ApiUrls.booking_list}?user_id=' +
        await getCurrentUserId() +
        '&user_type=1');
    print('res-----$res');
    if (res['status'].toString() == '1') {
      incoming = res['data']['pending'];
      setState(() {});
    }
    setState(() {
      load = false;
    });
  }

  gettoday_appointment() async {
    setState(() {
      load2 = true;
    });
    var res = await Webservices.get('${ApiUrls.today_appointment}?user_id=' +
        await getCurrentUserId() +
        '&user_type=1');
    print('ressdfsdf-----$res');
    if (res['status'].toString() == '1') {
      todays_app = res['data'];
      setState(() {});
    }
    setState(() {
      load2 = false;
    });
  }

  getDetail() async {
    // userData = await getUserDetails();
    var id = await getCurrentUserId();
    var res = await Webservices.get('${ApiUrls.get_user_by_id}?user_id=$id');
    print(' $res');
    if (res['status'].toString() == '1') {
      user_Data = res['data'];
      status = res['data']['call_status'].toString() == '1' ? true : false;
      setState(() {});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFE00A2EA).withOpacity(0.1),
        title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomCircularImage(
                    imageUrl: user_Data!['profile_image'],
                    fileType: CustomFileType.network,
                  ),
                ),
                hSizedBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainHeadingText(
                        text:
                            '${user_Data!['first_name']} ${user_Data!['last_name']}',
                        fontFamily: 'light',
                        fontSize: 15,
                      ),
                      const MainHeadingText(
                        text: 'Welcome Back!',
                        fontFamily: 'light',
                        color: MyColors.primaryColor,
                        fontSize: 12,
                      ),
                    ],
                  ),
                )
              ],
            )),
        actions: <Widget>[
          // Center(
          //     child: Container(
          //         padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          //         decoration: BoxDecoration(
          //             color: Colors.green,
          //             borderRadius: BorderRadius.circular(10)),
          //         child: Row(
          //           children: [
          //             Icon(
          //               Icons.check_circle_outline_rounded,
          //               color: MyColors.white,
          //               size: 16,
          //             ),
          //             hSizedBox05,
          //             MainHeadingText(
          //                 text: 'Verified & Active',
          //                 fontSize: 12,
          //                 color: MyColors.white,
          //                 fontFamily: 'light'),
          //           ],
          //         ))),
        
              badges.Badge(
                position: badges.BadgePosition.topEnd(top:5,end:2),
                showBadge: unread_noti_count!=0?true:false,
                badgeContent: Text('$unread_noti_count',style: const TextStyle(color: Colors.white),),
                child: IconButton(
                  icon: const Icon(Icons.chat),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MessagePage()));
                  },
                ),
              ),
              badges.Badge(
                position: badges.BadgePosition.topEnd(top: 5, end: 2),
                showBadge: unread_noti_count!=0?true:false,
                badgeContent: Text('$unread_noti_count',style: const TextStyle(color: Colors.white),),
                child: IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorNotificationPage()));
                  },
                ),
              ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/patter.png',
            ),
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // vSizedBox05,
              // ParagraphText(
              //   text: 'Learn how it works',
              //   color: MyColors.primaryColor,
              //   fontSize: 14,
              //   underlined: true,
              // ),
              vSizedBox2,
              GestureDetector(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => CreateSlot()));
                  // return;
                  if (user_Data!['is_bank_account_added'].toString() == '1') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const CreateSlot()));
                  } else {
                    // showSnackbar("Please add bank account first");
                    push(context: context, screen: const AddBankAccountPage());
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: MyColors.primaryColor),
                  child: const Center(
                    child: MainHeadingText(
                      text: 'Create/Modify your slots',
                      fontFamily: 'light',
                      color: MyColors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              vSizedBox,
              GestureDetector(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => CreateSlot()));
                  // return;
                  if (user_Data!['is_bank_account_added'].toString() == '1') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CreateBulkSlot(key: MyGlobalKeys.createBulkSlotPage,)));
                  } else {
                    // showSnackbar("Please add bank account first");
                    push(context: context, screen: const AddBankAccountPage());
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: MyColors.primaryColor),
                  child: const Center(
                    child: MainHeadingText(
                      text: 'Generate Multiple Slots',
                      fontFamily: 'light',
                      color: MyColors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              vSizedBox,
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: ParagraphText(
                  textAlign: TextAlign.center,
                  text:
                      'Clients will need you to schedule your available slots before they can provisionally book appointments',
                  fontSize: 12,
                ),
              ),
              vSizedBox4,
              const MainHeadingText(
                text: 'Appointment Request',
                fontSize: 16,
                fontFamily: 'light',
              ),
              const MainHeadingText(
                text:
                    'All appointment requests made between 7:00 AM and 8:00 PM should be accepted within 2 hours of the request. Failure to accept the appointment within this time frame will result in an automatic cancellation of the appointment.'
                        '\nSimilarly, all appointment requests made between 8:00 PM and 7:00 AM should be accepted by 8:00 AM the following day. If not accepted by that time, the appointment will be automatically canceled.',
                fontSize: 12,
                fontFamily: 'light',
                fontWeight: FontWeight.bold,
              ),
              vSizedBox,
              Column(
                children: [
                  for (var i = 0; i < incoming.length; i++)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => bookingdetail(
                                      booking_id: incoming[i]['id'].toString(),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            text: '${incoming[i]['price']} ZAR',
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
                                            color: MyColors.primaryColor,
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
                                                color: Colors.transparent,
                                                textColor:
                                                    MyColors.primaryColor,
                                                bordercolor:
                                                    MyColors.primaryColor,
                                                onTap: () async {
                                                  _displayTextInputDialog(
                                                      context,
                                                      incoming[i]['id']
                                                          .toString(),
                                                      incoming[i]['slot_id']
                                                          .toString(),
                                                      incoming[i]['user_id']
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
                                                      incoming[i]['id']
                                                          .toString(),
                                                      incoming[i]['slot_id']
                                                          .toString(),
                                                      incoming[i]['user_id']
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
                  if (incoming.length == 0 && !load)
                    const Center(
                      heightFactor: 5.0,
                      child: Text('No Appointment Yet.'),
                    ),
                  if (load)
                    const Center(
                      heightFactor: 5.0,
                      child: CustomLoader(
                        color: MyColors.secondarycolor,
                      ),
                    ),
                ],
              ),
              vSizedBox,
              const MainHeadingText(
                text: 'Today\'s Appointments',
                fontSize: 16,
                fontFamily: 'light',
              ),
              const ParagraphText(
                text:
                    'As the healthcare provider, it is your responsibility to initiate the video consultation at the scheduled time.'
                   '\nPlease remember to upload any necessary sick notes or referral letters during the consultation or as soon as possible after the consultation has ended.',
                fontSize: 12,
                fontFamily: 'light',
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              vSizedBox,
              for (int i = 0; i < todays_app.length; i++)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => bookingdetail(
                                  booking_id: todays_app[i]['id'].toString(),
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColors.lightBlue.withOpacity(0.11)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Image.asset('assets/images/23.png', width: 50,),
                              CustomCircularImage(
                                  imageUrl: todays_app[i]['userdata']
                                      ['profile_image']),
                              hSizedBox,
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MainHeadingText(
                                          text:
                                              '${todays_app[i]['userdata']['first_name']}',
                                          fontSize: 14,
                                        ),
                                      ),
                                      Expanded(
                                        child: MainHeadingText(
                                          text: '${todays_app[i]['price']} ZAR',
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
                                          const PopupMenuItem(
                                            value: 5,
                                            // row with two children
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text("Add ICD-10 codes to statement")
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
                                            push(
                                                context: context,
                                                screen:
                                                    Prescriptions_Doctor_Page(
                                                  booking_id: todays_app[i]
                                                          ['id']
                                                      .toString(),
                                                ));
                                          } else if (value == 2) {
                                            push(
                                                context: context,
                                                screen: Add_sicknote(
                                                  booking_id: todays_app[i]
                                                          ['id']
                                                      .toString(),
                                                ));
                                          } else if (value == 3) {
                                            push(
                                                context: context,
                                                screen:
                                                Referral_Letter_Page(
                                                  booking_id: todays_app[i]
                                                  ['id']
                                                      .toString(),
                                                ));
                                          } else if(value==4) {
                                            push(
                                                context: context,
                                                screen:
                                                Consultation_Notes_Page(
                                                  booking_id: todays_app[i]
                                                  ['id']
                                                      .toString(),
                                                ));
                                          }else if (value == 5) {
                                            print('skjdfkldas ${todays_app[i]['user_data']['first_name']}');
                                            // return;
                                            push(
                                              context: context,
                                              screen:AddIcdNotes(
                                                booking_id: todays_app[i]['id'].toString(),
                                                doctorName: '${todays_app[i]['user_data']['first_name']}',
                                              ),
                                            );
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
                                            '${todays_app[i]['slot_data']['date']}',
                                        fontSize: 14,
                                        fontFamily: 'bold',
                                        color: MyColors.bordercolor,
                                      ),
                                      hSizedBox,
                                      MainHeadingText(
                                        text:
                                            '${DateFormat.jm().format(DateFormat('hh:mm').parse(todays_app[i]['slot_data']['start_time']))} - ${DateFormat.jm().format(DateFormat('hh:mm').parse(todays_app[i]['slot_data']['end_time']))}',
                                        fontSize: 14,
                                        fontFamily: 'light',
                                        color: MyColors.bordercolor,
                                      )
                                    ],
                                  ),
                                  // MainHeadingText(text: 'Waiting for payment',fontSize: 10,color: Colors.green,),
                                  Column(
                                    children: [
                                      vSizedBox2,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          if (
                                          // todays_app[i]['is_join']
                                          //     .toString() ==
                                          //     '0' &&
                                          compare_time(todays_app[i]
                                                      ['slot_data']['date'] +
                                                  ' ' +
                                                  todays_app[i]['slot_data']
                                                      ['start_time']) ==
                                              true)
                                            RoundEdgedButton(
                                              text: 'Start',
                                              borderRadius: 100,
                                              width: 70,
                                              height: 35,
                                              horizontalPadding: 0,
                                              verticalPadding: 0,
                                              color: Colors.transparent,
                                              textColor:
                                                  MyColors.primaryColor,
                                              bordercolor:
                                                  MyColors.primaryColor,
                                              onTap: () async {
                                                push(
                                                    context: context,
                                                    screen: VideoCallScreen(
                                                      name: todays_app[i]
                                                              ['userdata']
                                                          ['first_name'],
                                                      bookingId: todays_app[i]
                                                              ['id']
                                                          .toString(),
                                                      userId: todays_app[i]
                                                                  ['userdata']
                                                              ['id']
                                                          .toString(),
                                                    ));
                                                // showSnackbar( 'Comming Soon.');
                                              },
                                            ),
                                          hSizedBox,
                                          RoundEdgedButton(
                                            text: 'Chat',
                                            borderRadius: 100,
                                            width: 70,
                                            height: 35,
                                            horizontalPadding: 0,
                                            verticalPadding: 0,
                                            color: Colors.transparent,
                                            textColor: MyColors.primaryColor,
                                            bordercolor:
                                                MyColors.primaryColor,
                                            onTap: () async {
                                              push(
                                                  context: context,
                                                  screen: ChatPage(
                                                    other_user_id: user_Data![
                                                                    'type']
                                                                .toString() ==
                                                            '1'
                                                        ? todays_app[i][
                                                                    'userdata']
                                                                ['id']
                                                            .toString()
                                                        : todays_app[i][
                                                                    'doctor_data']
                                                                ['id']
                                                            .toString(),
                                                    booking_id: todays_app[i]
                                                            ['id']
                                                        .toString(),
                                                  ));
                                              // showSnackbar( 'Comming Soon.');
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
                        ),
                      ],
                    ),
                  ),
                ),
              if (todays_app.length == 0 && !load2)
                const Center(
                  heightFactor: 5.0,
                  child: Text('No Appointment Yet.'),
                ),
              if (load2)
                const Center(
                  heightFactor: 5.0,
                  child: CustomLoader(
                    color: MyColors.secondarycolor,
                  ),
                ),


              // confirmed booking...
              vSizedBox,
              const MainHeadingText(
                text: 'Confirmed Appointment',
                fontSize: 16,
                fontFamily: 'light',
              ),
              for (int i = 0; i < confirms.length; i++)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => bookingdetail(
                              booking_id: confirms[i]['id'].toString(),
                            )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColors.lightBlue.withOpacity(0.11)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Image.asset('assets/images/23.png', width: 50,),
                              CustomCircularImage(
                                  imageUrl: confirms[i]['user_data']
                                  ['profile_image']),
                              hSizedBox,
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                              text: '${confirms[i]['price']} ZAR',
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
                                                push(
                                                    context: context,
                                                    screen:
                                                    Prescriptions_Doctor_Page(
                                                      booking_id: confirms[i]
                                                      ['id']
                                                          .toString(),
                                                    ));
                                              }
                                              else if (value == 2) {
                                                push(
                                                    context: context,
                                                    screen: Add_sicknote(
                                                      booking_id: confirms[i]
                                                      ['id']
                                                          .toString(),
                                                    ));
                                              } else if (value == 3) {
                                                push(
                                                    context: context,
                                                    screen: Referral_Letter_Page(
                                                      booking_id: confirms[i]
                                                      ['id']
                                                          .toString(),
                                                    ));
                                              } else if(value==4){
                                                push(context: context, screen:
                                                Consultation_Notes_Page(
                                                  booking_id: confirms[i]
                                                  ['id']
                                                      .toString(),
                                                ));
                                              }else if (value == 5) {
                                                push(
                                                    context: context,
                                                    screen:AddIcdNotes(
                                                      booking_id: confirms[i]
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
                                        children: [
                                          vSizedBox2,
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              if (
                                              // todays_app[i]['is_join']
                                              //     .toString() ==
                                              //     '0' &&
                                              compare_time(confirms[i]
                                              ['slot_data']['date'] +
                                                  ' ' +
                                                  confirms[i]['slot_data']
                                                  ['start_time']) ==
                                                  true)
                                                RoundEdgedButton(
                                                  text: 'Start',
                                                  borderRadius: 100,
                                                  width: 70,
                                                  height: 35,
                                                  horizontalPadding: 0,
                                                  verticalPadding: 0,
                                                  color: Colors.transparent,
                                                  textColor:
                                                  MyColors.primaryColor,
                                                  bordercolor:
                                                  MyColors.primaryColor,
                                                  onTap: () async {
                                                    push(
                                                        context: context,
                                                        screen: VideoCallScreen(
                                                          name: confirms[i]
                                                          ['user_data']
                                                          ['first_name'],
                                                          bookingId: confirms[i]
                                                          ['id']
                                                              .toString(),
                                                          userId: confirms[i]
                                                          ['user_data']
                                                          ['id']
                                                              .toString(),
                                                        ));
                                                    // showSnackbar( 'Comming Soon.');
                                                  },
                                                ),
                                              hSizedBox,
                                              RoundEdgedButton(
                                                text: 'Chat',
                                                borderRadius: 100,
                                                width: 70,
                                                height: 35,
                                                horizontalPadding: 0,
                                                verticalPadding: 0,
                                                color: Colors.transparent,
                                                textColor: MyColors.primaryColor,
                                                bordercolor:
                                                MyColors.primaryColor,
                                                onTap: () async {
                                                  push(
                                                      context: context,
                                                      screen: ChatPage(
                                                        other_user_id: user_Data![
                                                        'type']
                                                            .toString() ==
                                                            '1'
                                                            ? confirms[i][
                                                        'user_data']
                                                        ['id']
                                                            .toString()
                                                            : confirms[i][
                                                        'doctor_data']
                                                        ['id']
                                                            .toString(),
                                                        booking_id: confirms[i]
                                                        ['id']
                                                            .toString(),
                                                      ));
                                                  // showSnackbar( 'Comming Soon.');
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
                        ),
                      ],
                    ),
                  ),
                ),
              if (confirms.length == 0 && !load)
                const Center(
                  heightFactor: 5.0,
                  child: Text('No Appointment Yet.'),
                ),
              if (load)
                const Center(
                  heightFactor: 5.0,
                  child: CustomLoader(
                    color: MyColors.secondarycolor,
                  ),
                ),
              vSizedBox2,
              // end confirmed booking...


              // completed booking...
              vSizedBox,
              const MainHeadingText(
                text: 'Completed Appointment',
                fontSize: 16,
                fontFamily: 'light',
              ),
              for (int i = 0; i < completeds.length; i++)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => bookingdetail(
                              booking_id: completeds[i]['id'].toString(),
                            )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColors.lightBlue.withOpacity(0.11)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Image.asset('assets/images/23.png', width: 50,),
                              CustomCircularImage(
                                  imageUrl: completeds[i]['user_data']
                                  ['profile_image']),
                              hSizedBox,
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                              text: '${completeds[i]['price']} ZAR',
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
                                                push(
                                                    context: context,
                                                    screen:
                                                    Prescriptions_Doctor_Page(
                                                      booking_id: completeds[i]
                                                      ['id']
                                                          .toString(),
                                                    ));
                                              } else if (value == 2) {
                                                push(
                                                    context: context,
                                                    screen: Add_sicknote(
                                                      booking_id: completeds[i]
                                                      ['id']
                                                          .toString(),
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
                                      // MainHeadingText(text: 'Waiting for payment',fontSize: 10,color: Colors.green,),
                                      Column(
                                        children: [
                                          vSizedBox2,
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              if (
                                              // todays_app[i]['is_join']
                                              //     .toString() ==
                                              //     '0' &&
                                              compare_time(completeds[i]
                                              ['slot_data']['date'] +
                                                  ' ' +
                                                  completeds[i]['slot_data']
                                                  ['start_time']) ==
                                                  true)
                                              hSizedBox,
                                              RoundEdgedButton(
                                                text: 'Chat',
                                                borderRadius: 100,
                                                width: 70,
                                                height: 35,
                                                horizontalPadding: 0,
                                                verticalPadding: 0,
                                                color: Colors.transparent,
                                                textColor: MyColors.primaryColor,
                                                bordercolor:
                                                MyColors.primaryColor,
                                                onTap: () async {
                                                  push(
                                                      context: context,
                                                      screen: ChatPage(
                                                        other_user_id: user_Data![
                                                        'type']
                                                            .toString() ==
                                                            '1'
                                                            ? completeds[i][
                                                        'user_data']
                                                        ['id']
                                                            .toString()
                                                            : completeds[i][
                                                        'doctor_data']
                                                        ['id']
                                                            .toString(),
                                                        booking_id: completeds[i]
                                                        ['id']
                                                            .toString(),
                                                      ));
                                                  // showSnackbar( 'Comming Soon.');
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
                        ),
                      ],
                    ),
                  ),
                ),
              if (completeds.length == 0 && !load)
                const Center(
                  heightFactor: 5.0,
                  child: Text('No Appointment Yet.'),
                ),
              if (load)
                const Center(
                  heightFactor: 5.0,
                  child: CustomLoader(
                    color: MyColors.secondarycolor,
                  ),
                ),
              vSizedBox4,
              // end confirmed booking...

            ],
          ),
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
            apiUrl: ApiUrls.acceptBooking, body: data, context: context);
        print('res--------$res');
        EasyLoading.dismiss();
        if (res['status'].toString() == '1') {
          get_appointment();
          setState(() {
            Navigator.pop(context);
          });
          showSnackbar(res['message']);
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
                  if (reason.text.length == 0) {
                    showSnackbar('Please Enter Reason.');
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
                        context: context);
                    print('res--------$res');
                    EasyLoading.dismiss();
                    if (res['status'].toString() == '1') {
                      reason.text = '';
                      get_appointment();
                      setState(() {
                        Navigator.pop(context);
                      });
                      showSnackbar(res['message']);
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
    if (d.inMinutes >= -120 || d.inMinutes >= 120) {
      return true;
    }
      return false;
  }
}
