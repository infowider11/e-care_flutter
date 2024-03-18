import 'package:ecare/services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_2_allergies.dart';
import 'package:ecare/pages/question_2_medication.dart';
import 'package:ecare/pages/question_2_surgeries.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'need_consultation.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({Key? key}) : super(key: key);

  @override
  State<HabitsPage> createState() => HabitsPageState();
}

class HabitsPageState extends State<HabitsPage> with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  List lists = [];
  bool load = false;

  get_habits() async {
    setState(() {
      load = true;
    });
    var res = await Webservices.get(ApiUrls.gethabitquestion);
    print('habit list-----$res');
    if (res['status'].toString() == '1') {
      lists = res['data'];
      setState(() {});
    }
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_habits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RoundEdgedButton(
            horizontalMargin: 16,
              text: 'Continue',
              onTap: () async {
                Map<String, dynamic> data = {
                  'user_id': await getCurrentUserId(),
                };
                for (int i = 0; i < lists.length; i++) {
                  data['question_id'] = lists[i]['id'].toString();
                  data['ans_type'] =
                      lists[i]['value_status'].toString();
                }
                await EasyLoading.show(
                  status: null,
                  maskType: EasyLoadingMaskType.black,
                );
                var res = await Webservices.postData(
                    apiUrl: ApiUrls.PatientHabit,
                    body: data,
                    context: context);
                EasyLoading.dismiss();
                print('submit----$res');
                if (res['status'].toString() == '1') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ComingConsultation()));
                } else {}
              }),
          RoundEdgedButton(
            text: 'Skip',
            color: Colors.transparent,
            textColor: MyColors.primaryColor,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ComingConsultation())),
          ),
          vSizedBox2
        ],
      ),
      body: load
          ? CustomLoader()
          : SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    vSizedBox2,
                    MainHeadingText(
                      text: 'Tell us about your habits ',
                      fontSize: 32,
                      fontFamily: 'light',
                    ),
                    vSizedBox2,
                    ParagraphText(
                        fontSize: 16,
                        text:
                            'Please provide the following information to help your provider get a better understanding of your lifestyle. '),
                    vSizedBox4,
                    for (int i = 0; i < lists.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: MyColors.bordercolor, width: 1),
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainHeadingText(
                                text: '${lists[i]['question']}',
                                fontSize: 16,
                                fontFamily: 'light',
                              ),
                              MainHeadingText(
                                  text: '${lists[i]['sub_text']}',
                                  fontSize: 14,
                                  fontFamily: 'light',
                                  color: MyColors.onsurfacevarient),
                              vSizedBox4,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RoundEdgedButton(
                                    horizontalPadding: 10,
                                    text: 'Yes',
                                    width: 75,
                                    borderRadius: 100,
                                    isSolid:
                                        lists[i]['value_status'].toString() ==
                                                '1'
                                            ? true
                                            : false,
                                    onTap: () async {
                                      lists[i]['value_status'] = '1';
                                      setState(() {});
                                    },
                                  ),
                                  hSizedBox05,
                                  RoundEdgedButton(
                                    horizontalPadding: 10,
                                    text: 'No',
                                    width: 70,
                                    borderRadius: 100,
                                    isSolid:
                                        lists[i]['value_status'].toString() ==
                                                '0'
                                            ? true
                                            : false,
                                    onTap: () async {
                                      lists[i]['value_status'] = '0';
                                      setState(() {});
                                    },
                                  ),
                                  hSizedBox05,
                                  RoundEdgedButton(
                                    text: 'In the past',
                                    horizontalPadding: 10,
                                    width: 120,
                                    borderRadius: 100,
                                    isSolid:
                                        lists[i]['value_status'].toString() ==
                                                '2'
                                            ? true
                                            : false,
                                    onTap: () async {
                                      lists[i]['value_status'] = '2';
                                      setState(() {});
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    vSizedBox2,

                  ],
                ),
              ),
          ),
    );
  }
}
