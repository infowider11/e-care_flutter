import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/add_consultaion_notes.dart';
import 'package:ecare/pages/add_prescription.dart';
import 'package:ecare/pages/add_referral.dart';
import 'package:ecare/pages/add_sick_notes.dart';
import 'package:ecare/pages/review.dart';
import 'package:ecare/pages/sick_notes.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:flutter/material.dart';

import '../tabs_doctor.dart';
import '../widgets/CustomTexts.dart';

class DoctorVideoCall extends StatefulWidget {
  const DoctorVideoCall({Key? key}) : super(key: key);

  @override
  State<DoctorVideoCall> createState() => _DoctorVideoCallState();
}

class _DoctorVideoCallState extends State<DoctorVideoCall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Image.asset('assets/images/doctor.png', height: MediaQuery.of(context).size.height / 2, fit: BoxFit.cover,),
              Image.asset('assets/images/patient.png', height: MediaQuery.of(context).size.height / 2, fit: BoxFit.cover,),

            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RoundEdgedButton(
                    text: 'Create Documents', height: 30, width: 160, verticalPadding: 0, horizontalPadding: 0,
                    onTap: (){
                      bottomsheet(
                        backcolor: MyColors.surface3,
                        height: 260,
                          context: context,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              vSizedBox2,
                              GestureDetector(
                                onTap: (){
                                  push(context: context, screen: Add_Prescriptions_Doctor_Page());
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(color: MyColors.onsurfacevarient, width: 1)
                                      )
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      MainHeadingText(text: 'Add Prescription', color: MyColors.onsurfacevarient, fontSize: 14, fontFamily: 'light',),
                                      Icon(Icons.chevron_right_rounded)
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  push(context: context, screen: Add_Sick_Notes_Page());
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(color: MyColors.onsurfacevarient, width: 1)
                                      )
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      MainHeadingText(text: 'Add Sick note', color: MyColors.onsurfacevarient, fontSize: 14, fontFamily: 'light',),
                                      Icon(Icons.chevron_right_rounded)
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  push(context: context, screen: Add_Referral_Letter_Page());
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(color: MyColors.onsurfacevarient, width: 1)
                                      )
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      MainHeadingText(text: 'Add Referral letter', color: MyColors.onsurfacevarient, fontSize: 14, fontFamily: 'light',),
                                      Icon(Icons.chevron_right_rounded)
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  push(context: context, screen: Add_Consultation_Notes_Page());
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  // decoration: BoxDecoration(
                                  //     border: Border(
                                  //         bottom: BorderSide(color: MyColors.onsurfacevarient, width: 1)
                                  //     )
                                  // ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      MainHeadingText(text: 'Add consultation notes', color: MyColors.onsurfacevarient, fontSize: 14, fontFamily: 'light',),
                                      Icon(Icons.chevron_right_rounded)
                                    ],
                                  ),
                                ),
                              ),
                              vSizedBox
                            ],
                          )
                      );
                    },
                  ),
                  vSizedBox2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: MyColors.bordercolor
                        ),
                        child: Icon(Icons.video_call, color: MyColors.white, size: 30),
                      ),
                      hSizedBox2,
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => tabs_third_page(initialIndex: 1,))),
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFEDE3730)
                          ),
                          child: Icon(Icons.call_rounded, color: MyColors.white, size: 40),
                        ),
                      ),
                      hSizedBox2,
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                            color: MyColors.bordercolor
                        ),
                        child: Icon(Icons.mic_off_rounded, color: MyColors.white, size: 30),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
