// ignore_for_file: unused_local_variable, unused_element, non_constant_identifier_names, deprecated_member_use, avoid_print

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/navigation.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../constants/global_keys.dart';
import '../dialogs/payment_success_dialog.dart';
import '../pages/chat.dart';
import '../pages/videocall.dart';
import '../services/api_urls.dart';
import '../constants/sized_box.dart';
import '../pages/bookingDetail.dart';
import '../services/auth.dart';
import '../services/log_services.dart';
import '../services/pay_stack/flutter_paystack_services.dart';
import '../services/pay_stack/modals/FlutterPayStackInitializeTransactionResponseModal.dart';
import '../services/pay_stack/payment_page.dart';
import '../services/webservices.dart';
import '../widgets/custom_circular_image.dart';
import '../widgets/customtextfield.dart';
import '../widgets/showSnackbar.dart';
import 'package:badges/badges.dart' as badges;

import 'ErrorLogPage.dart';
import 'messages.dart';
import 'notification.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({Key? key}) : super(key: key);

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  TextEditingController reason = TextEditingController();
  TextEditingController review = TextEditingController();

  // Map userData = {};
  List incoming = [];
  List todays_app = [];
  List confirms = [];
  List completeds = [];
  bool load = false;
  bool load2 = false;
  bool status = false;
  double rating = 0;

  @override
  void initState() {
    
    super.initState();
    get_appointment();
    gettoday_appointment();
    getDetail();
    // get_lists();
  }

  get_appointment() async {
    setState(() {
      load = true;
    });
    var res = await Webservices.get(ApiUrls.booking_list +
        '?user_id=' +
        await getCurrentUserId() +
        '&user_type=2');
    print('res-----$res');
    if (res['status'].toString() == '1') {
      confirms = res['data']['confirmed'];
      completeds = res['data']['completed'];
      incoming = res['data']['accepted'];
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
    var res = await Webservices.get(ApiUrls.today_appointment +
        '?user_id=' +
        await getCurrentUserId() +
        '&user_type=2');
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
    var id = await getCurrentUserId();
    var res = await Webservices.get('${ApiUrls.get_user_by_id}?user_id=${id}');
    print(' $res');
    if (res['status'].toString() == '1') {
      user_Data = res['data'];
      status = res['data']['call_status'].toString() == '1' ? true : false;
      setState(() {});
    }
    setState(() {});
  }


  changeBookingStatus(
      {required String bookingId, required String transactionId}) async {
    PaymentStatus paymentStatus =
    await FlutterPayStackServices.isPaymentSuccessfull(transactionId,
        showLoading: false);
    String message =
        'the payment status for transaction id $transactionId is ${paymentStatus}';
    print(message);
    try {
      CustomLogServices.sendMessageToSentry(message: message);
    } catch (e) {}
    if (paymentStatus == PaymentStatus.success) {
      var request = {
        'booking_id': bookingId,
        'status': '3',
        'is_payment': '1',
      };
      var jsonResponse = await Webservices.postData(
          apiUrl: ApiUrls.change_booking_status, body: request);
    } else if (paymentStatus == PaymentStatus.failed) {
      var request = {
        'booking_id': bookingId,
        'status': '1',
        'is_payment': '0',
      };
      var jsonResponse = await Webservices.postData(
          apiUrl: ApiUrls.change_booking_status, body: request);
    }
  }

  // get_lists() async {
  //   setState(() {
  //     load = true;
  //   });
  //   var res = await Webservices.get(ApiUrls.booking_list +
  //       '?user_id=' +
  //       await getCurrentUserId() +
  //       '&user_type=2');
  //   print('res-----$res');
  //   if (res['status'].toString() == '1') {
  //     confirms = res['data']['confirmed'];
  //     completeds = res['data']['completed'];
  //     setState(() {});
  //   }
  //   setState(() {
  //     load = false;
  //   });
  // }

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
                Column(
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
                )
              ],
            )),
        actions: <Widget>[

          badges.Badge(
            position: badges.BadgePosition.topEnd(top: 5, end: 2),
            showBadge: unread_noti_count!=0?true:false,
            badgeContent: Text('${unread_noti_count}',style: const TextStyle(color: Colors.white),),
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
            badgeStyle: const badges.BadgeStyle(),
            // badgeContent: Text('22',style: TextStyle(color: Colors.white,fontSize: 10),),
            badgeContent: Text('${unread_noti_count}',style: const TextStyle(color: Colors.white,fontSize: 10),),
            child: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()));
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
              vSizedBox05,
              const MainHeadingText(
                text: 'Accepted consultation requests awaiting payment',
                fontSize: 16,
                fontFamily: 'bold',
              ),
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
                                      imageUrl: incoming[i]['doctor_data']
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
                                                  '${incoming[i]['doctor_data']['first_name']}',
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
                                                '${DateFormat('MMM,dd,yyyy').format(DateTime.parse(incoming[i]['slot_data']['date']))}',
                                            fontSize: 14,
                                            fontFamily: 'bold',
                                            color: MyColors.primaryColor,
                                          ),
                                          hSizedBox05,
                                          MainHeadingText(
                                            text:
                                                '${DateFormat.jm().format(DateFormat('hh:mm').parse(incoming[i]['slot_data']['start_time']))} - ${DateFormat.jm().format(DateFormat('hh:mm').parse(incoming[i]['slot_data']['end_time']))}',
                                            fontSize: 14,
                                            fontFamily: 'bold',
                                            color: MyColors.primaryColor,
                                          )
                                        ],
                                      ),
                                      Container(
                                        child: Column(
                                          children: [
                                            vSizedBox2,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                            if (incoming[i]['is_payment'] ==
                                              '2')
                                              RoundEdgedButton(
                                                text: 'Payment Processing',
                                                // text: 'Payment is under process.',
                                                color: Colors.orangeAccent,
                                                verticalPadding: 4,
                                                height: 40,
                                                width: 210,
                                                onTap: () async {
                                                  // setState(() {
                                                  //   load = true;
                                                  // });
                                                  //
                                                  changeBookingStatus(bookingId: incoming[i]['id'], transactionId: incoming[i]['transaction_id']);
                                                  get_appointment();
                                                },
                                              )
                                                else
                                                RoundEdgedButton(
                                                  text: 'Pay Now',
                                                  borderRadius: 100,
                                                  width: 70,
                                                  height: 35,
                                                  horizontalPadding: 0,
                                                  verticalPadding: 0,
                                                  color:MyColors.green,
                                                  textColor:
                                                      MyColors.white,
                                                  bordercolor:Colors.transparent,
                                                  onTap: () async {
                                                    await payment_popup(
                                                      incoming[i]['id']
                                                          .toString(),
                                                      double.parse(incoming[i]
                                                                  ['price']
                                                              .toString())
                                                          .toInt(),
                                                      doctorData: incoming[i]
                                                          ['doctor_data'],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
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
                fontFamily: 'bold',
              ),
              for (int i = 0; i < todays_app.length; i++)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => bookingdetail(
                                  booking_id: todays_app[i]['id'].toString(),
                                )));
                    // Navigator.push(context, bookingdetail());
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: MyColors.surface3,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCircularImage(
                            imageUrl: todays_app[i]['doctor_data']
                                ['profile_image']),
                        hSizedBox,
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MainHeadingText(
                                      text:
                                          '${todays_app[i]['doctor_data']['first_name']}',
                                      fontSize: 16,
                                      color: MyColors.labelcolor,
                                    ),
                                  ],
                                )),
                                MainHeadingText(
                                  text: '${todays_app[i]['price']} ZAR',
                                  fontSize: 18,
                                ),
                              ],
                            ),
                            vSizedBox05,
                            Row(
                              children: [
                                Expanded(
                                    flex: 8,
                                    child: Row(
                                      children: [
                                        MainHeadingText(
                                          text:
                                              '${todays_app[i]['slot_data']['date']}',
                                          fontSize: 11,
                                          fontFamily: 'semibold',
                                          color: MyColors.labelcolor,
                                        ),
                                        hSizedBox05,
                                        MainHeadingText(
                                          text:
                                              '${DateFormat.jm().format(DateFormat('hh:mm').parse(todays_app[i]['slot_data']['start_time']))} - ${DateFormat.jm().format(DateFormat('hh:mm').parse(todays_app[i]['slot_data']['end_time']))}',
                                          fontSize: 11,
                                          fontFamily: 'medium',
                                          color: MyColors.primaryColor,
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  // flex: 4,
                                  child: RoundEdgedButton(
                                    // width: 80,
                                    //height: 50,
                                    horizontalPadding: 0.0,
                                    text: 'Chat',
                                    // width: 50,
                                    isSolid: false,
                                    onTap: () {
                                      push(
                                          context: context,
                                          screen: ChatPage(
                                            other_user_id:
                                                user_Data!['type'].toString() ==
                                                        '1'
                                                    ? todays_app[i]['user_data']
                                                            ['id']
                                                        .toString()
                                                    : todays_app[i]['doctor_data']
                                                            ['id']
                                                        .toString(),
                                            booking_id:
                                            todays_app[i]['id'].toString(),
                                          ));
                                    },
                                  ),
                                ),
                                hSizedBox,
                                if (compare_time(todays_app[i]['slot_data']
                                                ['date'] +
                                            ' ' +
                                        todays_app[i]['slot_data']
                                                ['start_time']) ==
                                        true)
                                  Expanded(
                                    // flex: 4,
                                    child: RoundEdgedButton(
                                      // width: 100,
                                      // height: 10,
                                      text: 'Join',
                                      horizontalPadding: 0.0,
                                      // width: 50,
                                      isSolid: false,
                                      onTap: () async {
                                        var res = await Webservices.get(
                                            ApiUrls.PickCall +
                                                todays_app[i]['id'].toString());
                                        print('pickup call-----$res');
                                        push(
                                            context: context,
                                            screen: VideoCallScreen(
                                              name: todays_app[i]['doctor_data']
                                                  ['first_name'],
                                              bookingId:
                                              todays_app[i]['id'].toString(),
                                              userId: todays_app[i]['doctor_data']
                                                      ['id']
                                                  .toString(),
                                            ));
                                      },
                                    ),
                                  ),
                                hSizedBox,
                              ],
                            )
                          ],
                        )),
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
              // vSizedBox,
              // AppointmentBlock(
              //   bgColor: MyColors.white,
              // ),
              vSizedBox,

              // confirmed appoinemt
              vSizedBox,
              const MainHeadingText(
                text: 'Confirmed Appointments',
                fontSize: 16,
                fontFamily: 'bold',
              ),
              for (var i = 0; i < 1; i++)
                if (confirms.length != 0)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => bookingdetail(
                                    booking_id: confirms[i]['id'].toString(),
                                  )));
                      // Navigator.push(context, bookingdetail());
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: MyColors.surface3,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomCircularImage(
                              imageUrl: confirms[i]['doctor_data']
                                  ['profile_image']),
                          hSizedBox,
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MainHeadingText(
                                        text:
                                            '${confirms[i]['doctor_data']['first_name']}',
                                        fontSize: 16,
                                        color: MyColors.labelcolor,
                                      ),
                                      // MainHeadingText(
                                      //   text:
                                      //   'symptoms: ${accpeted[i]['symptoms'] ?? '-'}',
                                      //   // overflow: TextOverflow.ellipsis,
                                      //   fontFamily: 'light',
                                      //   fontSize: 13,
                                      //   height: 1,
                                      //   color: MyColors.labelcolor,
                                      //   overflow: TextOverflow.ellipsis,
                                      // ),
                                    ],
                                  )),
                                  MainHeadingText(
                                    text: '${confirms[i]['price']} ZAR',
                                    fontSize: 18,
                                  ),
                                ],
                              ),
                              vSizedBox05,
                              Row(
                                children: [
                                  Expanded(
                                      flex: 8,
                                      child: Row(
                                        children: [
                                          MainHeadingText(
                                            text:
                                                '${confirms[i]['slot_data']['date']}',
                                            fontSize: 11,
                                            fontFamily: 'semibold',
                                            color: MyColors.labelcolor,
                                          ),
                                          hSizedBox05,
                                          MainHeadingText(
                                            text:
                                                '${DateFormat.jm().format(DateFormat('hh:mm').parse(confirms[i]['slot_data']['start_time']))} - ${DateFormat.jm().format(DateFormat('hh:mm').parse(confirms[i]['slot_data']['end_time']))}',
                                            fontSize: 11,
                                            fontFamily: 'medium',
                                            color: MyColors.primaryColor,
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    // flex: 4,
                                    child: RoundEdgedButton(
                                      // width: 80,
                                      //height: 50,
                                      horizontalPadding: 0.0,
                                      text: 'Chat',
                                      // width: 50,
                                      isSolid: false,
                                      onTap: () {
                                        push(
                                            context: context,
                                            screen: ChatPage(
                                              other_user_id: user_Data!['type']
                                                          .toString() ==
                                                      '1'
                                                  ? confirms[i]['user_data']
                                                          ['id']
                                                      .toString()
                                                  : confirms[i]['doctor_data']
                                                          ['id']
                                                      .toString(),
                                              booking_id:
                                                  confirms[i]['id'].toString(),
                                            ));
                                      },
                                    ),
                                  ),
                                  hSizedBox,
                                  if (confirms[i]['is_join'].toString() ==
                                          '0' &&
                                      compare_time(confirms[i]['slot_data']
                                                  ['date'] +
                                              ' ' +
                                              confirms[i]['slot_data']
                                                  ['start_time']) ==
                                          true)
                                    Expanded(
                                      // flex: 4,
                                      child: RoundEdgedButton(
                                        // width: 100,
                                        // height: 10,
                                        text: 'Join',
                                        horizontalPadding: 0.0,
                                        // width: 50,
                                        isSolid: false,
                                        onTap: () async {
                                          var res = await Webservices.get(
                                              ApiUrls.PickCall +
                                                  confirms[i]['id'].toString());
                                          print('pickup call-----$res');
                                          push(
                                              context: context,
                                              screen: VideoCallScreen(
                                                name: confirms[i]['doctor_data']
                                                    ['first_name'],
                                                bookingId: confirms[i]['id']
                                                    .toString(),
                                                userId: confirms[i]
                                                        ['doctor_data']['id']
                                                    .toString(),
                                              ));
                                        },
                                      ),
                                    ),

                                  // hSizedBox,
                                  // Expanded(
                                  //   // flex: 4,
                                  //   child: RoundEdgedButton(
                                  //     // width: 100,
                                  //     // height: 10,
                                  //     text: 'Cancel',
                                  //     // width: 50,
                                  //     isSolid: false,
                                  //     horizontalPadding: 0.0,
                                  //     onTap: () async {
                                  //       showDialog(
                                  //           context: context,
                                  //           builder: (context1) {
                                  //             return AlertDialog(
                                  //               title: Text(
                                  //                 'Cancel Booking',
                                  //                 style: TextStyle(
                                  //                     color: Colors.red),
                                  //               ),
                                  //               content: Text(
                                  //                   'Please note that by cancelling, you will be charged a cancellation fee. The cancellation fee will be calculated as 10% of your consultation fee. We will refund the remainder (90% of your consultation fee) to you within 7 to 14 days.'),
                                  //               actions: [
                                  //                 TextButton(
                                  //                     onPressed: () async {
                                  //                       Map<String, dynamic>
                                  //                           data = {
                                  //                         'booking_id':
                                  //                             confirms[i]['id']
                                  //                                 .toString(),
                                  //                         'paitent_id':
                                  //                             await getCurrentUserId(),
                                  //                       };
                                  //                       EasyLoading.show(
                                  //                           status: null,
                                  //                           maskType:
                                  //                               EasyLoadingMaskType
                                  //                                   .black);
                                  //                       var res = await Webservices
                                  //                           .postData(
                                  //                               apiUrl: ApiUrls
                                  //                                   .booking_cancel,
                                  //                               body: data,
                                  //                               context:
                                  //                                   context);
                                  //                       print(
                                  //                           'pickup call-----$res');
                                  //                       await EasyLoading
                                  //                           .dismiss();
                                  //                       if (res['status']
                                  //                               .toString() ==
                                  //                           '1') {
                                  //                         showSnackbar(
                                  //                             res['message']);
                                  //                         get_appointment();
                                  //                         Navigator.pop(
                                  //                             context);
                                  //                       }
                                  //                     },
                                  //                     child: Text(
                                  //                       'Confirm',
                                  //                       style: TextStyle(
                                  //                           color: Colors.red),
                                  //                     )),
                                  //                 TextButton(
                                  //                     onPressed: () async {
                                  //                       Navigator.pop(context1);
                                  //                     },
                                  //                     child: Text('cancel')),
                                  //               ],
                                  //             );
                                  //           });
                                  //     },
                                  //   ),
                                  // ),

                                ],
                              ),
                              Column(
                                children: [
                                  vSizedBox,
                                  if(confirms[i]['is_refund_request'].toString()=='0')
                                    RoundEdgedButton(
                                      height: 60.0,
                                      text: 'Request a refund and cancel your booking',
                                      isSolid: false,
                                      onTap: () async{
                                        ask_a_refund(context,confirms[i]['id'].toString());
                                      },
                                    ),

                                  if(confirms[i]['is_refund_request'].toString()=='1')
                                    RoundEdgedButton(
                                      text: 'Pending Refund',
                                      color: Colors.red,
                                      onTap: () async{

                                      },
                                    ),

                                  if(confirms[i]['is_refund_request'].toString()=='2')
                                    RoundEdgedButton(
                                      text: 'Refunded',
                                      color: Colors.green,
                                      onTap: () async{

                                      },
                                    )
                                ],
                              )
                            ],
                          )),
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
              vSizedBox,

              // MainHeadingText(
              //   text: 'Completed Appointment',
              //   fontSize: 16,
              //   fontFamily: 'bold',
              // ),
              // for (var i = 0; i < 1; i++)
              //   if (completeds.length != 0)
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => bookingdetail(
              //                       booking_id: completeds[i]['id'].toString(),
              //                     )));
              //         // Navigator.push(context, bookingdetail());
              //       },
              //       child: Container(
              //         margin: EdgeInsets.only(bottom: 10),
              //         padding: EdgeInsets.all(10),
              //         decoration: BoxDecoration(
              //           color: MyColors.surface3,
              //           borderRadius: BorderRadius.circular(15),
              //         ),
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             CustomCircularImage(
              //                 imageUrl: completeds[i]['doctor_data']
              //                     ['profile_image']),
              //             hSizedBox,
              //             Expanded(
              //                 child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Row(
              //                   children: [
              //                     Expanded(
              //                         child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: [
              //                         MainHeadingText(
              //                           text:
              //                               '${completeds[i]['doctor_data']['first_name']}',
              //                           fontSize: 16,
              //                           color: MyColors.labelcolor,
              //                         ),
              //                         // MainHeadingText(
              //                         //   text:
              //                         //   'symptoms: ${accpeted[i]['symptoms'] ?? '-'}',
              //                         //   // overflow: TextOverflow.ellipsis,
              //                         //   fontFamily: 'light',
              //                         //   fontSize: 13,
              //                         //   height: 1,
              //                         //   color: MyColors.labelcolor,
              //                         //   overflow: TextOverflow.ellipsis,
              //                         // ),
              //                       ],
              //                     )),
              //                     MainHeadingText(
              //                       text: '${completeds[i]['price']} ZAR',
              //                       fontSize: 18,
              //                     ),
              //                   ],
              //                 ),
              //                 vSizedBox05,
              //                 Row(
              //                   children: [
              //                     Expanded(
              //                         flex: 8,
              //                         child: Row(
              //                           children: [
              //                             MainHeadingText(
              //                               text:
              //                                   '${completeds[i]['slot_data']['date']}',
              //                               fontSize: 11,
              //                               fontFamily: 'semibold',
              //                               color: MyColors.labelcolor,
              //                             ),
              //                             hSizedBox05,
              //                             MainHeadingText(
              //                               text:
              //                                   '${DateFormat.jm().format(DateFormat('hh:mm').parse(completeds[i]['slot_data']['start_time']))} - ${DateFormat.jm().format(DateFormat('hh:mm').parse(completeds[i]['slot_data']['end_time']))}',
              //                               fontSize: 11,
              //                               fontFamily: 'medium',
              //                               color: MyColors.primaryColor,
              //                             ),
              //                           ],
              //                         )),
              //                   ],
              //                 ),
              //                 if (completeds[i]['rate'].toString() == '0')
              //                   Row(
              //                     children: [
              //                       RoundEdgedButton(
              //                         width: 100,
              //                         // height: 10,
              //                         text: 'Rate',
              //                         // width: 50,
              //                         isSolid: false,
              //                         onTap: () async {
              //                           rating_sheet(
              //                               completeds[i]['id'].toString());
              //                         },
              //                       ),
              //                     ],
              //                   ),
              //                 Column(
              //                   children: [
              //                     vSizedBox,
              //                     if(completeds[i]['is_refund_request'].toString()=='0')
              //                       RoundEdgedButton(
              //                         text: 'Ask a Refund',
              //                         isSolid: false,
              //                         onTap: () async{
              //                           ask_a_refund(context,completeds[i]['id'].toString());
              //                         },
              //                       ),
              //
              //                     if(completeds[i]['is_refund_request'].toString()=='1')
              //                       RoundEdgedButton(
              //                         text: 'Pending Refund',
              //                         color: Colors.red,
              //                         onTap: () async{
              //
              //                         },
              //                       ),
              //
              //                     if(completeds[i]['is_refund_request'].toString()=='2')
              //                       RoundEdgedButton(
              //                         text: 'Refunded',
              //                         color: Colors.green,
              //                         onTap: () async{
              //
              //                         },
              //                       )
              //                   ],
              //                 ),
              //               ],
              //             )),
              //           ],
              //         ),
              //       ),
              //     ),
              // if (completeds.length == 0 && !load)
              //   Center(
              //     heightFactor: 5.0,
              //     child: Text('No Appointment Yet.'),
              //   ),
              // if (load)
              //   Center(
              //     heightFactor: 5.0,
              //     child: CustomLoader(
              //       color: MyColors.secondarycolor,
              //     ),
              //   ),

            ],
          ),
        ),
      ),
    );
  }

  rating_sheet(String booking_id) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height / 1.9,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: const BoxDecoration(
                color: Color(0xFFF1F4F8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                )),
            child: load2
                ? const CustomLoader()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image.asset(
                      //   MyImages.ratings,
                      //   height: 126,
                      //   fit: BoxFit.fitHeight,
                      // ),
                      vSizedBox,
                      const headingText(
                        text: 'Your Opinion matters to us!',
                        fontSize: 18,
                        fontFamily: 'medium',
                      ),
                      py4,
                      const ParagraphText(
                        text: 'Give us a quick review and help us improve?',
                        fontSize: 17,
                        color: MyColors.textcolor,
                      ),
                      vSizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBar.builder(
                            initialRating: rating, //rating!,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rate) {
                              print('rating------$rate');
                              rating = rate;
                              setState(() {});
                            },
                          ),
                        ],
                      ),

                      vSizedBox,
                      CustomTextField(
                        controller: review,
                        hintText: 'Review..',
                        maxLines: 3,
                      ),

                      vSizedBox2,
                      RoundEdgedButton(
                        text: 'Rate Now',
                        fontSize: 18,
                        textColor: Colors.white,
                        color: MyColors.primaryColor,
                        letterspace: 1,
                        onTap: () async {
                          // Navigator.pop(context);
                          if (rating == 0) {
                            showSnackbar('Please add rate.');
                          } else if (review.text == '') {
                            showSnackbar('Please add review.');
                          } else {
                            setState(() {
                              load2 = true;
                            });
                            // if(load==true)
                            //   CustomLoader();
                            print('rate now----');
                            Map<String, dynamic> data = {
                              'user_id': await getCurrentUserId(),
                              'booking_id': booking_id.toString(),
                              'rate': rating.toString(),
                              'msg': review.text,
                            };
                            var res = await Webservices.postData(
                                apiUrl: ApiUrls.rating,
                                body: data,
                                context: context);
                            print('rate----$res');
                            setState(() {
                              load2 = false;
                            });
                            if (res['status'].toString() == '1') {
                              rating = 0;
                              review.text = '';
                              get_appointment();
                              setState(() {});
                              Navigator.of(context).pop();
                              // showSnackbar('Rated Successfully.');
                            }
                          }
                        },
                      ),
                      vSizedBox,
                      TextButton(
                          onPressed: () {
                            rating = 0;
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const ParagraphText(
                            text: 'Not Now',
                            color: MyColors.primaryColor,
                            underlined: true,
                            fontFamily: 'medium',
                            fontSize: 18,
                          ))
                    ],
                  ));
      },
    );
  }

  Future<void> payment_popup(String booking_id, int amount,
      {required Map doctorData}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.end,
          buttonPadding: const EdgeInsets.all(0),
          title: const Text(
            'Make Payment',
            style: TextStyle(fontSize: 20),
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Are you sure?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                //TODO: commented to check
                Navigator.pop(context);


                FlutterPayStackInitializeTransactionResponseModal?
                    paystackInitiateTransactionResponse =
                    await FlutterPayStackServices.initializeTransaction(
                        email: user_Data!['email'],
                        amount: (amount * 100)
                            .toString(), //the money should be in kobo hence the need to multiply the value by 100
                        subAccountCode: doctorData['bank_details']
                            ['subaccount_code']);

                if (paystackInitiateTransactionResponse != null) {

                  // Map<String, dynamic> data = {
                  //   'user_id': await getCurrentUserId(),
                  //   'booking_id': booking_id.toString(),
                  //   'transaction_id': paystackInitiateTransactionResponse
                  //       .reference
                  //       .toString(), //'123456',
                  //   'status':paymentIsSuccess==PaymentStatus.ongoing?'1': '3',
                  //   'payment_status': PaymentStatus.ongoing.name,
                  // };
                  //
                  // var res = await Webservices.postData(
                  //     apiUrl: ApiUrls.FinalBooking,
                  //     body: data,
                  //     context: MyGlobalKeys.navigatorKey.currentContext!);
                  bool? success = await push(
                      context: MyGlobalKeys.navigatorKey.currentContext!,
                      screen: PayStackPaymentPage(
                        paymentUrl: paystackInitiateTransactionResponse
                            .authorization_url,
                      ));

                  print('payment status $success');
                  // return;


                  // bool paymentIsSuccess =await FlutterPayStackServices.isPaymentSuccessfull(paystackInitiateTransactionResponse.reference);


                  PaymentStatus paymentIsSuccess =await FlutterPayStackServices.isPaymentSuccessfull(paystackInitiateTransactionResponse.reference);
                  CustomLogServices.sendMessageToSentry(message: 'The navigation request: $success, api response : ${paymentIsSuccess.name}', sentryLevel: SentryLevel.info);
                  if(success==true || paymentIsSuccess!=PaymentStatus.failed){
                    Map<String, dynamic> data = {
                      'user_id': await getCurrentUserId(),
                      'booking_id': booking_id.toString(),
                      'transaction_id': paystackInitiateTransactionResponse
                          .reference
                          .toString(), //'123456',
                      'status':paymentIsSuccess==PaymentStatus.ongoing?'1': '3',
                      'payment_status': PaymentStatus.ongoing.name,
                    };
                    await EasyLoading.show(
                      status: null,
                      maskType: EasyLoadingMaskType.black,
                    );
                    var res = await Webservices.postData(
                        apiUrl: ApiUrls.FinalBooking,
                        body: data,
                        context: MyGlobalKeys.navigatorKey.currentContext!);
                    EasyLoading.dismiss();
                    print('booking------$res');
                    if (res['status'].toString() == '1') {
                      get_appointment();
                      gettoday_appointment();
                      await paymentsuccesspopup(
                          MyGlobalKeys.navigatorKey.currentContext!, paymentIsSuccess);
                    } else {
                      showSnackbar('Payment Failed!!!');
                    }
                  } else {
                    push(context: MyGlobalKeys.navigatorKey.currentContext!, screen: const ErrorLogPage());
                    showSnackbar('Something went wrong, please try again later.');
                  }
                }

                // print('Confirmed');
                // var charge = Charge()
                //   ..amount =
                //       amount * 100 //the money should be in kobo hence the need to multiply the value by 100
                //   ..reference = _getReference()
                //   ..currency = 'ZAR'
                //   // ..putCustomField('custom_id',
                //   //     '846gey6w') //to pass extra parameters to be retrieved on the response from Paystack
                //   ..email = 'sulaymaankajee.sk@gmail.com';
                // CheckoutResponse response = await plugin.checkout(
                //   context,
                //   method: CheckoutMethod.card,
                //   charge: charge,
                // );
                // print('payment success------ ${response}');
                // if (response.status == true) {
                //   showSnackbar( 'Payment was successful!!!');
                //   print('reference----- ${response.reference}');
                //   Map<String, dynamic> data = {
                //     'user_id': await getCurrentUserId(),
                //     'booking_id': booking_id.toString(),
                //     'transaction_id': response.reference.toString(), //'123456',
                //     'status': '3',
                //   };
                //   await EasyLoading.show(
                //     status: null,
                //     maskType: EasyLoadingMaskType.black,
                //   );
                //   var res = await Webservices.postData(
                //       apiUrl: ApiUrls.FinalBooking,
                //       body: data,
                //       context: context);
                //   EasyLoading.dismiss();
                //   print('booking------$res');
                //   if (res['status'].toString() == '1') {
                //     get_lists();
                //     // Navigator.pop(context);
                //     // setState(() {
                //     //
                //     // });
                //     await paymentsuccesspopup(context);
                //   } else {
                //     showSnackbar( 'Payment Failed!!!');
                //   }
                // }
                // // Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // paymentsuccesspopup(BuildContext context) {
  //   // set up the buttons
  //   Widget continueButton = TextButton(
  //     child: Text("Continue"),
  //     onPressed: () async {
  //       Navigator.pop(context);
  //       Navigator.popUntil(context, (route) => route.isFirst);
  //       setState(() {});
  //       // pushAndPopAll(
  //       //     context: context,
  //       //     screen: tabs_second_page(
  //       //       selectedIndex: 0,
  //       //     ));
  //     },
  //   );
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text(
  //       "Booking finalized",
  //       style: TextStyle(color: Colors.green),
  //     ),
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(
  //             'If your consultation does not take place due to your healthcare provider\'s failure to initiate the call, please contact us via the app or email admin@e-care.co.za within 24 hours of the appointment. We will investigate the issue further, and if appropriate, issue you a refund.'),
  //         // Text('Once approved by your healthcare provider, you will be directed to make a payment to finalize your booking.'),
  //       ],
  //     ),
  //     actions: [
  //       continueButton,
  //     ],
  //   );
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

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

  ask_a_refund(BuildContext context,String booking_id) {
    Widget YesButton = TextButton(
      child: const Text("Yes"),
      onPressed: () async {
        Map<String,dynamic> data = {
          'user_id':await getCurrentUserId(),
          'paitent_id':await getCurrentUserId(),
          'booking_id':booking_id.toString(),
        };
        EasyLoading.show(
            status: null,
            maskType: EasyLoadingMaskType.black
        );
        var res = await Webservices.postData(apiUrl:ApiUrls.booking_cancel,body:data);
        EasyLoading.dismiss();
        Navigator.pop(context);
        print(res);
        get_appointment();
        setState(() {});
      },
    );

    Widget NoButton = TextButton(
      child: const Text("No"),
      onPressed: () async {
        Navigator.pop(context);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      title: const Text(
        '',
        //"Request a refund and cancel your booking",
        style: TextStyle(color: Colors.green,fontSize: 14.0),
      ),
      content: const Padding(
        padding: EdgeInsets.only(left: 23.0),
        child: Text('Are you sure you would like to cancel your booking and request a refund?'
            '\nPlease note that all cancellations made 24 hours prior to the scheduled consultation will be refunded in full. Unfortunately, cancellations made within 24 hours of your scheduled consultation will not be refunded.'),
      ),
      actions: [
        YesButton,
        NoButton,
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

}
