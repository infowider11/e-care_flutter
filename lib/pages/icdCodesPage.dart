import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:ecare/functions/download_file.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_2_allergies.dart';
import 'package:ecare/pages/question_2_medication.dart';
import 'package:ecare/pages/who_i_am_page.dart';
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
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/api_variable_keys.dart';
import '../widgets/showSnackbar.dart';
import 'bookingDetail.dart';

class IcdCodesPage extends StatefulWidget {
  String? doc_name;
  String? doc_type;
  IcdCodesPage({Key? key, this.doc_name, this.doc_type}) : super(key: key);

  @override
  State<IcdCodesPage> createState() => IcdCodesPageState();
}

class IcdCodesPageState extends State<IcdCodesPage>
    with TickerProviderStateMixin {
  // TabBar get _tabBar => TabBar(
  //   padding: EdgeInsets.symmetric(horizontal: 0),
  //   labelPadding: EdgeInsets.symmetric(horizontal: 0),
  //   tabs: <Widget>[
  //     Tab(
  //       child: MainHeadingText(
  //         text: 'My Invoice',
  //         color: MyColors.onsurfacevarient,
  //         fontSize: 11,
  //       ),
  //     ),
  //     Tab(
  //       child: MainHeadingText(
  //         text: 'Statement with ICD-10 Notes',
  //         color: MyColors.onsurfacevarient,
  //         fontSize: 11,
  //       ),
  //     ),
  //   ],
  // );
  TextEditingController email = TextEditingController();
  bool load = false;
  // List invoiceList = [];
  List icdNotes = [];


  // ?doctor_id=23&booking_id=2
  getIcdCodes() async {
    icdNotes = await Webservices.getList(ApiUrls.usericdCode_list+'?user_id=${await getCurrentUserId()}&type=1');
    setState(() {

    });
  }


  @override
  void initState() {
    super.initState();
    getIcdCodes();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: MyColors.scaffold,
        appBar: AppBar(
          centerTitle: true,
          title: MainHeadingText(
            text: 'Statement with ICD-10 Notes',
            fontSize: 17,
            fontFamily: 'light',
          ),
          backgroundColor: MyColors.BgColor,
          // bottom: PreferredSizeWidget(
          //   child: MainHeadingText(
          //     text: 'My Invoice',
          //     color: MyColors.onsurfacevarient,
          //     fontSize: 11,
          //   ),
          // ),
          // bottom: PreferredSize(
          //   preferredSize: _tabBar.preferredSize,
          //   child: ColoredBox(
          //     color: MyColors.lightBlue.withOpacity(0.11),
          //     child: _tabBar,
          //   ),
          // ),
        ),
        body: load
            ? CustomLoader()
            : Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vSizedBox2,
                MainHeadingText(
                  text: 'Statements with ICD-10 codes',
                  fontSize: 32,
                  fontFamily: 'light',
                ),
                vSizedBox2,
                ParagraphText(
                    fontSize: 16,
                    text:
                    'Download statements with ICD-10 codes here'),
                vSizedBox4,
                for (int i = 0; i < icdNotes.length; i++)
                  InkWell(
                    onTap: () async{
                      // EasyLoading.show(
                      //   status: null,
                      //   maskType: EasyLoadingMaskType.black,
                      // );
                      var time = DateTime.now();
                      await savePdfToStorage1(icdNotes[i]['pdf_url'],'pdf',
                          '${time.millisecond}_STATEMENT_WITH_ICD10_CODE.pdf');
                      // EasyLoading.dismiss();
                    },
                    child: ListUI01(
                        heading: 'STATEMENT: ${icdNotes[i][ApiVariableKeys.doctor_lastname]}/${icdNotes[i][ApiVariableKeys.user_lastname]}',
                        // heading: 'STATEMENT: ${icdNotes[i]['doctor_data']['first_name']})',
                        // heading: 'STATEMENT #${icdNotes[i]['icd_code']}',
                        subheading: '${icdNotes[i][ApiVariableKeys.consult_dateTime]}',
                        // subheading: '${icdNotes[i]['date']} ${icdNotes[i]['time']}',
                        // subheading: '${icdNotes[i]['icd_code']??''}',
                        borderColor: MyColors.white,
                        image: 'assets/images/file.png'),
                  ),
                if (icdNotes.length == 0)
                  Center(
                    child: Text('No data found.'),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
