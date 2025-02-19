import 'package:ecare/Services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/navigation.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/doctor_module/bulk_slot_preview.dart';
import 'package:ecare/doctor_module/edit_slot_screen.dart';
import 'package:ecare/functions/print_function.dart';
import 'package:ecare/modals/slot_preview_modal.dart';
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

class CreateBulkSlot extends StatefulWidget {
  const CreateBulkSlot({
    required Key key,
  }) : super(key: key);

  @override
  State<CreateBulkSlot> createState() => CreateBulkSlotState();
}

class CreateBulkSlotState extends State<CreateBulkSlot> {
  TextEditingController dateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  TimeOfDay start_timestamp =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute + 5);
  TimeOfDay end_timestamp = TimeOfDay(
      hour: DateTime.now().hour + 2, minute: DateTime.now().minute + 5);
  List slots = [];
  bool load = false;
  int s_time = 0;
  List<int> weekdaysAvailable = [];
  List weekdays = [
    {
      "title": "Monday",
      "value": false,
      "day": 1,
    },
    {
      "title": "Tuesday",
      "value": false,
      "day": 2,
    },
    {
      "title": "Wednesday",
      "value": false,
      "day": 3,
    },
    {
      "title": "Thursday",
      "value": false,
      "day": 4,
    },
    {
      "title": "Friday",
      "value": false,
      "day": 5,
    },
    {
      "title": "Saturday",
      "value": false,
      "day": 6,
    },
    {
      "title": "Sunday",
      "value": false,
      "day": 7,
    },
  ];
  ValueNotifier<List<SlotPreviewModal>> slotsListNotifier = ValueNotifier([]);
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  initializeTimes() {
    s_time = (start_timestamp.minute) + ((start_timestamp.hour) * 60);

    String time = DateFormat.jm().format(
        DateTime(2025, 02, 19, start_timestamp.hour, start_timestamp.minute));
    print('picked----$time');
    startTimeController.text = time;
    String endTime = DateFormat.jm().format(
        DateTime(2025, 02, 19, end_timestamp.hour, end_timestamp.minute));
    endTimeController.text = endTime;

    String formatted = formatter.format(selectedStartDate);
    String formattedend = formatter.format(selectedEndDate);
    dateController.text = formatted;
    endDateController.text = formattedend;
    checkWeekdaysInRange(selectedStartDate, selectedEndDate);
  }

  Map<String, dynamic> getSlots() {
    Map<String, dynamic> request = {};

    for (int index = 0; index < slotsListNotifier.value.length; index++) {
      request['start_time[$index]'] =
          "${DateFormat('yyyy-MM-dd').format(slotsListNotifier.value[index].dateTime)} ${slotsListNotifier.value[index].fromTimeText(context)}";
      request['end_time[$index]'] =
          "${DateFormat('yyyy-MM-dd').format(slotsListNotifier.value[index].dateTime)} ${slotsListNotifier.value[index].toTimeText(context)}";
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
    WidgetsBinding.instance.addPostFrameCallback((event) {
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
          title: 'Generate Multiple Slot',
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
                        'Please specify your daily start and end times for availability. The app will automatically create 30-minute appointment slots within this timeframe for patients to book.',
                    fontSize: 15,
                    fontFamily: 'light',
                  ),
                  vSizedBox2,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: MyColors.lightBlue.withOpacity(0.11),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        // DropDown(label: 'Select Date', islabel: true, hint: '01-08-2022',),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  var m = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime(DateTime.now().year + 105),
                                  );
                                  if (m != null) {
                                    // DateFormat formatter = DateFormat('yyyy-MM-dd');
                                    String formatted = formatter.format(m);
                                    dateController.text = formatted;
                                    selectedStartDate = m;
                                    checkWeekdaysInRange(
                                        selectedStartDate, selectedEndDate);
                                    // print('checking date------${formatted}');
                                  }
                                },
                                child: CustomTextField(
                                  controller: dateController,
                                  hintText: 'Select Start Date',
                                  label: 'Select Start Date',
                                  showlabel: true,
                                  enabled: false,
                                  fontsize: 16,
                                  suffixheight: 16,
                                ),
                              ),
                            ),
                            hSizedBox,
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  var m = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime(DateTime.now().year + 105),
                                  );
                                  if (m != null) {
                                    // DateFormat formatter = DateFormat('yyyy-MM-dd');
                                    String formatted = formatter.format(m);
                                    endDateController.text = formatted;
                                    selectedEndDate = m;
                                    checkWeekdaysInRange(selectedStartDate, m);
                                    // print('checking date------${formatted}');
                                  }
                                },
                                child: CustomTextField(
                                  controller: endDateController,
                                  hintText: 'Select End Date',
                                  label: 'Select End Date',
                                  showlabel: true,
                                  enabled: false,
                                  fontsize: 16,
                                  suffixheight: 16,
                                ),
                              ),
                            ),
                          ],
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
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat:
                                                false), // Ensures 12-hour format
                                        child: child!,
                                      );
                                    },
                                    initialTime: start_timestamp ??
                                        const TimeOfDay(hour: 7, minute: 0),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      s_time =
                                          picked.minute + (picked.hour * 60);
                                    });
                                    start_timestamp = picked;
                                    String time = DateFormat.jm().format(
                                        DateTime(2025, 02, 19, picked.hour,
                                            picked.minute));
                                    // String time = picked.format(context);
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
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat:
                                                false), // Ensures 12-hour format
                                        child: child!,
                                      );
                                    },
                                    initialTime: end_timestamp ??
                                        const TimeOfDay(hour: 18, minute: 0),
                                    // initialTime: TimeOfDay.now(),
                                    // errorInvalidText: 'error'
                                  );
                                  if (picked != null) {
                                    print('unformate----${picked}');
                                    // String time = picked.format(context);
                                    // String time = DateFormat.jm().format(DateFormat('hh:mm').parse(.toString()));
                                    String time = DateFormat.jm().format(
                                        DateTime(2025, 02, 19, picked.hour,
                                            picked.minute));
                                    print('asdfasdfasd $time');
                                    // asdfasfas
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
                        vSizedBox,
                        const Align(
                          alignment: Alignment.topLeft,
                          child: ParagraphText(
                            text: "Repeat Availability:",
                            fontSize: 14,
                            color: MyColors.headingcolor,
                            fontFamily: 'regular',
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Wrap(
                            // direction: Axis.horizontal,
                            // textDirection: TextDirection.ltr,
                            spacing: 20,

                            children: [
                              for (int i = 0; i < weekdays.length; i++)
                                if (weekdaysAvailable
                                    .contains(weekdays[i]['day']))
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              weekdays[i]['value'] =
                                                  !weekdays[i]['value'];
                                            });
                                          },
                                          child: Container(
                                            height: 18,
                                            width: 18,
                                            decoration: BoxDecoration(
                                                color: weekdays[i]['value']
                                                    ? MyColors.primaryColor
                                                    : null,
                                                border: Border.all(
                                                  color: MyColors.primaryColor,
                                                )),
                                            child: weekdays[i]['value']
                                                ? const Icon(
                                                    Icons.done,
                                                    size: 12,
                                                    color: MyColors.white,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        hSizedBox,
                                        ParagraphText(
                                          text: weekdays[i]['title'],
                                          fontSize: 12,
                                          color: MyColors.headingcolor,
                                          fontFamily: 'regular',
                                        )
                                      ],
                                    ),
                                  ),
                            ],
                          ),
                        ),
                        vSizedBox2,
                        RoundEdgedButton(
                          text: 'Preview Availability',
                          onTap: () {
                            var dateTime = DateFormat("yyyy-MM-dd h:mm a").parse(
                                "${dateController.text} ${startTimeController.text}");
                            var endDateTime = DateFormat("yyyy-MM-dd h:mm a").parse(
                                "${endDateController.text} ${endTimeController.text}");
                            myCustomLogStatements(
                                "date time $weekdaysAvailable $dateTime  ${dateTime.isAfter(DateTime.now())}");
                            if (weekdaysAvailable.isEmpty) {
                              showSnackbar("Please select repeat availibity ");
                              return;
                            } else if (!dateTime.isAfter(DateTime.now())) {
                              showSnackbar("Please select future start time.");
                              return;
                            } else if (endDateTime.isBefore(dateTime)) {
                              showSnackbar("Please select future end time.");
                              return;
                            }
                            var list = generateBultSlotList();
                            print('the total slots are ${list.length}');
                            push(
                                context: context,
                                screen: BulkSlotPreview(
                                  slotList: list,
                                  endDate: endDateController.text,
                                  startDate: dateController.text,
                                ));
                          },
                        ),
                        vSizedBox2,
                        RoundEdgedButton(
                          text: 'Generate Slots',
                          onTap: () async {
                            var dateTime = DateFormat("yyyy-MM-dd h:mm a").parse(
                                "${dateController.text} ${startTimeController.text}");
                            var endDateTime = DateFormat("yyyy-MM-dd h:mm a").parse(
                                "${endDateController.text} ${endTimeController.text}");

                            print('the url is ${ApiUrls.createBulkSlots}');
                            if (dateController.text == '') {
                              showSnackbar('Please Select Start Date.');
                            } else if (endDateController.text == '') {
                              showSnackbar('Please Select End Date.');
                            } else if (startTimeController.text == '') {
                              showSnackbar('Please Select Start Time.');
                            } else if (endTimeController.text == '') {
                              showSnackbar('Please Select End Time.');
                            } else if (weekdaysAvailable.isEmpty) {
                              showSnackbar("Please select repeat availibity ");
                              return;
                            } else if (!dateTime.isAfter(DateTime.now())) {
                              showSnackbar("Please select future start time.");
                              return;
                            } else if (endDateTime.isBefore(dateTime)) {
                              showSnackbar("Please select future end time.");
                              return;
                            } else {
                              // DateTime startDateTime =  DateTime(selectedStartDate!.year, selectedStartDate!.month, selectedStartDate!.day, start_timestamp!.hour, start_timestamp!.minute);
                              // DateTime endDateTime =  DateTime(selectedStartDate!.year, selectedStartDate!.month, selectedStartDate!.day, end_timestamp!.hour, end_timestamp!.minute);
                              generateBultSlotList();
                              Map<String, dynamic> data = {
                                'user_id': await getCurrentUserId(),
                                'date': dateController.text.toString(),
                                'end_date': endDateController.text.toString(),
                                // 'start_time': startTimeController.text.toString(),
                                // 'end_time': endTimeController.text.toString(),
                              };

                              data.addAll(getSlots());
                              myCustomLogStatements("bulk slot is this $data");

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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () => {
                                            remove_slot(context,
                                                slots[i]['id'].toString()),
                                          },
                                          child: const Icon(
                                            Icons.restore_from_trash_rounded,
                                            color: Colors.red,
                                          ),
                                        ),
                                        vSizedBox05,
                                        InkWell(
                                          onTap: () {
                                            push(
                                                context: context,
                                                screen: EditSlotScreen(
                                                  slotData: slots[i],
                                                ));
                                          },
                                          child: const Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
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
  generateBultSlotList() {
    List<SlotPreviewModal> list = [];

    for (var j = 0;
        j <= selectedEndDate.difference(selectedStartDate).inDays + 1;
        j++) {
      int startMinute =
          ((start_timestamp?.hour ?? 0) * 60) + (start_timestamp?.minute ?? 0);
      int endMinute =
          ((end_timestamp?.hour ?? 0) * 60) + (end_timestamp?.minute ?? 0);

      for (int i = startMinute; i <= endMinute - 30; i = i + 30) {
        var indexExist = weekdays.indexWhere(
          (element) =>
              element["day"] ==
              selectedStartDate.add(Duration(days: j)).weekday,
        );
        if (indexExist != -1 && weekdays[indexExist]['value']) {
          list.add(
            SlotPreviewModal(
              from: TimeOfDay(hour: (i / 60).floor(), minute: i % 60),
              to: TimeOfDay(
                  hour: ((i + 30) / 60).floor(), minute: (i + 30) % 60),
              dateTime: selectedStartDate.add(Duration(days: j))!,
            ),
          );
        }
      }
    }
    slotsListNotifier.value = list;
    return list;
  }

  void checkWeekdaysInRange(DateTime startDate, DateTime endDate) {
    weekdaysAvailable.clear();

    for (DateTime date = startDate;
        date.isBefore(endDate.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      weekdaysAvailable.add(date.weekday);
    }
    myCustomLogStatements(
        "weekdaysAvailable    ---- ${startDate} ${endDate} ${weekdaysAvailable}");
    if (endDate.day == startDate.day &&
        endDate.month == startDate.month &&
        endDate.year == startDate.year) {
      weekdaysAvailable = [weekdaysAvailable[0]];
    }
    for (var i = 0; i < weekdays.length; i++) {
      if (weekdaysAvailable.contains(weekdays[i]['day'])) {
        weekdays[i]['value'] = true;
      } else {
        weekdays[i]['value'] = false;
      }
    }
    weekdaysAvailable = weekdaysAvailable.toSet().toList();
    myCustomLogStatements("weekdaysAvailable    ---- ${weekdaysAvailable}");
    setState(() {});
  }
}
