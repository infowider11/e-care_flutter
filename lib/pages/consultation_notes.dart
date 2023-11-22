import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/add_consultaion_notes.dart';
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

import '../services/api_urls.dart';
import '../services/auth.dart';
import '../services/webservices.dart';
import '../widgets/showSnackbar.dart';

class Consultation_Notes_Page extends StatefulWidget {
  final String? booking_id;
  const Consultation_Notes_Page({Key? key,this.booking_id}) : super(key: key);

  @override
  State<Consultation_Notes_Page> createState() => Consultation_Notes_PageState();
}

class Consultation_Notes_PageState extends State<Consultation_Notes_Page> with TickerProviderStateMixin {
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
      'doctor_id': await getCurrentUserId(),
      'booking_id': widget.booking_id ?? '',
    };
    var res = await Webservices.postData(
        apiUrl: ApiUrls.consultant_note_list, body: data, context: context);
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
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: load?CustomLoader():
      Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSizedBox2,
                  MainHeadingText(text: 'Consultation Notes', fontSize: 32, fontFamily: 'light',),
                  vSizedBox4,
                  for(int i=0;i<lists.length;i++)
                  ListUI02(heading: '${lists[i]['patient_data']['first_name']??''} ${lists[i]['patient_data']['last_name']??''}',//'Note ${i+1}',
                    editonTap: () async{
                      await push(context: context, screen: Add_Consultation_Notes_Page(
                        is_update: true,
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
                          '${lists[i]['id']}_notes.pdf');
                      // EasyLoading.dismiss();
                    },
                    deleteonTap: () {
                      delete(lists[i]['id'].toString(),'');
                    },
                    subheading: '${DateFormat.yMMMd().add_jm().format(DateTime.parse(lists[i]['created_at']))}',
                    isimage: false,
                    isIcon: false,
                    thirdHeadColor: MyColors.labelcolor,
                  ),

                  if(lists.length==0)
                    Center(
                      heightFactor: 2.0,
                      child: Text('No data found.'),
                    )

                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RoundEdgedButton(
                text: '+ Add Note',
                width: 115, fontSize: 16, horizontalPadding: 10,
                onTap: () async{
                  await push(context: context, screen: Add_Consultation_Notes_Page(
                    booking_id: widget.booking_id.toString(),
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
    var dir = await DownloadsPathProvider.downloadsDirectory;
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
                    'user_id':
                    await getCurrentUserId(),
                    'note_id': id.toString(),
                    'booking_id':
                    booking_id.toString(),
                  };
                  var res =
                  await Webservices.postData(
                      apiUrl: ApiUrls
                          .delete_consultation_note,
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
