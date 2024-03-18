import 'dart:developer';
import 'dart:io';

import 'package:ecare/constants/colors.dart';
import 'package:ecare/pages/choose_schedule.dart';
import 'package:ecare/pages/schedule_appointment.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/dropdown.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../Services/api_urls.dart';
import '../constants/image_urls.dart';
import '../constants/sized_box.dart';
import '../services/auth.dart';
import '../services/webservices.dart';
import '../widgets/image_picker.dart';
import '../widgets/loader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DoctorProfileEdit extends StatefulWidget {
  const DoctorProfileEdit({Key? key}) : super(key: key);

  @override
  State<DoctorProfileEdit> createState() => _DoctorProfileEditState();
}

class _DoctorProfileEditState extends State<DoctorProfileEdit> {
  TextEditingController email = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  // TextEditingController gender = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController exp_year = TextEditingController();
  TextEditingController education = TextEditingController();
  TextEditingController intrest = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController other = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController practiceNumberController = TextEditingController();

  List langKnown = [];
  List specialInterest = [];
  List specilization = [];
  String? language_id;
  String? special_intrest_id;
  String? specialization_id;
  String? genderr;
  List profile_image = [];
  bool isChange = false;
  String image = '';
  bool load = false;
  String country_code = '';
  String country_short_code = '';

  List<Map> categories = [];
  List<Map> subCategories = [];
  String? catType;
  String? subCatType;
  List<dynamic> allCat = [];

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

  getSubCategory(id)  {
    print('prasoon---subcate----call ${id}');
    log('sss ${allCat}');
    subCatType = null;
    subCategories = [];
    print("id------------" + id.toString());
    for (var i = 0; i < allCat.length; i++) {
      if (allCat[i]['parent'].toString() == id.toString()) {
        subCategories.add(allCat[i]);
        print("subCategories" + subCategories.length.toString());

      }
    }
    setState(() {});
  }

  getDetail() async {
    setState(() {
      load = true;
    });
    await getlangKnown();
    await getspecilization();
    await getspecialInterest();
    await getCategories();
    var id = await getCurrentUserId();

    await Webservices.get('${ApiUrls.get_user_by_id}?user_id=${id}')
        .then((value) async {
      print('the status is ${value}');
      await getSubCategory(value['data']['specialist_cat']);

      fname.text = value['data']['first_name'].toString();
      lname.text = value['data']['last_name'].toString();
      practiceNumberController.text = value['data']['pcns_no'].toString();
      phone.text = value['data']['phone'].toString();
      country_short_code = value['data']['country_code'];
      country_code = value['data']['phone_code'];
      exp_year.text = value['data']['exp_year'].toString();
      education.text = value['data']['education'].toString();
      email.text = value['data']['email'].toString();
      genderr = value['data']['gender'].toString();
      language_id = value['data']['language_id'].toString();
      // special_intrest_id=value['data']['special_intrest_id'].toString();
      intrest.text = value['data']['special_intrest'].toString();
      catType = value['data']['specialist_cat'].toString();
      subCatType = value['data']['specialist_subcat'];
      other.text = value['data']['other'] ?? '';
      // specialization_id=value['data']['specialization_id'].toString();
      profile_image.add(value['data']['profile_image'].toString());
      // profile_image[0]['image']=value['data']['profile_image'].toString();
      image = value['data']['profile_image'].toString();
      dob.text = value['data']['dob'];
      bio.text = value['data']['biography'];
      print(
          'gender---------${profile_image[0].runtimeType.toString()} ${image}');
      setState(() {
        load = false;
      });
    });
    Future.delayed(Duration(seconds: 5)).then((value) => {
      print('set state'),
      setState(() {
        print('the sub category list is ${subCategories}');
      })
    });
  }

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
    var res = await Webservices.get(ApiUrls.get_specialization);
    print('res from catlist---${res}');
    specilization = res['data'];
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    getDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(
        context: context,
        appBarColor: Color(0xFE00A2EA).withOpacity(0.1),
      ),
      body: load
          ? CustomLoader()
          : Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/patter.png',
                    ),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fitWidth),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (profile_image.length == 0)
                            Image.asset('assets/images/profile2.png',
                                fit: BoxFit.cover, width: 80)
                          else if (profile_image.length > 0)
                            if (profile_image[0].runtimeType != String)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(profile_image[0],
                                    fit: BoxFit.cover, width: 80),
                              ),
                          if (profile_image.length > 0)
                            if (profile_image[0].runtimeType == String)
                              ClipRRect(
                                child: Image.network(image.toString(),
                                    fit: BoxFit.cover, width: 80),
                                borderRadius: BorderRadius.circular(50),
                              ),
                          vSizedBox,
                          GestureDetector(
                            onTap: () async {
                              _showImage_popup(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/edit.png',
                                  width: 16,
                                ),
                                hSizedBox,
                                ParagraphText(
                                  text: 'Edit Image',
                                  color: MyColors.primaryColor,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    vSizedBox4,

                    CustomTextField(
                      controller: fname,
                      label: 'First Name',
                      hintText: 'Dr. John',
                      showlabel: true,
                      labelcolor: MyColors.onsurfacevarient,
                    ),
                    vSizedBox,
                    CustomTextField(
                      controller: lname,
                      label: 'Last Name',
                      hintText: 'Smith',
                      showlabel: true,
                      labelcolor: MyColors.onsurfacevarient,
                    ),
                    vSizedBox,
                    Text('Gender'),
                    CustomDropdownButton(
                        selected: genderr,
                        items: ['male', 'female'],
                        hint: 'Gender',
                        onChanged: (value) => {
                              print('commins type----$value'),
                              setState(() {
                                genderr = value.toString();
                              })
                            }),
                    // DropDown(islabel: true, label: 'Gender', hint: 'male',),

                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: MyColors.lightBlue.withOpacity(0.11),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ParagraphText(
                            fontSize: 16,
                            text: 'Select Category',
                            color: MyColors.onsurfacevarient,
                          ),
                          // DropDown(bgcolor: Colors.transparent),
                          vSizedBox,
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 55,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              // color: MyColors.white,
                              border: Border.all(color: MyColors.borderColor2),
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: DropdownButton<String>(
                              underline: Container(
                                height: 8,
                              ),
                              hint: Text('Select Category'),
                              value: catType,
                              icon: Icon(
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
                            ParagraphText(
                              fontSize: 16,
                              text: 'Select Sub Category',
                              color: MyColors.onsurfacevarient,
                            ),
                          vSizedBox,
                          if (subCategories.length > 0)
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                // color: MyColors.white,
                                border:
                                    Border.all(color: MyColors.borderColor2),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              child: DropdownButton<String>(
                                underline: Container(
                                  height: 8,
                                ),
                                hint: Text('Select Sub Category'),
                                value: subCatType,
                                icon: Icon(
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
                    vSizedBox,
                    CustomTextField(
                      controller: practiceNumberController,
                      label: 'Practice Number',
                      hintText: 'HPSCA01322322',
                      showlabel: true,
                      labelcolor: MyColors.onsurfacevarient,
                    ),
                    // if (subCategories.length == 0 && catType != null)
                    //   Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       vSizedBox2,
                    //       ParagraphText(
                    //           fontSize: 16, text: 'Other (please specify)'),
                    //       vSizedBox,
                    //       CustomTextField(
                    //           controller: other, hintText: 'Write here..'),
                    //     ],
                    //   ),
                    vSizedBox,
                    Text('Date of Birth'),
                    vSizedBox,
                    GestureDetector(
                      onTap: () async {
                        var m = await showDatePicker(
                            context: context,
                            initialDate: DateTime(DateTime.now().year - 16),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(DateTime.now().year - 15));
                        if (m != null) {
                          DateFormat formatter = DateFormat('yyyy-MM-dd');
                          String formatted = formatter.format(m);
                          dob.text = formatted;
                          // print('checking date------${formatted}');
                        }
                      },
                      child: CustomTextField(
                        controller: dob,
                        hintText: 'Date of birth',
                        // prefixIcon: MyImages.date,
                        showlabeltop: false,
                        enabled: false,
                        label: '',
                        // labelfont: 12,
                        labelcolor: MyColors.white,
                        bgColor: Colors.transparent,
                        fontsize: 16,
                        hintcolor: MyColors.headingcolor,
                        suffixheight: 16,
                      ),
                    ),
                    vSizedBox2,
                    Text('Phone Number'),
                    vSizedBox,
                    IntlPhoneField(
                      onChanged: (p) {
                        print('ghdvfh');
                        // phone.text=p.countryCode;
                        country_code = p.countryCode;
                        country_short_code = p.countryISOCode;
                        print('country_code-${country_code.toString()}');
                        setState(() {});
                        // print(p.completeNumber);
                      },
                      onCountryChanged: ((c) => {
                            print('country----${c.code}'),
                            country_short_code = c.code,
                            setState(() {}),
                          }),
                      dropdownIcon: Icon(
                        Icons.phone,
                        color: Colors.transparent,
                      ),
                      controller: phone,
                      decoration: InputDecoration(
                          // suffixIcon: Icon(Icons.phone),
                          // prefixIcon: Icon(Icons.phone,color: Colors.black,),
                          // labelText: 'Phone Number',
                          // floatingLabelAlignment: FloatingLabelAlignment.start,
                          // label:Container(
                          //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          //   decoration: BoxDecoration(
                          //       color: Color(0xFFCAE6FF),
                          //       borderRadius: BorderRadius.circular(10)
                          //   ),
                          //   child: ParagraphText(
                          //     text: "Phone Number",
                          //     fontSize: 16,
                          //     color: MyColors.paragraphcolor,
                          //     fontFamily: 'regular',
                          //   ),
                          // ) ,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: MyColors.bordercolor),
                              borderRadius: BorderRadius.circular(15)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: MyColors.bordercolor),
                              borderRadius: BorderRadius.circular(15)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: MyColors.bordercolor),
                              borderRadius: BorderRadius.circular(15))
                          // labelStyle: TextStyle(color:MyColors.paragraphcolor, backgroundColor: Color(0xFFCAE6FF)),
                          // enabledBorder:InputBorder(borderSide: BorderSide(Border.all(color: bordercolor))),
                          // focusedBorder: InputBorder(
                          //   borderSide: BorderSide(color: MyColors.bordercolor),
                          // ),
                          // border: InputBorder(
                          //   borderSide: BorderSide(color: MyColors.bordercolor),
                          // ),

                          // focusedBorder: Border.all()
                          ),
                      initialCountryCode: country_short_code, // SOUTH AFRICA
                      // onChanged: (phone) {
                      //   print(phone.completeNumber);
                      // },
                    ),

                    // vSizedBox,
                    // CustomTextField(controller: phone,
                    //   enabled:false,
                    //   label: 'Phone number', hintText: '+91 9898989959', showlabel: true, labelcolor: MyColors.onsurfacevarient,),
                    vSizedBox,

                    CustomTextField(
                      controller: email,
                      enabled: false,
                      label: 'Email',
                      hintText: 'Email Address',
                      showlabel: true,
                      labelcolor: MyColors.onsurfacevarient,
                    ),
                    vSizedBox,

                    CustomTextField(
                      controller: exp_year,
                      label: 'Years of Experience',
                      hintText: '05 Years',
                      showlabel: true,
                      labelcolor: MyColors.onsurfacevarient,
                    ),
                    vSizedBox,

                    CustomTextField(
                      controller: education,
                      label: 'Education',
                      hintText: 'B.H.M.S , MBBAS',
                      showlabel: true,
                      labelcolor: MyColors.onsurfacevarient,
                    ),
                    vSizedBox,

                    // vSizedBox,
                    Text('Language Known'),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: MyColors.white,
                        border: Border.all(color: MyColors.borderColor2),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: DropdownButton<String>(
                        underline: Container(
                          height: 8,
                        ),
                        hint: Text('Language Known'),
                        value: language_id,
                        icon: Icon(
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
                            child: Text(e['title']),
                          );
                        }).toList(),
                      ),
                    ),
                    // DropDown(hint: 'Language Known'),
                    vSizedBox,
                    Text('Special Intrests'),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 55,
                    //   padding: EdgeInsets.all(10),
                    //   decoration: BoxDecoration(
                    //     color: MyColors.white,
                    //     border: Border.all(color: MyColors.borderColor2),
                    //     borderRadius: BorderRadius.circular(17),
                    //   ),
                    //
                    //   child: DropdownButton<String>(
                    //     underline: Container(
                    //       height: 8,
                    //     ),
                    //     hint: Text('Special Intrests'),
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
                    //
                    //     items: specialInterest.map((e) {
                    //       return DropdownMenuItem<String>(
                    //         value: e['id'],
                    //         child: Text(e['title']),
                    //       );
                    //     }).toList(),
                    //
                    //   ),
                    // ),

                    CustomTextField(
                        controller: intrest, hintText: 'Special Intrests'),
                    vSizedBox,
                    Text('Bio'),
                    CustomTextField(controller: bio, hintText: 'Bio'),
                    // DropDown(hint: 'Special Intrests',),
                    // vSizedBox,
                    // Text('Specialization'),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 55,
                    //   padding: EdgeInsets.all(10),
                    //   decoration: BoxDecoration(
                    //     color: MyColors.white,
                    //     border: Border.all(color: MyColors.borderColor2),
                    //     borderRadius: BorderRadius.circular(17),
                    //   ),
                    //
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
                    //
                    //     items: specilization.map((e) {
                    //       return DropdownMenuItem<String>(
                    //         value: e['id'],
                    //         child: Text(e['title']),
                    //       );
                    //     }).toList(),
                    //
                    //   ),
                    // ),
                    // DropDown(hint: 'Specialization',),
                    vSizedBox2,

                    // DropDown(label: 'Language Known', hint: 'English,hindi', islabel: true),
                    // vSizedBox,
                    //
                    // DropDown(label: 'Special interest', hint: 'Bone Specialist', islabel: true),
                    // vSizedBox,
                    //
                    // DropDown(label: 'Specialization', hint: 'Bone Specialist', islabel: true),
                    // vSizedBox2,

                    RoundEdgedButton(
                      text: 'Update',
                      onTap: () async {
                        if (fname.text == '') {
                          showSnackbar('Please Enter your first name.');
                        } else if (lname.text == '') {
                          showSnackbar( 'Please Enter your last name.');
                        }
                        // else if (practiceNumberController.text == '') {
                        //   showSnackbar( 'Please Enter your practice number.');
                        // }
                        else if (subCatType == null &&
                            subCategories.length > 0) {
                          showSnackbar( 'Please select subcategory.');
                        }
                        // else if (other.text == '' &&
                        //     subCategories.length == 0) {
                        //   showSnackbar(
                        //       'Please Enter other(please specify) field.');
                        // }
                        else if (phone.text == '') {
                          showSnackbar( 'Please Enter Phone Number.');
                        } else if (exp_year.text == '') {
                          showSnackbar( 'Please Enter your experience year.');
                        } else if (education.text == '') {
                          showSnackbar( 'Please Enter your education.');
                        } else if (language_id == null) {
                          showSnackbar( 'Please Select languages.');
                        }
                        // else if(special_intrest_id==null){
                        //   showSnackbar( 'Please Select Interest.');
                        // }
                        // else if(specialization_id==null){
                        //   showSnackbar( 'Please Select Specialization.');
                        // }
                        // else if(profile_image.length==0){
                        //   showSnackbar( 'Please upload your profile.');
                        // }
                        else {
                          Map<String, dynamic> data = {
                            'user_id': await getCurrentUserId(),
                            'first_name': fname.text,
                            'last_name': lname.text,
                            'pcns_no': practiceNumberController.text,
                            'exp_year': exp_year.text,
                            'education': education.text,
                            'language_id': language_id.toString(),
                            'special_intrest': intrest.text,
                            "country_code": country_short_code.toString(),
                            "phone_code": country_code.toString(),
                            "biography": bio.text,
                            'gender': genderr,
                            'specialist_cat': catType,
                            'specialist_subcat':
                                subCategories.length == 0 ? '' : subCatType,
                            'other': other.text,
                            'dob': dob.text,
                            'phone': phone.text,
                            // 'specialization_id':specialization_id.toString(),
                          };

                          Map<String, dynamic> files = {};
                          if (isChange) {
                            files['profile_image'] = profile_image[0];
                          }
                          await EasyLoading.show(
                            status: null,
                            maskType: EasyLoadingMaskType.black,
                          );
                          setState(() {
                            // load=true;
                          });
                          var res = await Webservices.postDataWithImageFunction(
                              body: data,
                              files: files,
                              context: context,
                              apiUrl: ApiUrls.edit_profile);
                          log('res ------${res}');
                          await EasyLoading.dismiss();

                          setState(() {
                            // load=false;
                          });
                          if (res['status'].toString() == '1') {
                            Navigator.pop(context);
                            // userData=res['data'];
                            updateUserDetails(res['data']);
                            showSnackbar( res['message']);
                          }
                        }
                      },
                    )
                  ],
                ),
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
                      _close(ctx);
                      File? image;
                      image = await pickImage(false);
                      print('image----$image');
                      if (image != null) {
                        profile_image = [];
                        isChange = true;
                        profile_image.add(image);
                        setState(() {});

                      }

                    },
                    child: const Text('Take a picture')),
                CupertinoActionSheetAction(
                    onPressed: () async {
                      _close(ctx);
                      File? image;
                      image = await pickImage(true);
                      print('image----$image');

                      if (image != null) {
                        profile_image = [];
                        isChange = true;

                        profile_image.add(image);
                        print(
                            'image----${profile_image[0].runtimeType.toString()}');

                        setState(() {});
                      }

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
