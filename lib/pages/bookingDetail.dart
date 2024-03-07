import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/chat.dart';
import 'package:ecare/pages/prescriptions_doctor.dart';
import 'package:ecare/pages/referral_letter.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/custom_circular_image.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
// import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/global_keys.dart';
import '../constants/navigation.dart';
import '../dialogs/payment_success_dialog.dart';
import '../doctor_module/patient-details.dart';
import '../functions/get_folder_directory.dart';
import '../functions/global_Var.dart';
import '../services/api_urls.dart';
import 'dart:isolate';
import 'package:url_launcher/url_launcher.dart';

import '../services/pay_stack/flutter_paystack_services.dart';
import '../services/pay_stack/modals/FlutterPayStackInitializeTransactionResponseModal.dart';
import '../services/pay_stack/payment_page.dart';
import '../tabs.dart';
import '../widgets/showSnackbar.dart';
import 'add_icd_notes.dart';
import 'add_prescription.dart';
import 'addsick.dart';
import 'consultation_notes.dart';

class bookingdetail extends StatefulWidget {
  final String booking_id;
  const bookingdetail({Key? key, required this.booking_id}) : super(key: key);

  @override
  State<bookingdetail> createState() => _bookingdetailState();
}

class _bookingdetailState extends State<bookingdetail> {
  TextEditingController email = TextEditingController();
  bool load = false;
  Map info = {};
  Map current_user = {};
  double progress = 0;
  String progressString = '';
  bool didDownloadPDF = false;
  ReceivePort _port = ReceivePort();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   get_info();
  //
  // }

  @override
  void initState() {
    super.initState();
    get_info();
   if(Platform.isAndroid){
     IsolateNameServer.registerPortWithName(
         _port.sendPort, 'downloader_send_port');
     _port.listen((dynamic data) {
       String id = data[0];
       DownloadTaskStatus status = data[1];
       int progress = data[2];
       setState(() {});
     });

     FlutterDownloader.registerCallback(downloadCallback);
   }
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, int status, int progress) {
      // String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  get_info() async {
    current_user = await getUserDetails();
    print('current user-----$current_user');
    setState(() {
      load = true;
    });
    var res = await Webservices.get(ApiUrls.singleBookingData +
        widget.booking_id.toString() +
        '&user_type=1');
    print('res-----$res');
    if (res['status'].toString() == '1') {
      info = res['data'];
      setState(() {});
    }
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration(seconds: 1),
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Booking Detail'),
          leading: BackButton(
            color: Colors.black,
          ),
          backgroundColor: MyColors.BgColor,
          actions: [
            if (info['status'].toString() == '3' ||
                info['status'].toString() == '4')
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  // PopupMenuItem 1
                  PopupMenuItem(
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
                  // PopupMenuItem 2
                  PopupMenuItem(
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
                  PopupMenuItem(
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
                  PopupMenuItem(
                    value: 4,
                    // row with two children
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("My Consultation Notes")
                      ],
                    ),
                  ),
                  ///kjl
                  // lkjl
                  // PopupMenuItem(
                  //   value: 5,
                  //   // row with two children
                  //   child: Row(
                  //     children: [
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text("Add ICD-10 codes to statement")
                  //     ],
                  //   ),
                  // ),
                ],
                offset: Offset(0, 58),
                color: MyColors.white,
                elevation: 0,
                // on selected we show the dialog box
                onSelected: (value) {
                  // if value 1 show dialog
                  if (value == 1) {
                    push(
                        context: context,
                        screen: Prescriptions_Doctor_Page(
                          booking_id: info['id'].toString(),
                        ));
                  } else if (value == 2) {
                    push(
                        context: context,
                        screen: Add_sicknote(
                          booking_id: info['id'].toString(),
                        ));
                  } else if (value == 3) {
                    push(
                        context: context,
                        screen: Referral_Letter_Page(
                          booking_id: info['id'].toString(),
                        ));
                  } else if (value == 4) {
                    push(
                        context: context,
                        screen: Consultation_Notes_Page(
                          booking_id: info['id'].toString(),
                        ));
                  }else if (value == 5) {
                    print('skjdfkldas ${info['user_data']['first_name']}');
                    // return;
                    push(
                      context: context,
                      screen:AddIcdNotes(
                        booking_id: info
                        ['id']
                            .toString(),
                        doctorName: '${info[
                        'user_data']
                        [
                        'first_name']}',
                      ),
                    );
                  }
                },
              ),
          ],
        ),
        body: load
            ? CustomLoader()
            : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: MyColors.scaffold,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: headingText(
                                  text: 'Booking Id: ',
                                ),
                              ),
                              hSizedBox2,
                              Expanded(
                                flex: 7,
                                child: headingText(text: '#${info['id']}'),
                              ),
                            ],
                          ),
                          vSizedBox,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: headingText(text: 'Booking Status:'),
                              ),
                              hSizedBox2,
                              Expanded(
                                flex: 7,
                                child: headingText(
                                    color: info['status'].toString() == '2'
                                        ? Colors.red
                                        : Colors.green,
                                    text: (info['status'].toString() == '0')
                                        ? 'Pending approval from healthcare provider'
                                        : (info['status'].toString() == '1')
                                            ? 'Accepted by Healthcare Provider'
                                            : (info['status'].toString() == '2')
                                                ? 'Rejected by Healthcare Provider'
                                                : (info['status'].toString() ==
                                                        '3')
                                                    ? 'Confirmed by Healthcare Provider'
                                                    : (info['status']
                                                                .toString() ==
                                                            '5')
                                                        ? 'Booking Cancelled'
                                                        : 'Booking completed.'),
                              ),
                            ],
                          ),
                          vSizedBox,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: headingText(text: 'Date:'),
                              ),
                              hSizedBox2,
                              Expanded(
                                flex: 7,
                                child: headingText(
                                    text: '${info['slot_data']['date']}'),
                              ),
                            ],
                          ),
                          vSizedBox,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: headingText(text: 'Start Time:'),
                              ),
                              hSizedBox2,
                              Expanded(
                                flex: 7,
                                child: headingText(
                                    text:
                                        '${DateFormat.jm().format(DateFormat('hh:mm').parse(info['slot_data']['start_time']))}'),
                              ),
                            ],
                          ),
                          vSizedBox,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: headingText(text: 'End Time:'),
                              ),
                              hSizedBox2,
                              Expanded(
                                flex: 7,
                                child: headingText(
                                    text:
                                        '${DateFormat.jm().format(DateFormat('hh:mm').parse(info['slot_data']['end_time']))}'),
                              ),
                            ],
                          ),
                          vSizedBox,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: headingText(text: 'Price:'),
                              ),
                              hSizedBox2,
                              Expanded(
                                flex: 7,
                                child:
                                    headingText(text: '${info['price']} ZAR'),
                              ),
                            ],
                          ),
                          vSizedBox,
                          if (info['is_refund_request'].toString() == '2')
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: headingText(text: 'Payment Refund:'),
                                ),
                                hSizedBox2,
                                Expanded(
                                  flex: 7,
                                  child: headingText(
                                    text: 'Refunded Successfully',
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          vSizedBox,
                          if (info['reject_reason'] != null)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: headingText(text: 'Reject Reason:'),
                                ),
                                hSizedBox2,
                                Expanded(
                                  flex: 7,
                                  child: headingText(
                                      text: '${info['reject_reason']}'),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    vSizedBox4,
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: MyColors.scaffold,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          if (current_user['type'].toString() == '2')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                MainHeadingText(
                                    textAlign: TextAlign.start,
                                    text: 'Healthcare Provider details'),
                                vSizedBox,
                                Center(
                                  child: Column(
                                    children: [
                                      CustomCircularImage(
                                          imageUrl: info['doctor_data']
                                              ['profile_image']),
                                      headingText(
                                          text:
                                              '${info['doctor_data']['first_name']} ${info['doctor_data']['last_name']}'),
                                      headingText(
                                          text:
                                              '${info['doctor_data']['phone_code']}-${info['doctor_data']['phone']}'),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          if (current_user['type'].toString() == '1')
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MainHeadingText(text: 'Client Profile'),
                                  GestureDetector(
                                    onTap: () {
                                      push(
                                          context: context,
                                          screen: PatientDetails(
                                            user_id: info['user_data']['id']
                                                .toString(),
                                          ));
                                    },
                                    child: Container(
                                      child: Column(
                                        children: [
                                          CustomCircularImage(
                                              imageUrl: info['user_data']
                                                  ['profile_image']),
                                          headingText(
                                              text:
                                                  '${info['user_data']['first_name']} ${info['user_data']['last_name']}'),
                                          headingText(
                                              text:
                                                  '${info['user_data']['phone_code']}-${info['user_data']['phone']}'),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    vSizedBox4,
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: MyColors.scaffold,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MainHeadingText(
                                  textAlign: TextAlign.start,
                                  text: 'Consultation details'),
                            ],
                          ),
                          vSizedBox4,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: headingText(text: 'Category:'),
                              ),
                              hSizedBox2,
                              Expanded(
                                flex: 7,
                                child: headingText(
                                    text: '${info['category']['title']}'),
                              ),
                            ],
                          ),
                          vSizedBox,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: headingText(
                                    text: 'Reason for Consultation:'),
                              ),
                              hSizedBox2,
                              Expanded(
                                flex: 7,
                                child: headingText(
                                    text: '${info['other_reason'] ?? '-'}'),
                              ),
                            ],
                          ),
                          if (info['category']['id'].toString() == '1' &&
                              info['days'] != null)
                            Column(
                              children: [
                                vSizedBox,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: headingText(
                                          text: 'Duration of symptom :'),
                                    ),
                                    hSizedBox2,
                                    Expanded(
                                      flex: 7,
                                      child: headingText(
                                          text: '${info['days']} Days'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          vSizedBox,
                          if (info['category']['id'].toString() == '1' &&
                              info['temperature'] != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: headingText(text: 'Temperature:'),
                                ),
                                hSizedBox2,
                                Expanded(
                                  flex: 7,
                                  child: headingText(
                                      text: '${info['temperature']} °C'),
                                ),
                              ],
                            ),
                          vSizedBox,
                          if (info['category']['id'].toString() == '1' &&
                              info['symptoms'] != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: headingText(text: 'Symptoms:'),
                                ),
                                hSizedBox2,
                                Expanded(
                                  flex: 7,
                                  child:
                                      headingText(text: '${info['symptoms']}'),
                                ),
                              ],
                            ),
                          if (info['category']['id'].toString() != '1' &&
                              info['description'] != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: headingText(text: 'Description:'),
                                ),
                                hSizedBox2,
                                Expanded(
                                  flex: 7,
                                  child: headingText(
                                      text: '${info['description'] ?? '-'}'),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    vSizedBox4,
                    if (info['is_payment'] ==
                        '2' && info['status'].toString() == '1' &&
                        current_user['type'].toString() == '2')
                      RoundEdgedButton(
                        text: 'Payment Processing',
                        // text: 'Payment is under process.',
                        color: Colors.orangeAccent,
                        verticalPadding: 4,
                        height: 40,
                        onTap: () async {
                          // setState(() {
                          //   load = true;
                          // });
                          //
                          get_info();
                        },
                      )
                    else

                    if (info['status'].toString() == '1' &&
                        current_user['type'].toString() == '2')
                      RoundEdgedButton(
                        text: 'Payment',
                        onTap: () {
                          payment_popup();
                          // push(context: context, screen:
                          // ChatPage(other_user_id: current_user['type'].toString()=='1'?info['user_data']['id'].toString():
                          // info['doctor_data']['id'].toString(),booking_id: widget.booking_id.toString(),));
                        },
                      ),
                    Column(
                      children: [
                        vSizedBox,
                        if ((info['status'].toString() == '3') &&
                            info['is_refund_request'].toString() == '0' &&
                            current_user['type'].toString() == '2')
                          RoundEdgedButton(
                            text: 'Ask a Refund',
                            isSolid: false,
                            onTap: () async {
                              ask_a_refund(context, info['id'].toString());
                            },
                          ),

                        if ((info['status'].toString() == '2' ||
                                info['status'].toString() == '3') &&
                            info['is_refund_request'].toString() == '1' &&
                            current_user['type'].toString() == '2')
                          RoundEdgedButton(
                            text: 'Pending Refund',
                            color: Colors.red,
                            onTap: () async {},
                          ),

                        // if(info['is_refund_request'].toString()=='2')
                        //   RoundEdgedButton(
                        //     text: 'Refunded',
                        //     color: Colors.green,
                        //     onTap: () async{
                        //
                        //     },
                        //   )
                      ],
                    ),
                    vSizedBox4,
                    if (info['status'].toString() == '3')
                      RoundEdgedButton(
                        color: didDownloadPDF
                            ? Colors.grey
                            : MyColors.primaryColor,
                        text: 'Download Invoice PDF',
                        onTap: didDownloadPDF
                            ? null
                            : () async {
                                setState(() {
                                  didDownloadPDF = true;
                                });
                                // var status = await Permission.storage.request();
                                if (true) {
                                  String fileName = 'invoice_' +
                                      DateTime.now().second.toString();
                                  final externalDir =
                                      await getFolderDirectory();
                                  print('filename------$fileName');
                                  var download = await savePdfToStorage(
                                      info['invoice_link'],
                                      externalDir!.path,
                                      'invoice.pdf');
                                  print('download-----${download}');
                                  if (download != null) {
                                    showSnackbar(
                                        'Invoice Downloaded Successfully.');
                                    setState(() {
                                      didDownloadPDF = false;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    didDownloadPDF = false;
                                  });
                                }
                              },
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> payment_popup() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Make Payment')),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you sure?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                Navigator.pop(context);
                FlutterPayStackInitializeTransactionResponseModal?
                    paystackInitiateTransactionResponse =
                    await FlutterPayStackServices.initializeTransaction(
                  email: user_Data!['email'],
                  amount: (double.parse(info['price'].toString()).toInt() * 100)
                      .toString(), //amount.toString(),
                  //.roundToDouble()
                  //.toString(), //the money should be in kobo hence the need to multiply the value by 100
                  subAccountCode: info['doctor_data']['bank_details']['subaccount_code'],
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
                  PaymentStatus paymentIsSuccess =await FlutterPayStackServices.isPaymentSuccessfull(paystackInitiateTransactionResponse.reference);
                  if(success==true || paymentIsSuccess!=PaymentStatus.failed){
                  // if (success == true) {
                    print('Confirmed');
                    Map<String, dynamic> data = {
                      'user_id': await getCurrentUserId(),
                      'booking_id': widget.booking_id.toString(),
                      'transaction_id': paystackInitiateTransactionResponse
                          .reference
                          .toString(), //'123456',
                      // 'status': '3',
                      'status':paymentIsSuccess==PaymentStatus.ongoing?'1': '3',
                      'payment_status': PaymentStatus.ongoing.name,
                    };
                    await EasyLoading.show(
                      status: null,
                      maskType: EasyLoadingMaskType.black,
                    );
                    var res = await Webservices.postData(
                        apiUrl: ApiUrls.FinalBooking, body: data, context: context);
                    EasyLoading.dismiss();
                    print('booking------$res');
                    if (res['status'].toString() == '1') {
                      await paymentsuccesspopup(MyGlobalKeys.navigatorKey.currentContext!,paymentIsSuccess);
                      // Navigator.pop(context);
                      // setState(() {
                      //
                      // });
                    }
                  } else {
                    showSnackbar('Somting went wrong please try again later.');
                  }
                }


                // Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
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
  //             'If your consultation does not take place due to your healtcare provider not initiating the call, please contact us via the app or email admin@E-Care.co.za within 24 hours of the appointment, so that we may investigate further and refund you if appropriate.'),
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

  Future<String> savePdfToStorage(
      String url, targetPath, targetFilename) async {
    var response = await get(Uri.parse(url)); // <--2
    print('the url is__________________________________$url');
    final path = await getFolderDirectory();
    var firstPath = targetPath;
    var filePathAndName = path!.path + '/' + targetFilename;
    await Directory(firstPath).create(recursive: true);
    File file2 = new File(filePathAndName); // <-- 2
    file2.writeAsBytesSync(response.bodyBytes); // <-- 3
    return filePathAndName;
  }

  // Future download(Dio dio, String url, String savePath) async {
  //   print('download click----');
  //   try {
  //     Response response = await dio.get(
  //       url,
  //       onReceiveProgress: updateProgress,
  //       options: Options(
  //           responseType: ResponseType.bytes,
  //           followRedirects: false,
  //           validateStatus: (status) { return status! < 500; }
  //       ),
  //     );
  //     var file = File(savePath).openSync(mode: FileMode.write);
  //     file.writeFromSync(response.data);
  //     await file.close();
  //
  //     // Here, you're catching an error and printing it. For production
  //     // apps, you should display the warning to the user and give them a
  //     // way to restart the download.
  //   } catch (e) {
  //     print('catch-----$e');
  //   }
  // }

  void updateProgress(done, total) {
    progress = done / total;
    setState(() {
      if (progress >= 1) {
        progressString =
            '✅ File has finished downloading. Try opening the file.';
        didDownloadPDF = true;
      } else {
        progressString = 'Download progress:-' +
            (progress * 100).toStringAsFixed(0) +
            '% done.';
      }
    });
  }

  ask_a_refund(BuildContext context, String booking_id) {
    Widget YesButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        Map<String, dynamic> data = {
          'user_id': await getCurrentUserId(),
          'booking_id': booking_id.toString(),
        };
        EasyLoading.show(status: null, maskType: EasyLoadingMaskType.black);
        var res = await Webservices.postData(
            apiUrl: ApiUrls.refundrequest, body: data);
        EasyLoading.dismiss();
        Navigator.pop(context);
        print(res);
        get_info();
        setState(() {});
      },
    );

    Widget NoButton = TextButton(
      child: Text("No"),
      onPressed: () async {
        Navigator.pop(context);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      title: Text(
        "Booking Refund Request",
        style: TextStyle(color: Colors.green),
      ),
      content: Padding(
        padding: EdgeInsets.only(left: 23.0),
        child: Text('Are You Sure?'),
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
