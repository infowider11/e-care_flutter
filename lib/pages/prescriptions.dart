import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/list_ui_1.dart';
 
import 'package:flutter/material.dart';

class PrescriptionsPage extends StatefulWidget {
  const PrescriptionsPage({Key? key}) : super(key: key);

  @override
  State<PrescriptionsPage> createState() => PrescriptionsPageState();
}

class PrescriptionsPageState extends State<PrescriptionsPage> with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  late AnimationController controller;

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
            const MainHeadingText(text: 'Prescriptions ', fontSize: 32, fontFamily: 'light',),
            vSizedBox2,
            const ParagraphText(fontSize: 16, text: 'Download documents from your Healthcare Practitioner here'),
            vSizedBox4,

            ListUI01(heading: 'Cold'),
            ListUI01(heading: 'Coronavirus (Covid 19)',),
            ListUI01(heading: 'Cough',),
          ],
        ),
      ),
    );
  }
}
