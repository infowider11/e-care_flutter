// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/temperature.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
 
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MainHeadingText(
                text: 'Do you have any of these symptoms?',
                fontSize: 32,
                fontFamily: 'light',
              ),
              vSizedBox2,
              Container(
                padding: const EdgeInsets.all(16),
                // height: MediaQuery.of(context).size.height / 2 * 1.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: MyColors.teritiary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // for(var i = 0; i<10; i++)
                    const MainHeadingText(
                      text: 'General symptoms',
                      fontSize: 24,
                      fontFamily: 'light',
                    ),
                    vSizedBox05,
                    for(int i=0;i<sysptoms.length;i++)
                    Container(
                      decoration: const BoxDecoration(
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
                    const MainHeadingText(
                      text: 'Head / Neck',
                      fontSize: 24,
                      fontFamily: 'light',
                    ),
                    vSizedBox05,
                    for(int i=0;i<Head_neak.length;i++)
                    Container(
                      decoration: const BoxDecoration(
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
