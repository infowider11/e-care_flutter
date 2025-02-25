import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/prescriptions_doctor.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
 
import 'package:flutter/material.dart';

class Add_Sick_Notes_Page extends StatefulWidget {
  const Add_Sick_Notes_Page({Key? key}) : super(key: key);

  @override
  State<Add_Sick_Notes_Page> createState() => _Add_Sick_Notes_PageState();
}

class _Add_Sick_Notes_PageState extends State<Add_Sick_Notes_Page> {
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MainHeadingText(text: 'Add Sick Note', fontSize: 32, fontFamily: 'light',),
              vSizedBox4,
              Column(
                children: [
                  // CustomTextField(controller: email, label: 'Prescriptions Name', showlabel: true, labelcolor: MyColors.onsurfacevarient, hintText: 'xxxx/xxxx/xxxx'),
                  // vSizedBox,
                  // CustomTextField(controller: email, label: 'Tablet Name', showlabel: true, labelcolor: MyColors.onsurfacevarient, hintText: 'eg. 25/2023'),
                  // vSizedBox,
                  // CustomTextField(controller: email, label: 'Quantity', showlabel: true, labelcolor: MyColors.onsurfacevarient, hintText: 'xxxx'),
                  // vSizedBox,
                  CustomTextFieldmaxlines(
                    controller: email,
                    label: 'Decription',
                    showlabel: true,
                    labelcolor: MyColors.onsurfacevarient,
                    hintText: 'Description',
                    maxLines: 5,
                  ),
                  vSizedBox,
                ],
              ),

              vSizedBox2,
              RoundEdgedButton(text: 'Add Sick Note',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Prescriptions_Doctor_Page())),)
            ],
          ),
        ),
      ),
    );
  }
}
