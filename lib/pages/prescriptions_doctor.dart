// ignore_for_file: unused_local_variable, avoid_print, non_constant_identifier_names, camel_case_types

import 'dart:io';

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/add_prescription.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/list_ui_1.dart';
import 'package:ecare/widgets/loader.dart';
 
import 'package:flutter/material.dart';
import 'package:http/http.dart';
// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';

import '../constants/api_variable_keys.dart';
import '../functions/get_folder_directory.dart';
import '../services/auth.dart';
import '../widgets/custom_confirmation_dialog.dart';
import '../widgets/showSnackbar.dart';

class Prescriptions_Doctor_Page extends StatefulWidget {
  final String? booking_id;
  const Prescriptions_Doctor_Page({Key? key, this.booking_id})
      : super(key: key);

  @override
  State<Prescriptions_Doctor_Page> createState() =>
      Prescriptions_Doctor_PageState();
}

class Prescriptions_Doctor_PageState extends State<Prescriptions_Doctor_Page>
    with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  late AnimationController controller;
  List prescriptionList = [];
  bool load = false;

  @override
  void initState() {
    
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: load
          ? const CustomLoader()
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        vSizedBox2,
                        const MainHeadingText(
                          text: 'Prescriptions',
                          fontSize: 32,
                          fontFamily: 'light',
                        ),
                        // vSizedBox2,
                        // ParagraphText(fontSize: 16, text: 'Download documents from your Healthcare Practitioner here'),
                        vSizedBox4,

                        // for (int i = 0; i < lists.length; i++)
                        //   ListUI02(
                        //     sendonTap: () async {
                        //       print('send msg');
                        //      await savePdfToStorage(lists[i]['pdf_url'], 'pdf',
                        //           '${lists[i]['id']}_prescription_pdf.pdf');
                        //     },
                        //     editonTap: () async {
                        //       print('edit');
                        //       await push(
                        //           context: context,
                        //           screen: Add_Prescriptions_Doctor_Page(
                        //             is_update: true,
                        //             id: lists[i]['id'].toString(),
                        //             data: lists[i],
                        //           ));
                        //       get_lists();
                        //     },
                        //     deleteonTap: (() {
                        //       showDialog(
                        //           context: context,
                        //           builder: (BuildContext context) {
                        //             return AlertDialog(
                        //               title: Text('Remove'),
                        //               content: const Text('Are you sure?'),
                        //               actions: [
                        //                 TextButton(
                        //                   child: Text('Yes'),
                        //                   onPressed: () async {
                        //                     Map<String, dynamic> data = {
                        //                       'user_id':
                        //                           await getCurrentUserId(),
                        //                       'id': lists[i]['id'].toString(),
                        //                       'booking_id': lists[i]
                        //                               ['booking_id']
                        //                           .toString(),
                        //                     };
                        //                     var res =
                        //                         await Webservices.postData(
                        //                             apiUrl: ApiUrls
                        //                                 .delete_prescription,
                        //                             body: data,
                        //                             context: context);
                        //                     print('res----${res}');
                        //                     Navigator.of(context).pop();
                        //                     get_lists();
                        //                   },
                        //                 ),
                        //                 TextButton(
                        //                   child: Text('No'),
                        //                   onPressed: () {
                        //                     Navigator.of(context).pop();
                        //                   },
                        //                 ),
                        //               ],
                        //             );
                        //           });
                        //     }),
                        //     heading:
                        //         '${lists[i]['prescription_name']} (#${lists[i]['booking_id']})',
                        //     subheading: '${lists[i]['tablet_name']}',
                        //     isthirdHead: true,
                        //     isimage: false,
                        //     thirdHead:
                        //         '${lists[i]['quantity'].toString()} Tablets',
                        //     isIcon: false,
                        //     thirdHeadColor: MyColors.labelcolor,
                        //   ),


                        for(int i=0;i<prescriptionList.length;i++)
                          ListUI02(
                            heading: 'Prescription:  ${prescriptionList[i][ApiVariableKeys.doctor_lastname]}/${prescriptionList[i][ApiVariableKeys.user_lastname]}',
                            // heading: 'Prescription:  ${i+1}',
                            // heading: 'Prescription ${i+1}',
                            subheading: '${prescriptionList[i][ApiVariableKeys.consult_dateTime]}',
                            // subheading: '${DateFormat.yMMMEd().format(DateTime.parse(prescriptionList[i]['created_at']))}',
                            editonTap: () async{
                              await push(context: context, screen: Add_Prescriptions_Doctor_Page(
                                is_update:true,
                                data: prescriptionList[i],
                              ));
                              // get_lists();
                            },
                            sendonTap: () async{

                              // EasyLoading.show(
                              //   status: null,
                              //   maskType: EasyLoadingMaskType.black,
                              // );
                              await savePdfToStorage1(prescriptionList[i]['pdf_url'], 'pdf',
                                  '${prescriptionList[i]['id']}_prescription.pdf');
                              // EasyLoading.dismiss();
                            },
                            deleteonTap: () async{
                              Map<String, dynamic> data = {
                                'prescription_id': prescriptionList[i]['id']
                                    .toString(),
                                'booking_id': prescriptionList[i]['booking_id']
                                    .toString(),
                                'type': '1'
                              };
                              bool? result= await showCustomConfirmationDialog(
                                headingMessage: 'Are you sure you want to delete?',
                              ) ;
                              if(result==true) {
                                var res = await Webservices.postData(
                                    apiUrl: ApiUrls.deletePrescription,
                                    body: data,
                                    context: context);
                                get_lists();
                              }
                              // delete(prescriptionList[i]['id'].toString(),prescriptionList[i]['booking_id'].toString());
                            },
                            isimage: false,
                            isIcon: false,
                            thirdHeadColor: MyColors.labelcolor,
                          ),

                        // for (int i = 0; i < lists.length; i++)
                        //   Container(
                        //     padding: EdgeInsets.symmetric(
                        //         vertical: 8, horizontal: 8.0),
                        //     margin: EdgeInsets.all(5.0),
                        //     decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(16),
                        //         border: Border.all(
                        //             color: MyColors.bordercolor, width: 1)),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Expanded(
                        //           flex: 4,
                        //           child: GestureDetector(
                        //             behavior: HitTestBehavior.translucent,
                        //             onTap: () {
                        //               Navigator.push(
                        //                   context,
                        //                   MaterialPageRoute(
                        //                       builder: (context) => bookingdetail(
                        //                         booking_id:
                        //                         lists[i]['booking_id'].toString(),
                        //                       )));
                        //             },
                        //             child: Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               children: [
                        //                 MainHeadingText(
                        //                   text:
                        //                       '${lists[i]['prescription_medicine'][0]['medicines']} (#${lists[i]['booking_id']})',
                        //                   color: MyColors.headingcolor,
                        //                   fontSize: 15,
                        //                   fontFamily: 'bold',
                        //                 ),
                        //                 Row(
                        //                   children: [
                        //                     MainHeadingText(
                        //                       text:
                        //                           '${lists[i]['prescription_medicine'][0]['dosage']}',
                        //                       color: MyColors.headingcolor,
                        //                       fontFamily: 'light',
                        //                       fontSize: 13,
                        //                     ),
                        //                     hSizedBox,
                        //                     MainHeadingText(
                        //                         text: '${lists[i]['prescription_medicine'][0]['duration']}',
                        //                         color: Colors.black,
                        //                         fontSize: 13),
                        //                     hSizedBox,
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //         Expanded(
                        //           flex: 0,
                        //           child: PopupMenuButton<int>(
                        //             shape: RoundedRectangleBorder(
                        //                 borderRadius:
                        //                     BorderRadius.circular(20.0)),
                        //             itemBuilder: (context) => [
                        //               PopupMenuItem(
                        //                 value: 1,
                        //                 // row with 2 children
                        //                 child: Row(
                        //                   children: [
                        //                     SizedBox(
                        //                       width: 10,
                        //                     ),
                        //                     Text(
                        //                       "Edit",
                        //                       style: TextStyle(
                        //                           fontFamily: 'bold',
                        //                           color: MyColors.primaryColor),
                        //                     )
                        //                   ],
                        //                 ),
                        //               ),
                        //               PopupMenuItem(
                        //                 value: 2,
                        //                 // row with two children
                        //                 child: Row(
                        //                   children: [
                        //                     SizedBox(
                        //                       width: 10,
                        //                     ),
                        //                     Text(
                        //                       "Download",
                        //                       style: TextStyle(
                        //                           fontFamily: 'bold',
                        //                           color: MyColors.primaryColor),
                        //                     )
                        //                   ],
                        //                 ),
                        //               ),
                        //               PopupMenuItem(
                        //                 value: 3,
                        //                 // row with two children
                        //                 child: Row(
                        //                   children: [
                        //                     SizedBox(
                        //                       width: 10,
                        //                     ),
                        //                     Text(
                        //                       "Delete",
                        //                       style: TextStyle(
                        //                           fontFamily: 'bold',
                        //                           color: MyColors.red),
                        //                     )
                        //                   ],
                        //                 ),
                        //               ),
                        //             ],
                        //             offset: Offset(100, 50),
                        //             color: MyColors.white,
                        //             elevation: 0,
                        //             // on selected we show the dialog box
                        //             onSelected: (value) async {
                        //               // if value 1 show dialog
                        //               if (value == 1) {
                        //                 await push(
                        //                     context: context,
                        //                     screen: Add_Prescriptions_Doctor_Page(
                        //                       is_update: true,
                        //                       id: lists[i]['id'].toString(),
                        //                       data: lists[i],
                        //                     ));
                        //                 get_lists();
                        //               } else if (value == 2) {
                        //                 // EasyLoading.show(
                        //                 //   status: null,
                        //                 //   maskType: EasyLoadingMaskType.black,
                        //                 // );
                        //                 await savePdfToStorage1(lists[i]['pdf_url'], 'pdf',
                        //                               '${lists[i]['id']}_prescription_pdf.pdf');
                        //                 // EasyLoading.dismiss();
                        //               } else if (value == 3) {
                        //                 showDialog(
                        //                               context: context,
                        //                               builder: (BuildContext context) {
                        //                                 return AlertDialog(
                        //                                   title: Text('Remove'),
                        //                                   content: const Text('Are you sure?'),
                        //                                   actions: [
                        //                                     TextButton(
                        //                                       child: Text('Yes'),
                        //                                       onPressed: () async {
                        //                                         Map<String, dynamic> data = {
                        //                                           'user_id':
                        //                                               await getCurrentUserId(),
                        //                                           'id': lists[i]['id'].toString(),
                        //                                           'booking_id': lists[i]
                        //                                                   ['booking_id']
                        //                                               .toString(),
                        //                                         };
                        //                                         var res =
                        //                                             await Webservices.postData(
                        //                                                 apiUrl: ApiUrls
                        //                                                     .delete_prescription,
                        //                                                 body: data,
                        //                                                 context: context);
                        //                                         print('res----${res}');
                        //                                         Navigator.of(context).pop();
                        //                                         get_lists();
                        //                                       },
                        //                                     ),
                        //                                     TextButton(
                        //                                       child: Text('No'),
                        //                                       onPressed: () {
                        //                                         Navigator.of(context).pop();
                        //                                       },
                        //                                     ),
                        //                                   ],
                        //                                 );
                        //                               });
                        //               }
                        //             },
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),

                        if (prescriptionList.length == 0)
                          const Center(
                            heightFactor: 1.0,
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
                      text: '+ Add Prescription',
                      width: 180,
                      fontSize: 16,
                      horizontalPadding: 10,
                      onTap: () async {
                        await push(
                            context: context,
                            screen: Add_Prescriptions_Doctor_Page(
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

  Future<String> savePdfToStorage(
      String url, targetPath, targetFilename) async {
    //comment out the next two lines to prevent the device from getting
    // the image from the web in order to prove that the picture is
    // coming from the device instead of the web.

    // var targetPath = await getPathToDowload();

    var response = await get(Uri.parse(url)); // <--2

    print('the url is__________________________________$url');

    String path = await downloadfolderpath();
    // String path = '/storage/emulated/0/Download';

    var firstPath = targetPath;
    var filePathAndName = path + '/' + targetFilename;
    //comment out the next three lines to prevent the image from being saved
    //to the device to show that it's coming from the internet

    // final taskId = await FlutterDownloader.enqueue(
    //     url:url,
    //     savedDir: path,
    //     showNotification: true, // show download progress in status bar (for Android)
    //     openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    //     fileName: targetFilename
    // );
    // await Directory(firstPath).create(recursive: true);
    //
    //
    // // <-- 1
    File file2 = new File(filePathAndName); // <-- 2
    file2.writeAsBytesSync(response.bodyBytes);
    print(' the file name is $filePathAndName'); // <-- 3;
    showSnackbar('Pdf downloaded successfully.');
    return filePathAndName;
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
                    'prescription_id':id,
                    'booking_id': booking_id.toString(),
                    'type':'1'
                  };
                  var res =
                  await Webservices.postData(
                      apiUrl: ApiUrls.deletePrescription,
                      body: data,
                      context: context);
                  print('res----${res}');
                  Navigator.of(context).pop();
                  get_lists();
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
