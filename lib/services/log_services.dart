// ignore_for_file: avoid_print

import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/pages/ErrorLogPage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'dart:math' as math;

class CustomLogServices{


  static Future sendMessageToSentry({
    required String message,  Object? exception,  StackTrace? stackTrace,SentryLevel? sentryLevel,
})async{


    String errorMessage = 'Message : ${message}';

    try{

      errorMessage += '\nuser id : ${user_Data?['id']}\n,Time: ${DateTime.now().toString()}\n';
    }catch(e){
      print('Error in catch block 3469036 user is null');
    }
    // String userId = '${Provider.of<GlobalModal>(MyGlobalKeys.navigatorKey.currentContext!, listen: false).userData!.userId}';

    print('sending error message');



    if(exception!=null){
      errorMessage += '\nException : $exception';
    }
    errorLogs['${math.Random().nextInt(4000)}_${DateTime.now().millisecond}'] = 'error: $errorMessage \n${exception} ';
    if(sentryLevel!=null){
      await Sentry.captureMessage(errorMessage,level: sentryLevel,);
    }else{
      await Sentry.captureException(
        errorMessage,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          // 'login': userDetails,
          // 'user_id': userId,
          'message': message,
          'strack_trace': stackTrace??'',
          // 'exception': exception,
        }),
      );
    }
    print('error message sent');


  }
}