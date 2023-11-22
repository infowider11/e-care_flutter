import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_2_allergies.dart';
import 'package:ecare/pages/question_2_family_conditions.dart';
import 'package:ecare/pages/question_2_medication.dart';
import 'package:ecare/pages/relatives.dart';
import 'package:ecare/pages/review_profile.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Question1FamilyConditions extends StatefulWidget {
  const Question1FamilyConditions({Key? key}) : super(key: key);

  @override
  State<Question1FamilyConditions> createState() =>
      Question1FamilyConditionsState();
}

class Question1FamilyConditionsState extends State<Question1FamilyConditions>
    with TickerProviderStateMixin {
  TextEditingController search = TextEditingController();
  late AnimationController controller;
  bool isChecked = false;
  List conditions = [];
  List seleted_arr = [];
  bool load = false;
  int count = 0;
  bool add_another = false;

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
              text: '5/5',
              fontSize: 35,
            ),
            vSizedBox,
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                minHeight: 10,
                backgroundColor: MyColors.loadingbar,
                color: MyColors.primaryColor,
                value: 1,
                semanticsLabel: 'Linear progress indicator',
              ),
            ),
            vSizedBox2,
            MainHeadingText(
              text: 'Has anyone in your family had any medical conditions? ',
              fontSize: 32,
              fontFamily: 'light',
            ),
            vSizedBox2,
            //Please only include first degree relatives.
            ParagraphText(
                fontSize: 16,
                text:
                    '(parents, siblings, and children).'),
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
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewProfile())), //ReviewProfile()
                ),
                hSizedBox,
                RoundEdgedButton(
                  text: 'Yes',
                  width: 100,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Question2FamilyConditions())),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
