import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/doctor_module/pending_verification.dart';
import 'package:ecare/doctor_module/signup.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/signup.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/tabs_doctor.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../services/auth.dart';
import '../services/firebase_push_notifications.dart';
import '../services/onesignal.dart';
import '../services/validation.dart';
import '../widgets/loader.dart';
import 'forgot.dart';

class DoctorLoginPage extends StatefulWidget {
  const DoctorLoginPage({Key? key}) : super(key: key);

  @override
  State<DoctorLoginPage> createState() => _DoctorLoginPageState();
}

class _DoctorLoginPageState extends State<DoctorLoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController hpcsaController = TextEditingController();
  TextEditingController password = TextEditingController();
  bool load = false;
  bool invalid_user_detail = false;
  String? invalid_user_text;
  bool show_pass=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(
        context: context,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  MyImages.logo,
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                ),
                vSizedBox4,
                const MainHeadingText(
                  text: 'Login',
                  fontSize: 32,
                  fontFamily: 'light',
                  color: MyColors.primaryColor,
                ),
                if(invalid_user_detail)
                  headingText(text: '$invalid_user_text',color: MyColors.red,),
                vSizedBox4,
                CustomTextField(
                  controller: email,
                  hintText: 'Email Address',
                  prefixIcon: MyImages.profile,
                  showlabeltop: true,
                  label: 'Email',
                  labelfont: 12,
                  labelcolor: MyColors.paragraphcolor,
                  bgColor: Colors.transparent,
                  fontsize: 16,
                  hintcolor: MyColors.headingcolor,
                  suffixheight: 16,
                ),
                vSizedBox4,
                CustomTextField(
                  controller: password,
                  obscureText: !show_pass,
                  suffix: IconButton(
                    onPressed: (){
                      show_pass=!show_pass;
                      setState(() {

                      });
                    },
                    icon: show_pass?const Icon(Icons.visibility_off):const Icon(Icons.visibility),
                  ),
                  hintText: '**********',
                  prefixIcon: MyImages.password,
                  showlabeltop: true,
                  label: 'Password',
                  labelfont: 12,
                  labelcolor: MyColors.paragraphcolor,
                  bgColor: Colors.transparent,
                  fontsize: 16,
                  hintcolor: MyColors.headingcolor,
                  suffixheight: 18,
                ),
                vSizedBox4,
                // CustomTextField(
                //   controller: hpcsaController,
                //   hintText: 'HPCSA Number',
                //   prefixIcon: MyImages.profile,
                //   showlabeltop: true,
                //   label: 'HPCSA',
                //   labelfont: 12,
                //   labelcolor: MyColors.paragraphcolor,
                //   bgColor: Colors.transparent,
                //   fontsize: 16,
                //   hintcolor: MyColors.headingcolor,
                //   suffixheight: 16,
                // ),
                // vSizedBox4,
                load
                    ? const CustomLoader()
                    : RoundEdgedButton(
                        text: 'Login',
                        onTap: () async {
                          if (
                          validateEmail(email.text, context) == null &&
                              // validateString(hpcsaController.text,"Please enter hpcsa number", context) == null &&
                              validateString(password.text,
                                      "Please enter your password.", context) ==
                                  null) {
                            Map<String, dynamic> data = {
                              "email": email.text.trim(),
                              "password": password.text,
                              // "hpcsa_no": hpcsaController.text,
                              'type': '1'
                            };
                            await EasyLoading.show(
                              status: null,
                              maskType: EasyLoadingMaskType.black,
                            );
                            setState(() {
                              // load=true;
                              // EasyLoading.init();
                            });
                            var res = await Webservices.postData(
                                apiUrl: ApiUrls.login,
                                body: data,
                                context: context);
                            await EasyLoading.dismiss();
                            setState(() {
                              // load=false;
                              // EasyLoading.show(status: 'loading...');
                            });
                            if (res['status'].toString() == '1') {
                              updateUserDetails(res['data']);
                              user_Data=res['data'];
                              invalid_user_detail=false;
                              setState(() {

                              });
                              if (res['data']['is_verified'].toString() ==
                                  '1') {
                                String? token =   await get_device_id();
                                print('token-----$token');
                                await Webservices.updateDeviceToken(user_id: user_Data!['id'].toString(), token: token!);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) {
                                  return tabs_third_page(
                                    initialIndex: 0,
                                  );
                                }), (route) {
                                  return false;
                                });
                                //
                                // push(
                                //     context: context,
                                //     screen: tabs_third_page(
                                //       selectedIndex: 0,
                                //     ));
                              } else {
                                invalid_user_detail=false;
                                setState(() {

                                });
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) {
                                  return PendingVerificationPage(
                                    id: res['data']['id'].toString(),
                                  );
                                }), (route) {
                                  return false;
                                });
                              }
                            } else {
                              setState(() {
                                invalid_user_text=res['message'];
                                invalid_user_detail=true;
                              });
                            }
                          }
                        }),
                vSizedBox4,
                GestureDetector(
                  onTap: () {
                    push(context: context, screen: const ForgotPasswordPage());
                  },
                  child: const Center(
                    child: ParagraphText(
                      text: 'Forgot Password?',
                      fontFamily: 'semibold',
                      // underlined: true,
                      color: MyColors.primaryColor,
                    ),
                  ),
                ),
                // vSizedBox4,
                // Stack(
                //   alignment: Alignment.center,
                //   children: [
                //     Divider(
                //       color: MyColors.headingcolor,
                //       // thickness: 1,
                //       height: 40,
                //     ),
                //     Container(
                //       height: 30,
                //       decoration: BoxDecoration(
                //         color: Color(0xFFCAE6FF),
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           ParagraphText(
                //             text: 'Sign in with Google account',
                //             fontFamily: 'light',
                //             color: MyColors.headingcolor,
                //             fontSize: 12,
                //           ),
                //         ],
                //       ),
                //     )
                //   ],
                // ),
                // vSizedBox2,
                // Center(
                //     child: Image.asset(
                //   MyImages.google,
                //   height: 30,
                // )),
                vSizedBox4,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ParagraphText(
                      text: 'If you don’t have an Account? ',
                    ),
                    GestureDetector(
                      onTap: () {
                        push(context: context, screen: const SignUp_Page_Doctor());
                      },
                      child: const ParagraphText(
                        text: 'Sign up',
                        fontFamily: 'semibold',
                        underlined: true,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
