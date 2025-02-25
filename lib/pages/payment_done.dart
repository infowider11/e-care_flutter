// ignore_for_file: deprecated_member_use

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:flutter/material.dart';

class PaymentDone extends StatefulWidget {
  const PaymentDone({Key? key}) : super(key: key);

  @override
  State<PaymentDone> createState() => _PaymentDoneState();
}

class _PaymentDoneState extends State<PaymentDone> {
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
              const MainHeadingText(text: 'Congratulations', fontFamily: 'light', fontSize: 32,),
              vSizedBox4,
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
                    Image.asset('assets/images/tick.png', width: 48,),
                    vSizedBox2,
                    const MainHeadingText(textAlign: TextAlign.center, text: 'Appointment Scheduled', fontSize: 24, fontFamily: 'light',),

                    vSizedBox2,
                    // MainHeadingText(textAlign: TextAlign.center, text: 'We will hold your appointment request for 20 minutes while you answer a few Questions.', fontSize: 14, color: MyColors.paragraphcolor, fontFamily: 'light',),
                    // vSizedBox2,
                    // RoundEdgedButton(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCall())), text: 'Ok', borderRadius: 100, fontSize: 14, width: 100,),
                    vSizedBox2,
                    const MainHeadingText(textAlign: TextAlign.center, text: ' If your consultation does not take place, please send us a message via the app '
                        'Contact us Tab and we will review our records. If it is the fault of the healthcare provider that the consultation did not take place, we will refund you the full consultation fee.', fontSize: 14, color: MyColors.paragraphcolor,fontFamily: 'light',),
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
