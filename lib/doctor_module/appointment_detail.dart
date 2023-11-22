import 'package:ecare/constants/colors.dart';
import 'package:ecare/doctor_module/videocall.dart';
import 'package:ecare/pages/choose_schedule.dart';
import 'package:ecare/pages/schedule_appointment.dart';
import 'package:ecare/pages/upload_document.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:flutter/material.dart';

import '../constants/sized_box.dart';
import '../widgets/list_ui_1.dart';

class Appointment_Detail_Page extends StatefulWidget {
  const Appointment_Detail_Page({Key? key}) : super(key: key);

  @override
  State<Appointment_Detail_Page> createState() => _Appointment_Detail_PageState();
}

class _Appointment_Detail_PageState extends State<Appointment_Detail_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(
        context: context,
        appBarColor: Color(0xFE00A2EA).withOpacity(0.1),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/patter.png', ),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fitWidth
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/23.png', width: 85,),
                        hSizedBox2,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            vSizedBox,
                            MainHeadingText(text: 'John smith', fontSize: 22, fontFamily: 'light',),
                            vSizedBox05,
                            MainHeadingText(text: 'Age: (22)', fontSize: 14, color: MyColors.onsurfacevarient, fontFamily: 'light',),
                            MainHeadingText(text: '12 Aug, 2022', fontSize: 14, color: MyColors.onsurfacevarient,),
                            MainHeadingText(text: '8:00 pm - 9:00 pm', fontSize: 14, fontFamily: 'light', color: MyColors.onsurfacevarient,),
                          ],
                        )
                      ],
                    ),
                  ),
                  vSizedBox4,
                  MainHeadingText(text: 'Uploaded Documents'),
                  vSizedBox,
                  ListUI01(heading: 'test Document Name', image: 'assets/images/file.png', isIcon: false),
                  ListUI01(heading: 'test Document Name', image: 'assets/images/file.png', isIcon: false),
                  ListUI01(heading: 'test Document Name', image: 'assets/images/file.png', isIcon: false),

                  vSizedBox,
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xFE00A2EA).withOpacity(0.1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainHeadingText(text: 'About Patient', fontFamily: 'light', fontSize: 24,),
                        vSizedBox,
                        ParagraphText(text: 'Reddy absolutely loves being a primary care physician and focuses on keeping each individual she takes care of,as healthy as possible, both', fontSize: 14, height: 1.3,),
                        MainHeadingText(text: 'Read More', color: MyColors.primaryColor, fontSize: 14, fontFamily: 'semibold',),
                        vSizedBox2,
                        MainHeadingText(text: 'Reason for visit', fontFamily: 'light', fontSize: 16,),
                        ParagraphText(text: 'symptoms: Cold cough', fontSize: 14, fontFamily: 'light', color: MyColors.headingcolor,),
                        vSizedBox2,
                        MainHeadingText(text: 'Health profile', fontFamily: 'light', fontSize: 16,),
                        vSizedBox05,
                        MainHeadingText(text: 'Allergies', color: MyColors.primaryColor, fontFamily: 'light', fontSize: 14,),
                        ParagraphText(text: 'Lorem Ipsum, Lorem Ipsum, Ipsum', fontSize: 14, fontFamily: 'light', color: MyColors.headingcolor,),

                        vSizedBox,
                        MainHeadingText(text: 'Surgeries', color: MyColors.primaryColor, fontFamily: 'light', fontSize: 14,),
                        ParagraphText(text: 'Lorem Ipsum, Lorem Ipsum, Ipsum', fontSize: 14, fontFamily: 'light', color: MyColors.headingcolor,),

                        vSizedBox,
                        MainHeadingText(text: 'Medication', color: MyColors.primaryColor, fontFamily: 'light', fontSize: 14,),
                        ParagraphText(text: 'Lorem Ipsum, Lorem Ipsum, Ipsum', fontSize: 14, fontFamily: 'light', color: MyColors.headingcolor,),
                      ],
                    ),
                  ),

                  vSizedBox,

                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xFE00A2EA).withOpacity(0.1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainHeadingText(text: 'serious medical conditions in the family', fontFamily: 'light', fontSize: 16,),
                        ParagraphText(text: 'No', fontSize: 14, fontFamily: 'light', color: MyColors.headingcolor,),
                      ],
                    ),
                  ),

                  vSizedBox2,

                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: RoundEdgedButton(
                text: 'Upload Documents',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UploadDocument())),)
              ,
            ),
          )
        ],
      ),
    );
  }
}