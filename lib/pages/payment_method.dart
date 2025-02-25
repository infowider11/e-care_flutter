import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/payment_done.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:flutter/material.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  TextEditingController email = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(context: context),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          height: MediaQuery.of(context).size.height - 120,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MainHeadingText(text: 'Payment Method', fontFamily: 'light', fontSize: 32,),
                  vSizedBox2,
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: MyColors.white,
                      border: Border.all(
                          color: MyColors.bordercolor,
                          width: 1
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const ParagraphText(text: 'Congestion/ sinus problem', color: MyColors.bordercolor, ),
                        Checkbox(
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  vSizedBox,
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: MyColors.white,
                      border: Border.all(
                          color: MyColors.bordercolor,
                          width: 1
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const ParagraphText(text: 'Payfast', color: MyColors.bordercolor, ),
                        Checkbox(
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  vSizedBox2,
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundEdgedButton(text: 'Add new Card', borderRadius: 100, width: 140, horizontalPadding: 10,)
                    ],
                  )
                ],
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: RoundEdgedButton(text: 'Continue to pay', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentDone())),),
              )
            ]
          ),
        ),
      ),
    );
  }
}
