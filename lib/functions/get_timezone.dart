import 'package:flutter_native_timezone/flutter_native_timezone.dart';

Future<String> getUserTimeZone()async{
  final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  return currentTimeZone;
}
