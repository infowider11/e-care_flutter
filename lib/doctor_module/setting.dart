// ignore_for_file: deprecated_member_use, avoid_print

import 'package:ecare/doctor_module/change_password.dart';
import 'package:ecare/pages/contact_us.dart';
import 'package:ecare/pages/privacy_policy.dart';
import 'package:ecare/pages/terms_cond_page.dart';
import 'package:ecare/widgets/custom_circular_image.dart';
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
        backgroundColor: const Color(0xFE00A2EA).withOpacity(0.1),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MainHeadingText(
                text: 'My Profile', fontFamily: 'light', fontSize: 28),
          ],
        ),
        actions: <Widget>[
          GestureDetector(
            // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage())),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/patter.png',
            ),
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomCircularImage(
                      height: 35,
                      width: 35,
                      imageUrl: '${userData['profile_image']}'),
                  // Container(
                  //     clipBehavior: Clip.hardEdge,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: Image.network('${userData['profile_image']}',
                  //         width: 35)),
                  hSizedBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MainHeadingText(
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: const Color(0xFED3E5F5),
                    borderRadius: BorderRadius.circular(100)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ParagraphText(
                        text: 'My Profile',
                        fontFamily: 'bold',
                        color: MyColors.black),
                    GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DoctorProfileEdit()));
                          getDetail();
                        },
                        child: const ParagraphText(
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
                          builder: (context) => const AddBankAccountPage()))),

              SettingList(
                  heading: 'Change Password',
                  func: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage()))),

              SettingList(
                  heading: 'Terms & Conditions',
                  func: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TermsCondPage()))),
              SettingList(
                  heading: 'Privacy & Policy',
                  func: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrivacyPolicy()))),
              SettingList(
                  heading: 'Contact Us',
                  func: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactUsPage()))),
              SettingList(
                  heading: 'Sign Out',
                  func: () async {
                    showDialog(
                        context: context,
                        builder: (context1) {
                          return AlertDialog(
                            title: const Text(
                              'Logout',
                            ),
                            content: const Text('Are you sure, want to logout?'),
                            actions: [
                                TextButton(
                                  onPressed: () async {
                                    await logout();

                                    // Navigator.of(context).pushReplacementNamed('/pre-login');
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Welcome_Page()),
                                        (Route<dynamic> route) => false);
                                  },
                                  child: const Text('logout')),
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context1);
                                  },
                                  child: const Text('cancel')),
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
