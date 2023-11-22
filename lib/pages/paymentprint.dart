import 'package:ecare/constants/sized_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class paymentconsole extends StatefulWidget{
  final String data;
  final String url;
  const paymentconsole({Key?key,required this.data,required this.url}):super(key:key);

  @override
  State<paymentconsole> createState() => _paymentconsole();
}

class _paymentconsole extends State<paymentconsole> {

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
     appBar: AppBar(),
     body: Center(
       heightFactor: 10.0,
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Text(widget.data,style: TextStyle(color: Colors.black),),
         vSizedBox8,
         Text(widget.url,style: TextStyle(color: Colors.black),),
       ],
     )),
    );
  }
}

