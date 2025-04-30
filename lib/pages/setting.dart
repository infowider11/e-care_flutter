import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/doctor_module/change_password.dart';
import 'package:ecare/pages/privacy_policy.dart';
import 'package:ecare/pages/profile_edit.dart';
import 'package:ecare/pages/terms_cond_page.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/setting_list.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';
import '../welcome.dart';
import 'contact_us.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(context: context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainHeadingText(
              text: 'Setting',
              fontSize: 32,
              fontFamily: 'light',
            ),

            vSizedBox,

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
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileEdit())),
                      child: const ParagraphText(
                        text: 'Edit Profile',
                        color: MyColors.primaryColor,
                        fontFamily: 'semibold',
                      )),
                ],
              ),
            ),
            // vSizedBox,
            // vSizedBox05,
            SettingList(
                heading: 'Change Password',
                func: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePasswordPage()))),
            // SettingList(
            //     heading: 'My Notifications',
            //     func: () => Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => NotificationPage()))),
            ///
            // SettingList(
            //     heading: 'My Booking status',
            //     func: () => Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => BookingStatus()))),
            ///
            // SettingList(
            //     heading: 'Messages',
            //     func: () => Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => MessagePage()))),
            // SettingList(
            //     heading: 'Payment Method',
            //     func: () => Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => SettingPaymentMethod()))),
            SettingList(
                heading: 'Terms & Conditions',
                func: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const TermsCondPage(userType: '2',)))),
            SettingList(
                heading: 'Privacy Policy',
                func: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PrivacyPolicy(forDoctor: false,)))),
            SettingList(
                heading: 'Contact Us',
                func: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ContactUsPage()))),
            SettingList(
                heading: 'Sign Out',
                func: () => {
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
                          }),
                    }
                    ),
          ],
        ),
      ),
    );
  }
}
