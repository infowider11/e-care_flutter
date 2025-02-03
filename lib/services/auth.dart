

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:ecare/constants/navigation.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/services/webservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../functions/print_function.dart';
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
  globel_timer?.cancel();
  return true;
}
//
// Future<String> savePdfToStorage12( // old
//     String url, targetPath, targetFilename) async {
//   var response = await http.get(Uri.parse(url));
//   print('auth the url is__________________________________$url');
//   String path = await downloadfolderpath();
//   // String path = '/storage/emulated/0/Download';
//   var firstPath = targetPath;
//   var filePathAndName = path + '/' + targetFilename;
//   File file2 = new File(filePathAndName); // <-- 2
//   file2.writeAsBytesSync(response.bodyBytes);
//   print(' the file name is $filePathAndName'); // <-- 3;
//   showSnackbar('Pdf downloaded successfully.');
//   return filePathAndName;
// }
//
///
savePdfToStorage1(
    String pdfUrl, targetPath, targetFilename) async {
  print('downloading pdf $pdfUrl');
  if(Platform.isAndroid){
    savePdfToStorageForAndroid(pdfUrl, targetPath, targetFilename);
    return;
  }
  EasyLoading.show(
      status: null,
      maskType: EasyLoadingMaskType.black
  );
  try {

    final response = await http.get(Uri.parse(pdfUrl));

    if (response.statusCode == 200) {
      final directory = await getTemporaryDirectory();
      final pdfFile = File('${directory.path}/downloaded.pdf');

      await pdfFile.writeAsBytes(response.bodyBytes);

      // Save the file to the iOS device's shared documents directory
      final documentsDirectory = await getApplicationDocumentsDirectory();

      String path = '${documentsDirectory.path}/$targetFilename';
      myCustomPrintStatement('the save  path is $path');
      final savedPDF = await pdfFile.copy(path);
      // final savedPDF = await pdfFile.copy('${documentsDirectory.path}/downloaded.pdf');

      print('PDF downloaded and saved to: ${savedPDF.path}');
      if(Platform.isAndroid){
        try{
          print(' opening ${savedPDF.path}'); // <-- 3;
          await Permission.manageExternalStorage.request();
          var rr = await OpenFile.open("${savedPDF.path}");

          print(' opening opened ${savedPDF.path}.........${rr.message}'); // <-- 3;
        }catch(e){
          print('dsvgdf catch  $e');

          //return null;
        }
      }else{
        Share.shareXFiles([XFile(savedPDF.path)], text: 'PDF').then((value) {
          // print('sharing----- $value');
          EasyLoading.dismiss();
        });
      }
      // return savedPDF;
    } else {
      print('Failed to download PDF. Status code: ${response.statusCode}');
      EasyLoading.dismiss();
      // return null;
    }
  } catch (e) {
    print('Error downloading PDF: $e');
    EasyLoading.dismiss();
    // return null;
  }
}
///
savePdfToStorageForAndroid(
    String url, targetPath, targetFilename) async {
  // var status = await Permission.storage.request();
  // await Permission.manageExternalStorage.request();


  EasyLoading.show(

      status: null,
      maskType: EasyLoadingMaskType.black
  );
  var response = await http.get(Uri.parse(url));

  var dir = await getTemporaryDirectory();

  String path = dir.path;
  // String path = await downloadfolderpath();
  // String path = '/storage/emulated/0/Download';
  print('path ********* $path');
  var firstPath = targetPath;
  var filePathAndName = path+ '/' + targetFilename;
  File file2 = new File(filePathAndName); // <-- 2
  // file2.writeAsBytesSync(response.bodyBytes);
  try{
    await file2.create(recursive: true);
    await file2.writeAsBytes(response.bodyBytes.toList());
    print(' the file name is $filePathAndName'); // <-- 3;
    showSnackbar('Pdf downloaded successfully.dds');
    // launchUrl(Uri.parse(file2.path));


    EasyLoading.dismiss();
    try{
      print(' opening $filePathAndName'); // <-- 3;
      await Permission.manageExternalStorage.request();
      var rr = await OpenFile.open("${file2.path}");

      print(' opening opened $filePathAndName.........${rr.message}'); // <-- 3;
    }catch(e){
      print('dsvgdf catch  $e');

      //return null;
    }
    //return filePathAndName;
  }catch(e){
    print('catch  $e');
    EasyLoading.dismiss();
    //return null;
  }
  // print('auth the url is new fun________________________________$status...$url');
  // status = PermissionStatus.granted;
  // status = Permission.
  // if(status.isGranted){
  //
  //
  // }
  // else {
  //  showSnackbar('Permission denied');
  //  EasyLoading.dismiss();
  // }
}


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