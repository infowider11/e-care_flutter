import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_2_allergies.dart';
import 'package:ecare/pages/question_2_medication.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/list_ui_1.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../services/webservices.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => PrivacyPolicyState();
}

class PrivacyPolicyState extends State<PrivacyPolicy> with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  late AnimationController controller;

  String? conent;
  bool load=false;

  get_content() async{
    setState(() {
      load=true;
    });
    var res = await Webservices.get(ApiUrls.privacy);
    print('content-----$res');
    if(res['status'].toString()=='1'){
      conent = res['data']['description'];
      setState(() {

      });
    }
    setState(() {
      load=false;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_content();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context,title: 'Privacy Policy',fontsize: 20),
      body: load?CustomLoader():SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // vSizedBox2,
            // MainHeadingText(text: 'Privacy Policy ', fontSize: 32, fontFamily: 'light',),
            // vSizedBox4,

            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MyColors.lightBlue.withOpacity(0.11),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [
                  Html(data: conent),
                ],
              ),
            ),
            vSizedBox2
          ],
        ),
      ),
    );
  }
}
