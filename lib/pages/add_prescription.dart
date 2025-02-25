// ignore_for_file: prefer_final_fields, unused_field, deprecated_member_use, avoid_print, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ecare/constants/api_variable_keys.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/get_name.dart';
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

import '../functions/get_folder_directory.dart';
import 'dart:ui' as ui;

import '../widgets/custom_dropdown.dart';

class Add_Prescriptions_Doctor_Page extends StatefulWidget {
  final bool? is_update;
  final Map? data;
  final String? booking_id;
  final String? id;
  const Add_Prescriptions_Doctor_Page(
      {Key? key, this.is_update=false, this.data, this.booking_id,this.id})
      : super(key: key);

  @override
  State<Add_Prescriptions_Doctor_Page> createState() =>
      _Add_Prescriptions_Doctor_PageState();
}

class _Add_Prescriptions_Doctor_PageState
    extends State<Add_Prescriptions_Doctor_Page> {
  TextEditingController name = TextEditingController();
  TextEditingController table_name = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController desc = TextEditingController();
  List bookings = [];
  String booking_id = '';
  Map? selectedBookingData;
  ByteData _img = ByteData(0);
  var color = Colors.red;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();
  List<TextEditingController> _controller = List.generate(1, (i) => TextEditingController());
  List lists = [];



  @override
  void initState() {
    
    widget.is_update==false?lists.add(
        {
          'medicines':TextEditingController(),
          'dosage':TextEditingController(),
          'duration':TextEditingController(),
          'medicine_id':''
        }
    ):[];
    get_bookings();
    if (widget.booking_id != null && widget.booking_id != 'null') {
      booking_id = widget.booking_id!;

    }
    if(widget.data!=null){
      // name.text=widget.data!['prescription_name'];
      // table_name.text = widget.data!['tablet_name'];
      // quantity.text=widget.data!['quantity'].toString();
      // desc.text=widget.data!['description'];
      booking_id=widget.data!['booking_id'].toString();
      // Map
      for(int i=0;i<widget.data!['prescription_medicine'].length;i++){
        Map row = {
          'medicines':TextEditingController(),
          'dosage':TextEditingController(),
          'duration':TextEditingController(),
          'medicine_id':'',
        };
        row['medicines'].text = widget.data!['prescription_medicine'][i]['medicines'];
        row['dosage'].text = widget.data!['prescription_medicine'][i]['dosage'];
        row['duration'].text = widget.data!['prescription_medicine'][i]['duration'];
        row['medicine_id'] = widget.data!['prescription_medicine'][i]['id'].toString();
        lists.add(row);
      }
      print('update list----- ${lists}');
      // lists = widget.data!['prescription_medicine'];
    }
    super.initState();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: SingleChildScrollView(
        reverse: true,
        primary: true,
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainHeadingText(
                text: widget.is_update == false
                    ? 'Add Prescriptions '
                    : 'Edit Prescriptions',
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
                  vSizedBox,
                  for(int i=0;i<lists.length;i++)

                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top:40.0,left:8.0,right: 8.0,bottom: 10.0),
                          // height: 270,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: MyColors.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomTextField(controller: lists[i]['medicines'], hintText: 'Medicine Name'),
                                vSizedBox,
                                CustomTextField(controller: lists[i]['dosage'], hintText: 'Dosage, route and frequency'),
                                vSizedBox,
                                CustomTextField(controller: lists[i]['duration'], hintText: 'Duration'),
                              ],
                            ),
                          ),
                        ),
                        if(i>=1)
                        new Positioned(
                          right: 0,
                            child: IconButton(
                              onPressed: () {
                                lists.removeAt(i);
                                setState(() {

                                });
                              },
                              icon: const Icon(Icons.remove_circle,color: Colors.red,),
                            )
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(),
                      TextButton(
                        style: const ButtonStyle(
                        ),
                          onPressed: (){
                            Map row = {
                              'medicines':TextEditingController(),
                              'dosage':TextEditingController(),
                              'duration':TextEditingController(),
                              'medicine_id':'',
                            };
                            lists.add(row);
                            setState(() {

                            });
                          }
                          ,child: const Text('Add More'))
                    ],
                  ),

                  // CustomTextField(
                  //     controller: name,
                  //     label: 'Prescriptions Name',
                  //     showlabel: true,
                  //     labelcolor: MyColors.onsurfacevarient,
                  //     hintText: ''),
                  // vSizedBox,
                  // CustomTextField(
                  //     controller: table_name,
                  //     label: 'Tablet Name',
                  //     showlabel: true,
                  //     labelcolor: MyColors.onsurfacevarient,
                  //     hintText: ''),
                  // vSizedBox,
                  // CustomTextField(
                  //     controller: quantity,
                  //     label: 'Quantity',
                  //     keyboardType: TextInputType.number,
                  //     showlabel: true,
                  //     labelcolor: MyColors.onsurfacevarient,
                  //     hintText: ''),
                  // vSizedBox,
                  // CustomTextField(
                  //   controller: desc,
                  //   label: 'Decription',
                  //   showlabel: true,
                  //   labelcolor: MyColors.onsurfacevarient,
                  //   hintText: '',
                  // ),
                  vSizedBox,
                ],
              ),
              if(widget.is_update==false)
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
                          child: const Text('Clear',style: TextStyle(color: Colors.red),)),
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
              // _img.buffer.lengthInBytes == 0 ? Container() : LimitedBox(maxHeight: 200.0, child: Image.memory(_img.buffer.asUint8List())),
              vSizedBox2,
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: RoundEdgedButton(
                  text: widget.is_update == false
                      ? 'Add Prescriptions '
                      : 'Edit Prescriptions',
                  onTap: () async {
                    print('i am here');
                    File? file;
                    final sign = _sign.currentState;
                    print('i am here2');
                    // return;
                      final image = await sign?.getData();

                    print('sign----- ${image}');
                      // return;
                    if(widget.is_update==false){
                      var data = await image?.toByteData(format: ui.ImageByteFormat.png);
                      setState(() {
                        _img = data!;
                      });
                      final encoded = base64.encode(data!.buffer.asUint8List());
                      String bs4str = encoded;
                      Uint8List decodedbytes = base64.decode(bs4str);
                      // late Directory path;
                      var path = await getFolderDirectory();

                      // if(Platform.isMacOS ||Platform.isIOS){
                      //   path = await getTemporaryDirectory();
                      // }else{
                      //   path = await getExternalStorageDirectory();
                      // }
                      var filePathAndName = path!.path + '/'+'signature.png';
                      file = await File(filePathAndName).writeAsBytes(decodedbytes);
                      print('-------- ${file}');
                    }


                    if (booking_id == '') {
                      showSnackbar('Please select booking.');
                    // }
                    // else if (name.text == '') {
                    //   showSnackbar('Please enter prescription name.');
                    // } else if (table_name.text == '') {
                    //   showSnackbar('Please enter tablet name.');
                    // } else if (quantity.text == '') {
                    //   showSnackbar('Please enter quantity.');
                    } else {
                      for(int i=0;i<lists.length;i++){
                        if(lists[i]['medicines'].text ==''){
                          showSnackbar('Please enter medicine name.');
                          return;
                        } else if(lists[i]['dosage'].text==''){
                          showSnackbar('Please enter dosage.');
                          return;
                        } else if(lists[i]['duration'].text==''){
                          showSnackbar('Please enter duration.');
                          return;
                        }
                      }
                      // return;
                      Map<String, dynamic> files = {};
                      Map<String, dynamic> data = {
                        'user_id': await getCurrentUserId(),
                        'booking_id': booking_id.toString(),
                        // 'prescription_name': name.text,
                        // 'tablet_name': table_name.text,
                        // 'quantity': quantity.text,
                        // 'description': desc.text,
                      };
                      for(int i=0;i<lists.length;i++){
                        data['medicines[${i}]'] = lists[i]['medicines'].text;
                        data['dosage[${i}]'] = lists[i]['dosage'].text;
                        data['duration[${i}]'] = lists[i]['duration'].text;
                        if(widget.is_update==true)
                        data['medicine_id[${i}]'] = lists[i]['medicine_id'].toString();
                      }
                      if(_img.buffer.lengthInBytes != 0){
                        files['signature_image'] = file;
                      }

                      if(widget.is_update==true){
                        data['id'] = widget.data!['id'].toString();
                      }
                      print('passing data---- ${data}');

                      EasyLoading.show(
                          status: null, maskType: EasyLoadingMaskType.black);
                      var res = await Webservices.postDataWithImageFunction(
                          apiUrl: widget.is_update==false?ApiUrls.add_precriptions:ApiUrls.edit_prescription,
                          body: data,files: files,
                          context: context);
                      print('add-----${res}');
                      EasyLoading.dismiss();
                      if (res['status'].toString() == '1') {
                        Navigator.of(context).pop();
                        showSnackbar(res['message']);
                      }
                    }
                    // Navigator.push(
                    // context,
                    // MaterialPageRoute(
                    //     builder: (context) => Prescriptions_Doctor_Page()))
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
