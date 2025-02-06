// // import 'package:livestream/services/webservices.dart';
// import 'package:ecare/services/webservices.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
//
// import 'api_urls.dart';
// import 'auth.dart';
//
// // import '../FUNCTIONS/api_urls.dart';
// // import '../FUNCTIONS/auth.dart';
// // import '../FUNCTIONS/webservices.dart';
//
//
// // import 'navigation_functions.dart';
//
// String? onesignal_device_id;
// //this should be called in first screen init state (example: splash screen)
// Future<void> initOneSignal(app_id) async {
//   OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
//
//   OneSignal.shared.setAppId(app_id);
//
// // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//   OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
//     print("Accepted permission: $accepted");
//   });
// }
//
// //this should be called in after logged in first screen init state (example: tab)
// setNotificationHandler(context) async {
//   OneSignal.shared.setNotificationWillShowInForegroundHandler(
//       (OSNotificationReceivedEvent event) {
//         print('Notification is received $event');
//     // Will be called whenever a notification is received in foreground
//     // Display Notification, pass null param for not displaying the notification
//     event.complete(event.notification);
//   });
//
//   OneSignal.shared
//       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
//     print('the notificationnnn is ');
//     print('the notificationnnn is ${result.notification.toString()}');
//     // creating by you in flutter
//     notificationHandling(context,result.notification.additionalData);
//     print("notificationopen--------------------------------" +
//         result.notification.additionalData.toString());
//     // Will be called whenever a notification is opened/button pressed.
//   });
//
//   OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
//     // Will be called whenever the permission changes
//     // (ie. user taps Allow on the permission prompt in iOS)
//   });
//
//   // onesignal_device_id = await get_device_id();
//   // Map<String, dynamic> request = {
//   //   'user_id': await getCurrentUserId(),
//   //   'device_id': onesignal_device_id.toString()
//   // };
//   // // Webservices.postData('edit-profile', {"device_id":{"value":onesignal_device_id}},null);
//   // await Webservices.postData(apiUrl: ApiUrls.device_id, request: request);
//   // print("device id--------------------------------" +
//   //     onesignal_device_id.toString());
//   // OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) async{
//   //   print("subscription--------------------------------");
//   //
//   //
//   //
//   //   // Webservices.getData(url, data)
//   //   // Will be called whenever the subscription changes
//   //   // (ie. user gets registered with OneSignal and gets a user ID)
//   // });
// }
//
// Future<String?> get_device_id() async {
//   var deviceState = await OneSignal.shared.getDeviceState();
//   if (deviceState == null || deviceState.userId == null) return null;
//   return deviceState.userId!;
// }


import 'dart:developer';

import 'package:ecare/services/webservices.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'api_urls.dart';
import 'auth.dart';

String? onesignalDeviceId;

Future<void> initOneSignal(String appId) async {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

   OneSignal.initialize(appId);

  // Prompt for push notifications
  await OneSignal.Notifications.requestPermission(true);
}

void setNotificationHandler(context) {
  OneSignal.Notifications.addForegroundWillDisplayListener(
          (OSNotificationWillDisplayEvent event) {
        print('Notification received in foreground: ${event.notification.body}');
            ///TODO: uncomment in the end manish 0510
        // event.complete(event.notification);
      });

  OneSignal.Notifications.addClickListener(
          (OSNotificationClickEvent event) {
        print('Notification clicked: ${event.notification.body}');
        notificationHandling(context, event.notification.additionalData);
      });
}

String? get_device_id()  {
  var deviceState =  OneSignal.User.pushSubscription.id;
  // var deviceState = await OneSignal.User.getOnesignalId();
  // await OneSignal.User.pushSubscription.optIn();
  // var deviceState = await OneSignal.User.pushSubscription.getDeviceState();;
  checkSubscriptionStatus();


  // print('the device ids is ${deviceStates}');
  print('the device id is ${deviceState}');
  log('the device id is ${deviceState}');

  return deviceState;
}


 bool checkSubscriptionStatus()  {
  var status = OneSignal.User.pushSubscription.optedIn;
  print("Push Subscription Status: $status");
  log("Push Subscription Status: $status");
  log("Push Subscription Status: ${OneSignal.User.pushSubscription.id}");

  return status??false;

}