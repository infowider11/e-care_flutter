// ignore_for_file: deprecated_member_use, avoid_print, non_constant_identifier_names

import 'dart:io';

import 'package:ecare/constants/colors.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/showSnackbar.dart';
 import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../constants/sized_box.dart';
import '../services/validation.dart';
import '../widgets/image_picker.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  TextEditingController email = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController phone = TextEditingController();
  bool load = false;
  String? country_code;
  String? country_short_code;
  File? profile_image;
  Map? user_info;
  get_info() async {
    setState(() {
      load = true;
    });
    var res = await Webservices.get(
        '${ApiUrls.get_user_by_id}?user_id=${user_Data!['id']}');
    print('info----$res');
    if (res['status'].toString() == '1') {
      user_info=res['data'];
      email.text=res['data']['email'];
      fname.text=res['data']['first_name'];
      lname.text=res['data']['last_name'];
      phone.text=res['data']['phone'];
      country_code=res['data']['phone_code'];
      country_short_code=res['data']['country_code'];
      // dob.text=res['data']['dob'];
      setState(() {

      });
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
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.BgColor,
      appBar: appBar(
        context: context,
        appBarColor: const Color(0xFE00A2EA).withOpacity(0.1),
      ),
      body: load
          ? const CustomLoader()
          : Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                image:DecorationImage(
                    image: AssetImage(
                      'assets/images/patter.png',
                    ),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fitWidth),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(48), // Image radius
                            child: profile_image!=null?
                                Image.file(profile_image!)
                                :Image.network(user_info!['profile_image'], fit: BoxFit.cover),
                          ),
                        ),
                        // CircleAvatar(
                        //   radius: 48, // Image radius
                        //   backgroundImage: NetworkImage(user_info!['profile_image']),
                        // ),
                        vSizedBox,
                        GestureDetector(
                          onTap: () async{
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
                              const ParagraphText(
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
                    hintText: 'John ',
                    showlabel: true,
                    labelcolor: MyColors.onsurfacevarient,
                  ),
                  vSizedBox,
                  CustomTextField(
                    controller: lname,
                    label: 'Last Name',
                    hintText: 'Smith ',
                    showlabel: true,
                    labelcolor: MyColors.onsurfacevarient,
                  ),
                  vSizedBox,
                  IntlPhoneField(
                    onChanged: (p) {
                      print('ghdvfh $p');
                      print('onchange value---$p');
                      country_code = p.countryCode;
                      country_short_code=p.countryISOCode;
                      print('country_code-${country_code.toString()}');
                      setState((){});
                    },
                    onCountryChanged: (country) {
                      // print('country-----$country');
                    },
                    dropdownIcon:const Icon(Icons.phone,color: Colors.transparent,) ,
                    controller: phone,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: MyColors.bordercolor),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: MyColors.bordercolor),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: MyColors.bordercolor),
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),
                    initialCountryCode: country_short_code, // SOUTH AFRICA
                    // onChanged: (phone) {
                    //   print(phone.completeNumber);
                    // },
                  ),
                  // vSizedBox,
                  CustomTextField(
                    enabled: false,
                    controller: email,
                    label: 'Email',
                    hintText: 'Email Address',
                    showlabel: true,
                    labelcolor: MyColors.onsurfacevarient,
                  ),
                  vSizedBox2,
                  RoundEdgedButton(
                      text: 'Update',
                      onTap: () async{
                        if(
                          validateString(fname.text,"Please enter your first name.",context)==null &&
                            validateString(lname.text,"Please enter your last name.",context)==null &&
                            validateString(phone.text,"Please enter your phone number.",context)==null &&
                            validateEmail(email.text,context)==null
                        ){
                          Map<String,dynamic> fiels={};

                          Map<String,dynamic>  data = {
                            'user_id':await getCurrentUserId(),
                            "first_name":fname.text,
                            "last_name":lname.text,
                            "phone":phone.text,
                            "country_code":country_short_code.toString(),
                            "phone_code":country_code.toString(),
                            "email":email.text,//1 for doctor
                          };
                          if(profile_image!=null){
                            fiels['profile_image']=profile_image;
                          }
                          await EasyLoading.show(
                            status: null,
                            maskType: EasyLoadingMaskType.black
                          );
                          var res = await Webservices.postDataWithImageFunction(
                              body: data,
                              files: fiels,
                              context: context,
                              apiUrl: ApiUrls.edit_profile
                          );
                          print('update profile----$res');
                          EasyLoading.dismiss();
                          if(res['status'].toString()=='1'){
                            showSnackbar( res['message']);
                            updateUserDetails(res['data']);
                            user_Data=res['data'];
                            setState(() {

                            });
                            Navigator.pop(context);
                          }
                        }
                    },
                  )
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
                    profile_image=image;
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
                  if (image != null) {
                    profile_image=image;
                    print('image----${profile_image.runtimeType.toString()}');

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
