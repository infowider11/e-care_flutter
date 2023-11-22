import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/navigation.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/doctor-details.dart';
import 'package:ecare/pages/long_felt_way.dart';
import 'package:ecare/pages/payment_method.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/tabs.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class ScheduleAppoint extends StatefulWidget {
  final Map? booking_data;
  final String? booking_id;
  final Map<String,dynamic> api_request;
   ScheduleAppoint({Key? key, this.booking_data,this.booking_id,required this.api_request}) : super(key: key);

  @override
  State<ScheduleAppoint> createState() => _ScheduleAppointState();
}

class _ScheduleAppointState extends State<ScheduleAppoint> {
  @override
  void initState() {
    // TODO: implement initState
    print('booking data----- ${widget.booking_data}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      // appBar: appBar(context: context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSizedBox4,
            MainHeadingText(
              text: 'Schedule Appointment',
              fontFamily: 'light',
              fontSize: 32,
            ),
            vSizedBox4,
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
              decoration: BoxDecoration(
                  color: Color(0xFE00A2EA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/tick.png',
                    width: 48,
                  ),
                  vSizedBox2,
                  MainHeadingText(
                    textAlign: TextAlign.center,
                    text:
                        '${DateFormat.jm().format(DateFormat('hh:mm').parse(widget.booking_data!['start_time']))} to '
                        '${DateFormat.jm().format(DateFormat('hh:mm').parse(widget.booking_data!['end_time']))} On '
                        '${widget.booking_data!['date']}',
                    fontSize: 24,
                    fontFamily: 'light',
                  ),
                  vSizedBox2,
                  // vSizedBox2,
                  RoundEdgedButton(
                    horizontalPadding: 10,
                    onTap: () async {

                      await EasyLoading.show(
                            status: null, maskType: EasyLoadingMaskType.black);
                        var res = await Webservices.postData(
                            apiUrl: ApiUrls.Booking,
                            body: widget.api_request,
                            context: context);
                      print('booking------$res');
                      if (res['status'].toString() == '1') {
                        Map<String,dynamic> data = {
                          'user_id':await getCurrentUserId(),
                          'booking_id':res['data']['id'].toString(),
                        };
                        var val = await Webservices.postData(apiUrl: ApiUrls.send_notification_toprovider, body: data, context: context);
                        print('send noti api------${res}');
                        EasyLoading.dismiss();
                        // Navigator.popUntil(context, (route) => route.isFirst);
                        pushAndPopAll(
                            context: context,
                            screen: tabs_second_page(
                              selectedIndex: 0,
                            ));
                        Successpopup(context);
                      }



                      // => Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentMethod()))
                    },
                    text: 'Provisionally Book',
                    // text: 'Continue and Pay',
                    borderRadius: 100,
                    fontSize: 14,
                    width: 170,
                  ),
                  vSizedBox2,
                  MainHeadingText(
                    textAlign: TextAlign.center,
                    text:
                        'If your consultation does not take place due to your healthcare provider\'s failure to initiate the call, please contact us via the app or email admin@e-care.co.za within 24 hours of the appointment. We will investigate the issue further, and if appropriate, issue you a refund.',
                    fontSize: 14,
                    color: MyColors.paragraphcolor,
                    fontFamily: 'light',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Successpopup(BuildContext context) {
    // set up the buttons
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        Navigator.canPop(context);
        // Navigator.pop(context);
        // setState(() {
        // });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Provisionally booked",
        style: TextStyle(color: Colors.green),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //     'Provisionally booked'),
          Text('We are pleased to inform you that we have provisionally booked your selected consultation slot, and we have sent a booking request to your healthcare provider. We will notify you once your booking request is accepted, and provide you with further instructions to complete your payment and finalize your booking.'
              '\nPlease note that in case your healthcare provider does not accept the booking request within 2 hours of the request, all requests made before 8 p.m. will be automatically cancelled. For requests made between 8pm and 7am, your healthcare provider must accept the request by 8 a.m. the following morning, or it will also be automatically cancelled. We apologize for any inconvenience this may cause, and we encourage you to contact us if you have any questions or concerns.'),
          Text('\nThank you for choosing our service, and we look forward to serving you soon.'),
        ],
      ),
      actions: [
        // continueButton,
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
