

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:ecare/constants/navigation.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/services/webservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/bookingDetail.dart';
import '../widgets/showSnackbar.dart';

void updateUserDetails(details) async{
  SharedPreferences shared_User = await SharedPreferences.getInstance();
  String user = jsonEncode(details);
  shared_User.setString('user_details', user);
}

Future<Map<String, dynamic>> getUserDetails() async{
  SharedPreferences shared_User = await SharedPreferences.getInstance();
  String userMap = await shared_User.getString('user_details')!;
  String userS = (userMap==null)?'':userMap;
  // log('this is uer'+userMap!);
  // if(userMap==null){
  //     return 0.toString();
  // }
  // else{
  // userMap;
  //  log('this is one '+userS);
  Map<String , dynamic> user = jsonDecode(userS) as  Map<String, dynamic>;
  // log('this is '+user['user_id']);
  return user;//.toString();
  // }
}

Future getCurrentUserId() async{
  SharedPreferences shared_User = await SharedPreferences.getInstance();
  print('1');
  String? userMap = await shared_User.getString('user_details');
  print('2');
  String userS = (userMap==null)?'':userMap;
  print('3');
  // log('this is uer'+userMap!);
  // if(userMap==null){
  //     return 0.toString();
  // }
  // else{
  // userMap;
  //  log('this is one '+userS);
  Map<String , dynamic> user = jsonDecode(userS) as  Map<String, dynamic>;
  print('4');
  // log('this is '+user['user_id']);
  return user['id'].toString();//.toString();
  // }
}
void updateUserId(id) async{
  // await FlutterSession().set("user_id", id);
}

Future isUserLoggedIn() async{
  // log("checking 124");
  // // SharedPreferences? sharedUser = null;
  final  sharedUser = await SharedPreferences.getInstance();
  //
  // return false;


  String? user = await sharedUser.getString('user_details');
  log(user.toString());
  // var d = jsonDecode(user);
  if(user==null){
    return false;
  }
  else{
    return true;
    log('user is already logged in '+user);
  }
  // await FlutterSession().get("user_details", details);
}

Future logout() async{
  print("logout()");
  await Webservices.updateDeviceToken(user_id: await getCurrentUserId(), token: '');
  SharedPreferences shared_User = await SharedPreferences.getInstance();
  await shared_User.clear();
  user_Data={};
  globel_timer!.cancel();
  return true;
}

Future<String> savePdfToStorage12( // old
    String url, targetPath, targetFilename) async {
  var response = await http.get(Uri.parse(url));
  print('auth the url is__________________________________$url');
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

savePdfToStorage1(
    String url, targetPath, targetFilename) async {
  var status = await Permission.storage.request();
  EasyLoading.show(
      status: null,
      maskType: EasyLoadingMaskType.black
  );
  var response = await http.get(Uri.parse(url));
  print('auth the url is new fun__________________________________$url');
  if(status.isGranted){
    String path = await downloadfolderpath();
    // String path = '/storage/emulated/0/Download';
    print('path ********* $path');
    var firstPath = targetPath;
    var filePathAndName = path+ '/' + targetFilename;
    File file2 = new File(filePathAndName); // <-- 2
    // file2.writeAsBytesSync(response.bodyBytes);
    try{
      file2.writeAsBytesSync(response.bodyBytes);
      print(' the file name is $filePathAndName'); // <-- 3;
      showSnackbar('Pdf downloaded successfully.');
      EasyLoading.dismiss();
      //return filePathAndName;
    }catch(e){
      print('catch  $e');
      EasyLoading.dismiss();
      //return null;
    }
  } else {
   showSnackbar('Permission denied');
   EasyLoading.dismiss();
  }
}

// downloadfolderpath() async {
//   var dir = await DownloadsPathProvider.downloadsDirectory;
//   String downloadfolderpath = '';
//   if (dir != null) {
//     downloadfolderpath = dir.path;
//     print(
//         'downloadfolderpath---------${downloadfolderpath}'); //output: /storage/emulated/0/Download
//     // setState(() {
//     //   //refresh UI
//     // });
//   } else {
//     print("No download folder found.");
//   }
//   return downloadfolderpath;
// }
downloadfolderpath() async{
  var downloadsDirectory = Platform.isAndroid
      ? '/storage/emulated/0/Download' // Android downloads directory
      : Platform.isIOS
      ? '${Directory.current.path}/downloads' // iOS downloads directory
      : Directory.current.path; // Other platforms
  return downloadsDirectory;
}

notificationHandling(BuildContext context,Map? data) {
  print('push data $data');
  if (data!['screen'] == 'booking') {
    print('----------------enter--------------');
    Navigator.push(context, MaterialPageRoute(builder: (context){
     return bookingdetail(
            booking_id: data!['booking_id'].toString(),
          );
    }));
    // push(context: context, screen: bookingdetail(
    //   booking_id: data!['booking_id'].toString(),
    // ));
  }

}



// downloadfolderpath() async {
//   var dir = await DownloadsPathProvider.downloadsDirectory;
//   String downloadfolderpath = '';
//   if (dir != null) {
//     downloadfolderpath = dir.path;
//     print(
//         'downloadfolderpath---------${downloadfolderpath}'); //output: /storage/emulated/0/Download
//     // setState(() {
//     //   //refresh UI
//     // });
//   } else {
//     print("No download folder found.");
//   }
//   return dir!.path;
// }