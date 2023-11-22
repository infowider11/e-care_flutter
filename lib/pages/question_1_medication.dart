import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_1_allergies.dart';
import 'package:ecare/pages/question_2_medication.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Question1Medication extends StatefulWidget {
  const Question1Medication({Key? key}) : super(key: key);

  @override
  State<Question1Medication> createState() => Question1MedicationState();
}

class Question1MedicationState extends State<Question1Medication>
    with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  late AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSizedBox2,
            MainHeadingText(
              text: '1/5',
              fontSize: 35,
            ),
            vSizedBox,
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                minHeight: 10,
                backgroundColor: MyColors.loadingbar,
                color: MyColors.primaryColor,
                value: 0.1,
                semanticsLabel: 'Linear progress indicator',
              ),
            ),
            vSizedBox2,
            MainHeadingText(
              text: 'Are you currently taking any medications? ',
              fontSize: 32,
              fontFamily: 'light',
            ),
            vSizedBox2,
            ParagraphText(
                fontSize: 16,
                text:
                    'Please consider any medication you are taking, including those taken on a regular basis.'),
            vSizedBox4,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RoundEdgedButton(
                  text: 'No',
                  width: 100,
                  color: Colors.transparent,
                  textColor: MyColors.primaryColor,
                  bordercolor: MyColors.bordercolor,
                  onTap: () async{
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Question1Allergies()));
                  },
                ),
                hSizedBox,
                RoundEdgedButton(
                  text: 'Yes',
                  width: 100,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Question2Medication())),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
