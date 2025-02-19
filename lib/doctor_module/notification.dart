import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/navigation.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/pages/chat.dart';
import 'package:ecare/pages/notification.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';

import '../tabs_doctor.dart';

class DoctorNotificationPage extends StatefulWidget {
  const DoctorNotificationPage({Key? key}) : super(key: key);

  @override
  State<DoctorNotificationPage> createState() => _DoctorNotificationPageState();
}

class _DoctorNotificationPageState extends State<DoctorNotificationPage> {
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
          ? CustomLoader()
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainHeadingText(
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
                      onTap: () async {
                        if (lists[i]['other']['screen'] == 'booking') {
                          pushReplacement(
                              context: context,
                              screen: tabs_third_page(
                                initialIndex: 2,
                              ));
                        } else if (lists[i]['other']['screen'] ==
                            'booking_chat') {
                          push(
                              context: context,
                              screen: ChatPage(
                                  booking_id: lists[i]['other']['booking_id']
                                      .toString(),
                                  other_user_id: lists[i]['other']['sender_id']
                                              .toString() ==
                                          user_Data!['id'].toString()
                                      ? lists[i]['other']['receiver_id']
                                          .toString()
                                      : lists[i]['other']['sender_id']
                                          .toString()));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding:
                              EdgeInsets.only(top: 10, right: 10, bottom: 10,left: 10),
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
                                     color: MyColors.red,
                                    borderRadius: 8,
                                    horizontalPadding: 0,
                                    height: 25,
                                    fontSize: 8,
                                    onTap: () {
                                      removeNotification(
                                        context,
                                        id: "",
                                        onSuccess: (p0) {
                                          lists.removeAt(i);
                                          setState(() {
                                            
                                          });
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
                    Center(
                      child: Text('No Data Found.'),
                    ),
                ],
              ),
            ),
    );
  }
}
