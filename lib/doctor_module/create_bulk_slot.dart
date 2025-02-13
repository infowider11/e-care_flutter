import 'dart:math';

import 'package:ecare/Services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/modals/slot_preview_modal.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/custom_confirmation_dialog.dart';
import 'package:ecare/widgets/dropdown.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../widgets/customtextfield.dart';

class CreateBulkSlot extends StatefulWidget {
  const CreateBulkSlot({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateBulkSlot> createState() => _CreateBulkSlotState();
}

class _CreateBulkSlotState extends State<CreateBulkSlot> {
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay start_timestamp = TimeOfDay(hour: 7, minute: 0);
  TimeOfDay end_timestamp = TimeOfDay(hour: 18, minute: 0);
  List slots = [];
  bool load = false;
  int s_time = 0;

  ValueNotifier<List<SlotPreviewModal>> slotsListNotifier = ValueNotifier([]);
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  initializeTimes(){
    s_time =
        (start_timestamp.minute) + ((start_timestamp.hour) * 60);


  String time = start_timestamp.format(context);
  print('picked----$time');
  startTimeController.text = time;
    String endTime = end_timestamp.format(context);
  endTimeController.text = endTime;


    String formatted = formatter.format(selectedDate);
    dateController.text = formatted;

  setState(() {});
  }


  Map<String, dynamic> getSlots(){
    Map<String, dynamic> request = {};

    for(int index = 0;index<slotsListNotifier.value.length;index++){
      request['start_time'][index] = slotsListNotifier.value[index].fromTimeText(context);
      request['end_time'][index] = slotsListNotifier.value[index].toTimeText(context);
    }

    return request;
  }

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
    WidgetsBinding.instance.addPostFrameCallback((event){
      get_slots();
      initializeTimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(
          context: context,
          appBarColor: MyColors.BgColor,
          title: 'Bulk Slot Creation',
          fontsize: 20),
      body: load
          ? CustomLoader()
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingText(
                    text:
                        'You can select the start time and end time of your availability. We will automatically create slots of 30 minutes from your start time and end time.',
                    fontSize: 15,
                    fontFamily: 'light',
                  ),
                  vSizedBox4,
                  Container(
                    padding: EdgeInsets.all(16),
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
                              // DateFormat formatter = DateFormat('yyyy-MM-dd');
                              String formatted = formatter.format(m);
                              dateController.text = formatted;
                              selectedDate = m;
                              // print('checking date------${formatted}');
                            }
                          },
                          child: CustomTextField(
                            controller: dateController,
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
                                    initialEntryMode:
                                        TimePickerEntryMode.inputOnly,
                                    context: context,
                                    initialTime: start_timestamp??TimeOfDay(hour: 7, minute: 0),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      s_time =
                                          picked.minute + (picked.hour * 60);
                                    });
                                    start_timestamp = picked;
                                    String time = picked.format(context);
                                    print('picked----$time');
                                    startTimeController.text = time;
                                    setState(() {});
                                  }
                                },
                                child: CustomTextField(
                                  hintText: 'Select Time',
                                  controller: startTimeController,
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
                                    initialEntryMode:
                                        TimePickerEntryMode.inputOnly,
                                    context: context,
                                        initialTime: end_timestamp??TimeOfDay(hour: 18, minute: 0),
                                    // initialTime: TimeOfDay.now(),
                                    // errorInvalidText: 'error'
                                  );
                                  if (picked != null) {
                                    print('unformate----${picked}');
                                    String time = picked.format(context);
                                    print('picked----$time');
                                    int a = picked.minute + (picked.hour * 60);
                                    print('a ---$a');
                                      endTimeController.text = time;
                                      end_timestamp = picked;
                                      setState(() {});
                                    // }
                                  }
                                },
                                child: CustomTextField(
                                  hintText: 'Select Time',
                                  controller: endTimeController,
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
                          text: 'Get Preview',
                          onTap: () {
                            List<SlotPreviewModal> list = [];
                            int startMinute =
                                ((start_timestamp?.hour ?? 0) * 60) +
                                    (start_timestamp?.minute ?? 0);
                            int endMinute = ((end_timestamp?.hour ?? 0) * 60) +
                                (end_timestamp?.minute ?? 0);

                            for(int i = startMinute;i<=endMinute-30;i=i+30){
                              list.add(
                                SlotPreviewModal(
                                  from: TimeOfDay(hour: (i/60).floor(), minute: i%60),

                                  to: TimeOfDay(hour: ((i+30)/60).floor(), minute: (i+30)%60),
                                  dateTime: selectedDate!,
                                ),
                              );
                            }
                            slotsListNotifier.value = list;
                            print('the total slots are ${list.length}');
                          },
                        ),
                        vSizedBox2,
                        RoundEdgedButton(
                          text: 'Create Slot',
                          onTap: () async {
                            print('the url is ${ApiUrls.createBulkSlots}');
                            if (dateController.text == '') {
                              showSnackbar('Please Select Date.');
                            } else if (startTimeController.text == '') {
                              showSnackbar('Please Select Start Time.');
                            } else if (endTimeController.text == '') {
                              showSnackbar('Please Select End Time.');
                            } else {
                              // DateTime startDateTime =  DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, start_timestamp!.hour, start_timestamp!.minute);
                              // DateTime endDateTime =  DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, end_timestamp!.hour, end_timestamp!.minute);

                              Map<String, dynamic> data = {
                                'user_id': await getCurrentUserId(),
                                'date': dateController.text.toString(),
                                // 'start_time': startTimeController.text.toString(),
                                // 'end_time': endTimeController.text.toString(),
                              };

                              data.addAll(getSlots());
                              await EasyLoading.show(
                                status: null,
                                maskType: EasyLoadingMaskType.black,
                              );
                              var res = await Webservices.postData(
                                apiUrl: ApiUrls.createBulkSlots,
                                body: data,
                              );
                              print('create---slot$res');
                              EasyLoading.dismiss();
                              if (res['status'].toString() == '1') {
                                dateController.text = '';
                                startTimeController.text = '';
                                endTimeController.text = '';
                                get_slots();
                                showSnackbar(res['message']);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 50.0,
                  ),
                  SubHeadingText(text: 'Slot Preview'),
                  vSizedBox,
                  SizedBox(
                    height: 400,
                    child: ValueListenableBuilder<List<SlotPreviewModal>>(
                      valueListenable: slotsListNotifier,
                      builder: (context, slotList, child) {
                        return ListView.builder(
                          itemCount: slotList.length,
                          itemBuilder: (context,index){
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                alignment: Alignment.topLeft,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: MyColors.lightBlue.withOpacity(0.11),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text('Date: ${slotList[index].dateTime.toString()}'),
                                          Text(
                                              'Start Time: ${DateFormat.jm().format(DateFormat('hh:mm').parse(slotList[index].from.format(context)))}'),
                                          Text(
                                              'End Time: ${DateFormat.jm().format(DateFormat('hh:mm').parse(slotList[index].to.format(context)))}'),
                                          // if (slots[i]['is_booked'].toString() ==
                                          //     '1')
                                            Text(
                                              'You already have a booking of this slot. You are not able to delete or edit this.',
                                              style:
                                              TextStyle(color: Colors.green),
                                            ),
                                        ],
                                      ),
                                    ),
                                    // if (slots[i]['is_booked'].toString() == '0')
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

                                                    child: IconButton(
                                                      onPressed: ()  async{

                                                      bool? result = await showCustomConfirmationDialog(headingMessage: 'Are your sure?');
                                                      if(result==true){
                                                        slotsListNotifier.value.removeAt(index);
                                                        slotsListNotifier.notifyListeners();
                                                      }
                                                        // remove_slot(
                                                        //     context,
                                                        //     slots[i]['id']
                                                        //         .toString()),
                                                      },
                                                      icon: Icon(Icons
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
                            );
                          },
                        );
                      }
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 50.0,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MainHeadingText(text: 'Slot List'),
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
                              padding: EdgeInsets.all(16.0),
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
                                          Text(
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
                                                icon: Icon(Icons
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
                          Center(
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
