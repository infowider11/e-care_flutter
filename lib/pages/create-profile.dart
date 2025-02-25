// ignore_for_file: non_constant_identifier_names

import 'package:ecare/Services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/question_1_medication.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
 
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../services/auth.dart';

class CreateProfile extends StatefulWidget {
  final bool? hide_show;
  const CreateProfile({Key? key,this.hide_show}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: widget.hide_show==true?null:appBar(context: context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            if(widget.hide_show!=null)
            vSizedBox8,
            const MainHeadingText(text: 'Let’s create your health profile ', fontSize: 32, fontFamily: 'light',),
            vSizedBox2,
            const ParagraphText(fontSize: 16, text: 'The following 5 questions will help your Healthcare Practitioner better understand your healthcare needs'),
            vSizedBox4,
            RoundEdgedButton(text: 'Continue', onTap: (){
              // showSnackbar( 'Comming Soon.');
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Question1Medication()));
            }
                ),
            RoundEdgedButton(text: 'Skip', color: Colors.transparent, textColor: MyColors.primaryColor,
            onTap: () async{
              await EasyLoading.show(
                status: null,
                maskType: EasyLoadingMaskType.black
              );
              var res = await Webservices.get(ApiUrls.skip+'?user_id='+await getCurrentUserId());
              EasyLoading.dismiss();
              if(res['status'].toString()=='1'){
                Navigator.pop(context);
              }
              // await logout();

              // Navigator.of(context).pushReplacementNamed('/pre-login');
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             Welcome_Page()),
              //         (Route<dynamic> route) => false);
            },
            ),
          ],
        ),
      ),
    );
  }
}
