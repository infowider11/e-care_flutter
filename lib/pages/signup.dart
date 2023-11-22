import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import '../services/api_urls.dart';
import '../functions/global_Var.dart';
import '../services/auth.dart';
import '../services/firebase_push_notifications.dart';
import '../services/onesignal.dart';
import '../services/validation.dart';
import '../services/webservices.dart';
import '../tabs.dart';
import '../widgets/showSnackbar.dart';

class SignUp_Page extends StatefulWidget {
  late bool? is_googleSignin;
  late Map? googleSignin_data;
   SignUp_Page({Key? key,this.googleSignin_data,this.is_googleSignin}) : super(key: key);

  @override
  State<SignUp_Page> createState() => _SignUp_PageState();
}

class _SignUp_PageState extends State<SignUp_Page> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController dob = TextEditingController();
  bool show_pass=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('google login data---- ${widget.googleSignin_data?['email']}');
    if(widget.googleSignin_data!=null){
      email.text=widget.googleSignin_data?['email']??'';
    }
  }

  void _signInWithGoogle() async {
    await EasyLoading.show(
        status: null,
        maskType: EasyLoadingMaskType.black
    );
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      GoogleSignInAuthentication googleAuth =
      await googleAccount.authentication;
      final authResult = await firebaseAuth.signInWithCredential(
        GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ),
      );
      // return _userFromFirebase(authResult.user);
      print('the user data is ${authResult}');
      Map<String, dynamic> data = {
        'uid': authResult.user?.uid,
        'name':authResult.user?.displayName,
        'email':authResult.user?.email??'',
        // 'fname':authResult.additionalUserInfo.
      };
      await googleSignIn.disconnect();
      // EasyLoading.dismiss();
      print('google login successfully-------------- ${data}');

      Map<String,dynamic> request = {
        'email':authResult.user?.email??'',
        'google_id':authResult.user?.uid
      };
      var res = await Webservices.postData(apiUrl: ApiUrls.socialsignup, body: request, context: context);
      print('social api res------ ${res}');
      EasyLoading.dismiss();
      if(res['status'].toString()=='1'){
        updateUserDetails(res['data']);
        user_Data=res['data'];
        setState(() {
        });
        if(!kIsWeb) {
          String? token =   await get_device_id();
          print('token-----$token');
          await Webservices.updateDeviceToken(user_id: user_Data!['id'].toString(), token: token!);
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
              return tabs_second_page( selectedIndex: 0,);
            }), (route) {
          return false;
        });
      }
      // else {
      //   widget.is_googleSignin = true;
      //   widget.googleSignin_data = data;
      //   email.text=widget.googleSignin_data?['email']??'';
      //   setState(() {
      //   });
      //   // push(context: context, screen: SignUp_Page(
      //   //   is_googleSignin: true,
      //   //   googleSignin_data: data,
      //   // ));
      // }
      else if(res['status'].toString()=='0') {
          widget.is_googleSignin = true;
          widget.googleSignin_data = data;
          email.text=widget.googleSignin_data?['email']??'';
          setState(() {
          });
    } else if(res['status'].toString()=='2') {
      showSnackbar( res['message']);
    } else {
      showSnackbar( 'Something went wrong.Please try again latter.');
    }
    } else {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something Wrong happened.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Image.asset(
                    MyImages.logo,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                  ),
                  vSizedBox,
                  MainHeadingText(
                    text: 'SignUp to E-Care',
                    fontSize: 32,
                    fontFamily: 'light',
                    color: MyColors.primaryColor,
                  ),
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
                  GestureDetector(
                    onTap: () async {
                      var m = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 150),
                          lastDate: DateTime.now());
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
                      prefixIcon: MyImages.date,
                      showlabeltop: true,
                      enabled: false,
                      label: 'DOB',
                      labelfont: 12,
                      labelcolor: MyColors.paragraphcolor,
                      bgColor: Colors.transparent,
                      fontsize: 16,
                      hintcolor: MyColors.headingcolor,
                      suffixheight: 16,
                    ),
                  ),
                  vSizedBox4,
                  CustomTextField(
                    controller: password,
                    hintText: '**********',
                    prefixIcon: MyImages.password,
                    showlabeltop: true,
                    label: 'Password',
                    obscureText: !show_pass,
                    suffix: IconButton(
                      onPressed: (){
                        show_pass=!show_pass;
                        setState(() {

                        });
                      },
                      icon: show_pass?Icon(Icons.visibility_off):Icon(Icons.visibility),
                    ),
                    labelfont: 12,
                    labelcolor: MyColors.paragraphcolor,
                    bgColor: Colors.transparent,
                    fontsize: 16,
                    hintcolor: MyColors.headingcolor,
                    suffixheight: 18,
                  ),
                  vSizedBox4,
                  RoundEdgedButton(
                    text: 'Continue',
                    onTap: () {
                      if (validateEmail(email.text, context) == null &&
                          validateString(dob.text, "Please enter your date of birth.",
                                  context) ==
                              null &&
                          validateString(password.text, "Please enter your password.",
                                  context) ==
                              null) {
                        Map<String, dynamic> data = {
                          "email": email.text,
                          "dob": dob.text,
                          "password": password.text,
                          "type": '2' //2 for patient
                        };
                        push(
                            context: context,
                            screen: Whoiam_Page(
                              is_googleSignin: widget.is_googleSignin,
                              googleSignin_data: widget.googleSignin_data,
                              pre_data: data,
                            ));
                      }
                    },
                  ),
                  vSizedBox6,
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Divider(
                        color: MyColors.headingcolor,
                        // thickness: 1,
                        height: 40,
                      ),
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color(0xFFCAE6FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ParagraphText(
                              text: 'Or Sign in with Google account',
                              fontFamily: 'light',
                              color: MyColors.headingcolor,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  vSizedBox2,
              IconButton(
                  onPressed: () async{
                    _signInWithGoogle();
                  },
                  icon:Image.asset(MyImages.google, height: 30,)),
                  vSizedBox2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ParagraphText(
                        text: 'Already have an account? ',
                      ),
                      GestureDetector(
                        onTap: () {
                          push(context: context, screen: LoginPage());
                        },
                        child: ParagraphText(
                          text: 'Login',
                          fontFamily: 'semibold',
                          underlined: true,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
