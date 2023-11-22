import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_1_allergies.dart';
import 'package:ecare/pages/question_1_condition.dart';
import 'package:ecare/pages/question_1_medication.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({Key? key}) : super(key: key);

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainHeadingText(text: 'Add New Card ', fontSize: 32, fontFamily: 'light',),
              vSizedBox4,
              Column(
                children: [
                  CustomTextField(controller: email, label: 'Credit Card Number', showlabel: true, labelcolor: MyColors.onsurfacevarient, hintText: 'xxxx/xxxx/xxxx'),
                  vSizedBox,
                  CustomTextField(controller: email, label: 'Expiration(MM/YY)', showlabel: true, labelcolor: MyColors.onsurfacevarient, hintText: 'eg. 25/2023'),
                  vSizedBox,
                  CustomTextField(controller: email, label: 'CVV', showlabel: true, labelcolor: MyColors.onsurfacevarient, hintText: 'xxxx'),
                  vSizedBox,
                ],
              ),


              vSizedBox2,
              RoundEdgedButton(text: 'Save Credit card', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Question1Conditions())),)
            ],
          ),
        ),
      ),
    );
  }
}
