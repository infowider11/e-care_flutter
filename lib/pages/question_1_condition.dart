// ignore_for_file: must_be_immutable, deprecated_member_use, avoid_print, non_constant_identifier_names

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/question_1_surgeries.dart';
import 'package:ecare/pages/question_2_conditions.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
 
import 'package:flutter/material.dart';

class Question1Conditions extends StatefulWidget {
  List? first_step_arr = [];
  List? second_step_arr = [];
  Question1Conditions({Key? key, this.first_step_arr, this.second_step_arr})
      : super(key: key);

  @override
  State<Question1Conditions> createState() => Question1ConditionsState();
}

class Question1ConditionsState extends State<Question1Conditions>
    with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  late AnimationController controller;

  @override
  void initState() {
    
    super.initState();
    print('first_step_arr----${widget.first_step_arr}');
    print('second_step_arr----${widget.second_step_arr}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSizedBox2,
            const MainHeadingText(
              text: '3/5',
              fontSize: 35,
            ),
            vSizedBox,
            const ClipRRect(
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
            const MainHeadingText(
              text: 'Do you have any medical conditions? ',
              fontSize: 32,
              fontFamily: 'light',
            ),
            // vSizedBox2,
            // ParagraphText(
            //     fontSize: 16,
            //     text:
            //         'Not sure? Choose yes to browse a list of conditions and diseases.'),
            vSizedBox,
            ParagraphText(
                fontSize: 12,
                color: MyColors.black.withOpacity(0.3),
                text: 'Example: High Cholesterol, Insomnia, Asthma'),
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
                          builder: (context) => Question1Surgeries())),
                ),
                hSizedBox,
                RoundEdgedButton(
                    text: 'Yes',
                    width: 100,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Question2Conditions(
                                  first_step_arr: widget.first_step_arr,
                                  second_step_arr: widget.second_step_arr)));
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
