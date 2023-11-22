import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_1_condition.dart';
import 'package:ecare/pages/question_2_allergies.dart';
import 'package:ecare/pages/question_2_medication.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Question1Allergies extends StatefulWidget {
  List? first_step_arr = [];
  Question1Allergies({Key? key, this.first_step_arr}) : super(key: key);

  @override
  State<Question1Allergies> createState() => Question1AllergiesState();
}

class Question1AllergiesState extends State<Question1Allergies>
    with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  late AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('1st step data-----${widget.first_step_arr}');
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
              text: '2/5',
              fontSize: 35,
            ),
            vSizedBox,
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                minHeight: 10,
                backgroundColor: MyColors.loadingbar,
                color: MyColors.primaryColor,
                value: 0.30,
                semanticsLabel: 'Linear progress indicator',
              ),
            ),
            vSizedBox2,
            MainHeadingText(
              text: 'Do you have any drug allergies? ',
              fontSize: 32,
              fontFamily: 'light',
            ),
            vSizedBox2,
            ParagraphText(
                fontSize: 16, text: 'Example: Amoxicillin, Bactrim, Aspirin'),
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
                            builder: (context) => Question1Conditions()));
                  },
                ),
                hSizedBox,
                RoundEdgedButton(
                  text: 'Yes',
                  width: 100,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Question2Allergies(first_step_arr:widget.first_step_arr))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
