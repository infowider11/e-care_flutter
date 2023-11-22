import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/payment_method.dart';
import 'package:ecare/pages/profile_edit.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/list_ui_1.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/setting_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

import '../widgets/custom_circular_image.dart';
import '../widgets/image_picker.dart';
import '../widgets/showSnackbar.dart';

class ChatPage extends StatefulWidget {
  final String other_user_id;
  final String booking_id;
  const ChatPage(
      {Key? key, required this.booking_id, required this.other_user_id})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController msg = TextEditingController();
  List lists = [];
  bool load = false;
  String? user_name;
  Map current_user = {};
  bool is_file = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_chat_list(1);
  }

  get_chat_list(int loader) async {
    current_user = await getUserDetails();
    if (loader == 1)
      setState(() {
        load = true;
      });
    // String url = '${};
    var res = await Webservices.get(ApiUrls.chat_between_users +
        '?receiver_id=${widget.other_user_id.toString()}&sender_id=${await getCurrentUserId()}&booking_id=${widget.booking_id.toString()}');
    print('get chat-----$res');
    user_name = res['data']['user_data']['first_name'] +
        ' ' +
        res['data']['user_data']['last_name'];
    if (res['status'].toString() == '1') {
      lists = res['data']['chat_data'];
      setState(() {});
    }
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.BgColor,
      // bottomNavigationBar: ,
      // floatingActionButton: FloatingActionButton.extended(onPressed: onPressed, label: label),
      appBar: AppBar(
        backgroundColor: MyColors.BgColor,
        title: MainHeadingText(
          text: '${user_name ?? ''}',
          fontFamily: 'light',
          color: MyColors.headingcolor,
        ),
      ),
      body: load
          ? CustomLoader()
          : Stack(
              // alignment: AlignmentGeometry.lerp(a, b, t),
              children: [
                SingleChildScrollView(
                  physics: PageScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 40.0),
                  reverse: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: Container(
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info,
                                color: Colors.red.withOpacity(0.5),
                              ),
                              const Expanded(
                                child: Text(
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                  'Please note that the messaging portal between'
                                      ' you and your healthcare practitioner will'
                                      ' only be accessible from the time your'
                                      ' payment is finalized until 48 hours'
                                      ' after your consultation. You may use'
                                      ' this portal to ask questions and send'
                                      ' documents, but healthcare practitioners'
                                      ' are not obligated to respond. Please use'
                                      ' this portal responsibly, and remember to'
                                      ' contact your nearest healthcare'
                                      ' practitioner/hospital immediately for'
                                      ' urgent or emergency medical concerns.'
                                      ' Thank you for your cooperation and we hope you'
                                      ' have a productive consultation with'
                                      ' your healthcare practitioner.',
                                  textAlign: TextAlign.start,
                                  softWrap: true,
                                ),
                              )
                            ],
                          ),
                          padding: EdgeInsets.all(5.0),
                          width: MediaQuery.of(context).size.width,
                          // height: 200.0,
                          decoration: BoxDecoration(
                              color: MyColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                      for (int i = 0; i < lists.length; i++)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (lists[i]['sender_id'].toString() ==
                                current_user['id'].toString())
                              Container(
                                  child: Column(children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Stack(
                                      children: [
                                        Positioned(
                                          right: 15,
                                          bottom: 0,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.check,
                                                size: 20,
                                                color: lists[i]['is_read']
                                                            .toString() ==
                                                        '1'
                                                    ? MyColors.green
                                                    : Colors.grey,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: lists[i]['message_type'] ==
                                                  'image'
                                              ? GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  onTap: () {
                                                    print('zoom');
                                                  },
                                                  child: CustomCircularImage(
                                                    imageUrl: lists[i]
                                                        ['message'],
                                                    fileType:
                                                        CustomFileType.network,
                                                    borderRadius: 0.0,
                                                    height: 150,
                                                    width: 150,
                                                  ),
                                                )
                                              : lists[i]['message_type'] ==
                                                      'text'
                                                  ? Text(
                                                      '${lists[i]['message']}',
                                                      style: TextStyle(
                                                          color:
                                                              MyColors.white),
                                                    )
                                                  : Row(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () async {
                                                            // EasyLoading.show(
                                                            //   status: null,
                                                            //   maskType:
                                                            //       EasyLoadingMaskType
                                                            //           .black,
                                                            // );
                                                            await savePdfToStorage1(
                                                                lists[i]
                                                                    ['message'],
                                                                'Download',
                                                                lists[i][
                                                                        'message']
                                                                    .split(
                                                                        '/')[lists[i]
                                                                            [
                                                                            'message']
                                                                        .split(
                                                                            '/')
                                                                        .length -
                                                                    1]);
                                                            // EasyLoading
                                                            //     .dismiss();
                                                          },
                                                          icon: Icon(Icons
                                                              .file_download),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            lists[i]['message']
                                                                .split(
                                                                    '/')[lists[
                                                                            i][
                                                                        'message']
                                                                    .split('/')
                                                                    .length -
                                                                1],
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'bold',
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                          padding: EdgeInsets.fromLTRB(
                                              15.0, 10.0, 15.0, 10.0),
                                          width: 200.0,
                                          decoration: BoxDecoration(
                                              color: MyColors.primaryColor
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                          margin: EdgeInsets.only(right: 10.0),
                                        ),
                                      ],
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment
                                      .end, // aligns the chatitem to right end
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        height: 32,
                                        child: Text(
                                          '${lists[i]['create_date']}',
                                          style: TextStyle(
                                              color: MyColors.primaryColor,
                                              fontSize: 12.0,
                                              fontStyle: FontStyle.normal),
                                        ),
                                        margin: EdgeInsets.only(
                                            left: 5.0, top: 5.0, bottom: 5.0),
                                      )
                                    ])
                              ])),
                            if (lists[i]['sender_id'].toString() !=
                                current_user['id'].toString())
                              Container(
                                // height: 32,
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Stack(
                                          children: [
                                            Positioned(
                                              right: 18,
                                              bottom: 0,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    size: 20,
                                                    color: lists[i]['is_read']
                                                                .toString() ==
                                                            '1'
                                                        ? MyColors.green
                                                        : Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: lists[i]['message_type'] ==
                                                      'image'
                                                  ? GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .translucent,
                                                      onTap: () async {},
                                                      child:
                                                          CustomCircularImage(
                                                        imageUrl: lists[i]
                                                            ['message'],
                                                        fileType: CustomFileType
                                                            .network,
                                                        borderRadius: 0.0,
                                                        height: 150,
                                                        width: 150,
                                                      ),
                                                    )
                                                  : lists[i]['message_type'] ==
                                                          'text'
                                                      ? Text(
                                                          '${lists[i]['message']}',
                                                          style: TextStyle(
                                                              color: MyColors
                                                                  .white),
                                                        )
                                                      : Row(
                                                          children: [
                                                            IconButton(
                                                              onPressed:
                                                                  () async {
                                                                // EasyLoading
                                                                //     .show(
                                                                //   status: null,
                                                                //   maskType:
                                                                //       EasyLoadingMaskType
                                                                //           .black,
                                                                // );
                                                                await savePdfToStorage1(
                                                                    lists[i][
                                                                        'message'],
                                                                    'Download',
                                                                    lists[i][
                                                                            'message']
                                                                        .split(
                                                                            '/')[lists[i]
                                                                                ['message']
                                                                            .split('/')
                                                                            .length -
                                                                        1]);
                                                                // EasyLoading
                                                                //     .dismiss();
                                                              },
                                                              icon: Icon(Icons
                                                                  .file_download),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                lists[i][
                                                                        'message']
                                                                    .split(
                                                                        '/')[lists[i]
                                                                            [
                                                                            'message']
                                                                        .split(
                                                                            '/')
                                                                        .length -
                                                                    1],
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'bold',
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                              padding: EdgeInsets.fromLTRB(
                                                  15.0, 10.0, 15.0, 10.0),
                                              width: 200.0,
                                              decoration: BoxDecoration(
                                                  color: MyColors.primaryColor
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              margin:
                                                  EdgeInsets.only(right: 10.0),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Text(
                                        '${lists[i]['create_date']}',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                            fontStyle: FontStyle.normal),
                                      ),
                                      margin: EdgeInsets.only(
                                          left: 5.0, top: 5.0, bottom: 5.0),
                                    )
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                                margin: EdgeInsets.only(bottom: 10.0),
                              ),
                          ],
                        ),
                      if (lists.length == 0 && !load)
                        Center(
                          child: Text('No chat yet.'),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: is_file?null:Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomTextField(
                              paddingsuffix: 0.0,
                              left: 0.0,
                              preffix: IconButton(
                                padding: EdgeInsets.all(0),

                                onPressed: () {
                                  _showImage_popup(context);
                                },
                                icon: Icon(
                                  Icons.add_circle,
                                  color: MyColors.primaryColor,
                                ),
                              ),
                              height: 46,
                              bordercolor: MyColors.white,
                              borderradius: 100,
                              onChange: ((String value) {
                                setState(() {});
                              }),
                              suffix: IconButton(
                                onPressed: msg.text.length != 0
                                    ? (() async {
                                        Map<String, dynamic> data = {
                                          'booking_id':
                                              widget.booking_id.toString(),
                                          'receiver_id':
                                              widget.other_user_id.toString(),
                                          'sender_id': await getCurrentUserId(),
                                          'message': msg.text,
                                        };
                                        var res = await Webservices.postData(
                                            apiUrl: ApiUrls.send_msg,
                                            body: data,
                                            context: context);
                                        print('send_msg-----$res');
                                        setState(() {
                                          msg.text = '';
                                          get_chat_list(0);
                                        });
                                      })
                                    : null,
                                icon: Icon(
                                  Icons.send_rounded,
                                  color: msg.text.length != 0
                                      ? MyColors.primaryColor
                                      : Colors.grey,
                                ),
                              ),
                              // suffixIcon: 'assets/images/chat.png',
                              controller: msg,
                              hintText: 'Type message here..........')
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showImage_popup(
    BuildContext ctx,
  ) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                    onPressed: () async {
                      File? image;
                      image = await Imagepicker_Without_Croper(false);
                      print('image----$image');
                      if (image != null) {
                        send_file(image);
                        setState(() {});
                      }
                      _close(ctx);
                    },
                    child: const Text('Take a picture')),
                CupertinoActionSheetAction(
                    onPressed: () async {
                      File? image;
                      print('click');
                      image = await Imagepicker_Without_Croper(true);
                      print('image----$image');
                      if (image != null) {
                        send_file(image);
                        setState(() {});
                      }
                      _close(ctx);
                    },
                    child: const Text('Document')),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => _close(ctx),
                child: const Text('Close'),
              ),
            ));
  }

  void _close(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }

  send_file(File file) async {
    setState(() {
      is_file=true;
    });
    Map<String, dynamic> files = {};
    Map<String, dynamic> data = {
      'booking_id': widget.booking_id.toString(),
      'receiver_id': widget.other_user_id.toString(),
      'sender_id': await getCurrentUserId(),
    };
    files['message'] = file;
    var res = await Webservices.postDataWithImageFunction(
        apiUrl: ApiUrls.send_msg, files: files, body: data, context: context);
    print('send file ---${res}');
    get_chat_list(0);
    setState(() {
      is_file=false;
    });
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
}
