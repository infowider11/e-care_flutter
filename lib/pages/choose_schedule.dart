import 'package:cell_calendar/cell_calendar.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/navigation.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/doctor-details.dart';
import 'package:ecare/pages/long_felt_way.dart';
import 'package:ecare/pages/schedule_appointment.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ChooseSchedule extends StatefulWidget {
  final List? available_schedule;
  final String? doc_id;
  final List? symptoms;
  final List? head_neck;
  final Map? cate;
  final Map? sub_cate;
  final String? other_reason;
  final String? days;
  final String? temp;
  const ChooseSchedule(
      {Key? key,
      this.available_schedule,
      this.doc_id,
      this.symptoms,
      this.head_neck,
      this.cate,
      this.sub_cate,
      this.days,
      this.temp,
      this.other_reason})
      : super(key: key);

  @override
  State<ChooseSchedule> createState() => _ChooseScheduleState();
}

class _ChooseScheduleState extends State<ChooseSchedule> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int? selected_inx;
  bool? slot_;
  List available_slot = [];
  final cellCalendarPageController = CellCalendarPageController();
  List<CalendarEvent> sampleEvents = [];
  bool load = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    get_slots();
  }

  get_slots() async {
    setState(() {
      load = true;
    });
    Map<String, dynamic> data = {
      'user_id': widget.doc_id,
      // 'date': formatted,
    };
    var res = await Webservices.postData(
        apiUrl: ApiUrls.available_event, body: data, context: context);
    print('available----slot----$res');
    if (res['status'].toString() == '1') {
      for(int i=0;i<res['data'].length;i++){
        sampleEvents.add(
          CalendarEvent(
              eventName: '${res['data'][i]['slot_data'].length.toString()} Slot',
              eventDate: DateTime.parse(res['data'][i]['date']+' '+res['data'][i]['start_time']),
              eventBackgroundColor: MyColors.secondarycolor),
        );
      }
    }
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(context: context),
      body: load?CustomLoader():SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeadingText(
              text: 'Schedule Appointment',
              fontFamily: 'light',
              fontSize: 32,
            ),
            // vSizedBox4,
            Container(
              height: 500,
              child: CellCalendar(
                cellCalendarPageController: cellCalendarPageController,
                onCellTapped: (selectedDay) async {
                  print("$selectedDay is tapped !");
                  // Successpopup(context);
                  // return;
                  setState(() {
                    selected_inx = null;
                    slot_ = true;
                  });
                  print('selectedDay---$selectedDay');
                  // print('focusedDay---$focusedDay');
                  _selectedDay = selectedDay;
                  // _focusedDay = focusedDay;
                  DateFormat formatter = DateFormat('yyyy-MM-dd');
                  String formatted = formatter.format(_selectedDay);
                  print('formatted----$formatted');
                  setState(() {});
                  Map<String, dynamic> data = {
                    'user_id': widget.doc_id,
                    'date': formatted,
                  };
                  await EasyLoading.show(
                      status: null, maskType: EasyLoadingMaskType.black);
                  var res = await Webservices.postData(
                      apiUrl: ApiUrls.available_slot,
                      body: data,
                      context: context);
                  print('available----slot----$res');
                  EasyLoading.dismiss();
                  if (res['status'].toString() == '1') {
                    available_slot = res['data'];

                    for (int i = 0; i < available_slot.length; i++) {
                      available_slot[i]['duration'] = await duration_time(
                          available_slot[i]['date'] +
                              ' ' +
                              available_slot[i]['end_time'],
                          available_slot[i]['date'] +
                              ' ' +
                              available_slot[i]['start_time']);
                    }

                    setState(() {
                      slot_ = true;
                    });
                    print('duration-----$available_slot');
                  } else {
                    available_slot = [];
                    setState(() {
                      slot_ = false;
                    });
                  }
                  setState(() {
                    // update `_focusedDay` here as well
                  });
                },
                events: sampleEvents,
                daysOfTheWeekBuilder: (dayIndex) {
                  /// dayIndex: 0 for Sunday, 6 for Saturday.
                  final labels = ["S", "M", "T", "W", "T", "F", "S"];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      labels[dayIndex],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MyColors.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },

                // monthYearLabelBuilder: (datetime) {
                //   final year = datetime?.year.toString();
                //   final month = datetime?.month.toString();
                //   return Padding(
                //     padding: const EdgeInsets.all(16.0),
                //     child: Text(
                //       "$month, $year",
                //       style: TextStyle(
                //         fontSize: 24,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   );
                // },

              ),
            ),

            // Image.asset('assets/images/calender.png'),
            // TableCalendar(
            //   firstDay: DateTime.utc(2010, 10, 16),
            //   lastDay: DateTime.utc(2030, 3, 14),
            //   focusedDay: _selectedDay,
            //   selectedDayPredicate: (day) {
            //     return isSameDay(_selectedDay, day);
            //   },
            //   onDaySelected: (selectedDay, focusedDay) async {
            //     setState(() {
            //       selected_inx = null;
            //       slot_ = true;
            //     });
            //     print('selectedDay---$selectedDay');
            //     print('focusedDay---$focusedDay');
            //     _selectedDay = selectedDay;
            //     _focusedDay = focusedDay;
            //     DateFormat formatter = DateFormat('yyyy-MM-dd');
            //     String formatted = formatter.format(_selectedDay);
            //     print('formatted----$formatted');
            //     setState(() {});
            //     Map<String, dynamic> data = {
            //       'user_id': widget.doc_id,
            //       'date': formatted,
            //     };
            //     await EasyLoading.show(
            //         status: null, maskType: EasyLoadingMaskType.black);
            //     var res = await Webservices.postData(
            //         apiUrl: ApiUrls.available_slot,
            //         body: data,
            //         context: context);
            //     print('available----slot----$res');
            //     EasyLoading.dismiss();
            //     if (res['status'].toString() == '1') {
            //       available_slot = res['data'];
            //
            //       for (int i = 0; i < available_slot.length; i++) {
            //         available_slot[i]['duration'] = await duration_time(
            //             available_slot[i]['date'] +
            //                 ' ' +
            //                 available_slot[i]['end_time'],
            //             available_slot[i]['date'] +
            //                 ' ' +
            //                 available_slot[i]['start_time']);
            //       }
            //
            //       setState(() {
            //         slot_ = true;
            //       });
            //       print('duration-----$available_slot');
            //     } else {
            //       available_slot = [];
            //       setState(() {
            //         slot_ = false;
            //       });
            //     }
            //     setState(() {
            //       // update `_focusedDay` here as well
            //     });
            //   },
            //   onPageChanged: (focusedDay) {
            //     _focusedDay = focusedDay;
            //     setState(() {});
            //   },
            // ),

            MainHeadingText(
              text: 'Select Available time',
              fontFamily: 'light',
              fontSize: 32,
            ),
            vSizedBox05,
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(0xFE00A2EA).withOpacity(0.1),
              ),
              child: Column(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     for(var i =0; i<4;i++)
                  //     Container(
                  //       padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(8),
                  //         border: Border.all(color: MyColors.primaryColor),
                  //       ),
                  //       child: MainHeadingText(text: '06:00 AM', color: MyColors.primaryColor, fontSize: 14,),
                  //     ),
                  //   ],
                  // ),
                  // vSizedBox,
                  Wrap(
                    runSpacing: 10,
                    direction: Axis.horizontal,
                    spacing: 6,
                    alignment: WrapAlignment.start,
                    children: [
                      for (var i = 0; i < available_slot.length; i++)
                        GestureDetector(
                          onTap: () async {
                            selected_inx = i;
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 6),
                            decoration: BoxDecoration(
                              color: selected_inx == i
                                  ? MyColors.primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: MyColors.primaryColor),
                            ),
                            child: MainHeadingText(
                              text: '${available_slot[i]['date']}, '
                                  '${DateFormat.jm().format(DateFormat('hh:mm').parse(available_slot[i]['start_time']))} '
                                  '(${available_slot[i]['duration']} minutes consultation available)',
                              color: selected_inx == i
                                  ? Colors.white
                                  : MyColors.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      if (slot_ == false)
                        Center(
                          child: Text('Not Available Slot.'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            vSizedBox2,
            RoundEdgedButton(
              text: 'Next',
              color: selected_inx != null ? MyColors.primaryColor : Colors.grey,
              onTap: selected_inx != null
                  ? () async {
                      print('working------');
                      Map<String, dynamic> data = {
                        'user_id': await getCurrentUserId(),
                        'slot_id':
                            available_slot[selected_inx!]['id'].toString(),
                        'specialist_id': widget.doc_id,
                        'symptoms': widget.symptoms != null
                            ? widget.symptoms!.join(',')
                            : '',
                        'head_neck': widget.head_neck != null
                            ? widget.head_neck!.join(',')
                            : '',
                        'description': widget.days != null ? widget.days : '',
                        'days': widget.days != null ? widget.days : '',
                        'category': widget.cate != null
                            ? widget.cate!['id'].toString()
                            : '',
                        'subcategory': widget.sub_cate != null
                            ? widget.sub_cate!['id'].toString()
                            : '',
                        'other_reason': widget.other_reason != null
                            ? widget.other_reason
                            : '',
                        'temperature': widget.temp != null ? widget.temp : '',
                      };
                      // await EasyLoading.show(
                      //     status: null, maskType: EasyLoadingMaskType.black);
                      // var res = await Webservices.postData(
                      //     apiUrl: ApiUrls.Booking,
                      //     body: data,
                      //     context: context);
                      // print('booking------$res');
                      // EasyLoading.dismiss();
                      // if (res['status'].toString() == '1') {
                        push(
                            context: context,
                            screen: ScheduleAppoint(
                              api_request: data,
                              booking_id:'',
                              booking_data: available_slot[selected_inx!]//res['data']['slot_data'],
                            ));
                        // Successpopup(context);
                        // showSnackbar( res['message']);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleAppoint(
                        //   booking_data: res['data'],
                        // )));
                      // } else {
                      //   showSnackbar( res['message']);
                      // }
                    }
                  : null,
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
        Navigator.pop(context);
        // setState(() {
        // });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Booking successful",
        style: TextStyle(color: Colors.green),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //     'Provisionally booked'),
          Text('Your selected consultation slot has been provisionally booked and we have sent a booking request to your healthcare provider'
            'Once your booking request has been accepted, you will be notified, and directed to complete your payment to finalize your booking.'),
          Text('Please note that all booking requests not accepted by your healthcare provider within 2 hours of the request, for all requests made before 8pm, will be automatically cancelled. All requests made between 8pm and 7am will need to be accepted by your healthcare provider by 8am the following morning or will also be automatically cancelled.'),
        ],
      ),
      actions: [
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

  Future<String> duration_time(String datetime1, String datetime2) async {
    print('date1 $datetime1-----date2------$datetime2');
    DateTime dt1 = DateTime.parse(datetime1);
    DateTime dt2 = DateTime.parse(datetime2);
    Duration diff = dt1.difference(dt2);
    print('diff------${diff.inMinutes.toString()}');
    String d = await diff.inMinutes.toString();
    print('d------$d');
    return d;
  }
}
