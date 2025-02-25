// ignore_for_file: deprecated_member_use

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/list_ui_1.dart';
import 'package:flutter/material.dart';

class BookingStatus extends StatefulWidget {
  const BookingStatus({Key? key}) : super(key: key);

  @override
  State<BookingStatus> createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(context: context, appBarColor: MyColors.BgColor),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainHeadingText(text: 'Booking Status', fontSize: 32, fontFamily: 'light',),

            vSizedBox,

            ListUI01(isthirdHead: true,  image: 'assets/images/23.png', bgColor: MyColors.lightBlue.withOpacity(0.11), borderColor: MyColors.lightBlue.withOpacity(0.11), heading: 'John Smith', subheading: 'symptoms: Cold cough', isIcon: false, thirdHead: 'Paid and Finalized Booking',),
            ListUI01(isthirdHead: true, thirdHeadColor: MyColors.red, thirdHead: 'Cancelled', image: 'assets/images/23.png', bgColor: MyColors.lightBlue.withOpacity(0.11), borderColor: MyColors.lightBlue.withOpacity(0.11), heading: 'John Smith', subheading: 'symptoms: Cold cough', isIcon: false,),
            ListUI01(isthirdHead: true, thirdHead: 'Pending', thirdHeadColor: MyColors.yellow, image: 'assets/images/23.png', bgColor: MyColors.lightBlue.withOpacity(0.11), borderColor: MyColors.lightBlue.withOpacity(0.11), heading: 'John Smith', subheading: 'symptoms: Cold cough', isIcon: false,),
            ListUI01(isthirdHead: true, thirdHead: 'confirmed/awaiting payment to \nfinalize booking',  image: 'assets/images/23.png', bgColor: MyColors.lightBlue.withOpacity(0.11), borderColor: MyColors.lightBlue.withOpacity(0.11), heading: 'John Smith', subheading: 'symptoms: Cold cough', isIcon: false,),
          ],
        ),
      ),
    );
  }
}
