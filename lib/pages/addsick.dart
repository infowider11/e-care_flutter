import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/prescriptions_doctor.dart';
import 'package:ecare/pages/question_1_allergies.dart';
import 'package:ecare/pages/question_1_condition.dart';
import 'package:ecare/pages/question_1_medication.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import '../widgets/Customdropdownbutton.dart';
import '../widgets/custom_dropdown.dart';

class Add_sicknote extends StatefulWidget {
  final bool? is_update;
  final Map? data;
  final String? booking_id;
  final String? doctorName;
  const Add_sicknote({Key? key, this.is_update, this.data,this.booking_id,  this.doctorName})
      : super(key: key);

  @override
  State<Add_sicknote> createState() =>
      _Add_sicknoteState();
}

class _Add_sicknoteState extends State<Add_sicknote> {
  final _sign = GlobalKey<SignatureState>();
  var strokeWidth = 5.0;
  ByteData _img = ByteData(0);
  Map? booking_info;
  bool load = false;

  @override
  void initState() {
    // TODO: implement initState
    get_bookings();
    if (widget.booking_id != null && widget.booking_id != 'null') {
      booking_id = widget.booking_id!;
      get_booking_detail(booking_id);
    }
    if(widget.data!=null){
      assessment.text=widget.data!['assessment'];
      from_date.text=widget.data!['from_date'];
      to_date.text=widget.data!['to_date'];
      and_date.text=widget.data!['end_date'];
    }
    super.initState();
  }
  TextEditingController desc = TextEditingController();
  TextEditingController assessment = TextEditingController();
  TextEditingController from_date = TextEditingController();
  TextEditingController to_date = TextEditingController();
  TextEditingController and_date = TextEditingController();
  List bookings = [];
  String booking_id = '';


  get_bookings() async {
    bookings = await Webservices.getList(
        ApiUrls.bookingslist + await getCurrentUserId());
    print('-------- ${bookings}');
    if(bookings.length>0){
      // booking_id = bookings[0]['id'].toString();
      // setState((){});
      // get_booking_detail(bookings[0]['id'].toString());
    }
    setState(() {});
  }

  get_booking_detail(String booking_id) async{
    setState(() {
      load = true;
    });
    var res = await Webservices.get(ApiUrls.singleBookingData +
        booking_id.toString() +
        '&user_type=1');
    booking_info=res['data'];
    print('res-----$booking_info');

    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: load?CustomLoader():SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainHeadingText(
                text: widget.is_update == null
                    ? 'Add Sick Note'
                    : 'Edit Sick Note',
                fontSize: 32,
                fontFamily: 'light',
              ),
              vSizedBox4,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ParagraphText(
                    text: 'Booking Id',
                    fontSize: 14.0,
                    color: Colors.black,
                    fontFamily: 'regular',
                  ),
                  Container(
                    padding: EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColors.bordercolor),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomDropdownButton(
                      extra_text:widget.doctorName==null? 'Booking Id #': '(${widget.doctorName}) Booking Id #',
                      // extra_text: 'Booking Id #',
                      isextra_text: true,
                      margin: 0.0,
                      isLabel: false,
                      onChanged: ((dynamic value) {
                        print('select bank ---- ${value}');
                        booking_id = value['id'].toString();
                        get_booking_detail(booking_id);
                        setState(() {});
                      }),
                      selectedItem: booking_id != null ? booking_id : '',
                      items: bookings,
                      hint: 'Select Booking',
                      itemMapKey: 'id',
                      // text: '',
                    ),
                  ),
                  vSizedBox,
                  // CustomTextFieldmaxlines(
                  //   controller: desc,
                  //   label: 'Decription',
                  //   showlabel: true,
                  //   labelcolor: MyColors.onsurfacevarient,
                  //   hintText: 'Description',
                  //   maxLines: 5,
                  // ),
                  headingText(text: 'To Whom it may concern'),
                  vSizedBox,
                if(booking_info!=null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ParagraphText(text: 'I hereby certify that  ${booking_info!['user_data']['first_name']}'
                          ' ${booking_info!['user_data']['last_name']??''} was seen today  ${DateFormat.yMMMEd().format(DateTime.parse(booking_info!['slot_data']['date_with_time']))} '
                          'for a medical consultation.',color: MyColors.black,),

                      headingText(text: 'Diagnosis/Assessment: '),
                      CustomTextFieldmaxlines(
                        controller: assessment,
                        label: '',
                        showlabel: false,
                        labelcolor: MyColors.onsurfacevarient,
                        hintText: 'Diagnosis/Assessment',
                        // maxLines: 5,
                      ),
                      ParagraphText(text: 'Based on the assessment conducted, it is deemed necessary for the patient\'s full recovery that he/she be granted leave from work starting from',color: MyColors.black,),
                      GestureDetector(
                        onTap: () async{
                          var m = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 105),
                            lastDate: DateTime(DateTime.now().year + 105),
                          );
                          if (m != null) {
                            DateFormat formatter = DateFormat('yyyy-MM-dd');
                            String formatted = formatter.format(m);
                            from_date.text = formatted;
                            // print('checking date------${formatted}');
                          }
                        },
                        child: CustomTextField(
                          controller: from_date,
                          label: '',
                          enabled: false,
                          showlabel: false,
                          labelcolor: MyColors.onsurfacevarient,
                          hintText: 'From',
                          // maxLines: 5,
                        ),
                      ),
                      ParagraphText(text: 'to',color: MyColors.black,),
                      GestureDetector(
                        onTap: () async{
                          var m = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 105),
                            lastDate: DateTime(DateTime.now().year + 105),
                          );
                          if (m != null) {
                            DateFormat formatter = DateFormat('yyyy-MM-dd');
                            String formatted = formatter.format(m);
                            to_date.text = formatted;
                            // print('checking date------${formatted}');
                          }
                        },
                        child: CustomTextField(
                          controller: to_date,
                          enabled: false,
                          label: '',
                          showlabel: false,
                          labelcolor: MyColors.onsurfacevarient,
                          hintText: 'To',
                          // maxLines: 5,
                        ),
                      ),
                      ParagraphText(text: ', and will return to work on'
                          '',color: MyColors.black,),
                      GestureDetector(
                        onTap: () async{
                          var m = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 105),
                            lastDate: DateTime(DateTime.now().year + 105),
                          );
                          if (m != null) {
                            DateFormat formatter = DateFormat('yyyy-MM-dd');
                            String formatted = formatter.format(m);
                            and_date.text = formatted;
                            // print('checking date------${formatted}');
                          }
                        },
                        child: CustomTextField(
                          controller: and_date,
                          enabled: false,
                          label: '',
                          showlabel: false,
                          labelcolor: MyColors.onsurfacevarient,
                          hintText: 'And',
                          // maxLines: 5,
                        ),
                      ),
                      ParagraphText(text: 'Your understanding and support in this matter are greatly appreciated.Should you require any further information or clarification, please do not hesitate to contact me.Thank you for your attention to this matter.',color: MyColors.black,),
                      vSizedBox,
                      ParagraphText(text: 'Kind regards',color: MyColors.black,),
                      ParagraphText(text: '${user_Data!['first_name']} ${user_Data!['last_name']??''}',color: MyColors.black,fontWeight: FontWeight.w600,),
                    ],
                  ),


                  vSizedBox,
                  if(widget.is_update==null)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ParagraphText(
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
                                child: Text('Clear',style: TextStyle(color: Colors.red),)),
                          ],
                        ),
                        Container(
                          // color: Colors.white,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                widget.is_update == null ? 'Add Sick Note' : 'Edit Sick Note',
                onTap:() async{
                  if(booking_id==''){
                    showSnackbar('Please select booking.');
                  } else
                  if(assessment.text==''){
                    showSnackbar('Please enter diagnosis/assessment.');
                  } else if(from_date.text==''){
                    showSnackbar('Please enter from date.');
                  } else if(to_date.text==''){
                    showSnackbar('Please enter to date.');
                  } else if(and_date.text==''){
                    showSnackbar('Please enter and date.');
                  }
                  else if(_sign.currentState?.points.length==0){
                    showSnackbar('Please add signature.');
                  }
                  else {
                    Map<String,dynamic> files = {};
                    Map<String,dynamic> data = {
                      'doctor_id':await getCurrentUserId(),
                      'assessment':assessment.text,
                      'booking_id':booking_id.toString(),
                      'from_date':from_date.text,
                      'to_date':to_date.text,
                      'end_date':and_date.text,
                    };
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
                      final path = await getExternalStorageDirectory();
                      var filePathAndName = path!.path + '/'+'signature.png';
                      file = await File(filePathAndName).writeAsBytes(decodedbytes);
                      print('file-------- ${file}');
                    }
                    if(_img.buffer.lengthInBytes != 0){
                      files['signature_image'] = file;
                    }
                    if(widget.is_update==true){
                      data['id'] = widget.data!['id'].toString();
                    }
                    EasyLoading.show(
                        status: null,
                        maskType: EasyLoadingMaskType.black
                    );
                    // var res = await Webservices.postData(apiUrl: ApiUrls.add_sicknotes, body:data, context: context);
                    var res = await Webservices.postDataWithImageFunction(body: data, files: files,
                        context: context, apiUrl: widget.is_update == null?ApiUrls.add_sicknotes:ApiUrls.edit_sicknotes);
                    EasyLoading.dismiss();
                    print('add reffal note---- $res');
                    Navigator.of(context).pop();
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
