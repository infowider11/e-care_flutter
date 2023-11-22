import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_1_allergies.dart';
import 'package:ecare/pages/question_1_condition.dart';
import 'package:ecare/pages/question_1_medication.dart';
import 'package:ecare/pages/question_1_surgeries.dart';
import 'package:ecare/pages/temperature.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SyptomsPage extends StatefulWidget {
  final Map? cate;
  final Map? sub_cate;
  final String? other_reason;
  final String? days;
  const SyptomsPage(
      {Key? key, this.cate,this.sub_cate,this.other_reason,this.days})
      : super(key: key);

  @override
  State<SyptomsPage> createState() => _SyptomsPageState();
}

class _SyptomsPageState extends State<SyptomsPage> {
  TextEditingController email = TextEditingController();
  bool isChecked = false;
  List sysptoms = [
    {'name':'Abnormal thyroid','ischeck':false},
    {'name':'Fatigue/Weakness','ischeck':false},
    {'name':'Fever','ischeck':false},
  ];

  List Head_neak = [
    {'name':'Congestion/Sinus Problem','ischeck':false},
    {'name':'Ear Pain','ischeck':false},
    {'name':'Ear Drainage','ischeck':false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainHeadingText(
                text: 'Do you have any of these symptoms?',
                fontSize: 32,
                fontFamily: 'light',
              ),
              vSizedBox2,
              Container(
                padding: EdgeInsets.all(16),
                // height: MediaQuery.of(context).size.height / 2 * 1.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: MyColors.teritiary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // for(var i = 0; i<10; i++)
                    MainHeadingText(
                      text: 'General symptoms',
                      fontSize: 24,
                      fontFamily: 'light',
                    ),
                    vSizedBox05,
                    for(int i=0;i<sysptoms.length;i++)
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: MyColors.bordercolor, width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ParagraphText(
                            text: '${sysptoms[i]['name']}',
                            color: MyColors.onsurfacevarient,
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            value: sysptoms[i]['ischeck'],
                            onChanged: (bool? value) {
                              setState(() {
                                sysptoms[i]['ischeck'] = value!;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    vSizedBox2,
                    MainHeadingText(
                      text: 'Head / Neck',
                      fontSize: 24,
                      fontFamily: 'light',
                    ),
                    vSizedBox05,
                    for(int i=0;i<Head_neak.length;i++)
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: MyColors.bordercolor, width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ParagraphText(
                            text: '${Head_neak[i]['name']}',
                            color: MyColors.onsurfacevarient,
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            value: Head_neak[i]['ischeck'],
                            onChanged: (bool? value) {
                              setState(() {
                                Head_neak[i]['ischeck'] = value!;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              vSizedBox2,
              RoundEdgedButton(
                text: 'Save',
                onTap: () async{
                  // List check_symptoms = sysptoms.where((element) => element['ischeck']).toList();
                  List check_symptoms = [];
                  List check_headNeck = [];

                  for(int i=0;i<sysptoms.length;i++){
                      if(sysptoms[i]['ischeck']){
                        check_symptoms.add(sysptoms[i]['name']);
                      }
                  }

                  for(int i=0;i<Head_neak.length;i++){
                    if(sysptoms[i]['ischeck']){
                      check_headNeck.add(sysptoms[i]['name']);
                    }
                  }

                  print('check_sys----${check_symptoms}');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TemparaturePage(
                        cate:widget.cate,
                        sub_cate: widget.sub_cate,
                        other_reason:widget.other_reason,
                        days: widget.days,
                        symptoms:check_symptoms,
                        head_neck:check_symptoms,
                      )));
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
