import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/navigation.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/homepage.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_2_allergies.dart';
import 'package:ecare/pages/question_2_medication.dart';
import 'package:ecare/pages/question_2_surgeries.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../functions/global_Var.dart';
import '../tabs.dart';

class ComingConsultation extends StatefulWidget {
  const ComingConsultation({Key? key}) : super(key: key);

  @override
  State<ComingConsultation> createState() => ComingConsultationState();
}

class ComingConsultationState extends State<ComingConsultation>
    with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  bool is_yes = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vSizedBox2,
                MainHeadingText(
                  height: 1.2,
                  text:
                      'Will you be needing a doctor\'s note/ healthcare practitioner\'s note for your coming consultations? ',
                  fontSize: 32,
                  fontFamily: 'light',
                ),
                vSizedBox2,
                ParagraphText(
                    fontSize: 16,
                    text:
                        'For example: a note to be excused from work or school etc. Please inform your healthcare practitioner during your consult that this will be required as well.'),
                vSizedBox4,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RoundEdgedButton(
                      horizontalPadding: 10,
                      text: 'Yes',
                      width: 75,
                      borderRadius: 100,
                      isSolid: is_yes,
                      onTap: () async{
                        is_yes=true;
                        setState(() {

                        });
                      },
                    ),
                    hSizedBox05,
                    RoundEdgedButton(
                      horizontalPadding: 10,
                      text: 'No',
                      width: 70,
                      borderRadius: 100,
                      isSolid: !is_yes,
                      onTap: () async{
                        is_yes=false;
                        setState(() {

                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RoundEdgedButton(
                    text: 'Continue',
                    onTap: () async{
                      Map<String,dynamic> data = {
                        'user_id':await getCurrentUserId(),
                        'step7':'7',
                        'doctor_need':is_yes?'1':'0',
                      };
                      await EasyLoading.show(
                        status: null,
                        maskType: EasyLoadingMaskType.black,
                      );
                      var res = await Webservices.postData(apiUrl: ApiUrls.healthProfile, body: data, context: context);
                      if(res['status'].toString()=='1'){
                        // var val = await Webservices.get(ApiUrls.skip+'?user_id='+await getCurrentUserId());
                        // if(val['status'].toString()=='1'){
                          var userdata = await Webservices.get(
                              ApiUrls.get_user_by_id + '?user_id=' + user_Data!['id'].toString());
                            EasyLoading.dismiss();
                          // if(userdata['status'].toString()=='1')
                          updateUserDetails(userdata['data']);
                          setState(() {
                            user_Data=userdata['data'];
                          });
                          pushAndPopAll(context: context, screen:tabs_second_page());
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => tabs_second_page()));
                          showSnackbar( 'Health Profile submitted successfully.');
                        // }
                      } else {

                      }
                    },
                  ),
                  RoundEdgedButton(
                    text: 'Skip',
                    color: Colors.transparent,
                    textColor: MyColors.primaryColor,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => tabs_second_page())),
                  ),
                  vSizedBox2
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
