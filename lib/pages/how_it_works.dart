// ignore_for_file: deprecated_member_use, avoid_print, non_constant_identifier_names

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/loader.dart';
 
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';

import '../services/webservices.dart';

class HowItWorks extends StatefulWidget {
  const HowItWorks({Key? key}) : super(key: key);

  @override
  State<HowItWorks> createState() => HowItWorksState();
}

class HowItWorksState extends State<HowItWorks> with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  late AnimationController controller;
  String? content;
  bool load=false;

  get_content() async{
    setState(() {
      load=true;
    });
    var res = await Webservices.get(ApiUrls.howitswork+user_Data!['type'].toString());
    print('content-----$res');
    if(res['status'].toString()=='1'){
      content = res['data']['description'];
      setState(() {

      });
    }
    setState(() {
      load=false;
    });
  }

  @override
  void initState() {
    
    super.initState();
    get_content();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context,title: 'How it works',fontsize: 20,fontfamily: 'light'),
      body: load?const CustomLoader():SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // vSizedBox2,
            // MainHeadingText(text: 'How it works ', fontSize: 32, fontFamily: 'light',),
            // vSizedBox4,
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MyColors.lightBlue.withOpacity(0.11),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [
                  Html(data: content, extensions:const [
                             TableHtmlExtension(),
                          ],),
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
