import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_2_allergies.dart';
import 'package:ecare/pages/question_2_medication.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/list_ui_1.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TermsCondPage extends StatefulWidget {
  final String? userType;
  const TermsCondPage({Key? key, this.userType}) : super(key: key);

  @override
  State<TermsCondPage> createState() => TermsCondPageState();
}

class TermsCondPageState extends State<TermsCondPage>
    with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  late AnimationController controller;
  String? conent;
  bool load=false;

  get_content() async{
    setState(() {
      load=true;
    });

    print('the userLogin status is ${user_Data?['type']}....${widget.userType}');
    // var type = await isUserLoggedIn()?user_Data!['type'].toString():'1';
    var type = await isUserLoggedIn()?user_Data!['type'].toString():widget.userType??'1';
      var res = await Webservices.get(ApiUrls.term+type);
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
      appBar: appBar(context: context,title: 'Terms & Conditions',fontsize: 20,),
      body: load?CustomLoader():SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // vSizedBox2,
            // MainHeadingText(
            //   text: 'Terms & Conditions',
            //   fontSize: 32,
            //   fontFamily: 'light',
            // ),
            // vSizedBox4,
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: MyColors.lightBlue.withOpacity(0.11),
                  borderRadius: BorderRadius.circular(15)),
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
