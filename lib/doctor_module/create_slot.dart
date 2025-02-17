
import 'package:ecare/Services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../widgets/customtextfield.dart';

class CreateSlot extends StatefulWidget {
  final bool isBulk;
  const CreateSlot({Key? key,  this.isBulk = false}) : super(key: key);

  @override
  State<CreateSlot> createState() => _CreateSlotState();
}

class _CreateSlotState extends State<CreateSlot> {
  TextEditingController date = TextEditingController();
  TextEditingController stime = TextEditingController();
  TextEditingController etime = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? start_timestamp;
  TimeOfDay? end_timestamp;
  List slots = [];
  bool load = false;
  int s_time = 0;

  get_slots() async {
    setState(() {
      load = true;
    });
    var res = await Webservices.get(ApiUrls.getslot + await getCurrentUserId());
    print('list----$res');
    setState(() {
      load = false;
    });
    if (res['status'].toString() == '1') {
      slots = res['data'];
      setState(() {});
    } else {
      slots = [];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_slots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(
          context: context,
          appBarColor: MyColors.BgColor,
          title: widget.isBulk?'Bulk Slot Creation':'Create Slot',
          fontsize: 20),
      body: load
          ? const CustomLoader()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const headingText(
                    text:
                        'Each consultation time slot may only be between 15 minutes and 60 minutes in duration. Any time slots created shorter than 15 minutes or longer than 60 minutes will not be accepted by the system.',
                    fontSize: 15,
                    fontFamily: 'light',
                  ),
                  vSizedBox4,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: MyColors.lightBlue.withOpacity(0.11),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        // DropDown(label: 'Select Date', islabel: true, hint: '01-08-2022',),
                        GestureDetector(
                          onTap: () async {
                            var m = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 105),
                            );
                            if (m != null) {
                              DateFormat formatter = DateFormat('yyyy-MM-dd');
                              String formatted = formatter.format(m);
                              date.text = formatted;
                              selectedDate = m;
                              // print('checking date------${formatted}');
                            }
                          },
                          child: CustomTextField(
                            controller: date,
                            hintText: 'Select Date',
                            label: 'Select Date',
                            showlabel: true,
                            enabled: false,
                            fontsize: 16,
                            suffixheight: 16,
                          ),
                        ),
                        vSizedBox,
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final TimeOfDay? picked =
                                      await showTimePicker(
                                      initialEntryMode: TimePickerEntryMode.inputOnly,
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      s_time =
                                          picked.minute + (picked.hour * 60);
                                    });
                                    start_timestamp = picked;
                                    String time = picked.format(context);
                                    print('picked----$time');
                                    stime.text = time;
                                    setState(() {});
                                  }
                                },
                                child: CustomTextField(
                                  hintText: 'Select Time',
                                  controller: stime,
                                  showlabel: true,
                                  enabled: false,
                                  label: 'Start Time',
                                ),
                              ),
                            ),
                            hSizedBox,
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final TimeOfDay? picked =
                                      await showTimePicker(
                                    // useRootNavigator: false,
                                    initialEntryMode: TimePickerEntryMode.inputOnly,
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    // errorInvalidText: 'error'
                                  );
                                  if (picked != null) {
                                    print('unformate----${picked}');
                                    String time = picked.format(context);
                                    print('picked----$time');
                                    int a = picked.minute + (picked.hour * 60);
                                    print('a ---$a');
                                    int diff = 0;
                                    setState(() {
                                      diff = a - s_time;
                                    });
                                    print('diff   $diff');
                                    if (diff > 60) {
                                      showSnackbar(
                                          'Please note that the minimum duration of a consultation slot is 15 minutes and the maximum duration is 60 minutes.');
                                    } else if (diff < 15) {
                                      showSnackbar(
                                          'Please note that the minimum duration of a consultation slot is 15 minutes and the maximum duration is 60 minutes.');
                                    } else {
                                      etime.text = time;
                                      end_timestamp = picked;
                                      setState(() {});
                                    }
                                  }
                                },
                                child: CustomTextField(
                                  hintText: 'Select Time',
                                  controller: etime,
                                  showlabel: true,
                                  enabled: false,
                                  label: 'End Time',
                                ),
                              ),
                            ),
                          ],
                        ),
                        vSizedBox2,
                        RoundEdgedButton(
                          text: 'Create Slot',
                          onTap: () async {
                            if (date.text == '') {
                              showSnackbar('Please Select Date.');
                            } else if (stime.text == '') {
                              showSnackbar('Please Select Start Time.');
                            } else if (etime.text == '') {
                              showSnackbar('Please Select End Time.');
                            } else {

                              // DateTime startDateTime =  DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, start_timestamp!.hour, start_timestamp!.minute);
                              // DateTime endDateTime =  DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, end_timestamp!.hour, end_timestamp!.minute);

                              Map<String, dynamic> data = {
                                'user_id': await getCurrentUserId(),
                                'date': date.text.toString(),
                                'start_time': stime.text.toString(),
                                'end_time': etime.text.toString(),
                                // 'start_timestamp': startDateTime.millisecondsSinceEpoch.toString(),
                                // 'end_timestamp': endDateTime.millisecondsSinceEpoch.toString(),
                              };
                              await EasyLoading.show(
                                status: null,
                                maskType: EasyLoadingMaskType.black,
                              );
                              var res = await Webservices.postData(
                                apiUrl: ApiUrls.CreateSlot,
                                body: data,
                              );
                              print('create---slot$res');
                              EasyLoading.dismiss();
                              if (res['status'].toString() == '1') {
                                date.text = '';
                                stime.text = '';
                                etime.text = '';
                                get_slots();
                                showSnackbar(res['message']);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 50.0,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const MainHeadingText(text: 'Slot List'),
                        for (int i = 0; i < slots.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              alignment: Alignment.topLeft,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: MyColors.lightBlue.withOpacity(0.11),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Date: ${slots[i]['date']}'),
                                        Text(
                                            'Start Time: ${DateFormat.jm().format(DateFormat('hh:mm').parse(slots[i]['start_time']))}'),
                                        Text(
                                            'End Time: ${DateFormat.jm().format(DateFormat('hh:mm').parse(slots[i]['end_time']))}'),
                                        if (slots[i]['is_booked'].toString() ==
                                            '1')
                                          const Text(
                                            'You already have a booking of this slot. You are not able to delete or edit this.',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (slots[i]['is_booked'].toString() == '0')
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Stack(
                                            children: [
                                              Positioned(
                                                  // top: 10,
                                                  // right:0,
                                                  child: IconButton(
                                                onPressed: () => {
                                                  remove_slot(
                                                      context,
                                                      slots[i]['id']
                                                          .toString()),
                                                },
                                                icon: const Icon(Icons
                                                    .restore_from_trash_rounded),
                                                color: Colors.red,
                                              ))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        if (slots.length == 0 && !load)
                          const Center(
                            child: Text('No slot yet.'),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  remove_slot(context, id) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Remove Slot?'),
            content: const Text('Are you sure to remove?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () async {
                    Map<String, dynamic> data = {
                      'user_id': await getCurrentUserId(),
                      'slot_id': id.toString(),
                    };
                    await EasyLoading.show(
                      status: null,
                      maskType: EasyLoadingMaskType.black,
                    );
                    var res = await Webservices.get(
                        ApiUrls.deleteslot + '?slot_id=' + id.toString());
                    EasyLoading.dismiss();
                    if (res['status'].toString() == '1') {
                      get_slots();
                      Navigator.pop(context);
                    }
                    setState(() {
                      // _isShown = false;
                    });
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  conver12hoursFormat(time) {
    // String time  = DateFormat("h:mma").format(time);
  }
}
