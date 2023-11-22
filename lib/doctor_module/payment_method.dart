import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/add_new_card.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/list_ui_1.dart';
import 'package:flutter/material.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(context: context, appBarColor: MyColors.BgColor),
      body: Container(
        color: MyColors.lightBlue.withOpacity(0.11),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainHeadingText(text: 'Payment method', fontFamily: 'light', fontSize: 28,),
              vSizedBox2,
              ListUI01(heading: 'VISA:1234', imgWidth: 70, subheading: 'EXP. Date: 06/26', isIcon: false, image: 'assets/images/card.png', bgColor: MyColors.lightBlue.withOpacity(0.11), borderColor: Colors.transparent, ),
              vSizedBox2,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RoundEdgedButton(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewCard())), text: 'Add new Card', width: 140, height: 40, borderRadius: 100, verticalPadding: 0, horizontalPadding: 0,)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
