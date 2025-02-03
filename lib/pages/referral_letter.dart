import 'dart:io';

// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:ecare/constants/api_variable_keys.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/get_name.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/add_prescription.dart';
import 'package:ecare/pages/add_referral.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_2_allergies.dart';
import 'package:ecare/pages/question_2_medication.dart';
import 'package:ecare/pages/who_i_am_page.dart';
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
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../functions/get_folder_directory.dart';
import '../services/api_urls.dart';
import '../services/auth.dart';
import '../services/webservices.dart';
import '../widgets/custom_confirmation_dialog.dart';
import '../widgets/showSnackbar.dart';

class Referral_Letter_Page extends StatefulWidget {
  final String? booking_id;
  final String? doctorName;
  const Referral_Letter_Page({Key? key,this.booking_id, this.doctorName}) : super(key: key);

  @override
  State<Referral_Letter_Page> createState() => Referral_Letter_PageState();
}

class Referral_Letter_PageState extends State<Referral_Letter_Page> with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  late AnimationController controller;
  List lists = [];
  bool load = false;

  @override
  void initState() {
    // TODO: implement initState
    get_lists();
    super.initState();
  }

  get_lists() async {
    setState(() {
      load = true;
    });
    Map<String, dynamic> data = {
      'user_id': await getCurrentUserId(),
      'booking_id': widget.booking_id ?? '',
    };
    var res = await Webservices.postData(
        apiUrl: ApiUrls.get_reffral, body: data, context: context);
    print('list    ${res}');
    if (res['status'].toString() == '1') {
      lists = res['data'];
      setState(() {});
    }
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: load?CustomLoader():Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSizedBox2,
                  MainHeadingText(text: 'Referral Letters', fontSize: 32, fontFamily: 'light',),
                  // vSizedBox2,
                  // ParagraphText(fontSize: 16, text: 'Download documents from your Healthcare Practitioner here'),
                  vSizedBox4,
                  for(int i=0;i<lists.length;i++)
                  ListUI02(
                    heading: '${getName(prefixText: 'Referral Letter', doctorLastName: '${lists[i][ApiVariableKeys.doctor_lastname]}', userLastName: '${lists[i][ApiVariableKeys.user_lastname]}', dateTimeConsultation: null,)}',
                    // heading: 'Letter ${i+1}',
                    subheading: '${DateFormat.yMMMEd().format(DateTime.parse(lists[i]['created_at']))}',
                    editonTap: () async{
                       await push(context: context, screen: Add_Referral_Letter_Page(
                        is_update:true,
                        data: lists[i],
                      ));
                       get_lists();
                    },
                    sendonTap: () async{
                      // EasyLoading.show(
                      //   status: null,
                      //   maskType: EasyLoadingMaskType.black,
                      // );
                      await savePdfToStorage1(lists[i]['pdf_url'], 'pdf',
                          '${lists[i]['id']}_refrral.pdf');
                      // EasyLoading.dismiss();
                    },
                    deleteonTap: () async{
                      Map<String, dynamic> data = {
                        'type': '1',
                        'booking_id': lists[i]['booking_id'].toString(),
                      };
                      bool? result= await showCustomConfirmationDialog(
                        headingMessage: 'Are you sure you want to delete?',
                      ) ;
                      if(result==true) {
                        var res =
                        await Webservices.postData(
                            apiUrl: ApiUrls
                                .deleteReferal,
                            body: data,
                            context: context);
                        get_lists();
                      }
                      // delete(lists[i]['id'].toString(),lists[i]['booking_id'].toString());
                    },
                    isimage: false,
                    isIcon: false,
                    thirdHeadColor: MyColors.labelcolor,
                  ),
                  if(lists.length==0)
                  Center(
                    heightFactor: 2.0,
                    child: Text('No data found.'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RoundEdgedButton(
                text: '+ Add referral letter',
                width: 200,
                fontSize: 14,
                horizontalPadding: 10,
                onTap: () async{
                  await push(context: context, screen: Add_Referral_Letter_Page(
                    booking_id: widget.booking_id.toString(),
                    doctorName: widget.doctorName,
                  ));
                  get_lists();
                },
              ),
            ),
          )
        ],
      ),
    );
  }


  downloadfolderpath() async {
    var dir = await getCustomDownloadsDirectory();
    String downloadfolderpath = '';
    if (dir != null) {
      downloadfolderpath = dir.path;
      print(
          'downloadfolderpath---------${downloadfolderpath}'); //output: /storage/emulated/0/Download
      setState(() {
        //refresh UI
      });
    } else {
      print("No download folder found.");
    }
    return downloadfolderpath;
  }

    Future<void> delete(String id,String booking_id) async{
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Remove'),
            content: const Text('Are you sure?'),
            actions: [
              TextButton(
                child: Text('Yes'),
                onPressed: () async {
                  Map<String, dynamic> data = {
                    'type': '1',
                    'booking_id':
                    booking_id.toString(),
                  };
                  var res =
                  await Webservices.postData(
                      apiUrl: ApiUrls
                          .deleteReferal,
                      body: data,
                      context: context);
                  print('res----${res}');
                  Navigator.of(context).pop();
                  get_lists();
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
    }
}
