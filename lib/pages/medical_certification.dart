import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_2_allergies.dart';
import 'package:ecare/pages/question_2_medication.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/list_ui_1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MedicalCertification extends StatefulWidget {
  const MedicalCertification({Key? key}) : super(key: key);

  @override
  State<MedicalCertification> createState() => MedicalCertificationState();
}

class MedicalCertificationState extends State<MedicalCertification> with TickerProviderStateMixin {
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
            MainHeadingText(text: 'Medical Certification ', fontSize: 32, fontFamily: 'light',),
            vSizedBox2,
            ParagraphText(fontSize: 16, text: 'Download documents from your Healthcare Practitioner here'),
            vSizedBox4,

            for(var i=0; i<3; i++)
            ListUI01(heading: 'Document Name ${i+1}'),
          ],
        ),
      ),
    );
  }
}
