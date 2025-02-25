
// ignore_for_file: unused_local_variable, use_build_context_synchronously, avoid_print

// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/add_consultaion_notes.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/list_ui_1.dart';
import 'package:ecare/widgets/loader.dart';
 
import 'package:flutter/material.dart';

import '../constants/api_variable_keys.dart';
import '../functions/get_folder_directory.dart';
import '../services/api_urls.dart';
import '../services/auth.dart';
import '../services/webservices.dart';
import '../widgets/custom_confirmation_dialog.dart';

class Consultation_Notes_Page extends StatefulWidget {
  final String? booking_id;
  const Consultation_Notes_Page({Key? key,this.booking_id}) : super(key: key);

  @override
  State<Consultation_Notes_Page> createState() => Consultation_Notes_PageState();
}

class Consultation_Notes_PageState extends State<Consultation_Notes_Page> with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  late AnimationController controller;
  List consultationNotes = [];
  bool load = false;

  @override
  void initState() {
    
    getConsultationNotes();
    super.initState();
  }

  getConsultationNotes() async {
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
      consultationNotes = res['data'];
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
      body: load?const CustomLoader():
      Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSizedBox2,
                  const MainHeadingText(text: 'Consultation Notes', fontSize: 32, fontFamily: 'light',),
                  vSizedBox4,
                  for(int i=0;i<consultationNotes.length;i++)
                  ListUI02(
                    heading: 'Consultation Notes: ${consultationNotes[i][ApiVariableKeys.doctor_lastname]}/${consultationNotes[i][ApiVariableKeys.user_lastname]}',
                    // heading: '${consultationNotes[i]['patient_data']['first_name']??''} ${consultationNotes[i]['patient_data']['last_name']??''}',//'Note ${i+1}',
                    editonTap: () async{
                      await push(context: context, screen: Add_Consultation_Notes_Page(
                        is_update: true,
                        data: consultationNotes[i],
                      ));
                      getConsultationNotes();
                    },
                    sendonTap: () async{
                      // EasyLoading.show(
                      //   status: null,
                      //   maskType: EasyLoadingMaskType.black,
                      // );
                      await savePdfToStorage1(consultationNotes[i]['pdf_url'], 'pdf',
                          '${consultationNotes[i]['id']}_notes.pdf');
                      // EasyLoading.dismiss();
                    },
                    deleteonTap: () async{
                      Map<String, dynamic> data = {
                        'user_id': await getCurrentUserId(),
                        'note_id': consultationNotes[i]['id'].toString(),
                        'booking_id': '',
                      };
                      bool? result= await showCustomConfirmationDialog(
                        headingMessage: 'Are you sure you want to delete?',
                      ) ;
                      if(result==true) {

                        var res =
                        await Webservices.postData(
                            apiUrl: ApiUrls
                                .delete_consultation_note,
                            body: data,
                            context: context);
                        getConsultationNotes();
                      }
                      // delete(consultationNotes[i]['id'].toString(),'');
                    },
                    subheading: '${consultationNotes[i][ApiVariableKeys.consult_dateTime]}',
                    // subheading: '${DateFormat.yMMMd().add_jm().format(DateTime.parse(consultationNotes[i]['created_at']))}',
                    isimage: false,
                    isIcon: false,
                    thirdHeadColor: MyColors.labelcolor,
                  ),

                  if(consultationNotes.length==0)
                    const Center(
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
                  getConsultationNotes();
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
            title: const Text('Remove'),
            content: const Text('Are you sure?'),
            actions: [
              TextButton(
                child: const Text('Yes'),
                onPressed: () async {
                  Map<String, dynamic> data = {
                    'user_id': await getCurrentUserId(),
                    'note_id': id.toString(),
                    'booking_id': booking_id.toString(),
                  };
                  var res =
                  await Webservices.postData(
                      apiUrl: ApiUrls
                          .delete_consultation_note,
                      body: data,
                      context: context);
                  print('res----${res}');
                  Navigator.of(context).pop();
                  getConsultationNotes();
                },
              ),
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
