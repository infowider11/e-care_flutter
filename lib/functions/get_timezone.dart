
import 'package:flutter_timezone/flutter_timezone.dart';

Future<String> getUserTimeZone()async{
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  return currentTimeZone;
}
