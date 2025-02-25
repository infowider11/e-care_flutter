// ignore_for_file: unused_local_variable, unused_element, deprecated_member_use, avoid_print

import 'dart:developer';

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/global_keys.dart';
import 'package:ecare/constants/navigation.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/pages/videocall.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/log_services.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/custom_circular_image.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../dialogs/payment_success_dialog.dart';
import '../services/api_urls.dart';
import '../services/pay_stack/flutter_paystack_services.dart';
import '../services/pay_stack/modals/FlutterPayStackInitializeTransactionResponseModal.dart';
import '../services/pay_stack/payment_page.dart';
import '../widgets/custom_confirmation_dialog.dart';
import 'bookingDetail.dart';
import 'chat.dart';

import 'dart:async';
import 'dart:io';
// import 'package:flutter_paystack/flutter_paystack.dart';

class BookedVisit extends StatefulWidget {
  const BookedVisit({Key? key}) : super(key: key);

  @override
  State<BookedVisit> createState() => _BookedVisitState();
}

class _BookedVisitState extends State<BookedVisit>
    with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  TextEditingController review = TextEditingController();
  late TabController _tabController;
ValueNotifier<bool> callStatusLoad=ValueNotifier(false);
  String paystackPublicKey =
      'pk_test_c9873b01e7f63337f4e6818c1bf64b9b834566a1'; // test public key
  
  // final plugin = PaystackPlugin();

  bool load = false;
  bool load2 = false;
  List pending = [];
  List acceptedBookings = [];
  List confirms = [];
  List completeds = [];
  List rejects = [];
  Map current_user = {};
  double rating = 0;

  double getPrice(String price) {
    // double amount = (100 * (double.parse(price) + 1)) / 97.1;
    double amount = (double.parse(price));
    return amount;
  }

  TabBar get _tabBar => TabBar(
        automaticIndicatorColorAdjustment: false,
        enableFeedback: false,
        controller: _tabController,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 0),
        tabs: const <Widget>[
          Tab(
            child: MainHeadingText(
              text: 'Pending',
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

  @override
  void initState() {
    
   
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {});
      print('controll----');
    });

    get_lists(shouldCheckAcceptedBookingStatus: true);
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  // chargeCard(String? email) async {
  //   var charge = Charge()
  //     ..amount =
  //         10000 //the money should be in kobo hence the need to multiply the value by 100
  //     ..reference = _getReference()
  //     ..currency = 'ZAR'
  //     // ..putCustomField('custom_id',
  //     //     '846gey6w') //to pass extra parameters to be retrieved on the response from Paystack
  //     ..email = email ?? 'sulaymaankajee.sk@gmail.com';
  //   CheckoutResponse response = await plugin.checkout(
  //     context,
  //     method: CheckoutMethod.card,
  //     charge: charge,
  //   );
  //   print('payment success------ ${response}');
  //   if (response.status == true) {
  //     showSnackbar( 'Payment was successful!!!');
  //     print('reference----- ${response.reference}');
  //     return response.reference;
  //   } else {
  //     showSnackbar( 'Payment Failed!!!');
  //     return null;
  //   }
  // }

  get_lists({bool shouldCheckAcceptedBookingStatus = false}) async {
    current_user = await getUserDetails();
    setState(() {
      load = true;
    });
    var res = await Webservices.get(ApiUrls.booking_list +
        '?user_id=' +
        await getCurrentUserId() +
        '&user_type=2');
    log('res----dd-$res');
    if (res['status'].toString() == '1') {
      pending = res['data']['pending'];
      acceptedBookings = res['data']['accepted'];
      confirms = res['data']['confirmed'];
      completeds = res['data']['completed'];
      rejects = res['data']['rejected'];
      setState(() {});
    }
    if (shouldCheckAcceptedBookingStatus) {
      checkAcceptedBookingsStatus();
    }
    setState(() {
      load = false;
    });
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

  checkAcceptedBookingsStatus() async {
    log('the accepted bookings are ${acceptedBookings}');
    for (int i = 0; i < acceptedBookings.length; i++) {
      if (acceptedBookings[i]['is_payment'] == '2') {
        print('${acceptedBookings[i]['id']} payment is on hold');
        await changeBookingStatus(
            transactionId: acceptedBookings[i]['transaction_id'],
            bookingId: acceptedBookings[i]['id']);
        // PaymentStatus paymentStatus =await FlutterPayStackServices.isPaymentSuccessfull(acceptedBookings[i]['transaction_id']);
        // print('the payment status is ${paymentStatus}');
        // if(paymentStatus==PaymentStatus.success){
        //   var request = {
        //     'booking_id': '${acceptedBookings[i]['id']}',
        //     'status': '3',
        //     'is_payment': '1',
        //   };
        //   var jsonResponse = await Webservices.postData(apiUrl: ApiUrls.change_booking_status, body: request);
        // }else if(paymentStatus==PaymentStatus.failed){
        //   var request = {
        //     'booking_id': '${acceptedBookings[i]['id']}',
        //     'status': '1',
        //     'is_payment': '0',
        //   };
        //   var jsonResponse = await Webservices.postData(apiUrl: ApiUrls.change_booking_status, body: request);
        // }
      }
    }
    get_lists();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('sdlkfjsfj ${confirms}');
    return ValueListenableBuilder<bool>(
      valueListenable:callStatusLoad ,
      builder: (context, value, child) =>

       Stack(
         children: [
           DefaultTabController(
            animationDuration: const Duration(seconds: 1),
            initialIndex: 4,
            length: 5,
            child: Scaffold(
              appBar: AppBar(
                leading: const BackButton(
                  color: Colors.black,
                ),
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
                      controller: _tabController,
                      children: [
                        // ElevatedButton(
                        //     style: ButtonStyle(),
                        //     onPressed: () async {
                        //       chargeCard(null);
                        //     },
                        //     child: Text('Pay')),
                        Container(
                          color: MyColors.BgColor,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                for (var i = 0; i < pending.length; i++)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => bookingdetail(
                                                    booking_id:
                                                        pending[i]['id'].toString(),
                                                  )));
                                      // Navigator.push(context, bookingdetail());
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        // color: MyColors.lightBlue.withOpacity(0.11),
                                        color: MyColors.surface3,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomCircularImage(
                                              imageUrl: pending[i]['doctor_data']
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
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        MainHeadingText(
                                                          text:
                                                              '${pending[i]['doctor_data']['first_name']}',
                                                          fontSize: 16,
                                                          color: MyColors.labelcolor,
                                                        ),
                                                        // MainHeadingText(
                                                        //   text:
                                                        //   'symptoms: ${pending[i]['symptoms'] ?? '-'}',
                                                        //   overflow: TextOverflow.ellipsis,
                                                        //   fontFamily: 'light',
                                                        //   fontSize: 13,
                                                        //   height: 1,
                                                        //   color: MyColors.labelcolor,
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                  MainHeadingText(
                                                    text:
                                                        '${pending[i]['price']} ZAR',
                                                    fontSize: 18,
                                                  ),
                                                ],
                                              ),
                                              vSizedBox05,
                                              Row(
                                                children: [
                                                  MainHeadingText(
                                                    text:
                                                        '${pending[i]['slot_data']['date']}',
                                                    fontSize: 11,
                                                    fontFamily: 'bold',
                                                    color: MyColors.labelcolor,
                                                  ),
                                                  hSizedBox,
                                                  MainHeadingText(
                                                    text:
                                                        '${DateFormat.jm().format(DateFormat('hh:mm').parse(pending[i]['slot_data']['start_time']))} - ${DateFormat.jm().format(DateFormat('hh:mm').parse(pending[i]['slot_data']['end_time']))}',
                                                    fontSize: 11,
                                                    fontFamily: 'medium',
                                                    color: MyColors.primaryColor,
                                                  )
                                                ],
                                              ),
                                              const MainHeadingText(
                                                text:
                                                    'Pending approval from healthcare Provider.',
                                                fontSize: 12,
                                                color: Colors.red,
                                              )
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (pending.length == 0)
                                  const Center(
                                    child: Text('No Data Found.'),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: MyColors.BgColor,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                for (var i = 0; i < acceptedBookings.length; i++)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => bookingdetail(
                                                    booking_id: acceptedBookings[i]
                                                            ['id']
                                                        .toString(),
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
                                              imageUrl: acceptedBookings[i]
                                                  ['doctor_data']['profile_image']),
                                          hSizedBox,
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                            '${acceptedBookings[i]['doctor_data']['first_name']}',
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
                                                    text:
                                                        '${getPrice(acceptedBookings[i]['price']).toStringAsFixed(2)} ZAR',
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
                                                                '${acceptedBookings[i]['slot_data']['date']}',
                                                            fontSize: 11,
                                                            fontFamily: 'semibold',
                                                            color:
                                                                MyColors.labelcolor,
                                                          ),
                                                          hSizedBox05,
                                                          MainHeadingText(
                                                            text:
                                                                '${DateFormat.jm().format(DateFormat('hh:mm').parse(acceptedBookings[i]['slot_data']['start_time']))} - ${DateFormat.jm().format(DateFormat('hh:mm').parse(acceptedBookings[i]['slot_data']['end_time']))}',
                                                            fontSize: 11,
                                                            fontFamily: 'medium',
                                                            color:
                                                                MyColors.primaryColor,
                                                          ),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                              // vSizedBox05,
                                              MainHeadingText(
                                                text:
                                                acceptedBookings[i]['is_payment'] ==
                                                    '2'?'Your payment is currently being processed. Once we receive confirmation from your bank, it will be automatically reflected as confirmed in the "Confirmed" tab of your "My Consultation" section. Please note that this process may take up to 30 minutes. If the payment status does not update within that time, kindly click on the "Payment processing" button to refresh the status of your payment.':'To confirm your booking, please click the "Pay Now" button to proceed to our secure payment portal.'
                                                    '\nPlease note that all cancellations made 24 hours prior to the scheduled consultation will be refunded in full. Unfortunately, cancellations made within 24 hours of your scheduled consultation will not be refunded.',
                                                fontSize: 12,
                                                color: Colors.green,
                                                textAlign: TextAlign.justify,
                                              ),
                                              vSizedBox,
                                              if (acceptedBookings[i]['is_payment'] ==
                                                  '2')
                                                RoundEdgedButton(
                                                  text: 'Payment Processing',
                                                  // text: 'Payment is under process.',
                                                  color: Colors.orangeAccent,
                                                  verticalPadding: 4,
                                                  height: 40,
                                                  onTap: () async {
                                                    setState(() {
                                                      load = true;
                                                    });

                                                    await changeBookingStatus(
                                                        transactionId:
                                                            acceptedBookings[i]
                                                                ['transaction_id'],
                                                        bookingId: acceptedBookings[i]
                                                            ['id']);
                                                    get_lists();
                                                  },
                                                )
                                              else
                                                RoundEdgedButton(
                                                  width: 150,
                                                  text: 'Pay Now',
                                                  color: Colors.green,
                                                  // width: 50,
                                                  // isSolid: false,
                                                  onTap: () async {
                                                    await payment_popup(
                                                      acceptedBookings[i]['id']
                                                          .toString(),
                                                      getPrice(acceptedBookings[i]
                                                          ['price']),
                                                      doctorData: acceptedBookings[i]
                                                          ['doctor_data'],
                                                    );
                                                  },
                                                ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (acceptedBookings.length == 0)
                                  const Center(
                                    child: Text('No Data Found.'),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: MyColors.BgColor,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                    text:
                                                        '${confirms[i]['price']} ZAR',
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
                                                            color:
                                                                MyColors.labelcolor,
                                                          ),
                                                          hSizedBox05,
                                                          MainHeadingText(
                                                            text:
                                                                '${DateFormat.jm().format(DateFormat('hh:mm').parse(confirms[i]['slot_data']['start_time']))} - ${DateFormat.jm().format(DateFormat('hh:mm').parse(confirms[i]['slot_data']['end_time']))}',
                                                            fontSize: 11,
                                                            fontFamily: 'medium',
                                                            color:
                                                                MyColors.primaryColor,
                                                          ),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                              vSizedBox,
                                              Row(
                                                children: [
                                                  Expanded(
                                                    // flex: 4,
                                                    child: RoundEdgedButton(
                                                      // width: 80,
                                                      //height: 50,
                                                      height: 60,
                                                      horizontalPadding: 0.0,
                                                      text: 'Chat',
                                                      // width: 50,
                                                      isSolid: false,
                                                      onTap: () {
                                                        push(
                                                            context: context,
                                                            screen: ChatPage(
                                                              other_user_id: current_user[
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
                                                      },
                                                    ),
                                                  ),
                                                  hSizedBox,
                                                  if (confirms[i]['is_join']
                                                              .toString() ==
                                                          '0' &&
                                                      compare_time(confirms[i]
                                                                      ['slot_data']
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
                                                        height: 60,
                                                        text: 'Join',
                                                        horizontalPadding: 0.0,
                                                        // width: 50,
                                                        isSolid: false,
                                                        onTap: () async {


                                                          // showSnackbar('sddsssfsd ${confirms[i]['id']}');
                                                          // return;
                                                          callStatusLoad.value=true;
                                                          var res = await Webservices.get(ApiUrls.callStatus+
                                                              '?bookingId=${confirms[i]['id']}');
                                                          callStatusLoad.value=false;
                                                          print('res---I am here ');
                                                        print('res---${res['data']['status']}');
                                                        if(res['data']['status']=="0"){

                                                          var res = await Webservices
                                                              .get(ApiUrls.PickCall +
                                                                  confirms[i]['id']
                                                                      .toString());
                                                          print(
                                                              'pickup call-----$res');
                                                          push(
                                                              context: context,
                                                              screen: VideoCallScreen(
                                                                name: confirms[i][
                                                                        'doctor_data']
                                                                    ['first_name'],
                                                                bookingId: confirms[i]
                                                                        ['id']
                                                                    .toString(),
                                                                userId: confirms[i][
                                                                            'doctor_data']
                                                                        ['id']
                                                                    .toString(),
                                                              ));
                                                        }else{
                                                          showSnackbar('Please wait for doctor to start call');
                                                        }

                                                        },
                                                      ),
                                                    ),
                                                  hSizedBox,
                                                  if (confirms[i]['is_join']
                                                              .toString() ==
                                                          '0' &&
                                                      ismarkascomlete(confirms[i]
                                                                      ['slot_data']
                                                                  ['date'] +
                                                              ' ' +
                                                              confirms[i]['slot_data']
                                                                  ['start_time']) ==
                                                          true)
                                                    Expanded(
                                                      child: RoundEdgedButton(
                                                        // width: 100,
                                                        // height: 10,
                                                        text: 'Mark as Complete',
                                                        // width: 50,
                                                        height: 60,
                                                        isSolid: false,
                                                        horizontalPadding: 0.0,
                                                        onTap: () async {
                                                          EasyLoading.show(
                                                              status: null,
                                                              maskType:
                                                                  EasyLoadingMaskType
                                                                      .black);
                                                          var res = await Webservices
                                                              .get(ApiUrls
                                                                      .mark_as_complete +
                                                                  confirms[i]['id']
                                                                      .toString());
                                                          print(
                                                              'booking complete   $res');
                                                          await EasyLoading.dismiss();
                                                          get_lists();
                                                        },
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  vSizedBox,
                                                  if (confirms[i]['is_refund_request']
                                                          .toString() ==
                                                      '0')
                                                    RoundEdgedButton(
                                                      height: 60.0,
                                                      text:
                                                          'Request a refund and cancel your booking',
                                                      isSolid: false,
                                                      onTap: () async {
                                                        ask_a_refund(
                                                            context,
                                                            confirms[i]['id']
                                                                .toString());
                                                      },
                                                    ),
                                                  if (confirms[i]['is_refund_request']
                                                          .toString() ==
                                                      '1')
                                                    RoundEdgedButton(
                                                      text: 'Pending Refund',
                                                      color: Colors.red,
                                                      onTap: () async {},
                                                    ),
                                                  if (confirms[i]['is_refund_request']
                                                          .toString() ==
                                                      '2')
                                                    RoundEdgedButton(
                                                      text: 'Refunded',
                                                      color: Colors.green,
                                                      onTap: () async {},
                                                    )
                                                ],
                                              )
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (confirms.length == 0)
                                  const Center(
                                    child: Text('No Data Found.'),
                                  ),
                                vSizedBox2,
                                vSizedBox2,

                                // Container(
                                //   margin: EdgeInsets.only(bottom: 15),
                                //   padding: EdgeInsets.all(16),
                                //   decoration: BoxDecoration(
                                //     color: MyColors.lightBlue.withOpacity(0.11),
                                //     borderRadius: BorderRadius.circular(15),
                                //   ),
                                //   child: Row(
                                //     children: [
                                //       Image.asset('assets/images/23.png', width: 50,),
                                //       hSizedBox2,
                                //       Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           MainHeadingText(text: 'John Smith', fontSize: 14, ),
                                //           MainHeadingText(text: 'symptoms: Cold cough', fontFamily: 'light', fontSize: 14, ),
                                //           Row(
                                //             children: [
                                //               MainHeadingText(text: '10 Aug, 2022', fontSize: 14, fontFamily: 'bold', color: MyColors.bordercolor,),
                                //               hSizedBox,
                                //               MainHeadingText(text: '8:00 pm - 9:00 pm', fontSize: 14, fontFamily: 'light', color: MyColors.bordercolor,)
                                //             ],
                                //           )
                                //         ],
                                //       )
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: MyColors.BgColor,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
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
                                              imageUrl: completeds[i]['doctor_data']
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
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      MainHeadingText(
                                                        text:
                                                            '${completeds[i]['doctor_data']['first_name']}',
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
                                                    text:
                                                        '${completeds[i]['price']} ZAR',
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
                                                                '${completeds[i]['slot_data']['date']}',
                                                            fontSize: 11,
                                                            fontFamily: 'semibold',
                                                            color:
                                                                MyColors.labelcolor,
                                                          ),
                                                          hSizedBox05,
                                                          MainHeadingText(
                                                            text:
                                                                '${DateFormat.jm().format(DateFormat('hh:mm').parse(completeds[i]['slot_data']['start_time']))} - ${DateFormat.jm().format(DateFormat('hh:mm').parse(completeds[i]['slot_data']['end_time']))}',
                                                            fontSize: 11,
                                                            fontFamily: 'medium',
                                                            color:
                                                                MyColors.primaryColor,
                                                          ),
                                                        ],
                                                      )),
                                                ],
                                              ),

                                                Row(
                                                  children: [
                                                    if (completeds[i]['rate'].toString() == '0')
                                                    RoundEdgedButton(
                                                      width: 100,
                                                      // height: 10,
                                                      text: 'Rate',
                                                      // width: 50,
                                                      horizontalPadding: 0,
                                                      isSolid: false,
                                                      onTap: () async {
                                                        rating_sheet(completeds[i]
                                                                ['id']
                                                            .toString());
                                                      },
                                                    ),

                                                    RoundEdgedButton(
                                                      width: 100,
                                                      // height: 10,
                                                      text: 'Delete',
                                                      // width: 50,
                                                      isSolid: false,
                                                      horizontalPadding: 0,
                                                      horizontalMargin: 15,
                                                      verticalMargin: 05,
                                                      onTap: () async {
                                                        Map<String, dynamic> data = {
                                                          'booking_id': completeds[i]['id'],
                                                          'type': '2',
                                                        };
                                                        bool? result= await showCustomConfirmationDialog(
                                                          headingMessage:'Are you sure you want to delete?',
                                                          // description: 'You want to delete'
                                                        ) ;
                                                       if(result==true){
                                                         setState(() {
                                                           load = true;
                                                         });
                                                         var res = await Webservices.postData(
                                                             apiUrl: ApiUrls.deleteBooking,
                                                             body: data,
                                                             context: context).then((value) => get_lists(shouldCheckAcceptedBookingStatus: true));
                                                       }
                                                      },
                                                    ),
                                                  ],
                                                ),

                                              // Column(
                                              //   children: [
                                              //     vSizedBox,
                                              //     // if (completeds[i]
                                              //     //             ['is_refund_request']
                                              //     //         .toString() ==
                                              //     //     '0')
                                              //     //   RoundEdgedButton(
                                              //     //     text: 'Ask a Refund',
                                              //     //     isSolid: false,
                                              //     //     onTap: () async {
                                              //     //       ask_a_refund(
                                              //     //           context,
                                              //     //           completeds[i]['id']
                                              //     //               .toString());
                                              //     //     },
                                              //     //   ),
                                              //     // if (completeds[i]
                                              //     //             ['is_refund_request']
                                              //     //         .toString() ==
                                              //     //     '1')
                                              //     //   RoundEdgedButton(
                                              //     //     text: 'Pending Refund',
                                              //     //     color: Colors.red,
                                              //     //     onTap: () async {},
                                              //     //   ),
                                              //     // if (completeds[i]
                                              //     //             ['is_refund_request']
                                              //     //         .toString() ==
                                              //     //     '2')
                                              //     //   RoundEdgedButton(
                                              //     //     text: 'Refunded',
                                              //     //     color: Colors.green,
                                              //     //     onTap: () async {},
                                              //     //   )
                                              //   ],
                                              // )
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (completeds.length == 0)
                                  const Center(
                                    child: Text('No Data Found.'),
                                  ),
                                // Container(
                                //   margin: EdgeInsets.only(bottom: 15),
                                //   padding: EdgeInsets.all(16),
                                //   decoration: BoxDecoration(
                                //     color: MyColors.lightBlue.withOpacity(0.11),
                                //     borderRadius: BorderRadius.circular(15),
                                //   ),
                                //   child: Row(
                                //     children: [
                                //       Image.asset('assets/images/23.png', width: 50,),
                                //       hSizedBox2,
                                //       Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           MainHeadingText(text: 'John Smith', fontSize: 14, ),
                                //           MainHeadingText(text: 'symptoms: Cold cough', fontFamily: 'light', fontSize: 14, ),
                                //           Row(
                                //             children: [
                                //               MainHeadingText(text: '10 Aug, 2022', fontSize: 14, fontFamily: 'bold', color: MyColors.bordercolor,),
                                //               hSizedBox,
                                //               MainHeadingText(text: '8:00 pm - 9:00 pm', fontSize: 14, fontFamily: 'light', color: MyColors.bordercolor,)
                                //             ],
                                //           )
                                //         ],
                                //       )
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: MyColors.BgColor,
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
                                      // Navigator.push(context, bookingdetail());
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
                                              //       'symptoms: ${rejects[i]['symptoms'] ?? '-'}',
                                              //   overflow: TextOverflow.ellipsis,
                                              //   fontFamily: 'light',
                                              //   fontSize: 14,
                                              // ),
                                              if(rejects[i]['slot_data'] != null && rejects[i]['slot_data'].isNotEmpty )
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
                                                        'type': '2',
                                                      };
                                                      bool? result= await showCustomConfirmationDialog(
                                                          headingMessage: 'Are you sure you want to delete?',

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
                                if (rejects.length == 0)
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
                 ),
           if(value)const Center(child: CircularProgressIndicator()),
         ],
       ),
    );
  }

  Future<void> payment_popup(String booking_id, double amount,
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
                  amount: (double.parse(amount.toString()).toInt() * 100)
                      .toString(), //amount.toString(),
                  //.roundToDouble()
                  //.toString(), //the money should be in kobo hence the need to multiply the value by 100
                  subAccountCode: doctorData['bank_details']['subaccount_code'],
                );
                if (paystackInitiateTransactionResponse != null) {
                  bool? success = await push(
                      context: MyGlobalKeys.navigatorKey.currentContext!,
                      screen: PayStackPaymentPage(
                        paymentUrl: paystackInitiateTransactionResponse
                            .authorization_url,
                      ));
                  print('payment success----- $success');
                  // return;

                  // bool paymentIsSuccess =await FlutterPayStackServices.isPaymentSuccessfull(paystackInitiateTransactionResponse.reference);
                  PaymentStatus paymentIsSuccess =
                      await FlutterPayStackServices.isPaymentSuccessfull(
                          paystackInitiateTransactionResponse.reference);
                  if (success == true ||
                      paymentIsSuccess != PaymentStatus.failed) {
                    Map<String, dynamic> data = {
                      'user_id': await getCurrentUserId(),
                      'booking_id': booking_id.toString(),
                      'transaction_id': paystackInitiateTransactionResponse
                          .reference
                          .toString(), //'123456',
                      // 'status':'1',
                      'status':
                          paymentIsSuccess == PaymentStatus.ongoing ? '1' : '3',

                      // 'status': '3',
                      // 'payment_status': PaymentStatus.ongoing.name,
                      'payment_status': paymentIsSuccess.name,
                    };
                    await EasyLoading.show(
                      status: null,
                      maskType: EasyLoadingMaskType.black,
                    );
                    print('the request isssd $data');
                    var res = await Webservices.postData(
                        apiUrl: ApiUrls.FinalBooking,
                        body: data,
                        context: MyGlobalKeys.navigatorKey.currentContext!);
                    EasyLoading.dismiss();
                    print('booking------$res');
                    if (res['status'].toString() == '1') {
                      get_lists();
                      _tabController.animateTo(2);
                      setState(() {});
                      // Navigator.pop(context);
                      // setState(() {
                      //
                      // });

                      await paymentsuccesspopup(
                          MyGlobalKeys.navigatorKey.currentContext!,
                          paymentIsSuccess);
                    } else {
                      showSnackbar('Payment Failed!!!');
                    }
                  } else {
                    
                    showSnackbar('Your transaction is failed due to some error. Please try again after some time.');
                    // showSnackbar(
                    //     'Somting went wrong please try again later.');
                    print('ksdklfsja');
                    // push(
                    //     context: MyGlobalKeys.navigatorKey.currentContext!,
                    //     screen: ErrorLogPage());
                  }
                }
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

  ask_a_refund(BuildContext context, String booking_id) {
    // set up the buttons
    Widget YesButton = TextButton(
      child: const Text("Yes"),
      onPressed: () async {
        Map<String, dynamic> data = {
          'user_id': await getCurrentUserId(),
          'paitent_id': await getCurrentUserId(),
          'booking_id': booking_id.toString(),
        };
        EasyLoading.show(status: null, maskType: EasyLoadingMaskType.black);
        var res = await Webservices.postData(
            apiUrl: ApiUrls.booking_cancel, body: data);
        EasyLoading.dismiss();
        Navigator.pop(context);
        print(res);
        get_lists();
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
        " ",
        style: TextStyle(color: Colors.green),
      ),
      content: const Padding(
        padding: EdgeInsets.only(left: 23.0),
        child: Text(
            'Are you sure you would like to cancel your booking and request a refund?'
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

  compare_time(String date_time) {
    DateTime dt1 = DateTime.parse(date_time);
    DateTime dt2 = DateTime.now();
    Duration d = dt1.difference(dt2);
    print('comprea************${d.inMinutes}');
    if (d.inMinutes >= -120 || d.inMinutes >= 120) {
      return true;
    }
    return false;
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
                  :Scaffold(
                    backgroundColor:  const Color(0xFFF1F4F8),
          body:  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
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
                                get_lists();
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
                    )),);
        
      },
    );
  }


}
