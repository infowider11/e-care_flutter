import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:flutter/material.dart';

class RefundPage extends StatefulWidget {
  const RefundPage({Key? key}) : super(key: key);

  @override
  State<RefundPage> createState() => _RefundPageState();
}

class _RefundPageState extends State<RefundPage> {
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainHeadingText(text: 'What is the reason for refund?', fontSize: 32, fontFamily: 'light',),

            vSizedBox4,

            CustomTextField(showlabel: true, controller: email, maxLines: 5, height: 120, label: 'Reason', labelcolor: MyColors.bordercolor, hintText: 'I want to refund my amount...'),
            vSizedBox2,
            const RoundEdgedButton(text: 'Request')

          ],
        ),
      ),
    );
  }
}
