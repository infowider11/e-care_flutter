import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:ecare/pages/booked_visit.dart';
import 'package:ecare/pages/filter.dart';
import 'package:ecare/pages/get_care.dart';
import 'package:ecare/pages/invite-freinds.dart';
import 'package:ecare/pages/myecare.dart';
import 'package:ecare/pages/other_reason_visit.dart';
import 'package:ecare/pages/reason_visit.dart';
import 'package:ecare/pages/refund.dart';
import 'package:ecare/services/firebase_push_notifications.dart';
import 'package:ecare/services/log_services.dart';
import 'package:ecare/services/onesignal.dart';
import 'package:ecare/splash.dart';
import 'package:ecare/tabs.dart';
import 'package:ecare/tabs_doctor.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'constants/constans.dart';
import 'constants/global_keys.dart';
import 'constants/navigation.dart';
import 'doctor_module/add_new_card.dart';
import 'doctor_module/appointment_request.dart';
import 'doctor_module/money_request.dart';
import 'doctor_module/my_wallet.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'functions/download_file.dart';
import 'functions/get_timezone.dart';
import 'functions/global_Var.dart';
import 'package:flutter/foundation.dart';

import 'functions/print_function.dart';

setDownloadProgress(int progress){
  print('Changing download progress from ${downloadStatusProgress} to $progress');
  downloadStatusProgress = progress;
}
class TestClass{
  static void callback(String id, int status, int progress) {
    //
    // myCustomPrintStatement('Download status: $status');
    // myCustomPrintStatement('Download progress: $progress');
    // // downloadStatusProgress = progress;
    //
    // setDownloadProgress(progress);
    myCustomPrintStatement('Download status progress: ${progress}');


    final SendPort? send =
    IsolateNameServer.lookupPortByName('downloader_send_port');

    send!.send([id, status, progress]);
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();


  if(Platform.isAndroid){
    await FlutterDownloader.initialize(
        debug: true, // optional: set to false to disable printing logs to console (default: true)
        ignoreSsl: true // option: set to false to disable working with http links (default: false)
    );
    await FlutterDownloader.registerCallback(TestClass.callback);

  }

  // if(!kIsWeb) {
    await Firebase.initializeApp();
    print('firebase is initialized');
    await initOneSignal('090aa36a-e6f9-4195-9413-fa54d2789e23');
  try{
    // currentTimezone = await getUserTimeZone();
  }catch(e){
    print('Errir in catch block in gettiing timezone $e');
  }
    print('onesingal init successfully----');
    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // }

  runApp(const MyApp());
  configLoading();

  // runZonedGuarded(() async{
  //   await SentryFlutter.init(
  //         (options) {
  //
  //       options.dsn = 'https://fe4b503f6bc049158a7fd3473a43f211@o4505385253666816.ingest.sentry.io/4505385254846464'; //manish
  //
  //       // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
  //       // We recommend adjusting this value in production.
  //       options.tracesSampleRate = 1.0;
  //     },
  //     appRunner: () => runApp(const MyApp()),
  //
  //   );
  // }, (error, stack) {
  //   log('Error foung $error, \nStack:  $stack');
  //   // CustomLogServices.sendMessageToSentry(message: 'Error $error', stackTrace: stack);
  // });


}





// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   print('firebase is initialized');
//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//   print('firebase is initialized2');
//
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: (payload)async{
//         print('the notification is selected $payload');
//         // {booking_id: 8, user_type: 3, user_id: 9, screen: booking}
//         if(payload!=null){
//
//         }
//       }
//   );
//
//   print('firebase is initialized3 d');
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//   final NotificationAppLaunchDetails? notificationAppLaunchDetails =
//   await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//   String? payload= notificationAppLaunchDetails!.payload;
//   print('the payload is ${payload}');
//
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   await FirebasePushNotifications.firebaseSetup();
//   runApp(const MyApp());
//   configLoading();
// }

void configLoading() {
  EasyLoading.instance

    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.light

    ..indicatorSize = 45.0
    ..radius = 10.0

    ..maskColor = Colors.blue.withOpacity(0.7)
    ..userInteractions = false
    ..dismissOnTap = false;
    // ..customAnimation = CustomAnimation();
}

TextEditingController _controller = TextEditingController();


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      navigatorKey: MyGlobalKeys.navigatorKey,
      title: 'E-CARE',
      darkTheme: ThemeData(
        // primaryColor: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        fontFamily: 'regular',
        // This is the theme of your application.
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
      ),
      home: SplashScreenPage(),
      builder: EasyLoading.init(),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),

            ActionChip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: const Text('AB'),
                ),
                label: const Text('Aaron Burr'),
                onPressed: () {
                  print('If you stand for nothing, Burr, what’ll you fall for?');
                }
            ),

            TextFormField(
              controller: _controller,
              maxLength: 20,
              decoration: InputDecoration(
                labelText: 'Label text',
                labelStyle: TextStyle(
                  color: Color(0xFF6200EE),
                ),
                helperText: 'Helper text',
                suffixIcon: Icon(
                  Icons.check_circle,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6200EE)),
                ),
                border: OutlineInputBorder(),
              ),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
