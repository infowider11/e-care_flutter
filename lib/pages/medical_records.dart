import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/medical_certification.dart';
import 'package:ecare/pages/prescriptions.dart';
import 'package:ecare/pages/sick_notes.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/setting_list.dart';
import 'package:flutter/material.dart';

import 'lab_test.dart';

class MedicalRecords extends StatefulWidget {
  const MedicalRecords({Key? key}) : super(key: key);

  @override
  State<MedicalRecords> createState() => _MedicalRecordsState();
}

class _MedicalRecordsState extends State<MedicalRecords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeadingText(text: 'Medical Documents from my Healthcare providers', fontSize: 32, fontFamily: 'light',),
            vSizedBox,
            SettingList(heading: 'Prescriptions/Referrals', func: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LabTestPage()))),
            SettingList(heading: 'Sick notes', func: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => SickNotesPage()))),
            // SettingList(heading: 'Medical certificates', func: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalCertification()))),
            // SettingList(heading: 'Referrals from my healthcare practitioner', func: () {}),
          ],
        ),
      ),
    );
  }
}
