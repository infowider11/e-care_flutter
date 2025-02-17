import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/signup.dart';
import 'package:ecare/services/validation.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../doctor_module/forgot.dart';
import '../functions/global_Var.dart';
import '../services/auth.dart';
import '../services/onesignal.dart';
import '../tabs.dart';
import 'package:flutter/foundation.dart';

class LoginPage extends StatefulWidget {
  final bool loginWihtHealthCareProviderCode ; 
  const LoginPage({Key? key ,  this.loginWihtHealthCareProviderCode = false}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class UserData {
  UserData({this.uid});
  final String? uid;
}

final firebaseAuth = FirebaseAuth.instance;

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController hpcsaController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  bool invalid_user_detail = false;
  String? invalid_user_text;
  bool show_pass = false;

  addUserToFirebase(Map data) async {
    DocumentReference documentReferencer = _userCollection.doc();
    QuerySnapshot user =
        await _userCollection.where("email", isEqualTo: data['email']).get();
    print('the user is ${user.docs.length}');

    print(user);
    if (user.docs.length == 0) {
      await documentReferencer
          .set(data)
          .whenComplete(() => print("Notes item added to the database"))
          .catchError((e) => print(e));
    }
    print('user added');
    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));
  }

  void _signInWithGoogle() async {
    await EasyLoading.show(status: null, maskType: EasyLoadingMaskType.black);
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
        'name': authResult.user?.displayName,
        'email': authResult.user?.email ?? '',
        // 'fname':authResult.additionalUserInfo.
      };
      await googleSignIn.disconnect();
      print('google login successfully-------------- ${data}');
      Map<String, dynamic> request = {
        'email': authResult.user?.email ?? '',
        'google_id': authResult.user?.uid
      };
      var res = await Webservices.postData(
        apiUrl: ApiUrls.socialsignup,
        body: request,
        context: context,
      );
      print('social api res------ ${res}');
      EasyLoading.dismiss();
      if (res['status'].toString() == '1') {
        updateUserDetails(res['data']);
        user_Data = res['data'];
        invalid_user_detail = false;
        setState(() {});
        if (!kIsWeb) {
          String? token = await get_device_id();
          print('token-----$token');
          await Webservices.updateDeviceToken(
              user_id: user_Data!['id'].toString(), token: token!);
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return tabs_second_page(
            selectedIndex: 0,
          );
        }), (route) {
          return false;
        });
      } else if (res['status'].toString() == '0') {
        push(
            context: context,
            screen: SignUp_Page(
              is_googleSignin: true,
              googleSignin_data: data,
            ));
      } else if (res['status'].toString() == '2') {
        showSnackbar(res['message']);
      } else {
        showSnackbar('Something went wrong.Please try again latter.');
      }
      // addUserToFirebase(data);
    } else {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Something Wrong happened!!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.scaffold,
      appBar: appBar(
        context: context,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
              if (invalid_user_detail)
                headingText(
                  text: '$invalid_user_text',
                  color: MyColors.red,
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
              CustomTextField(
                controller: password,
                hintText: '**********',
                prefixIcon: MyImages.password,
                showlabeltop: true,
                suffix: IconButton(
                  onPressed: () {
                    show_pass = !show_pass;
                    setState(() {});
                  },
                  icon: show_pass
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                ),
                obscureText: !show_pass,
                label: 'Password',
                labelfont: 12,
                labelcolor: MyColors.paragraphcolor,
                bgColor: Colors.transparent,
                fontsize: 16,
                hintcolor: MyColors.headingcolor,
                suffixheight: 18,
              ),
              if(widget.loginWihtHealthCareProviderCode)
              vSizedBox4,
              if(widget.loginWihtHealthCareProviderCode)
              CustomTextField(
                controller: hpcsaController,
                hintText: 'Healthcare Provider code',
                prefixIcon: MyImages.profile,
                showlabeltop: true,
                label: 'Healthcare Provider code',
                labelfont: 12,
                labelcolor: MyColors.paragraphcolor,
                bgColor: Colors.transparent,
                fontsize: 16,
                hintcolor: MyColors.headingcolor,
                suffixheight: 16,
              ),

              vSizedBox4,
              RoundEdgedButton(
                onTap: () async {
                  if(widget.loginWihtHealthCareProviderCode){
                    showSnackbar("Comming Soon.....");
                    return ;
                  }
                  if (validateEmail(email.text, context) == null &&
                      validateString(password.text, 'Please Enter Password',
                              context) ==
                          null) {
                    Map<String, dynamic> data = {
                      'email': email.text.trim(),
                      'password': password.text,
                      'type': '2'
                    };
                    await EasyLoading.show(
                      status: null,
                      maskType: EasyLoadingMaskType.black,
                    );
                    var res = await Webservices.postData(
                        apiUrl: ApiUrls.login, body: data, context: context);
                    print('login successfully----$res');
                    EasyLoading.dismiss();
                    if (res['status'].toString() == '1') {
                      updateUserDetails(res['data']);
                      user_Data = res['data'];
                      invalid_user_detail = false;
                      setState(() {});
                      if (!kIsWeb) {
                        String? token = await get_device_id();
                        print('token-----$token');
                        await Webservices.updateDeviceToken(
                            user_id: user_Data!['id'].toString(),
                            token: token!);
                      }
                      // if(res['data']['is_verified'].toString()=='1') {
                      //   Navigator.of(context).pushAndRemoveUntil(
                      //       MaterialPageRoute(builder: (context) {
                      //         return tabs_second_page( selectedIndex: 0,);
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
                      // updateUserDetails(res['data']);

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) {
                        return tabs_second_page(
                          selectedIndex: 0,
                        );
                      }), (route) {
                        return false;
                      });
                    } else {
                      setState(() {
                        invalid_user_text = res['message'];
                        invalid_user_detail = true;
                      });
                      // showSnackbar( res['message']);
                    }
                  }
                  // push(context: context, screen: tabs_second_page(selectedIndex: 0,));
                },
                text: 'Login',
              ),
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
              vSizedBox4,
              // Stack(
              //   alignment: Alignment.center,
              //   children: [
              //     Divider(
              //       color: MyColors.headingcolor,
              //       // thickness: 1,
              //       height: 40,
              //     ),
              //
              //     Container(
              //       height: 30,
              //       decoration: BoxDecoration(
              //         color: Color(0xFFCAE6FF),
              //         borderRadius: BorderRadius.circular(8),
              //
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
              //
              //   ],
              // ),
              // vSizedBox2,
              // IconButton(
              // onPressed: () async{
              //
              //   _signInWithGoogle();
              // },
              // icon:Image.asset(MyImages.google, height: 30,)),
              // vSizedBox2,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ParagraphText(
                    text: 'If you don’t have an Account? ',
                  ),
                  GestureDetector(
                    onTap: () {
                      push(context: context, screen: SignUp_Page());
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
    );
  }
}
