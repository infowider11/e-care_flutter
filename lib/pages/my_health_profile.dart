// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'dart:convert';

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/relatives.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/selected_option.dart';

import 'package:flutter/material.dart';

import '../Services/api_urls.dart';
import '../functions/global_Var.dart';
import '../services/auth.dart';
import '../services/webservices.dart';
import 'edit-drugPage.dart';
import 'edit-family-condition.dart';
import 'edit-medical-conditions.dart';
import 'edit-medications.dart';
import 'edit-surgeris-page.dart';

class MyHealthProfile extends StatefulWidget {
  const MyHealthProfile({Key? key}) : super(key: key);

  @override
  State<MyHealthProfile> createState() => _MyHealthProfileState();
}

class _MyHealthProfileState extends State<MyHealthProfile> {
  TextEditingController email = TextEditingController();

  bool load = false;
  Map? info;
  List lists = [
    {
      "name": "",
      "step": "1",
      "medication_value": "",
      "other_value": "",
      "doctor_need": "0",
    },
    {
      "name": "",
      "step": "2",
      "medication_value": "",
      "other_value": "",
      "doctor_need": "0",
    },
    {
      "name": "",
      "step": "3",
      "medication_value": "",
      "other_value": "",
      "doctor_need": "0",
    },
    {
      "name": "",
      "step": "4",
      "medication_value": "",
      "other_value": "",
      "doctor_need": "0",
    },
    {
      "name": "",
      "step": "5",
      "medication_value": "",
      "other_value": "",
      "doctor_need": "0",
    },
  ];

  get_info() async {
    setState(() {
      load = true;
    });
    var res = await Webservices.get(
        ApiUrls.healthdetail + '?user_id=' + await getCurrentUserId() + 'm==1');
    print('info-----${jsonEncode(res)}');
    if (res['status'].toString() == '1') {
      // lists=res['data'];
      for (var i = 0; i < res['data'].length; i++) {
        var index = lists.indexWhere(
          (element) => res['data'][i]['step'] == element['step'],
        );
        if (index == -1) {
          lists[lists.length - 1] = res['data'][i];
        } else {
          lists[index] = res['data'][i];
        }
      }
    }
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    super.initState();
    get_info();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: load
          ? const CustomLoader()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MainHeadingText(
                    text: 'My Health Profile ',
                    fontSize: 32,
                    fontFamily: 'light',
                  ),
                  vSizedBox2,
                  // GestureDetector(
                  //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadedDocument())),
                  //   child: Container(
                  //     padding: const EdgeInsets.all(14),
                  //     decoration: BoxDecoration(
                  //       color: MyColors.white,
                  //       border: Border.all(
                  //         color: MyColors.bordercolor,
                  //         width: 1
                  //       ),
                  //       borderRadius: BorderRadius.circular(16)
                  //     ),
                  //     child: const Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         MainHeadingText(text: 'Uploaded medical documents', fontSize: 16, fontFamily: 'light', color: MyColors.onsurfacevarient,),
                  //         Icon(Icons.chevron_right_rounded, color: MyColors.onsurfacevarient,)
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // vSizedBox,
                  // GestureDetector(
                  //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicalRecords())),
                  //   child: Container(
                  //     padding: const EdgeInsets.all(14),
                  //     decoration: BoxDecoration(
                  //       color: MyColors.white,
                  //       border: Border.all(
                  //         color: MyColors.bordercolor,
                  //         width: 1
                  //       ),
                  //       borderRadius: BorderRadius.circular(16)
                  //     ),
                  //     child: const Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         MainHeadingText(text: 'Uploaded medical Records', fontSize: 16, fontFamily: 'light', color: MyColors.onsurfacevarient,),
                  //         Icon(Icons.chevron_right_rounded, color: MyColors.onsurfacevarient,)
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // vSizedBox2,

                  const MainHeadingText(
                      text: 'Age', fontSize: 16, fontFamily: 'regular'),
                  vSizedBox,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: MyColors.bordercolor, width: 1),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ParagraphText(
                          text: '${user_Data!['age'] ?? 0} Year Old',
                          color: MyColors.onsurfacevarient,
                        ),
                      ],
                    ),
                  ),
                  vSizedBox2,
                  for (int i = 0; i < lists.length; i++)
                    GestureDetector(
                      onTap: () async {
                        print('press----${lists[i]['step']}');
                        if (lists[i]['step'].toString() == '1') {
                          await push(
                              context: context,
                              screen: editmedications(
                                pre_data: lists[i],
                              ));
                          get_info();
                        } else if (lists[i]['step'].toString() == '2') {
                          await push(
                              context: context,
                              screen: editDrugpage(
                                pre_data: lists[i],
                              ));
                          get_info();
                        } else if (lists[i]['step'].toString() == '3') {
                          await push(
                              context: context,
                              screen: editmedicleconditions(
                                pre_data: lists[i],
                              ));
                          get_info();
                        } else if (lists[i]['step'].toString() == '4') {
                          await push(
                              context: context,
                              screen: editsurgeries(
                                pre_data: lists[i],
                              ));
                          get_info();
                        } else if (lists[i]['step'].toString() == '5') {
                          await push(
                              context: context,
                              screen: editfamilyCondition(
                                pre_data: lists[i],
                              ));
                          get_info();
                        } else {
                          lists[i]['id'] = lists[i]['relative_id'];
                          setState(() {});
                          await push(
                              context: context,
                              screen: RelativesPage(
                                is_update: true,
                                pre_data: lists[i],
                              ));
                          get_info();
                        }
                      },
                      child: SelectedBox(
                        heading: (lists[i]['step'].toString() == '1')
                            ? 'Medications'
                            : lists[i]['step'].toString() == '2'
                                ? 'Drug Allergies'
                                : lists[i]['step'].toString() == '3'
                                    ? 'Medical Conditions'
                                    : lists[i]['step'].toString() == '4'
                                        ? 'Surgeries'
                                        : lists[i]['step'].toString() == '5'
                                            ? 'Family Conditions'
                                            : 'Relative',
                        text:
                            '${lists[i]['name'] == null || lists[i]['name'].isEmpty ? 'No' : lists[i]['name']}',
                        icon:const Icon(
                          Icons.edit,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  // vSizedBox,
                  // Container(
                  //   padding: EdgeInsets.all(16),
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(16),
                  //       border: Border.all(
                  //           color: MyColors.bordercolor,
                  //           width: 1
                  //       ),
                  //       color: Colors.white
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       ParagraphText(text: 'Yes', color: MyColors.onsurfacevarient,),
                  //     ],
                  //   ),
                  // ),
                  vSizedBox2,
                  // RoundEdgedButton(text: 'Cancel', onTap: () => {}),
                  // vSizedBox4
                ],
              ),
            ),
    );
  }
}
