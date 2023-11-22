import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/doctor_module/loginpage.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/image_urls.dart';
import '../functions/navigation_functions.dart';
import '../widgets/CustomTexts.dart';
import '../widgets/lists.dart';
class Select_Type_Page extends StatefulWidget {
  const Select_Type_Page({Key? key}) : super(key: key);

  @override
  State<Select_Type_Page> createState() => _Select_Type_PageState();
}

class _Select_Type_PageState extends State<Select_Type_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              MyImages.logo,
              height: 150,
            width: MediaQuery.of(context).size.width,
            ),
            vSizedBox6,
            GestureDetector(
              onTap: (){
                push(context: context, screen: LoginPage());
              },
              child: StaffList(
                text: 'Client/Patient',
                subtext: 'Select if you are a Healthcare user',
                fontSize: 14,
                image: MyImages.client_icon,
                // popupmenu: true,
              ),
            ),

            vSizedBox05,
            GestureDetector(
              onTap: (){
                push(context: context, screen: DoctorLoginPage());
              },
              child: StaffList(
                text: 'Healthcare Practitioner',
                subtext: 'Select if you are a Healthcare provider',
                fontSize: 14,
                image: MyImages.practitioner,
                // popupmenu: true,
              ),
            ),
            // vSizedBox05,
            // StaffList(
            //   text: 'Employee',
            //   subtext: 'Register and start marking your attendance',
            //   image: MyImages.employee,
            //   fontSize: 13,
            //   // popupmenu: true,
            // )
          ],



        ),
      ),
    );
  }
}
