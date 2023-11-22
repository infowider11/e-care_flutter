import 'package:ecare/constants/colors.dart';
import 'package:ecare/pages/choose_schedule.dart';
import 'package:ecare/pages/schedule_appointment.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/dropdown.dart';
import 'package:flutter/material.dart';

import '../constants/sized_box.dart';

class MoneyRequest extends StatefulWidget {
  const MoneyRequest({Key? key}) : super(key: key);

  @override
  State<MoneyRequest> createState() => _MoneyRequestState();
}

class _MoneyRequestState extends State<MoneyRequest> {
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(
        context: context,
        appBarColor: Color(0xFE00A2EA).withOpacity(0.11)
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xFE00A2EA).withOpacity(0.11),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainHeadingText(text: 'Enter Request Money for Withdraw', fontFamily: 'light', fontSize: 32),
              vSizedBox4,
              
              CustomTextField(controller: email, hintText: 'Enter Request Money', showlabel: true, label: 'Enter Request Money',),
              vSizedBox4,

              RoundEdgedButton(text: 'Raise request')
            ],
          ),
        ),
      ),
    );
  }
}