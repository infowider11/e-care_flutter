import 'package:flutter/material.dart';

class SlotPreviewModal{
  TimeOfDay from;
  TimeOfDay to;
  DateTime dateTime;

  SlotPreviewModal({
    required this.from,
    required this.to,
    required this.dateTime,
  });


  String fromTimeText(BuildContext context){
    String time = from.format(context);
    return time;
  }

  String toTimeText(BuildContext context){
    String time = to.format(context);
    return time;
  }
}