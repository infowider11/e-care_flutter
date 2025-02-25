// ignore_for_file: non_constant_identifier_names

import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/services/validation.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:flutter/material.dart';

import 'long_felt_way.dart';

class ReasonVisit extends StatefulWidget {
  final Map? cate;
  const ReasonVisit({Key? key,this.cate}) : super(key: key);

  @override
  State<ReasonVisit> createState() => _ReasonVisitState();
}

class _ReasonVisitState extends State<ReasonVisit> {
  TextEditingController other_reason = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainHeadingText(text: 'What is the reason for your visit?', fontSize: 32, fontFamily: 'light',),
            vSizedBox4,
            CustomTextField(controller: other_reason, hintText: 'I would like to focus on...'),
            vSizedBox2,
            RoundEdgedButton(
              text: 'Continue',
              onTap: () async{
                if(validateString(other_reason.text, 'Please Enter Reason', context)==null){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HowLongFeltThisWay(
                            cate:widget.cate,
                            other_reason:other_reason.text,
                          )));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
