import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/material.dart';

import 'choose_doctor.dart';

class SchedulePage extends StatefulWidget {
  final Map? cate;
  final Map? sub_cate;
  final String? other_reason;
  final String? days;
  final List? symptoms;
  final List? head_neck;
  final String? temp;
  const SchedulePage({
    Key? key,
    this.cate,
    this.sub_cate,
    this.other_reason,
    this.days,
    this.symptoms,
    this.head_neck,
    this.temp,
  }) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  TextEditingController temp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(context: context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MainHeadingText(
                text: 'How to Schedule? ',
                fontFamily: 'light',
                fontSize: 32,
              ),
              vSizedBox05,
              const ParagraphText(
                text: 'How would you like to Schedule?',
                fontSize: 16,
              ),
              vSizedBox,
              RoundEdgedButton(
                borderRadius: 100,
                text: 'See next available Doctor',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder:(context) => ChooseDoctor(
                        cate:widget.cate,
                        sub_cate: widget.sub_cate,
                        other_reason:widget.other_reason,
                        days: widget.days,
                        symptoms:widget.symptoms,
                        head_neck:widget.head_neck,
                        temp: temp.text,
                      )));
                },
                bordercolor: MyColors.primaryColor,
                color: MyColors.white,
                textColor: MyColors.primaryColor,
              ),
              vSizedBox,
              RoundEdgedButton(
                borderRadius: 100,
                text: 'Schedule an appointment',
                onTap: () {
                  showSnackbar('Comming Soon.');
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => ChooseSchedule()));
                },
                bordercolor: MyColors.primaryColor,
                color: MyColors.white,
                textColor: MyColors.primaryColor,
              ),
              vSizedBox8,
              const ParagraphText(
                  textAlign: TextAlign.center,
                  text:
                      'Please note that each healthcare practitioner charges their own consultation rates. You can choose the rate you would like to pay by simply clicking on the filter tab on the next page and updating your preference')
            ],
          ),
        ),
      ),
    );
  }
}
