import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/navigation.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/booked_visit.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool load = false;
  List lists = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_noti();
    read_noti();
  }

  get_noti() async {
    setState(() {
      load = true;
    });
    var res = await Webservices.getList(
        ApiUrls.GetNotification + await getCurrentUserId());
    print('res----$res');
    lists = res;
    setState(() {
      load = false;
    });
  }

  read_noti() async {
    var res = await Webservices.getList(
        ApiUrls.MarkAsReadNotification + await getCurrentUserId());
    print('----res-----$res');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(context: context),
      body: load
          ? const CustomLoader()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MainHeadingText(
                    text: 'Notification',
                    fontSize: 32,
                    fontFamily: 'light',
                  ),

                  // vSizedBox,
                  // MainHeadingText(text: 'Today', color: MyColors.headingcolor, fontSize: 16,),
                  // vSizedBox,
                  // AppointmentBlock(
                  //   bgColor: MyColors.lightBlue.withOpacity(0.11),
                  //   showButton: true,
                  // ),

                  vSizedBox,
                  for (int i = 0; i < lists.length; i++)
                    GestureDetector(
                      onTap: () {
                        if (lists[i]['other']['screen'] == 'booking') {
                          push(context: context, screen: const BookedVisit());
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, bottom: 10.0),
                          decoration: BoxDecoration(
                            color: MyColors.lightBlue.withOpacity(0.11),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ParagraphText(
                                    text: '${lists[i]['create_date']}',
                                    fontSize: 8,
                                    color: MyColors.headingcolor,
                                  )
                                ],
                              ),
                              MainHeadingText(
                                text: '${lists[i]['message']}',
                                fontSize: 14,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MainHeadingText(
                                      text: '${lists[i]['title']}',
                                      fontFamily: 'light',
                                      fontSize: 14,
                                    ),
                                  ),
                                  RoundEdgedButton(
                                    text: "Delete",
                                    width: 60,
                                    borderRadius: 8,
                                    color: MyColors.red,
                                    horizontalPadding: 0,
                                    height: 25,
                                    fontSize: 8,
                                    onTap: () {
                                      removeNotification(
                                        context,
                                        id: "",
                                        onSuccess: (p0) {
                                          lists.removeAt(i);
                                          setState(() {});
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (lists.length == 0)
                    const Center(
                      child: Text('No Data Found.'),
                    ),
                ],
              ),
            ),
    );
  }
}

removeNotification(context,
    {required String id, required Function(String) onSuccess}) async {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Remove Notification?'),
          content:
              const Text('Are you sure you want to remove this notification'),
          actions: [
            // The "Yes" button
            TextButton(
                onPressed: () async {
                  // Map<String, dynamic> data = {
                  //   'user_id': await getCurrentUserId(),
                  //   'notification_id': id.toString(),
                  // };
                  await EasyLoading.show(
                    status: null,
                    maskType: EasyLoadingMaskType.black,
                  );
                  var res = await Webservices.get(
                      ApiUrls.deleteNotification + '?slot_id=' + id.toString());
                  EasyLoading.dismiss();
                  if (res['status'].toString() == '1') {
                    Navigator.pop(context);
                    onSuccess(id);
                  }
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
