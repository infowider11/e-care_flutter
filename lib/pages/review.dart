// ignore_for_file: deprecated_member_use

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/tabs.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(context: context),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(50),
                decoration: BoxDecoration(
                    color: const Color(0xFE00A2EA).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star_rounded, color: MyColors.primaryColor,),
                        Icon(Icons.star_rounded, color: MyColors.primaryColor,),
                        Icon(Icons.star_rounded, color: MyColors.primaryColor,),
                        Icon(Icons.star_rounded, color: MyColors.bordercolor,),
                        Icon(Icons.star_rounded, color: MyColors.bordercolor,),
                      ],
                    ),
                    vSizedBox,
                    const MainHeadingText(textAlign: TextAlign.center, text: 'Please rate the service received from your Healthcare provider.', fontSize: 14, color: MyColors.paragraphcolor, fontFamily: 'light',),
                    vSizedBox2,
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star_rounded, color: MyColors.primaryColor,),
                        Icon(Icons.star_rounded, color: MyColors.primaryColor,),
                        Icon(Icons.star_rounded, color: MyColors.primaryColor,),
                        Icon(Icons.star_rounded, color: MyColors.bordercolor,),
                        Icon(Icons.star_rounded, color: MyColors.bordercolor,),
                      ],
                    ),
                    vSizedBox,
                    const MainHeadingText(textAlign: TextAlign.center, text: 'Please rate the quality of your video call', fontSize: 14, color: MyColors.paragraphcolor, fontFamily: 'light',),

                    vSizedBox2,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundEdgedButton(height: 40,  horizontalPadding: 10, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => tabs_second_page(selectedIndex: 0,))), text: 'Cancel', borderRadius: 100, fontSize: 14, width: 100, color: MyColors.white, textColor: MyColors.primaryColor, bordercolor: MyColors.bordercolor,),
                        // hSizedBox,
                        // RoundEdgedButton(height: 40,  horizontalPadding: 10, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCall())), text: 'Submit', borderRadius: 100, fontSize: 14, width: 100,),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
