import 'package:ecare/doctor_module/patient-details.dart';
import 'package:ecare/widgets/custom_circular_image.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/sized_box.dart';
import '../doctor_module/videocall.dart';
import 'CustomTexts.dart';
import 'buttons.dart';

class AppointmentBlock extends StatelessWidget {
  final bool showButton;
  final bool showStartButton;
  final bool showCheck;
  final Color bgColor;
  final String? heading;
  final String? subheading;
  final String? date_time;
  final bool? networkimage;
  final String? image_url;
  const AppointmentBlock({
    Key? key,
    this.heading = 'Test',
    this.subheading = 'Sub-head',
    this.date_time = '10 Aug, 2022    8:00 pm - 9:00 pm',
    this.showButton = false,
    this.showStartButton = false,
    this.image_url = '',
    this.networkimage = false,
    this.showCheck = false,
    this.bgColor = MyColors.lightBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PatientDetails())),
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: bgColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (networkimage!)
                  CustomCircularImage(
                    imageUrl: image_url!,
                    width: 50,
                  ),
                hSizedBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainHeadingText(
                      text: heading!,
                      fontSize: 16,
                    ),
                    MainHeadingText(
                      text: 'Category: ${subheading}',
                      fontFamily: 'light',
                      fontSize: 14,
                    ),
                    MainHeadingText(
                      text: date_time!,
                      fontFamily: 'light',
                      color: MyColors.onsurfacevarient,
                      fontSize: 14,
                    ),
                    if (showStartButton)
                      Column(
                        children: [
                          vSizedBox,
                          RoundEdgedButton(
                            text: 'Start',
                            borderRadius: 100,
                            width: 80,
                            height: 35,
                            horizontalPadding: 0,
                            verticalPadding: 0,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DoctorVideoCall())),
                          ),
                        ],
                      ),
                    if (showButton)
                      Column(
                        children: [
                          vSizedBox2,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RoundEdgedButton(
                                text: 'Skip',
                                borderRadius: 100,
                                width: 70,
                                height: 35,
                                horizontalPadding: 0,
                                verticalPadding: 0,
                                color: Colors.transparent,
                                textColor: MyColors.primaryColor,
                                bordercolor: MyColors.primaryColor,
                              ),
                              hSizedBox,
                              RoundEdgedButton(
                                text: 'Accept',
                                borderRadius: 100,
                                width: 80,
                                height: 35,
                                horizontalPadding: 0,
                                verticalPadding: 0,
                                // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Question2Allergies())),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            if (showCheck)
              Image.asset(
                'assets/images/tick.png',
                width: 20,
              ),
          ],
        ),
      ),
    );
  }
}
