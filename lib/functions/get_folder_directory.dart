import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<Directory?> getFolderDirectory()async{
  if(Platform.isIOS ||Platform.isMacOS){
    var directory = await getTemporaryDirectory();
    return directory;
  }
  return getExternalStorageDirectory();

}


Future<Directory?> getCustomDownloadsDirectory()async{
  if(Platform.isIOS ||Platform.isMacOS){
    var directory = await getTemporaryDirectory();
    return directory;
  }
  return getExternalStorageDirectory();

}
