import 'package:ecare/pages/setting.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/sized_box.dart';
import '../doctor_module/notification.dart';
import '../widgets/customtextfield.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({Key? key}) : super(key: key);

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: AppBar(
        backgroundColor: MyColors.BgColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 5),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
              ),
              child: Image.asset('assets/images/23.png', width: 35)
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage())),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset('assets/images/menu.png', width: 24),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            MainHeadingText(text: 'Invite your friends & family!', fontSize: 32, fontFamily: 'light',),
            vSizedBox4,
            Column(
              children: [
                // CustomTextField(labelText: '', hintText: 'Invite your friends & family to download the app', upperSpace: 0, isIcon: true, icon: Icons.search_outlined,),

                for(var i = 0; i < 5; i++)
                Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/23.png', width: 45,),
                              hSizedBox2,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MainHeadingText(text: 'Lindsey Septimus', fontSize: 16, fontFamily: 'medium', color: MyColors.headingcolor),
                                  vSizedBox05,
                                  MainHeadingText(text: '+91 9876543210', fontSize: 12, fontFamily: 'medium', color: Color(0xFE7a7a7a)),
                                ],
                              )
                            ],
                          ),

                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: MyColors.headingcolor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: MainHeadingText(text: 'Invite', fontSize: 14, color: MyColors.headingcolor, fontFamily: 'medium',),
                              ),
                            ),
                          )
                        ],
                      ),
                      vSizedBox2,
                    ],
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
