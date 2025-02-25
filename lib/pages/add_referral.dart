// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, unnecessary_string_interpolations, non_constant_identifier_names, camel_case_types

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/showSnackbar.dart';
 
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/api_variable_keys.dart';
import '../functions/get_name.dart';
import 'dart:ui' as ui;

import '../widgets/custom_dropdown.dart';


class Add_Referral_Letter_Page extends StatefulWidget {
  final bool? is_update;
  final Map? data;
  final String? booking_id;
  final String? doctorName;
  const Add_Referral_Letter_Page({Key? key, this.is_update, this.data,this.booking_id, this.doctorName})
      : super(key: key);


  @override
  State<Add_Referral_Letter_Page> createState() =>
      _Add_Referral_Letter_PageState();
}

class _Add_Referral_Letter_PageState extends State<Add_Referral_Letter_Page> {
  TextEditingController desc = TextEditingController();
  List bookings = [];
  String booking_id = '';

  final _sign = GlobalKey<SignatureState>();
  var strokeWidth = 5.0;
  ByteData _img = ByteData(0);
  Map? selectedBookingData;
  get_bookings() async {
    bookings = await Webservices.getList(
        ApiUrls.bookingslist + await getCurrentUserId());
    print('-------- ${bookings}');
    for(int i = 0;i<bookings.length;i++){
      bookings[i]['${ApiVariableKeys.temp_name}'] = getName(prefixText: 'Booking', doctorLastName: bookings[i][ApiVariableKeys.doctor_data][ApiVariableKeys.last_name], userLastName: '${bookings[i][ApiVariableKeys.user_data][ApiVariableKeys.last_name]}', dateTimeConsultation: '${bookings[i]['${ApiVariableKeys.slot_data}'][ApiVariableKeys.date_with_time]}');
      print('the booking data is ${bookings[i]}');
      if(bookings[i]['id']==widget.booking_id){
        selectedBookingData = bookings[i];
      }
    }
    setState(() {});
  }


  @override
  void initState() {
    
    if (widget.booking_id != null && widget.booking_id != 'null') {
      booking_id = widget.booking_id!;
    }
    if(widget.data!=null){
      booking_id=widget.data!['booking_id'].toString();
      desc.text=widget.data!['description'];
    }
    get_bookings();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainHeadingText(
                text: widget.is_update == null
                    ? 'Add Referral later'
                    : 'Edit Referral later',
                fontSize: 32,
                fontFamily: 'light',
              ),
              vSizedBox4,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ParagraphText(
                    text: 'Booking Id',
                    fontSize: 14.0,
                    color: Colors.black,
                    fontFamily: 'regular',
                  ),
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColors.bordercolor),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // child: CustomDropdownButton(
                    //   // extra_text: 'Booking Id #',
                    //   extra_text:widget.doctorName==null? 'Booking Id #': '(${widget.doctorName}) Booking Id #',
                    //   isextra_text: true,
                    //   margin: 0.0,
                    //   isLabel: false,
                    //   onChanged: ((dynamic value) {
                    //     print('select bank ---- ${value}');
                    //     booking_id = value['id'].toString();
                    //     setState(() {});
                    //   }),
                    //   selectedItem: booking_id != null ? booking_id : '',
                    //   items: bookings,
                    //   hint: 'Select Booking',
                    //   itemMapKey: 'id',
                    //   text: '',
                    // ),
                    child: CustomDropdownButton(

                      height: 70,
                      isextra_text: true,
                      // extra_text: getName(prefixText: 'Booking', doctorLastName: value['${ApiVariableKeys.doctor_lastname}'], userLastName: userLastName, dateTimeConsultation: dateTimeConsultation),
                      // extra_text: 'Booking',
                      // extra_text: 'Booking id #',
                      margin: 0.0,
                      isLabel: false,
                      onChanged: ((dynamic value) {
                        print('select bank ---- ${value}');
                        booking_id = value['id'].toString();
                        setState(() {});
                      }),
                      selectedItem: selectedBookingData,
                      // selectedItem: booking_id != null ? booking_id : '',
                      items: bookings,
                      hint: 'Select Booking',
                      // itemMapKey: 'id',
                      itemMapKey: '${ApiVariableKeys.temp_name}',
                      text: '',
                    ),
                  ),
                  CustomTextFieldmaxlines(
                    controller: desc,
                    label: 'Decription',
                    showlabel: true,
                    labelcolor: MyColors.onsurfacevarient,
                    hintText: 'Description',
                    maxLines: 5,
                  ),
                  vSizedBox,
                  if(widget.is_update==null)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const ParagraphText(
                              text: 'Signature',
                              fontSize: 14.0,
                              color: Colors.black,
                              fontFamily: 'regular',
                            ),
                            TextButton(
                                onPressed: () {
                                  final sign = _sign.currentState;
                                  sign?.clear();
                                },
                                child: const Text('Clear',style: TextStyle(color: Colors.red),)
                            ),
                          ],
                        ),
                        Container(
                          // color: Colors.white,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          width: double.infinity,
                          height: 200,
                          child:Row(
                            children: [
                              Expanded(
                                child: Signature(
                                  color: Colors.black,
                                  key: _sign,
                                  onSign: () {
                                    final sign = _sign.currentState;
                                    debugPrint('${sign?.points.length} points in the signature');
                                  },
                                  // backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                                  strokeWidth: strokeWidth,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              vSizedBox2,
              RoundEdgedButton(
                text:
                widget.is_update == null ? 'Add Referral' : 'Edit Referral',
                onTap:() async{
                  if(booking_id==''){
                    showSnackbar('Please select booking.');
                  } else
                  if(desc.text==''){
                    showSnackbar('Please enter description.');
                  } else {
                    Map<String,dynamic> files = {};
                    Map<String,dynamic> data = {
                      'user_id':await getCurrentUserId(),
                      'description':desc.text,
                      'booking_id':booking_id,
                    };
                    if(widget.is_update==true){
                      data['id'] = widget.data!['id'].toString();
                    }
                    File? file;
                    final sign = _sign.currentState;
                    // return;
                    final image = await sign?.getData();
                    if(widget.is_update==null){
                      var data = await image?.toByteData(format: ui.ImageByteFormat.png);
                      setState(() {
                        _img = data!;
                      });
                      final encoded = base64.encode(data!.buffer.asUint8List());
                      String bs4str = encoded;
                      Uint8List decodedbytes = base64.decode(bs4str);
                      /// added by dipanshu
                      final path = Platform.isIOS?await getApplicationDocumentsDirectory():await getExternalStorageDirectory();
                      // final path = await getExternalStorageDirectory();
                      var filePathAndName = path!.path + '/'+'signature.png';
                      file = await File(filePathAndName).writeAsBytes(decodedbytes);
                      print('file-------- ${file}');
                    }
                    if(_img.buffer.lengthInBytes != 0){
                      files['signature_image'] = file;
                    }
                    EasyLoading.show(
                      status: null,
                      maskType: EasyLoadingMaskType.black
                    );
                    // var res = await Webservices.postData(apiUrl:
                    // widget.is_update==true?ApiUrls.edit_reffral:ApiUrls.add_reffral, body:data, context: context);
                    var res = await Webservices.postDataWithImageFunction(apiUrl:
                    widget.is_update==true?ApiUrls.edit_reffral:ApiUrls.add_reffral, body:data, context: context, files: files);
                    EasyLoading.dismiss();
                    print('add reffal note---- $res');
                    Navigator.pop(context);
                  }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => Prescriptions_Doctor_Page()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
