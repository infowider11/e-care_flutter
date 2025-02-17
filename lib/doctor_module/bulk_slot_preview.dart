import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/global_keys.dart';
import 'package:ecare/constants/navigation.dart';
import 'package:ecare/functions/print_function.dart';
import 'package:ecare/modals/slot_preview_modal.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/custom_confirmation_dialog.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class BulkSlotPreview extends StatefulWidget {
  final List<SlotPreviewModal> slotList;
  final String startDate;
  final String endDate;
  const BulkSlotPreview(
      {super.key,
      required this.slotList,
      required this.endDate,
      required this.startDate});

  @override
  State<BulkSlotPreview> createState() => _BulkSlotPreviewState();
}

class _BulkSlotPreviewState extends State<BulkSlotPreview> {
  ValueNotifier<List<SlotPreviewModal>> slotsListNotifier = ValueNotifier([]);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        slotsListNotifier.value = widget.slotList;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.BgColor,
        appBar: appBar(
            context: context,
            appBarColor: MyColors.BgColor,
            title: 'Multiple Slot Preview',
            fontsize: 20),
        bottomNavigationBar: RoundEdgedButton(
          horizontalMargin: 20,
          verticalMargin: 10,
          text: 'Generate Slots',
          onTap: () async {
            // DateTime startDateTime =  DateTime(selectedStartDate!.year, selectedStartDate!.month, selectedStartDate!.day, start_timestamp!.hour, start_timestamp!.minute);
            // DateTime endDateTime =  DateTime(selectedStartDate!.year, selectedStartDate!.month, selectedStartDate!.day, end_timestamp!.hour, end_timestamp!.minute);

            Map<String, dynamic> data = {
              'user_id': await getCurrentUserId(),
              'date': widget.startDate,
              'end_date': widget.endDate
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
              popPage(context: context);
              MyGlobalKeys.createBulkSlotPage.currentState!.get_slots();
              showSnackbar(res['message']);
            }
          },
        ),
        body: ValueListenableBuilder<List<SlotPreviewModal>>(
            valueListenable: slotsListNotifier,
            builder: (context, slotList, child) {
              return ListView.builder(
                itemCount: slotList.length,
                itemBuilder: (context, index) {
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Date: ${slotList[index].dateTime.toString()}'),
                                Text(
                                    'Start Time: ${DateFormat.jm().format(DateFormat('hh:mm').parse(slotList[index].from.format(context)))}'),
                                Text(
                                    'End Time: ${DateFormat.jm().format(DateFormat('hh:mm').parse(slotList[index].to.format(context)))}'),
                                // // if (slots[i]['is_booked'].toString() ==
                                // //     '1')
                                // Text(
                                //   'You already have a booking of this slot. You are not able to delete or edit this.',
                                //   style: TextStyle(
                                //       color: Colors.green),
                                // ),
                              ],
                            ),
                          ),
                          // if (slots[i]['is_booked'].toString() == '0')
                          IconButton(
                            onPressed: () async {
                              bool? result = await showCustomConfirmationDialog(
                                  headingMessage: 'Are your sure?',
                                  description: "You want remove this slot");
                              if (result == true) {
                                slotsListNotifier.value.removeAt(index);
                                if (slotsListNotifier.value.isEmpty) {
                                  popPage(context: context);
                                }
                                slotsListNotifier.notifyListeners();
                              }
                              // remove_slot(
                              //     context,
                              //     slots[i]['id']
                              //         .toString()),
                            },
                            icon: Icon(Icons.restore_from_trash_rounded),
                            color: Colors.red,
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }));
  }

  Map<String, dynamic> getSlots() {
    Map<String, dynamic> request = {};

    for (int index = 0; index < slotsListNotifier.value.length; index++) {
      request['start_time[$index]'] =
          slotsListNotifier.value[index].fromTimeText(context);
      request['end_time[$index]'] =
          slotsListNotifier.value[index].toTimeText(context);
    }

    return request;
  }
}
