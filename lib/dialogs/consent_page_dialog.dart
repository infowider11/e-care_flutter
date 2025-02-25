// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:flutter/material.dart';

class ConsentPageDialog extends StatelessWidget {
   ConsentPageDialog({Key? key}) : super(key: key);

  // final ValueNotifier<bool> isSelectedNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: double.infinity,
      // width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white
      ),
      child: Column(
        children: [
          const SubHeadingText(text: 'Welcome to E-Care, your trusted Telehealth App.'),
          vSizedBox2,
          const ParagraphText(text: 'As part of our privacy policy, we\'d like to inform you:\nWe may collect and store images uploaded by you for two essential purposes:\n1. Verification purposes\n2. Visual medical consultations to assist with your consultation.\n\nRest assured, your data is treated with the utmost privacy and is exclusively utilized to enhance our app\'s features. Thank you for choosing E-Care for your healthcare needs.',),
          vSizedBox2,
          const ParagraphText(text: 'If you agree to these terms, kindly click on the \'Accept\' button to proceed.'),
          vSizedBox2,
          RoundEdgedButton(text: 'Accept', onTap: (){
            Navigator.pop(context, true);
          },)
        ],
      ),
    );
  }
}
