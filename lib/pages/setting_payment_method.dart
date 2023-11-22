import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/add_new_card.dart';
import 'package:ecare/pages/doctor-details.dart';
import 'package:ecare/pages/long_felt_way.dart';
import 'package:ecare/pages/payment_done.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:flutter/material.dart';

class SettingPaymentMethod extends StatefulWidget {
  const SettingPaymentMethod({Key? key}) : super(key: key);

  @override
  State<SettingPaymentMethod> createState() => _SettingPaymentMethodState();
}

class _SettingPaymentMethodState extends State<SettingPaymentMethod> {
  TextEditingController email = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(context: context),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          height: MediaQuery.of(context).size.height - 120,
          child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainHeadingText(text: 'Payment Method', fontFamily: 'light', fontSize: 32,),
                    vSizedBox2,

                    RoundEdgedButton(horizontalPadding: 16, isSingleLeftContent: true, textalign: TextAlign.left, text: 'Credit Card, FSA,HSA', bordercolor: MyColors.primaryColor, color: MyColors.white, textColor: MyColors.primaryColor,),
                    vSizedBox,
                    RoundEdgedButton(horizontalPadding: 16, isSingleLeftContent: true, textalign: TextAlign.left, text: 'Paypal', bordercolor: MyColors.bordercolor, color: MyColors.white, textColor: MyColors.onsurfacevarient,),

                    vSizedBox2,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RoundEdgedButton(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewCard())), height: 40, text: 'Add new Card', borderRadius: 100, width: 140, horizontalPadding: 10,)
                      ],
                    )
                  ],
                ),
              ]
          ),
        ),
      ),
    );
  }
}
