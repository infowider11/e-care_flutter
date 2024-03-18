import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:ecare/functions/print_function.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import 'package:path_provider/path_provider.dart' as pp;

ReceivePort port = ReceivePort();
void _bindBackgroundIsolate() async{

  final isSuccess = IsolateNameServer.registerPortWithName(
    port.sendPort,
    'downloader_send_port',
  );
  if (!isSuccess) {
    _unbindBackgroundIsolate();
    _bindBackgroundIsolate();
    return;
  }
  try{
    port.listen((dynamic data) {
      print('the listener is fetched data port is $data');
      final taskId = (data as List<dynamic>)[0] as String;
      final progress = data[2] as int;
      downloadStatusProgress = progress;

      print(
        'Callback on UI isolate: '
            'task ($taskId)  and process ($progress)',
      );


    });
  }
  catch(e){
    print('Error in catch  block pokfpsdfkp $e');
  }
}

void _unbindBackgroundIsolate() {
  IsolateNameServer.removePortNameMapping('downloader_send_port');
}

int downloadStatusProgress = 0;
Future<bool> checkDownloadStatus({bool initial = true})async{
  // print('checking download progress from funct : ${downloadStatusProgress.value}');
  // if(initial){
  //   await Future.delayed(Duration(seconds: 2));
  // }else{
  //   await Future.delayed(Duration(milliseconds: 300));
  // }
  print('checking download progress from funct : ${downloadStatusProgress}');
  if(downloadStatusProgress == 100){
    _unbindBackgroundIsolate();
    downloadStatusProgress = 0;
    return true;
  }else{
    await Future.delayed(Duration(milliseconds: 50));
    return checkDownloadStatus(initial: false);
  }
}

Future<void> downloadCsvFile(Uri uri) async {

  print('the donlxowww is $uri');
  // myCustomPrintStatement('the donlxowww is $uri');
  String path = '';
  if (Platform.isAndroid) {
    var status = await Permission.notification.request();
    myCustomPrintStatement('the status is $status');
    myCustomPrintStatement('i ame here...0-1');
    // final directory = await pp.getExternalStorageDirectory();
    Directory directory = Directory('../storage/emulated/0/Download');
    path = directory.path;
    myCustomPrintStatement('i ame here...1');
  }


  if (Platform.isIOS) {

    myCustomPrintStatement('i ame here...2');
    var tt = await pp.getApplicationDocumentsDirectory();
    path = tt.path;
    myCustomPrintStatement('the temp directory name for ios is $path');
  }
  // Directory directory = Directory('../storage/emulated/0/Download');
  // var path = await xp.ExternalPath(ExternalPath.DIRECTORY_DOWNLOADS);
  // var path =  await xp.ExternalPath.getExternalStoragePublicDirectory(xp.ExternalPath.DIRECTORY_DOWNLOADS);
  // myCustommyCustomPrintStatement('the directory name is ${directory!.path} ${directory}');
  myCustomPrintStatement('the directory name is $path');
  // return;

  String url = uri.toString();
  List temp = uri.path.split('.');
  if (url.contains('?url=')) {
    myCustomPrintStatement('hello world');
    List tt = url.split('?url=');
    print('the tt is $tt');
    url = tt[tt.length - 1];
    temp = url.split('.');
  }

  myCustomPrintStatement('the temp is $temp');
  String fileName = '';
  fileName =
  '${DateTime.now().millisecondsSinceEpoch}_123.${temp[temp.length - 1]}';
  myCustomPrintStatement(
      'the file name is $fileName download directory is $path and url is ...${url.toString()}...');
  final savedDir = path;
  // if(!Platform.isIOS){
 if(Platform.isAndroid){
   String? taskId = await FlutterDownloader.enqueue(
     url: url.toString(),
     savedDir: savedDir,
     fileName: fileName,
     showNotification: true,
     openFileFromNotification: false,
     saveInPublicStorage: true,
     requiresStorageNotLow: true,

   );

   _bindBackgroundIsolate();
   print('the task id is $taskId');

   myCustomPrintStatement('file is downloaded');
 }
  // }
  if (Platform.isIOS) {
    // downloadStatusProgress.notifyListeners();
    // await Future.delayed(Duration(seconds: 6));
    // myCustomPrintStatement('check download status start-----');
    // await checkDownloadStatus();
    //
    // myCustomPrintStatement('check download status end-----');
    try {
      var response = await get(uri);
      myCustomPrintStatement('mannn...$savedDir/$fileName');
      String filePath = '$savedDir/$fileName';
      // String filePath = '$savedDir/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      print('the file path name is $filePath');
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      // await file.writeAsBytes(response.bodyBytes.toList());
      XFile xFile = XFile(file.path);
      Share.shareXFiles([xFile]);
      // Share.shareFiles([filePath]);
      // Share.s
      // Share.s
      myCustomPrintStatement('Hel iing kkglllg');
    } catch (e) {
      myCustomPrintStatement('Hellow ooo.....$e');
    }
  }
}
