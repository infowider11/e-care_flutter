import 'package:ecare/Services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/pages/reason_visit.dart';
import 'package:ecare/pages/setting.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/custom_circular_image.dart';
import 'package:ecare/widgets/getCareblocks.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';

import '../constants/sized_box.dart';
import '../dialogs/loading_popup.dart';

class GetCare extends StatefulWidget {
  const GetCare({Key? key}) : super(key: key);

  @override
  State<GetCare> createState() => _GetCareState();
}

class _GetCareState extends State<GetCare> {
  List categories = [];
  bool load = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_cate();
  }

  get_cate() async{
    setState(() {
      load=true;
    });
    var res = await Webservices.getList(ApiUrls.getSpecialistCategory);
    print('cate------$res');
    categories=res;
    setState(() {
      
    });
    setState(() {
      load=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.BgColor,
      appBar: AppBar(
        backgroundColor: Color(0xFE00A2EA).withOpacity(0.1),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 5),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
              ),
              child: CustomCircularImage(
                imageUrl: user_Data!['profile_image'],
              ),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingPage())),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset('assets/images/menu.png', width: 24),
            ),
          ),
        ],
      ),
      body: load?CustomLoader():SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/patter.png',
              ),
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSizedBox2,
              MainHeadingText(
                text: 'Please choose a visit right for you',
                fontSize: 30,
                fontFamily: 'light',
              ),
              vSizedBox6,
              for(int i=0;i<categories.length;i++)
                if(categories[i]['parent'].toString()=='0')
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                    onTap: ()  {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ReasonPage(cate:categories[i],)));
                    },
                    child: GetCareBlocks(
                        fontSize: 20,
                        fontFamily: 'bold',
                        heading: '${categories[i]['title']}',
                        image: categories[i]['cat_icon'],
                        is_network_image: true,
                        bgColor: Color(0xFED8ECF8))),
              ),
              vSizedBox,
              // GetCareBlocks(
              //   heading: 'Specialist Doctors',
              //   iconColor: Color(0xFE00A2EA).withOpacity(0.1),
              //   image: 'assets/images/specialist.png',
              // ),
              // vSizedBox,
              // GetCareBlocks(
              //   heading: 'Mental Health',
              //   iconColor: Color(0xFE00A2EA).withOpacity(0.1),
              //   image: 'assets/images/mental.png',
              // ),
              // vSizedBox,
              // GetCareBlocks(
              //   heading: 'Allied Health Care',
              //   iconColor: Color(0xFE00A2EA).withOpacity(0.1),
              //   image: 'assets/images/allied.png',
              // ),
              // vSizedBox,
              // ParagraphText(
              //   text: 'How it works',
              //   underlined: true,
              //   fontFamily: 'semibold',
              //   fontSize: 14,
              //   color: MyColors.primaryColor,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
