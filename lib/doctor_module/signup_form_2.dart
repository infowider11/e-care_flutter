// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, non_constant_identifier_names

import 'dart:developer';
import 'dart:io';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/doctor_module/pending_verification.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/showSnackbar.dart';
 import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Services/api_urls.dart';
import '../services/auth.dart';
import '../services/webservices.dart';
import '../widgets/image_picker.dart';

class SignUpForm2 extends StatefulWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic> files;
  const SignUpForm2({Key? key, required this.data, required this.files})
      : super(key: key);

  @override
  State<SignUpForm2> createState() => _SignUpForm2State();
}

class _SignUpForm2State extends State<SignUpForm2> {
  TextEditingController email = TextEditingController();
  TextEditingController exp_year = TextEditingController();
  TextEditingController consultation_fees = TextEditingController();
  TextEditingController education = TextEditingController();
  TextEditingController biography = TextEditingController();
  TextEditingController intrest = TextEditingController();
  // TextEditingController biography = TextEditingController();
  String? language_id;
  String? special_intrest_id;
  String? specialization_id;
  bool isChecked = false;
  List profile_image = [];
  List langKnown = [];
  List specialInterest = [];
  List specilization = [];
  bool load = false;
  getlangKnown() async {
    var res = await Webservices.get(ApiUrls.get_language);
    print('res from catlist---${res}');
    langKnown = res['data'];
    setState(() {});
    // get(ApiUrls.);
  }

  getspecialInterest() async {
    var res = await Webservices.get(ApiUrls.get_specialIntrest);
    print('res from catlist---${res}');
    specialInterest = res['data'];
    setState(() {});
  }

  getspecilization() async {
    setState(() {
      load = true;
    });
    var res = await Webservices.get(ApiUrls.get_specialization);
    setState(() {
      load = false;
    });
    print('res from catlist---${res}');
    specilization = res['data'];
    setState(() {});
  }

  @override
  void initState() {
    
    super.initState();
    print('data from signup ------${widget.data}   ------${widget.files}');
    getlangKnown();
    getspecialInterest();
    getspecilization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context,title: 'Complete Your Profile',fontsize: 25),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MainHeadingText(
            //   text: 'Complete Your Profile ',
            //   color: MyColors.headingcolor,
            //   fontSize: 32,
            //   fontFamily: 'light',
            // ),
            const MainHeadingText(
              text: 'Tell us some basic info ',
              color: MyColors.onsurfacevarient,
              fontSize: 16,
              fontFamily: 'light',
            ),
            vSizedBox2,
            GestureDetector(
              onTap: () {
                _showImage_popup(context);
              },
              child: Row(
                children: [
                  if (profile_image.length == 0)
                    Image.asset('assets/images/profile2.png',
                        fit: BoxFit.cover, width: 80)
                  else if (profile_image.length > 0)
                    if (profile_image[0].runtimeType != String)
                      Image.file(profile_image[0],
                          fit: BoxFit.cover, width: 80),
                  if (profile_image.length > 0)
                    if (profile_image[0].runtimeType == String)
                      Image.network(profile_image[0].toString(),
                          fit: BoxFit.cover, width: 80),
                  // Image.asset('assets/images/profile2.png', width: 80,),
                  hSizedBox,
                  const MainHeadingText(
                    text: 'Upload Profile Image',
                    fontSize: 16,
                    fontFamily: 'light',
                  )
                ],
              ),
            ),
            vSizedBox2,
            CustomTextField(
              controller: exp_year,
              hintText: 'Years of experience',
              keyboardType: TextInputType.number,
            ),
            vSizedBox,
            CustomTextField(controller: education, hintText: 'Education'),
            vSizedBox,
            CustomTextField(
                controller: consultation_fees,
                hintText: 'Consultation fees (ZAR)',
                keyboardType: TextInputType.number),
            vSizedBox,
            CustomTextField(
              controller: biography,
              hintText: 'Biography',
              maxLines: 5,
              height: 120,
            ),
            vSizedBox,
            Container(
              width: MediaQuery.of(context).size.width,
              height: 55,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: MyColors.white,
                border: Border.all(color: MyColors.borderColor2),
                borderRadius: BorderRadius.circular(17),
              ),
              child: DropdownButton<String>(
                underline: Container(
                  height: 8,
                ),
                hint: const Text('Language Known'),
                value: language_id,
                icon: const Icon(
                  Icons.keyboard_arrow_down_outlined,
                ),
                elevation: 0,
                isExpanded: true,
                alignment: Alignment.centerLeft,
                style: const TextStyle(color: Colors.black),
                onChanged: (String? newValue) async {
                  language_id = newValue!;
                  print('id' + language_id.toString());

                  setState(() {});
                },
                items: langKnown.map((e) {
                  return DropdownMenuItem<String>(
                    value: e['id'],
                    child: Text('${e['title']}'),
                  );
                }).toList(),
              ),
            ),
            // DropDown(hint: 'Language Known'),
            vSizedBox,
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: 55,
            //   padding: EdgeInsets.all(10),
            //   decoration: BoxDecoration(
            //     color: MyColors.white,
            //     border: Border.all(color: MyColors.borderColor2),
            //     borderRadius: BorderRadius.circular(17),
            //   ),
            //   child: DropdownButton<String>(
            //     underline: Container(
            //       height: 8,
            //     ),
            //     hint: Text('Special Interests'),
            //     value: special_intrest_id,
            //     icon: Icon(
            //       Icons.keyboard_arrow_down_outlined,
            //     ),
            //     elevation: 0,
            //     isExpanded: true,
            //     alignment: Alignment.centerLeft,
            //     style: const TextStyle(color: Colors.black),
            //     onChanged: (String? newValue) async {
            //       special_intrest_id = newValue!;
            //       print('id' + special_intrest_id.toString());
            //
            //       setState(() {});
            //     },
            //     items: specialInterest.map((e) {
            //       return DropdownMenuItem<String>(
            //         value: e['id'],
            //         child: Text(e['title']),
            //       );
            //     }).toList(),
            //   ),
            // ),
            CustomTextField(
              controller: intrest,
              hintText: 'Special Interests',
            ),
            // DropDown(hint: 'Special Interests',),
            // vSizedBox,
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: 55,
            //   padding: EdgeInsets.all(10),
            //   decoration: BoxDecoration(
            //     color: MyColors.white,
            //     border: Border.all(color: MyColors.borderColor2),
            //     borderRadius: BorderRadius.circular(17),
            //   ),
            //   child: DropdownButton<String>(
            //     underline: Container(
            //       height: 8,
            //     ),
            //     hint: Text('Specialization'),
            //     value: specialization_id,
            //     icon: Icon(
            //       Icons.keyboard_arrow_down_outlined,
            //     ),
            //     elevation: 0,
            //     isExpanded: true,
            //     alignment: Alignment.centerLeft,
            //     style: const TextStyle(color: Colors.black),
            //     onChanged: (String? newValue) async {
            //       specialization_id = newValue!;
            //       print('id' + specialization_id.toString());
            //
            //       setState(() {});
            //     },
            //     items: specilization.map((e) {
            //       return DropdownMenuItem<String>(
            //         value: e['id'],
            //         child: Text(e['title']),
            //       );
            //     }).toList(),
            //   ),
            // ),
            // DropDown(hint: 'Specialization',),
            vSizedBox2,

            RoundEdgedButton(
                text: 'Save',
                onTap: () async {
                  // if (profile_image.length == 0) {
                  //   showSnackbar( 'Please upload your profile.');
                  // } else
                    if (exp_year.text == '') {
                    showSnackbar( 'Please Enter your Experience year.');
                  } else if (education.text == '') {
                    showSnackbar( 'Please Enter your Education.');
                  } else if (consultation_fees.text == '') {
                    showSnackbar(
                         'Please Enter your Consultation Fee.');
                  } else if (biography.text == '') {
                    showSnackbar( 'Please Enter your Biography.');
                  } else if (language_id == null) {
                    showSnackbar( 'Please Select languages.');
                  }
                  // else if (special_intrest_id == null) {
                  //   showSnackbar( 'Please Select Interest.');
                  // }
                  // else if (specialization_id == null) {
                  //   showSnackbar( 'Please Select Specialization.');
                  // }
                  else {
                    widget.data['exp_year'] = exp_year.text;
                    widget.data['consultation_fees'] = consultation_fees.text;
                    widget.data['education'] = education.text;
                    widget.data['biography'] = biography.text;
                    widget.data['language_id'] = language_id.toString();
                    widget.data['special_intrest'] = intrest.text;
                        //special_intrest_id.toString();
                    // widget.data['specialization_id'] =
                    //     specialization_id.toString();
                    if(profile_image.length > 0) {
                      widget.files['profile_image'] = profile_image[0];
                    }

                    log('data for api -----data------${widget.files['profile_image'].runtimeType.toString()}');
                    log('data for api -----files----${widget.files}');
                    await EasyLoading.show(
                      status: null,
                      maskType: EasyLoadingMaskType.black,
                    );
                    setState(() {
                      load = true;
                    });
                    var res = await Webservices.postDataWithImageFunction(
                        body: widget.data,
                        files: widget.files,
                        context: context,
                        apiUrl: ApiUrls.signup);
                    await EasyLoading.dismiss();

                    setState(() {
                      load = false;
                    });
                    log('res ------${res}');
                    if (res['status'].toString() == '1') {
                      updateUserDetails(res['data']);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) {
                        return PendingVerificationPage(
                          id: res['data']['id'].toString(),
                        );
                      }), (route) {
                        return false;
                      });
                      // push(context: context, screen: PendingVerificationPage(id: res['data']['id'].toString(),));
                    } else {
                      showSnackbar( 'Somting went wrong.');
                    }
                  }
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => tabs_third_page()));
                  // push(context: context, screen: PendingVerificationPage());
                }),

            vSizedBox4
          ],
        ),
      ),
    );
  }



  void _showImage_popup(
    BuildContext ctx,
  ) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                    onPressed: () async {
                      File? image;
                      image = await pickImage(false);
                      print('image----$image');
                      if (image != null) {
                        profile_image = [];
                        profile_image.add(image);
                        setState(() {});
                      }
                      _close(ctx);
                    },
                    child: const Text('Take a picture')),
                CupertinoActionSheetAction(
                    onPressed: () async {
                      File? image;
                      image = await pickImage(true);
                      print('image----$image');
                      ;
                      if (image != null) {
                        profile_image = [];
                        profile_image.add(image);
                        setState(() {});
                      }
                      _close(ctx);
                    },
                    child: const Text('Gallery')),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => _close(ctx),
                child: const Text('Close'),
              ),
            ));
  }

  void _close(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
