// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/privacy_policy.dart';
import 'package:ecare/pages/select_type_page.dart';
import 'package:ecare/pages/terms_cond_page.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/showSnackbar.dart';
 
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../services/validation.dart';

class Whoiam_Page extends StatefulWidget {
  final Map pre_data;
  final bool? is_googleSignin;
  final Map? googleSignin_data;
  const Whoiam_Page(
      {Key? key,
      required this.pre_data,
      this.is_googleSignin,
      this.googleSignin_data})
      : super(key: key);

  @override
  State<Whoiam_Page> createState() => _Whoiam_PageState();
}

class _Whoiam_PageState extends State<Whoiam_Page> {
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController phone = TextEditingController();
  String? country_short_code;
  String? country_code;
  bool isChecked = false;
  bool is_understand = false;
  String gender = 'male';

  @override
  void initState() {
    
    super.initState();
    print('google login data---- ${widget.googleSignin_data?['email']}');
    if (widget.googleSignin_data != null) {
      List name = widget.googleSignin_data?['name']?.split(' ');
      fname.text = name[0] ?? ''; //widget.googleSignin_data?['name']??'';
      lname.text = name[1] ?? ''; //widget.googleSignin_data?['name']??'';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColors.scaffold,
        appBar: appBar(context: context),
        bottomNavigationBar:   RoundEdgedButton(
          text: 'Sign Up',
          verticalMargin: 15,
            horizontalMargin: 16,
          onTap: () => {
            if (validateString(fname.text,
                "Please enter your first name.", context) ==
                null &&
                validateString(lname.text,
                    "Please enter your last name.", context) ==
                    null &&
                validateString(phone.text, "Please enter your phone number",
                    context) ==
                    null)
              {
                if (!isChecked || !is_understand)
                  {
                    showSnackbar(
                        'Please accept Terms & condition and Privacy Policy.'),
                    // return
                  }

                // if (!is_understand)
                //   {
                //     showSnackbar(
                //         'Please check app .'),
                //     // return
                //   }

                else
                  {
                    widget.pre_data['first_name'] = fname.text,
                    widget.pre_data['last_name'] = lname.text,
                    widget.pre_data['phone'] = phone.text,
                    widget.pre_data['phone_code'] = country_code,
                    widget.pre_data['country_code'] =
                        country_short_code,
                    widget.pre_data['gender'] = gender,
                    setState(() {}),
                    if (widget.is_googleSignin == true)
                      widget.pre_data['google_id'] =
                      widget.googleSignin_data!['uid'],
                    // }
                    print('data------${widget.pre_data}'),
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfile())),
                    submit_signup_form(widget.pre_data),
                  }
              }
            // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfile())),
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            // height: MediaQuery.of(context).size.height - 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vSizedBox,
                const MainHeadingText(
                  text: 'Who am I ?',
                  fontSize: 32,
                  fontFamily: 'light',
                  color: MyColors.primaryColor,
                ),
                const ParagraphText(
                  text: 'Tell us some basic info',
                  fontSize: 16,
                  color: MyColors.paragraphcolor,
                ),
                vSizedBox4,
                 Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IntlPhoneField(
                      onChanged: (p) {
                        print('ghdvfh $p');
                        print('onchange value---$p');
                        // phone.text=p.countryCode;
                        country_code = p.countryCode;
                        country_short_code = p.countryISOCode;
                        print('country_code-${country_code.toString()}');
                        setState(() {});
                      },
                      onCountryChanged: (country) {
                        country_short_code = country.code;
                        setState(() {});
                        // print('country-----$country');
                      },
                      dropdownIcon: const Icon(
                        Icons.phone,
                        color: Colors.transparent,
                      ),
                      controller: phone,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: MyColors.bordercolor),
                              borderRadius: BorderRadius.circular(15)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: MyColors.bordercolor),
                              borderRadius: BorderRadius.circular(15)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: MyColors.bordercolor),
                              borderRadius: BorderRadius.circular(15))),
                      initialCountryCode: 'ZA', // SOUTH AFRICA
                    ),
                    Positioned(
                      left: 14,
                      top: -10,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                        decoration: BoxDecoration(
                            color: const Color(0xFFCAE6FF),
                            borderRadius: BorderRadius.circular(10)),
                        child: const ParagraphText(
                          text: "Phone Number",
                          fontSize: 12,
                          color: MyColors.paragraphcolor,
                          fontFamily: 'regular',
                        ),
                      ),
                    ),
                  ],
                ),
                vSizedBox,
                CustomTextField(
                  controller: fname,
                  hintText: 'First Name',
                  showlabeltop: true,
                  label: 'First Name',
                  labelfont: 12,
                  labelcolor: MyColors.paragraphcolor,
                  bgColor: Colors.transparent,
                  fontsize: 16,
                  hintcolor: MyColors.headingcolor,
                ),
                vSizedBox4,
                CustomTextField(
                  controller: lname,
                  hintText: 'Last Name',
                  showlabeltop: true,
                  label: 'Last Name',
                  labelfont: 12,
                  labelcolor: MyColors.paragraphcolor,
                  bgColor: Colors.transparent,
                  fontsize: 16,
                  hintcolor: MyColors.headingcolor,
                ),
                vSizedBox4,
               
                const MainHeadingText(
                  text: 'Select Gender',
                  fontFamily: 'regular',
                  fontSize: 16,
                  color: MyColors.onsurfacevarient,
                ),
                // vSizedBox,
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        gender = 'male';
                        setState(() {});
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                              color: (gender == 'male')
                                  ? MyColors.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: MyColors.primaryColor, width: 1)),
                          child: ParagraphText(
                            text: 'Male',
                            fontFamily: 'light',
                            fontSize: 11,
                            color: (gender == 'male')
                                ? MyColors.white
                                : MyColors.headingcolor,
                          )),
                    ),
                    hSizedBox,
                    GestureDetector(
                      onTap: () {
                        gender = 'female';
                        setState(() {});
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                              color: (gender == 'female')
                                  ? MyColors.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: MyColors.bordercolor, width: 1)),
                          child: ParagraphText(
                            text: 'Female',
                            fontFamily: 'light',
                            fontSize: 11,
                            color: (gender == 'female')
                                ? MyColors.white
                                : MyColors.headingcolor,
                          )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                          style: const TextStyle(
                                              color: MyColors.primaryColor),
                                          recognizer: new TapGestureRecognizer()
                                            ..onTap = () => push(
                                                context: context,
                                                screen: const TermsCondPage(userType: '2',))),
                                      const TextSpan(text: "and"),
                                      TextSpan(
                                          text: " Privacy Policy",
                                          style: const TextStyle(
                                              color: MyColors.primaryColor),
                                          recognizer: new TapGestureRecognizer()
                                            ..onTap = () => push(
                                                context: context,
                                                screen: const PrivacyPolicy())),
                                    ])
                              // text: 'I agree to E-Care Terms & Conditions and Privacy Policy? ',
                            ),
                          ),
                        ],
                      ),
                      vSizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Checkbox(
                              checkColor: Colors.white,
                              value: is_understand,
                              onChanged: (bool? value) {
                                setState(() {
                                  is_understand = value!;
                                });
                              },
                            ),
                          ),
                          // hSizedBox,
                          Expanded(
                            flex: 11,
                            child: RichText(
                                text: const TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                          text:
                                          "I understand that Telehealth consultations are not a substitute for in-person consultations.  E-Care is a platform connecting healthcare providers with healthcare users and will not be held liable for any loss/harm whatsoever resulting from its use. Please see terms and conditions for more information."),
                                      // GestureDetector(
                                      //   onTap: (){},
                                      //   child: ,
                                      // )
                                    ])
                              // text: 'I agree to E-Care Terms & Conditions and Privacy Policy? ',
                            ),
                          ),
                        ],
                      ),
                      vSizedBox4,

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  submit_signup_form(data) async {
    await EasyLoading.show(
      status: null,
      maskType: EasyLoadingMaskType.black,
    );
    var res = await Webservices.postData(
        apiUrl: ApiUrls.signup, body: data, context: context);
    print('signup-----$res');
    EasyLoading.dismiss();
    if (res['status'].toString() == '1') {
      showSnackbar( res['message'],seconds: 60);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return const Select_Type_Page();
      }), (route) {
        return false;
      });
      // updateUserDetails(res['data']);
      // user_Data=res['data'];
      // setState(() {
      //
      // });
      // String? token =   await FirebasePushNotifications.getToken();
      // print('token-----$token');
      // await Webservices.updateDeviceToken(user_id: user_Data!['id'].toString(), token: token!);
      // showSnackbar( res['message']);

      // if(res['data']['is_verified'].toString()=='1') {
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (context) {
      //         return tabs_second_page(
      //           selectedIndex: 0,
      //         );
      //       }), (route) {
      //     return false;
      //   });
      // }
      // else {
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (context) {
      //         return PendingVerificationPage(
      //           id: res['data']['id'].toString(),
      //         );
      //       }), (route) {
      //     return false;
      //   });
      // }

      // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfile()));

    } else {
      showSnackbar( res['message']);
    }
  }
}
