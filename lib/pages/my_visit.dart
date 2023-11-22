import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/appointment_request_block.dart';
import 'package:ecare/widgets/list_ui_1.dart';
import 'package:flutter/material.dart';

class VisitPage extends StatefulWidget {
  const VisitPage({Key? key}) : super(key: key);

  @override
  State<VisitPage> createState() => VisitPageState();
}

class VisitPageState extends State<VisitPage> with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  late AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSizedBox2,
            MainHeadingText(text: 'My Completed Visits ', fontSize: 32, fontFamily: 'light',),
            vSizedBox2,
            ParagraphText(fontSize: 16, text: 'Check your total visits here'),
            vSizedBox4,
 
            for(var i=0; i<5; i++)
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xfe006493).withOpacity(0.11)
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/23.png', width: 50,),
                        hSizedBox,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainHeadingText(text: 'Dr. John Smith', fontSize: 16,),
                            MainHeadingText(text: 'Lorem ipsum dolor sit amet', fontFamily: 'light', fontSize: 14,),
                            vSizedBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                MainHeadingText(text: '10 Aug, 2022', fontFamily: 'light', color: MyColors.onsurfacevarient, fontSize: 14,),
                                hSizedBox2,
                                Row(
                                  children: [
                                    Image.asset('assets/images/call.png', width: 20,),
                                    hSizedBox05,
                                    MainHeadingText(text: '1:20:00', fontFamily: 'light', color: MyColors.onsurfacevarient, fontSize: 14,),
                                  ],
                                ),
                              ],
                            )

                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
