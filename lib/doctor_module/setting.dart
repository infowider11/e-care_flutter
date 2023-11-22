import 'package:ecare/doctor_module/changePassword.dart';
import 'package:ecare/doctor_module/loginpage.dart';
import 'package:ecare/doctor_module/payment_method.dart';
import 'package:ecare/pages/contact_us.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/privacy_policy.dart';
import 'package:ecare/pages/terms_cond_page.dart';
import 'package:flutter/material.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/doctor_module/profile_edit.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/setting_list.dart';

import '../pages/add_bank_account_page.dart';
import '../services/auth.dart';
import '../welcome.dart';

class DoctorSettingPage extends StatefulWidget {
  const DoctorSettingPage({Key? key}) : super(key: key);

  @override
  State<DoctorSettingPage> createState() => _DoctorSettingPageState();
}

class _DoctorSettingPageState extends State<DoctorSettingPage> {
  Map userData = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetail();
  }

  getDetail() async {
    userData = await getUserDetails();
    print(userData);
    setState(() {});
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFE00A2EA).withOpacity(0.1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MainHeadingText(
                text: 'My Profile', fontFamily: 'light', fontSize: 28),
          ],
        ),
        actions: <Widget>[
          GestureDetector(
            // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage())),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.notifications,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/patter.png',
            ),
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.network('${userData['profile_image']}',
                          width: 35)),
                  hSizedBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainHeadingText(
                        text: 'Hello,',
                        fontFamily: 'light',
                        color: MyColors.onsurfacevarient,
                        fontSize: 14,
                      ),
                      MainHeadingText(
                        text:
                            '${userData['first_name']} ${userData['last_name']}!',
                        color: MyColors.primaryColor,
                        fontSize: 16,
                      ),
                    ],
                  )
                ],
              ),
              vSizedBox4,

              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Color(0xFED3E5F5),
                    borderRadius: BorderRadius.circular(100)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ParagraphText(
                        text: 'My Profile',
                        fontFamily: 'bold',
                        color: MyColors.black),
                    GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DoctorProfileEdit()));
                          getDetail();
                        },
                        child: ParagraphText(
                          text: 'Edit Profile',
                          color: MyColors.primaryColor,
                          fontFamily: 'semibold',
                        )),
                  ],
                ),
              ),
              SettingList(
                  heading: 'Add bank account',
                  func: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddBankAccountPage()))),

              SettingList(
                  heading: 'Change Password',
                  func: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordPage()))),

              SettingList(
                  heading: 'Terms & Conditions',
                  func: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TermsCondPage()))),
              SettingList(
                  heading: 'Privacy & Policy',
                  func: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacyPolicy()))),
              SettingList(
                  heading: 'Contact Us',
                  func: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactUsPage()))),
              SettingList(
                  heading: 'Sign Out',
                  func: () async {
                    showDialog(
                        context: context,
                        builder: (context1) {
                          return AlertDialog(
                            title: Text(
                              'Logout',
                            ),
                            content: Text('Are you sure, want to logout?'),
                            actions: [
                                TextButton(
                                  onPressed: () async {
                                    await logout();

                                    // Navigator.of(context).pushReplacementNamed('/pre-login');
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Welcome_Page()),
                                        (Route<dynamic> route) => false);
                                  },
                                  child: Text('logout')),
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context1);
                                  },
                                  child: Text('cancel')),
                            ],
                          );
                        });
                  })
              // } Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorLoginPage()))),
            ],
          ),
        ),
      ),
    );
  }
}
