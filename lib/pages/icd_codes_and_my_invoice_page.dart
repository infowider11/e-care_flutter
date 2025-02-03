
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/list_ui_1.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/api_variable_keys.dart';
import '../widgets/custom_confirmation_dialog.dart';
import '../widgets/showSnackbar.dart';
import 'bookingDetail.dart';

class ICDCodesAndMyInvoicePage extends StatefulWidget {
  String? doc_name;
  String? doc_type;
  ICDCodesAndMyInvoicePage({Key? key, this.doc_name, this.doc_type}) : super(key: key);

  @override
  State<ICDCodesAndMyInvoicePage> createState() => ICDCodesAndMyInvoicePageState();
}

class ICDCodesAndMyInvoicePageState extends State<ICDCodesAndMyInvoicePage>
    with TickerProviderStateMixin {
  TabBar get _tabBar => TabBar(
    padding: EdgeInsets.symmetric(horizontal: 0),
    labelPadding: EdgeInsets.symmetric(horizontal: 0),
    tabs: <Widget>[
      Tab(
        child: MainHeadingText(
          text: 'My Invoice',
          color: MyColors.onsurfacevarient,
          fontSize: 11,
        ),
      ),
      Tab(
        child: MainHeadingText(
          text: 'Statement with ICD-10 Notes',
          color: MyColors.onsurfacevarient,
          fontSize: 11,
        ),
      ),
    ],
  );
  TextEditingController email = TextEditingController();
  bool load = false;
  List invoiceList = [];
  List icdNotes = [];

  getInvoiceList() async {
    setState(() {
      load = true;
    });
    invoiceList = await Webservices.getList(ApiUrls.invoice_list+await getCurrentUserId()+'&type=2');
    setState(() {
      load = false;
    });
  }

  // ?doctor_id=23&booking_id=2
  getIcdCodeList() async {
    // Map<String, dynamic> data = {
    //   'user_id': await getCurrentUserId(),
    //   'booking_id': '',
    // };
    // var res = await Webservices.postData(
    //     apiUrl: ApiUrls.get_reffral, body: data, context: context);
    // print('list    ${res}');
    // if (res['status'].toString() == '1') {
    //   raffrals = res['data'];
    //   setState(() {});
    // }
    icdNotes = await Webservices.getList(ApiUrls.usericdCode_list+'?user_id=${await getCurrentUserId()}&type=2');
    setState(() {
      load = false;
    });
  }

  // get_lists() async {
  //   setState(() {
  //     load = true;
  //   });
  //   Map<String, dynamic> data = {
  //     'user_id': await getCurrentUserId(),
  //     'booking_id': '',
  //   };
  //   var res = await Webservices.postData(
  //       apiUrl: ApiUrls.get_precriptions, body: data, context: context);
  //   print('list    ${res}');
  //   if (res['status'].toString() == '1') {
  //     lists = res['data'];
  //     setState(() {});
  //   }
  //   setState(() {
  //     load = false;
  //   });
  // }

  @override
  void initState() {

    super.initState();
    getInvoiceList();
    getIcdCodeList();
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
            text: 'My Invoice/Statement with ICD-10 Notes',
            fontSize: 17,
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
            ? CustomLoader()
            : TabBarView(children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSizedBox2,
                  MainHeadingText(
                    text: 'My Invoices ',
                    fontSize: 32,
                    fontFamily: 'light',
                  ),
                  vSizedBox2,
                  ParagraphText(
                      fontSize: 16,
                      text:
                      'Download invoices from your Healthcare Practitioner here'),
                  vSizedBox4,
                  for (int i = 0; i < invoiceList.length; i++)
                    ListUI02(
                        heading: 'Invoice: ${invoiceList[i][ApiVariableKeys.doctor_lastname]}/${invoiceList[i][ApiVariableKeys.user_lastname]}/${invoiceList[i][ApiVariableKeys.consult_dateTime]}',
                        // subheading: '${invoiceList[i]['time_ago']??''}',
                        subheading: '${invoiceList[i]['date']} ${invoiceList[i]['time']}',
                        borderColor: MyColors.white,
                        is_edit: false,
                        isIcon: false,
                        deleteonTap: () async{
                          Map<String, dynamic> data = {
                            'booking_id':invoiceList[i]['id'].toString(),
                            'type':'2'
                          };
                          bool? result= await showCustomConfirmationDialog(
                              headingMessage: 'Are you sure you want to delete?',
                              // description: 'Are you sure you want to delete?'
                          ) ;
                          if(result==true){
                            setState(() {
                              load = true;
                            });
                            var res = await Webservices.postData(apiUrl: ApiUrls.deleteInvoice,
                                body: data,
                                context: context);
                            print('res----${res}');
                            getInvoiceList();
                          }},
                        sendonTap: () async{
                          var time = DateTime.now();
                          await savePdfToStorage1(invoiceList[i]['invoice_attachment'],'pdf',
                              '${time.millisecond}_invoice_attachment.pdf');
                          // EasyLoading.dismiss();
                        },
                        image: 'assets/images/file.png'),
                  if (invoiceList.length == 0)
                    Center(
                      child: Text('No data found.'),
                    )
                ],
              ),
            ),
          ),
          Container(
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
                      'Download statements from your Healthcare Practitioner here'),
                  vSizedBox4,
                  for (int i = 0; i < icdNotes.length; i++)
                    ListUI02(
                        heading: 'STATEMENT: ${icdNotes[i][ApiVariableKeys.doctor_lastname]}/${icdNotes[i][ApiVariableKeys.user_lastname]}',
                        subheading: '${icdNotes[i][ApiVariableKeys.consult_dateTime]}',
                        borderColor: MyColors.white,
                        is_edit: false,
                        isIcon: false,
                        deleteonTap: () async{
                          Map<String, dynamic> data = {
                            'booking_id':icdNotes[i]['booking_id'].toString(),
                            'type':'2'
                          };
                          bool? result= await showCustomConfirmationDialog(
                              headingMessage: 'Are you sure you want to delete?',
                          ) ;
                          if(result==true){
                            setState(() {
                              load = true;
                            });
                            var res = await Webservices.postData(apiUrl: ApiUrls.deleteIcd,
                                body: data,
                                context: context);
                            print('res----${res}');
                            getIcdCodeList();
                          }},
                        sendonTap: () async{
                          var time = DateTime.now();
                          await savePdfToStorage1(icdNotes[i]['pdf_url'],'pdf',
                              '${time.millisecond}_STATEMENT_WITH_ICD10_CODE.pdf');
                        },
                        image: 'assets/images/file.png'),
                  if (icdNotes.length == 0)
                    Center(
                      child: Text('No data found.'),
                    )
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



  // Future<void> savePdfToStorage(
  //     String url, targetPath, targetFilename) async {
  //   //comment out the next two lines to prevent the device from getting
  //   // the image from the web in order to prove that the picture is
  //   // coming from the device instead of the web.
  //
  //   // var targetPath = await getPathToDowload();
  //
  //   var response = await get(Uri.parse(url)); // <--2
  //
  //   print('the url is__________________________________$url');
  //   print('the url is2__________________________________${response.bodyBytes}');
  //
  //
  //   // if(await Permission.storage.request().isGranted){
  //   print('persmision----granted---------');
  //   // String path = await downloadfolderpath();
  //   Directory? dir = await getExternalStorageDirectory();
  //   String path = dir!.path;
  //   print('path ${path}');
  //   // String path = '/storage/emulated/0/Download';
  //
  //   var firstPath = targetPath;
  //   var filePathAndName = path + '/' + targetFilename;
  //   File file2 = new File(filePathAndName); // <-- 2
  //   try{
  //     await file2.writeAsBytes(response.bodyBytes);
  //     print(' the file name is $filePathAndName'); // <-- 3;
  //     showSnackbar('Pdf downloaded successfully.dd');
  //     launchUrl(Uri.parse(file2.path));
  //   }catch(e)  {
  //     print('catch err---- ${e}');
  //   };
  //
  //   // return filePathAndName;
  //   // } else {
  //   //   EasyLoading.dismiss();
  //   //   await Permission.storage.request();
  //   //   print('persmission graned2--');
  //   //   // return;
  //   // }
  //
  // }

  // downloadfolderpath() async {
  //   var dir = await DownloadsPathProvider.downloadsDirectory;
  //   String downloadfolderpath = '';
  //   if (dir != null) {
  //     downloadfolderpath = dir.path;
  //     print(
  //         'downloadfolderpath---------${downloadfolderpath}'); //output: /storage/emulated/0/Download
  //     setState(() {
  //       //refresh UI
  //     });
  //   } else {
  //     print("No download folder found.");
  //   }
  //   return downloadfolderpath;
  // }

  // showAlertDialog(BuildContext context, String id) {
  //   // set up the button
  //   Widget okButton = TextButton(
  //     child: Text("Yes"),
  //     onPressed: () async {
  //       await EasyLoading.show(
  //           status: null, maskType: EasyLoadingMaskType.black);
  //       var res = await Webservices.get(ApiUrls.deletedocimage + '?id=' + id);
  //       EasyLoading.dismiss();
  //       if (res['status'].toString() == '1') {
  //         Navigator.pop(context);
  //         get_lists();
  //       }
  //     },
  //   );
  //
  //   Widget noButton = TextButton(
  //     child: Text("No"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );
  //
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Remove Document"),
  //     content: Text("Are you sure?"),
  //     actions: [
  //       okButton,
  //       noButton,
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
}
