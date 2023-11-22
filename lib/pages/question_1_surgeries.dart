import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_1_family_conditions.dart';
import 'package:ecare/pages/question_2_allergies.dart';
import 'package:ecare/pages/question_2_medication.dart';
import 'package:ecare/pages/question_2_surgeries.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Question1Surgeries extends StatefulWidget {
  List? first_step_arr = [];
  List? second_step_arr = [];
  List? thired_step_arr = [];
  String? thired_step_other_val;
  Question1Surgeries(
      {Key? key,
      this.first_step_arr,
      this.second_step_arr,
      this.thired_step_arr,
      this.thired_step_other_val})
      : super(key: key);

  @override
  State<Question1Surgeries> createState() => Question1SurgeriesState();
}

class Question1SurgeriesState extends State<Question1Surgeries>
    with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  late AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('first_step_arr----${widget.first_step_arr}');
    print('second_step_arr----${widget.second_step_arr}');
    print('thired_step_arr----${widget.thired_step_arr}');
    print('thired_step_other_val----${widget.thired_step_other_val}');
  }

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
              text: '4/5',
              fontSize: 35,
            ),
            vSizedBox,
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                minHeight: 10,
                backgroundColor: MyColors.loadingbar,
                color: MyColors.primaryColor,
                value: 0.8,
                semanticsLabel: 'Linear progress indicator',
              ),
            ),
            vSizedBox2,
            MainHeadingText(
              text: 'Have you had any surgeries? ',
              fontSize: 32,
              fontFamily: 'light',
            ),
            vSizedBox2,
            ParagraphText(
                fontSize: 16,
                text: 'Example: Appendectomy, Tonsillectomy, Knee replacement'),
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
                          builder: (context) => Question1FamilyConditions())),
                ),
                hSizedBox,
                RoundEdgedButton(
                  text: 'Yes',
                  width: 100,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Question2Surgeries(
                            first_step_arr:widget.first_step_arr,second_step_arr:widget.second_step_arr,
                            thired_step_arr:widget.thired_step_arr,thired_step_other_val:widget.thired_step_other_val,
                          ))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
