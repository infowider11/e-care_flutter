import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
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

import '../constants/api_variable_keys.dart';
import '../services/api_urls.dart';
import '../services/auth.dart';
import '../services/webservices.dart';
import '../widgets/custom_confirmation_dialog.dart';
import '../widgets/showSnackbar.dart';
import 'addsick.dart';
import 'bookingDetail.dart';

class SickNotesPage extends StatefulWidget {
  final bool? is_add_btn;
  const SickNotesPage({Key? key,this.is_add_btn=true}) : super(key: key);

  @override
  State<SickNotesPage> createState() => SickNotesPageState();
}

class SickNotesPageState extends State<SickNotesPage>
    with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  late AnimationController controller;
  List sickNoteList = [];
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
      // 'booking_id': widget.booking_id ?? '',
    };
    var res = await Webservices.postData(
        apiUrl: ApiUrls.get_sicknotes, body: data, context: context);
    print('list    ${res}');
    if (res['status'].toString() == '1') {
      sickNoteList = res['data'];
      setState(() {});
    } else {
      sickNoteList = [];
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
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vSizedBox2,
                MainHeadingText(
                  text: 'Sick Note ',
                  fontSize: 32,
                  fontFamily: 'light',
                ),
                vSizedBox2,
                if(user_Data!['type'].toString()=='2')
                ParagraphText(
                    fontSize: 16,
                    text:
                        'Download documents from your Healthcare Practitioner here'),
                vSizedBox4,

                for(int i=0;i<sickNoteList.length;i++)
                  ListUI02(
                    is_edit: user_Data!['type'].toString()=='1'?true:false,

                    heading: 'Sick Note: ${sickNoteList[i][ApiVariableKeys.doctor_lastname]}/${sickNoteList[i][ApiVariableKeys.user_lastname]}/${sickNoteList[i][ApiVariableKeys.consult_dateTime]}',
                    // heading: 'Sick Note ${i+1}',
                    subheading: '',
                    // subheading: '${DateFormat.yMMMEd().format(DateTime.parse(sickNoteList[i]['created_at']))}',
                    editonTap: () async{
                      await push(context: context,screen:Add_sicknote(
                        is_update:true,
                        data: sickNoteList[i],
                        booking_id: sickNoteList[i]['booking_id'].toString(),
                      ));
                      get_lists();
                    },
                    sendonTap: () async{
                      await savePdfToStorage1(sickNoteList[i]['sick_pdf'], 'pdf',
                          '${sickNoteList[i]['id']}_sick_note.pdf');
                    },
                    deleteonTap: () async{
                      Map<String, dynamic> data = {
                        'booking_id':sickNoteList[i]['booking_id'].toString(),
                        'type':user_Data!['type']
                      };
                      bool? result= await showCustomConfirmationDialog(
                          headingMessage: 'Are you sure you want to delete?',

                      ) ;
                      if(result==true){
                        setState(() {
                          load = true;
                        });
                        var res = await Webservices.postData(apiUrl: ApiUrls.new_delete_sick_note,
                            body: data,
                            context: context);
                        print('res----${res}');
                        get_lists();
                      }

                      // delete(sickNoteList[i]['id'].toString(),sickNoteList[i]['booking_id'].toString(),sickNoteList[i]['booking_details']['user_data']['type']);
                    },
                    isimage: false,
                    isIcon: false,
                    thirdHeadColor: MyColors.labelcolor,
                  ),

                // for (var i = 0; i < lists.length; i++)
                //
                // Container(
                //   padding: EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(16),
                //       border: Border.all(color: MyColors.bordercolor, width: 1)),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //         IconButton(
                //             onPressed: () async{
                //               // EasyLoading.show(
                //               //   status: null,
                //               //   maskType: EasyLoadingMaskType.black,
                //               // );
                //               await savePdfToStorage1(lists[i]['sick_pdf'], 'pdf',
                //               '${lists[i]['id']}_sicknote_pdf.pdf');
                //               // EasyLoading.dismiss();
                //             },
                //             icon:Image.asset(
                //               'assets/images/download.png',
                //               height: 50.0,
                //               width: 50.0,
                //               fit: BoxFit.cover,
                //             ),
                //         ),
                //       hSizedBox,
                //       Expanded(
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Row(
                //               children: [
                //                 Expanded(
                //                   child: GestureDetector(
                //                     onTap:(){
                //                       Navigator.push(
                //                           context,
                //                           MaterialPageRoute(
                //                               builder: (context) => bookingdetail(
                //                                 booking_id:
                //                                 lists[i]['booking_id'].toString(),
                //                               )));
                //                     },
                //                     behavior: HitTestBehavior.translucent,
                //                     child: MainHeadingText(
                //                       text: 'Sick note (#${lists[i]['booking_id']})',
                //                       color: MyColors.headingcolor,
                //                       fontSize: 16,
                //                       fontFamily: 'bold',
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //             MainHeadingText(
                //               text: '${lists[i]['created_at']}',
                //               color: MyColors.headingcolor,
                //               fontFamily: 'light',
                //               fontSize: 14,
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           ],
                //         ),
                //       )
                //     ],
                //   ),
                // ),

                if(sickNoteList.length==0)
                  Center(
                    heightFactor: 1.0,
                    child: Text('No data found.'),
                  ),
              ],
            ),
          ),
          if(widget.is_add_btn!)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RoundEdgedButton(
                text: '+ Add Sick',
                width: 180,
                fontSize: 16,
                horizontalPadding: 10,
                onTap: () async {
                  await push(context: context, screen: Add_sicknote());
                  get_lists();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
  Future<String> savePdfToStorage(
      String url, targetPath, targetFilename) async {
    var response = await get(Uri.parse(url));
    print('the url is__________________________________$url');
    String path = await downloadfolderpath();
    // String path = '/storage/emulated/0/Download';
    var firstPath = targetPath;
    var filePathAndName = path + '/' + targetFilename;
    File file2 = new File(filePathAndName); // <-- 2
    file2.writeAsBytesSync(response.bodyBytes);
    print(' the file name is $filePathAndName'); // <-- 3;
    showSnackbar('Pdf downloaded successfully.');
    return filePathAndName;
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

  Future<void> delete(String id,String booking_id,String type) async{
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
                    'id': id.toString(),
                    'booking_id':
                    booking_id.toString(),
                    'type':type
                  };
                  var res =
                  await Webservices.postData(
                      apiUrl: ApiUrls
                          .delete_sick_note,
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
