// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, non_constant_identifier_names

import 'dart:io';

// import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:ecare/Services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../widgets/image_picker.dart';
import '../widgets/showSnackbar.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:path/path.dart';

class hpcsaregistration extends StatefulWidget {
  final Map<String, dynamic>? data;
  const hpcsaregistration({Key? key, this.data}) : super(key: key);

  @override
  State<hpcsaregistration> createState() => _hpcsaregistrationState();
}

class _hpcsaregistrationState extends State<hpcsaregistration> {
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
  bool hide_image = false;
  bool load = false;

  // specialist_cat,specialist_subcat,other,,,,exp_year,
  // consultation_fees,education,biography,language_id,special_intrest_id,specialization_id,
  // id_image,hpcsa_image,profile_image
  List<Map> categories = [];
  List<Map> subCategories = [];
  String? catType;
  String? subCatType;
  List<dynamic> allCat = [];
  Map? user_data;

  bool isChecked = false;
  @override
  void initState() {
    super.initState();
    getDetail();
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

  getDetail() async {
    setState(() {
      load = true;
    });
    var id = await getCurrentUserId();
    var res = await Webservices.get('${ApiUrls.get_user_by_id}?user_id=${id}');
    print('data-----$res');
    if (res['status'].toString() == '1') {
      user_data = res['data'];
      hpcsa_no.text = res['data']['hpcsa_no'];
      expiry_date.text = res['data']['expiry_date'];
      setState(() {});
    }
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(
          context: context,
          appBarColor: MyColors.BgColor,
          title: 'My HPCSA/ASCHP registration',
          fontsize: 25),
      body: load
          ? const CustomLoader()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSizedBox,

                  const ParagraphText(
                      fontSize: 16, text: 'HPCSA/ASCHP registration number '),
                  vSizedBox,
                  CustomTextField(
                      controller: hpcsa_no,
                      hintText: 'HPSCA01322322',
                      keyboardType: TextInputType.number),

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
                      fontSize: 16,
                      text:
                          'Proof of active HPCSA registration (please upload)'),
                  vSizedBox,
                  Row(
                    children: [
                      RoundEdgedButton(
                        text: 'Upload Proof',
                        width: 155,
                        onTap: () async {
                          setState(() {
                            // hide_image=false;
                          });
                          _showImage_popup(context, true);
                        },
                      ),
                      hSizedBox,
                      if (proofFile.length > 0)
                        // Text('${proofFile[0].toString().split('cache/image_cropper_')[1]}',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                        Expanded(
                            child: Text(
                          '${basename(proofFile[0].path)}',
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        )),
                    ],
                  ),
                  vSizedBox2,
                  if (user_data != null)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: proofFile.length == 0
                              ? Image.network(
                                  user_data!['hpcsa_image'],
                                  width: 150,
                                  height: 150,
                                )
                              : Image.file(
                                  proofFile[0],
                                  width: 150,
                                  height: 150,
                                ),
                        ),
                        // Positioned(
                        //   top: 0,
                        //   right:0,
                        //   child:IconButton(
                        //     onPressed: () {
                        //       if(proofFile.length>0){
                        //         setState(() {
                        //           proofFile=[];
                        //           hide_image=true;
                        //         });
                        //       } else {
                        //         setState(() {
                        //           hide_image=true;
                        //         });
                        //       }
                        //     },
                        //     icon: Icon(Icons.remove_circle,color: Colors.red,),),
                        // )
                      ],
                    ),
                  // CustomTextField(controller: proof, hintText: 'Write here..'),
                  vSizedBox2,
                  RoundEdgedButton(
                      text: 'Submit',
                      onTap: () async {
                        print('catType-------------${proofFile.length}');
                        if (hpcsa_no.text == '') {
                          showSnackbar(
                              'Please enter HPCSA registration number.');
                        } else if (expiry_date.text == '') {
                          showSnackbar('Please enter expiry date.');
                        } else if (proofFile.length == 0) {
                          showSnackbar('Please upload HPCSA number proof.');
                        } else {
                          Map<String, dynamic> files = {
                            'hpcsa_image': proofFile[0]
                          };
                          Map<String, dynamic> data = {
                            'user_id': await getCurrentUserId(),
                            'hpcsa_no': hpcsa_no.text,
                            'expiry_date': expiry_date.text,
                          };
                          await EasyLoading.show(
                            status: null,
                            maskType: EasyLoadingMaskType.black,
                          );
                          var res = await Webservices.postDataWithImageFunction(
                              body: data,
                              files: files,
                              context: context,
                              apiUrl: ApiUrls.Renewhpscano);
                          EasyLoading.dismiss();
                          if (res['status'].toString() == '1') {
                            Navigator.pop(context);
                            showSnackbar(res['message']);
                          } else {
                            showSnackbar(res['message']);
                          }
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
