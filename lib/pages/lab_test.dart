import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:ecare/constants/api_variable_keys.dart';
import 'package:ecare/functions/global_Var.dart';
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
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import '../functions/get_folder_directory.dart';
import '../widgets/custom_confirmation_dialog.dart';
import '../widgets/showSnackbar.dart';
import 'bookingDetail.dart';

class LabTestPage extends StatefulWidget {
  String? doc_name;
  String? doc_type;
  LabTestPage({Key? key, this.doc_name, this.doc_type}) : super(key: key);

  @override
  State<LabTestPage> createState() => LabTestPageState();
}

class LabTestPageState extends State<LabTestPage>
    with TickerProviderStateMixin {
  TabBar get _tabBar => const TabBar(
        padding: EdgeInsets.symmetric(horizontal: 0),
        labelPadding: EdgeInsets.symmetric(horizontal: 0),
        tabs: <Widget>[
          Tab(
            child: MainHeadingText(
              text: 'My Prescription',
              color: MyColors.onsurfacevarient,
              fontSize: 11,
            ),
          ),
          Tab(
            child: MainHeadingText(
              text: 'Referral Notes',
              color: MyColors.onsurfacevarient,
              fontSize: 11,
            ),
          ),
        ],
      );
  TextEditingController email = TextEditingController();
  bool load = false;
  List prescriptionList = [];
  List referralList = [];

  // get_lists1() async {
  //   setState(() {
  //     load = true;
  //   });
  //   var res = await Webservices.get(ApiUrls.get_document_image +
  //       "?user_id=" +
  //       await getCurrentUserId() +
  //       '&type=' +
  //       '${widget.doc_type}');
  //   print('list----$res');
  //   if (res['status'].toString() == '1') {
  //     lists = res['data'];
  //     setState(() {});
  //   } else {
  //     lists = [];
  //   }
  //   setState(() {
  //     load = false;
  //   });
  // }

  getReferralList() async {
    Map<String, dynamic> data = {
      'user_id': await getCurrentUserId(),
      'booking_id': '',
    };
    var res = await Webservices.postData(
        apiUrl: ApiUrls.get_reffral, body: data, context: context);
    print('list    ${res}');
    if (res['status'].toString() == '1') {
      referralList = res['data'];
      setState(() {});
    }
    setState(() {
      load = false;
    });
  }

  getPrescriptionList() async {
    setState(() {
      load = true;
    });
    Map<String, dynamic> data = {
      'user_id': await getCurrentUserId(),
      'booking_id': '',
      // 'type': user_Data!['type'],
    };
    var res = await Webservices.postData(
        apiUrl: ApiUrls.get_precriptions, body: data, context: context);
    print('list    ${res}');
    if (res['status'].toString() == '1') {
      prescriptionList = res['data'];
      setState(() {});
    }
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrescriptionList();
    getReferralList();
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
          title: const MainHeadingText(
            text: 'My Prescriptions/Referral Notes',
            fontSize: 20,
            fontFamily: 'light',
          ),
          backgroundColor: MyColors.BgColor,
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color: MyColors.lightBlue.withOpacity(0.11),
              child: _tabBar,
            ),
          ),
        ),
        body: load
            ? const CustomLoader()
            : TabBarView(children: [
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < prescriptionList.length; i++)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8.0),
                            margin: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: MyColors.bordercolor, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             bookingdetail(
                                      //               booking_id: lists[i]
                                      //                       ['booking_id']
                                      //                   .toString(),
                                      //             )));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MainHeadingText(
                                          text:
                                              '${prescriptionList[i]['prescription_medicine'][0]['medicines']}: ${prescriptionList[i][ApiVariableKeys.doctor_lastname]}/${prescriptionList[i][ApiVariableKeys.user_lastname]}/${prescriptionList[i][ApiVariableKeys.consult_dateTime]}',
                                              // ' ${prescriptionList[i]['prescription_medicine'][0]['medicines']} (#${prescriptionList[i]['booking_id']})',
                                          color: MyColors.headingcolor,
                                          fontSize: 15,
                                          fontFamily: 'bold',
                                        ),
                                        Row(
                                          children: [
                                            MainHeadingText(
                                              text:
                                                  '${prescriptionList[i]['prescription_medicine'][0]['dosage']}',
                                              color: MyColors.headingcolor,
                                              fontFamily: 'light',
                                              fontSize: 13,
                                            ),
                                            hSizedBox,
                                            MainHeadingText(
                                                text:
                                                    '${prescriptionList[i]['prescription_medicine'][0]['duration']}',
                                                color: Colors.black,
                                                fontSize: 13),
                                            hSizedBox,
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                hSizedBox05,
                                Row(mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RoundEdgedButton(
                                      fontSize: 10,
                                      onTap:()async{
                                        await savePdfToStorage1(
                                            prescriptionList[i]['pdf_url'],
                                            'pdf',
                                            '${prescriptionList[i]['id']}_prescription_pdf.pdf');
                                      },

                                      text: 'Download',
                                      width: 70,
                                      verticalPadding: 0,
                                      horizontalPadding: 0,
                                      height: 30,
                                    ),
                                    hSizedBox,
                                    RoundEdgedButton(
                                      fontSize: 10,
                                      color: Colors.red,
                                      text: 'Delete',
                                      width: 70,
                                      onTap: () async{
                                        Map<String, dynamic> data = {
                                          'prescription_id': prescriptionList[i]['id'].toString(),
                                          'booking_id': prescriptionList[i]['booking_id'].toString(),
                                          'type': '2',
                                        };
                                        bool? result= await showCustomConfirmationDialog(
                                            headingMessage: 'Are you sure you want to delete?',

                                        ) ;
                                        if(result==true){
                                          setState(() {
                                            load = true;
                                          });
                                          var res = await Webservices.postData(
                                              apiUrl: ApiUrls.deletePrescription,
                                              body: data,
                                              context: context).then((value) => getPrescriptionList());
                                        }
                                      },
                                      verticalPadding: 0,
                                      horizontalPadding: 0,
                                      height: 30,
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        if (prescriptionList.length == 0)
                          const Center(
                            heightFactor: 5.0,
                            child: Text('No Data Found.'),
                          )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < referralList.length; i++)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8.0),
                            margin: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: MyColors.bordercolor, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             bookingdetail(
                                      //               booking_id: raffrals[i]
                                      //                       ['booking_id']
                                      //                   .toString(),
                                      //             )));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MainHeadingText(
                                          text:
                                              // 'Letter ${i+1}',
                                          'Referral: ${referralList[i][ApiVariableKeys.doctor_lastname]}/${referralList[i][ApiVariableKeys.user_lastname]}/${referralList[i][ApiVariableKeys.consult_dateTime]}',
                                          color: MyColors.headingcolor,
                                          fontSize: 15,
                                          fontFamily: 'bold',
                                        ),
                                        ParagraphText(fontSize: 12.0,
                                            text: '${DateFormat.yMMMEd().format(DateTime.parse(referralList[i]['created_at']))}'),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RoundEdgedButton(
                                      text: 'Download',
                                      width: 70,
                                      height: 30,
                                      fontSize: 10,
                                      verticalPadding: 0,
                                      horizontalPadding: 0,
                                      onTap: () async{
                                        await savePdfToStorage1(
                                            referralList[i]['pdf_url'],
                                            'pdf',
                                            '${referralList[i]['id']}_referral.pdf');
                                      },
                                    ),
                                    hSizedBox,
                                    RoundEdgedButton(
                                      fontSize: 10,
                                      onTap: () async{
                                        Map<String, dynamic> data = {
                                          'booking_id': referralList[i]['booking_id'].toString(),
                                          'type': '2',
                                        };
                                        bool? result= await showCustomConfirmationDialog(
                                            headingMessage:'Are you sure you want to delete?',

                                        ) ;
                                        if(result==true){
                                          setState(() {
                                            load = true;
                                          });
                                          var res = await Webservices.postData(
                                              apiUrl: ApiUrls.deleteReferal,
                                              body: data,
                                              context: context).then((value) => getReferralList());
                                        }
                                      },
                                      color: Colors.red,
                                      text: 'Delete',
                                      width: 70,
                                      verticalPadding: 0,
                                      horizontalPadding: 0,
                                      height: 30,
                                    ),
                                  ],
                                ),

                                // Expanded(
                                //   flex: 0,
                                //   child: PopupMenuButton<int>(
                                //     shape: RoundedRectangleBorder(
                                //         borderRadius:
                                //             BorderRadius.circular(20.0)),
                                //     itemBuilder: (context) => [
                                //       PopupMenuItem(
                                //         value: 2,
                                //         // row with two children
                                //         child: Row(
                                //           children: [
                                //             SizedBox(
                                //               width: 10,
                                //             ),
                                //             Text(
                                //               "Download",
                                //               style: TextStyle(
                                //                   fontFamily: 'bold',
                                //                   color: MyColors.primaryColor),
                                //             )
                                //           ],
                                //         ),
                                //       ),
                                //     ],
                                //     offset: Offset(100, 50),
                                //     color: MyColors.white,
                                //     elevation: 0,
                                //     // on selected we show the dialog box
                                //     onSelected: (value) async {
                                //       // if value 1 show dialog
                                //       if (value == 1) {
                                //       } else if (value == 2) {
                                //         // EasyLoading.show(
                                //         //   status: null,
                                //         //   maskType: EasyLoadingMaskType.black,
                                //         // );
                                //         await savePdfToStorage1(
                                //             raffrals[i]['pdf_url'],
                                //             'pdf',
                                //             '${raffrals[i]['id']}_raffral.pdf');
                                //         // EasyLoading.dismiss();
                                //       } else if (value == 3) {}
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        if (referralList.length == 0)
                          const Center(
                            heightFactor: 2.0,
                            child: Text('No data found.'),
                          ),
                      ],
                    ),
                  ),
                ),
              ]),
      ),
    );
  }

//   Future<File> urlToFile(String html_link) async {
// // generate random number.
//     var rng = new math.Random();
// // get temporary directory of device.
//     Directory tempDir = await getDownloads();
// // get temporary path from temporary directory.
//     String tempPath = tempDir.path;
// // create a new file in temporary path with random file name.
//     File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.mp3');
// // call http.get method and pass imageUrl into it to get response.
//     try {
//       var response = await http.get(Uri.parse(html_link));
//       await file.writeAsBytes(response.bodyBytes);
//     } catch (er) {
//       print('errrrrr--onfile' + er.toString());
//     }
//   }



  Future<void> savePdfToStorage(
      String url, targetPath, targetFilename) async {
    //comment out the next two lines to prevent the device from getting
    // the image from the web in order to prove that the picture is
    // coming from the device instead of the web.

    // var targetPath = await getPathToDowload();

    var response = await get(Uri.parse(url)); // <--2

    print('the url is__________________________________$url');
    print('the url is2__________________________________${response.bodyBytes}');


    // if(await Permission.storage.request().isGranted){
      print('persmision----granted---------');
      // String path = await downloadfolderpath();
      Directory? dir = await getFolderDirectory();
      String path = dir!.path;
      print('path ${path}');
      // String path = '/storage/emulated/0/Download';

      var firstPath = targetPath;
      var filePathAndName = path + '/' + targetFilename;
      File file2 = new File(filePathAndName); // <-- 2
    try{
      await file2.writeAsBytes(response.bodyBytes);
      print(' the file name is $filePathAndName'); // <-- 3;
      showSnackbar('Pdf downloaded successfully.');
    }catch(e)  {
      print('catch err---- ${e}');
    };

      // return filePathAndName;
    // } else {
    //   EasyLoading.dismiss();
    //   await Permission.storage.request();
    //   print('persmission graned2--');
    //   // return;
    // }

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

  showAlertDialog(BuildContext context, String id) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Yes"),
      onPressed: () async {
        await EasyLoading.show(
            status: null, maskType: EasyLoadingMaskType.black);
        var res = await Webservices.get(ApiUrls.deletedocimage + '?id=' + id);
        EasyLoading.dismiss();
        if (res['status'].toString() == '1') {
          Navigator.pop(context);
          getPrescriptionList();
        }
      },
    );

    Widget noButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Remove Document"),
      content: const Text("Are you sure?"),
      actions: [
        okButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
