// ignore_for_file: deprecated_member_use, prefer_interpolation_to_compose_strings, avoid_print, non_constant_identifier_names

import 'dart:io';

// import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:ecare/Services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/doctor_module/signup_form_2.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/privacy_policy.dart';
import 'package:ecare/pages/terms_cond_page.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/image_picker.dart';
import '../widgets/showSnackbar.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:path/path.dart';

class SignUpForm1 extends StatefulWidget {
  final Map<String, dynamic> data;
  const SignUpForm1({Key? key, required this.data}) : super(key: key);

  @override
  State<SignUpForm1> createState() => _SignUpForm1State();
}

class _SignUpForm1State extends State<SignUpForm1> {
  TextEditingController email = TextEditingController();
  TextEditingController other = TextEditingController();
  TextEditingController id_number = TextEditingController();
  TextEditingController hpcsa_no = TextEditingController();
  TextEditingController expiry_date = TextEditingController();
  TextEditingController exp_year = TextEditingController();
  TextEditingController pcns_no = TextEditingController();
  TextEditingController proof = TextEditingController();
  List images = [];
  List proofFile = [];

  // specialist_cat,specialist_subcat,other,,,,exp_year,
  // consultation_fees,education,biography,language_id,special_intrest_id,specialization_id,
  // id_image,hpcsa_image,profile_image
  List<Map> categories = [];
  List<Map> subCategories = [];
  String? catType;
  String? subCatType;
  List<dynamic> allCat = [];

  bool isChecked = false;
  @override
  void initState() {
    super.initState();
    getCategories();
  }

  getCategories() async {
    var res = await Webservices.get(ApiUrls.getSpecialistCategory);
    print('res from catlist---${res}');
    allCat = res['data'];
    for (var i = 0; i < res['data'].length; i++) {
      if (res['data'][i]['parent'].toString() == '0') {
        categories.add(res['data'][i]);
      } else {
        // subCategories.add(res['data'][i]);
      }
    }

    setState(() {});
    // get(ApiUrls.);
  }

  getSubCategory(id) async {
    subCatType = null;
    subCategories = [];
    print("id------------" + id.toString());
    for (var i = 0; i < allCat.length; i++) {
      if (allCat[i]['parent'].toString() == id.toString()) {
        subCategories.add(allCat[i]);
        print("subCategories" + subCategories.length.toString());
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(
          context: context,
          appBarColor: MyColors.BgColor,
          title: 'Medical professional registered as:',
          fontsize: 25),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MainHeadingText(text: 'Medical professional registered as: ', color: MyColors.onsurfacevarient, fontSize: 16, fontFamily: 'light',),
            // vSizedBox2,
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: MyColors.lightBlue.withOpacity(0.11),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ParagraphText(
                    fontSize: 16,
                    text: 'Select Category',
                    color: MyColors.onsurfacevarient,
                  ),
                  // DropDown(bgcolor: Colors.transparent),
                  vSizedBox,
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // color: MyColors.white,
                      border: Border.all(color: MyColors.borderColor2),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: DropdownButton<String>(
                      underline: Container(
                        height: 8,
                      ),
                      hint: const Text('Select Category'),
                      value: catType,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                      ),
                      elevation: 0,
                      isExpanded: true,
                      alignment: Alignment.centerLeft,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String? newValue) async {
                        catType = newValue!;
                        print('id' + catType.toString());
                        getSubCategory(catType);
                        setState(() {});
                      },
                      items: categories.map((e) {
                        return DropdownMenuItem<String>(
                          value: e['id'],
                          child: Text(e['title']),
                        );
                      }).toList(),
                    ),
                  ),
                  vSizedBox2,
                  if (subCategories.length > 0)
                    const ParagraphText(
                      fontSize: 16,
                      text: 'Select Sub Category',
                      color: MyColors.onsurfacevarient,
                    ),
                  vSizedBox,
                  if (subCategories.length > 0)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // color: MyColors.white,
                        border: Border.all(color: MyColors.borderColor2),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: DropdownButton<String>(
                        underline: Container(
                          height: 8,
                        ),
                        hint: const Text('Select Sub Category'),
                        value: subCatType,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_outlined,
                        ),
                        elevation: 0,
                        isExpanded: true,
                        alignment: Alignment.centerLeft,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (String? newValue) async {
                          subCatType = newValue!;
                          print('id' + subCatType.toString());

                          setState(() {});
                        },
                        items: subCategories.map((e) {
                          return DropdownMenuItem<String>(
                            value: e['id'],
                            child: Text(e['title']),
                          );
                        }).toList(),
                      ),
                    ),
                  // DropDown(bgcolor: Colors.transparent,),
                ],
              ),
            ),

            // if(subCategories.length==0&&catType!=null)
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     vSizedBox2,
            //     ParagraphText(fontSize: 16, text: 'Other (please specify)'),
            //     vSizedBox,
            //     CustomTextField(controller: other, hintText: 'Write here..'),
            //   ],
            // ),

            vSizedBox2,
            const ParagraphText(
                fontSize: 16,
                text:
                    'South African ID number/ passport number (if not a South African Citizen)'),
            vSizedBox,
            CustomTextField(controller: id_number, hintText: 'Write here..'),
            vSizedBox2,
            const ParagraphText(
                fontSize: 16, text: 'Upload copy of South African ID/Passport'),
            vSizedBox,
            Row(
              children: [
                RoundEdgedButton(
                  text: 'Upload',
                  width: 120,
                  onTap: () async {
                    _showImage_popup(context, false);
                  },
                ),
                hSizedBox,
                if (images.length > 0)
                  Expanded(child: Text('${basename(images[0].path)}')),
                // Text('${images[0].toString().split('cache/image_cropper_')[1]}'),
              ],
            ),
            vSizedBox,

            vSizedBox2,

            const ParagraphText(
                fontSize: 16, text: 'HPCSA/ASCHP registration number '),
            vSizedBox,
            CustomTextField(
              controller: hpcsa_no,
              hintText: 'HPSCA01322322',
            ),

            hSizedBox,

            GestureDetector(
                onTap: () async {
                  var m = await showMonthYearPicker(
                    context: context,
                    initialMonthYearPickerMode: MonthYearPickerMode.month,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime(DateTime.now().year + 50),
                    builder: (context, child) {
                      return Dialog(
                        child: SizedBox(
                          width: double.maxFinite, // Adjust width
                          height: 500, // Adjust height
                          child: child, // Embed the picker
                        ),
                      );
                    },
                  );
                  print(m);
                  // await showDatePicker(context: context,
                  //     // initialDatePickerMode: DatePickerMode.year,
                  //     initialDate: DateTime(DateTime.now().year-16),
                  //     firstDate: DateTime(DateTime.now().year-50),
                  //     lastDate: DateTime(DateTime.now().year-15));
                  if (m != null) {
                    DateFormat formatter = DateFormat('MM/yyyy');
                    String formatted = formatter.format(m);
                    expiry_date.text = formatted;
                    setState(() {});
                    // print('checking date------${formatted}');
                  }
                },
                child: const ParagraphText(
                  fontSize: 16,
                  text: 'Expiry Date ',
                )),
            vSizedBox,
            GestureDetector(
                onTap: () async {
                  var m = await showMonthYearPicker(
                    context: context,
                    initialMonthYearPickerMode: MonthYearPickerMode.month,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime(DateTime.now().year + 50),
                    builder: (context, child) {
                      return Dialog(
                        child: SizedBox(
                          width: double.maxFinite, // Adjust width
                          height: 500, // Adjust height
                          child: child, // Embed the picker
                        ),
                      );
                    },
                  );
                  print(m);
                  // await showDatePicker(context: context,
                  //     // initialDatePickerMode: DatePickerMode.year,
                  //     initialDate: DateTime(DateTime.now().year-16),
                  //     firstDate: DateTime(DateTime.now().year-50),
                  //     lastDate: DateTime(DateTime.now().year-15));
                  if (m != null) {
                    DateFormat formatter = DateFormat('MM/yyyy');
                    String formatted = formatter.format(m);
                    expiry_date.text = formatted;
                    setState(() {});
                    // print('checking date------${formatted}');
                  }
                },
                child: CustomTextField(
                  controller: expiry_date,
                  hintText: '10/16',
                  enabled: false,
                )),

            vSizedBox2,
            const ParagraphText(
                fontSize: 16, text: 'Practice number (PCNS) (Optional) '),
            vSizedBox,
            CustomTextField(controller: pcns_no, hintText: 'HPSCA01322322'),
            vSizedBox,

            vSizedBox2,
            const ParagraphText(
                fontSize: 16,
                text: 'Proof of active HPCSA registration (please upload) '),
            vSizedBox,
            Row(
              children: [
                RoundEdgedButton(
                  text: 'Upload proof',
                  width: 155,
                  onTap: () async {
                    _showImage_popup(context, true);
                  },
                ),
                hSizedBox,
                if (proofFile.length > 0)
                  Expanded(child: Text('${basename(proofFile[0].path)}')),
                // Text('${proofFile[0].toString().split('cache/image_cropper_')[1]}'),
              ],
            ),
            // CustomTextField(controller: proof, hintText: 'Write here..'),
            vSizedBox2,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Checkbox(
                    checkColor: Colors.white,
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                ),
                hSizedBox,
                Expanded(
                  flex: 11,
                  child: RichText(
                      text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                        const TextSpan(text: "I agree to E-Care "),
                        // GestureDetector(
                        //   onTap: (){},
                        //   child: ,
                        // )
                        TextSpan(
                            text: "Terms & Conditions ",
                            style:
                                const TextStyle(color: MyColors.primaryColor),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () => push(
                                  context: context,
                                  screen: const TermsCondPage(userType: '1',))),
                        const TextSpan(text: "and"),
                        TextSpan(
                            text: " Privacy Policy",
                            style:
                                const TextStyle(color: MyColors.primaryColor),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () => push(
                                  context: context,
                                  screen: const PrivacyPolicy(forDoctor: true,))),
                      ])
                      // text: 'I agree to E-Care Terms & Conditions and Privacy Policy? ',
                      ),
                ),
                // Expanded(
                //   flex: 11,
                //   child: ParagraphText(
                //     text: 'I agree to E-Care Terms & Conditions and Privacy Policy? ',
                //   ),
                // ),
              ],
            ),
            vSizedBox,
            const ParagraphText(
                text:
                    'You will be notified once your account has been verified and is activated for use – This may take up to three business days',
                fontSize: 12),
            vSizedBox2,

            RoundEdgedButton(
                text: 'Save',
                onTap: () {
                  print('catType-------------${proofFile.length}');
                  if (catType == null) {
                    showSnackbar('Please Select category.');
                  } else if (subCatType == null && subCategories.length != 0) {
                    showSnackbar('Please Select sub Category.');
                  }
                  // else if(other.text==''&&subCategories.length==0){
                  //   showSnackbar('Please Enter other(please specify) field.');
                  // }
                  else if (hpcsa_no.text == '') {
                    showSnackbar(
                        'Please Enter HPCSA/ASCHP registration number.');
                  } else if (expiry_date.text == '') {
                    showSnackbar('Please Enter Expiry Date.');
                  } else if (proofFile.length == 0) {
                    showSnackbar('Please Upload proof.');
                  } else if (!isChecked) {
                    showSnackbar('Please accept terms and conditions.');
                  } else {
                    widget.data['specialist_cat'] = catType;
                    widget.data['specialist_subcat'] =
                        subCategories.length == 0 ? '' : subCatType;
                    widget.data['other'] = other.text;
                    widget.data['id_number'] = id_number.text;
                    widget.data['hpcsa_no'] = hpcsa_no.text;
                    widget.data['expiry_date'] = expiry_date.text;
                    if (pcns_no.text != '') {
                      widget.data['pcns_no'] = pcns_no.text;
                    }
                    Map<String, dynamic> files = {'hpcsa_image': proofFile[0]};
                    if (images.length > 0) {
                      files['id_image'] = images[0];
                    }
                    // hpcsa_image
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpForm2(
                                  data: widget.data,
                                  files: files,
                                )));
                  }
                }),

            vSizedBox4
          ],
        ),
      ),
    );
  }

  void _showImage_popup(BuildContext ctx, bool isProof) {
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
                        if (isProof) {
                          proofFile = [];
                          proofFile.add(image);
                        } else {
                          images = [];
                          images.add(image);
                        }

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
                        if (isProof) {
                          proofFile = [];
                          proofFile.add(image);
                        } else {
                          images = [];
                          images.add(image);
                        }
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
