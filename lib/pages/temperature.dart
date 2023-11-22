import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_1_allergies.dart';
import 'package:ecare/pages/question_1_condition.dart';
import 'package:ecare/pages/question_1_medication.dart';
import 'package:ecare/pages/schedule.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'choose_doctor.dart';

class TemparaturePage extends StatefulWidget {
  final Map? cate;
  final Map? sub_cate;
  final String? other_reason;
  final String? days;
  final List? symptoms;
  final List? head_neck;
  const TemparaturePage(
      {Key? key,
      this.cate,
      this.sub_cate,
      this.other_reason,
      this.days,
      this.symptoms,
      this.head_neck})
      : super(key: key);

  @override
  State<TemparaturePage> createState() => _TemparaturePageState();
}

class _TemparaturePageState extends State<TemparaturePage> {
  TextEditingController temp = TextEditingController();
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
            MainHeadingText(
              text: 'Add your temperature ',
              fontSize: 32,
              fontFamily: 'light',
            ),
            vSizedBox2,
            ParagraphText(
                fontSize: 16,
                text:
                    'If you have a thermometer, please add your temperature now'),
            vSizedBox2,

            CustomTextField(controller: temp, hintText: 'Temperature',keyboardType: TextInputType.number,),
            // vSizedBox,

            // ParagraphText(fontSize: 16, text: 'Thermometer Location'),
            // vSizedBox,
            // DropDown(),

            vSizedBox2,
            RoundEdgedButton(
              text: 'Save',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChooseDoctor(
                      cate:widget.cate,
                      sub_cate: widget.sub_cate,
                      other_reason:widget.other_reason,
                      days: widget.days,
                      symptoms:widget.symptoms,
                      head_neck:widget.head_neck,
                      temp: temp.text,
                    )));
              }
            ),
            RoundEdgedButton(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        ChooseDoctor(
                      cate:widget.cate,
                      sub_cate: widget.sub_cate,
                      other_reason:widget.other_reason,
                      days: widget.days,
                      symptoms:widget.symptoms,
                      head_neck:widget.head_neck,
                      temp: temp.text,
                    )));
              },
              text: 'Skip',
              color: Colors.transparent,
              textColor: MyColors.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
