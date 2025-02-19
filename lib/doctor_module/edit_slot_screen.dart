
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

class EditSlotScreen extends StatefulWidget {
  final Map slotData;
  const EditSlotScreen({Key? key, required this.slotData}) : super(key: key);

  @override
  State<EditSlotScreen> createState() => _EditSlotScreenState();
}

class _EditSlotScreenState extends State<EditSlotScreen> {
  TextEditingController date = TextEditingController();
  TextEditingController stime = TextEditingController();
  TextEditingController etime = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? start_timestamp;
  TimeOfDay? end_timestamp;
  bool load = false;
  int s_time = 0;

  

  @override
  void initState() {
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    date.text = widget.slotData['date'];
    stime.text = widget.slotData['start_time'];
    etime.text = widget.slotData['end_time'];

   },)
   ; super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(
          context: context,
          appBarColor: MyColors.BgColor,
          title:'Edit Slot',
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
                          text: 'Edit Slot',
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
                                'id':widget.slotData['id'],
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
                                apiUrl: ApiUrls.editSlot,
                                body: data,
                              );
                              print('create---slot$res');
                              EasyLoading.dismiss();
                              if (res['status'].toString() == '1') {
                                date.text = '';
                                stime.text = '';
                                etime.text = '';
                                showSnackbar(res['message']);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  
                ],
              ),
            ),
    );
  }


}
