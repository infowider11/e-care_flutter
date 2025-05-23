// ignore_for_file: avoid_print, unnecessary_string_interpolations, non_constant_identifier_names

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

import '../constants/api_variable_keys.dart';
import '../functions/get_name.dart';
import '../modals/icd_notes_container_modal.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

import '../widgets/custom_dropdown.dart';

class AddIcdNotes extends StatefulWidget {
  final bool? is_update;
  final Map? data;
  final String? booking_id;
  final String? id;
  final String? doctorName;
  const AddIcdNotes(
      {Key? key, this.is_update=false, this.data, this.booking_id,this.id, this.doctorName})
      : super(key: key);

  @override
  State<AddIcdNotes> createState() =>
      _AddIcdNotesState();
}

class _AddIcdNotesState
    extends State<AddIcdNotes> {
  TextEditingController name = TextEditingController();
  TextEditingController table_name = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController desc = TextEditingController();
  List bookings = [];

  List getBookings = [0];
  String booking_id = '';
  ByteData _img = ByteData(0);
  var color = Colors.red;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();

  // List lists = [];

  List<IcdNotesContainerModal> icdNotesContainers = [];
  List<IcdNotesContainerModal> deleteIcdCodeId = [];


  TextEditingController patientIdNumberController = TextEditingController();
  TextEditingController patientMedicalAidNameController = TextEditingController();
  TextEditingController patientMedicalAidNumberController = TextEditingController();
  TextEditingController patientMedicalAidDetailController = TextEditingController();

  @override
  void initState() {
    ///commented by manish
    widget.is_update==false?icdNotesContainers.add(IcdNotesContainerModal(descriptionController: TextEditingController(), icdCodeController: TextEditingController(),costController: TextEditingController(),procedureCode: TextEditingController(),)):[];
    get_bookings();
    if (widget.booking_id != null && widget.booking_id != 'null') {
      booking_id = widget.booking_id!;
    }

    ///commented by manish
    // if(widget.is_update==true){
    //   booking_id=widget.data!['booking_id'].toString();
    //   for(int i=0;i<widget.data!['prescription_medicine'].length;i++){
    //     // Map row = {
    //     //   'medicines':TextEditingController(),
    //     //   'dosage':TextEditingController(),
    //     //   'duration':TextEditingController(),
    //     //   'medicine_id':'',
    //     // };
    //     // row['medicines'].text = widget.data!['prescription_medicine'][i]['medicines'];
    //     // row['dosage'].text = widget.data!['prescription_medicine'][i]['dosage'];
    //     // row['duration'].text = widget.data!['prescription_medicine'][i]['duration'];
    //     // row['medicine_id'] = widget.data!['prescription_medicine'][i]['id'].toString();
    //     icdNotesContainers.add(IcdNotesContainerModal(descriptionController: TextEditingController(), icdCodeController: TextEditingController(), id: ));
    //     // lists.add(row);
    //   }
    //   // print('update list----- ${lists}');
    //   // lists = widget.data!['prescription_medicine'];
    // }
    ///
    if (widget.is_update == true)
      getIcdDetails();
    super.initState();
  }

  getIcdDetails() {
    booking_id= widget.data!['id'];
    patientIdNumberController.text = widget.data!['patient_id_number'] ?? '';
    patientMedicalAidNameController.text = widget.data!['patient_medical_aid_name'] ?? '';
    patientMedicalAidNumberController.text = widget.data!['patient_medical_aid_number'] ?? '';
    patientMedicalAidDetailController.text = widget.data!['patient_medical_aid_detail'] ?? '';
    if(widget.data!['icdCode'].isNotEmpty){
    for(int i = 0;i< widget.data!['icdCode'].length;i++){
    icdNotesContainers.add(IcdNotesContainerModal(
      id: widget.data!['icdCode'][i]['id'],
      doctor_id: widget.data!['icdCode'][i]['doctor_id'],
      descriptionController: TextEditingController(text:widget.data!['icdCode'][i]['description']??""),
      icdCodeController: TextEditingController(text:widget.data!['icdCode'][i]['icd_code']??""),
      procedureCode: TextEditingController(text:widget.data!['icdCode'][i]['procedure_code']??''),
      costController  : TextEditingController(text:widget.data!['icdCode'][i]['cost']??''),));
  }}else{
      icdNotesContainers.add(IcdNotesContainerModal(
        descriptionController: TextEditingController(),
        icdCodeController: TextEditingController(),costController: TextEditingController(),
        procedureCode: TextEditingController(),));
}}
  Map? selectedBookingData;
  get_bookings() async {
    bookings = await Webservices.getList(
        ApiUrls.bookingslist + await getCurrentUserId());
    print('bookings-------- ${bookings}');
    for(int i = 0;i<bookings.length;i++){
      bookings[i]['${ApiVariableKeys.temp_name}'] = getName(prefixText: 'Booking', doctorLastName: bookings[i][ApiVariableKeys.doctor_data][ApiVariableKeys.last_name], userLastName: '${bookings[i][ApiVariableKeys.user_data][ApiVariableKeys.last_name]}', dateTimeConsultation: '${bookings[i]['${ApiVariableKeys.slot_data}'][ApiVariableKeys.date_with_time]}');
      print('the booking data is ${bookings[i]}');
      if(widget.is_update==true){
        bookings[i]['${ApiVariableKeys.temp_name}'] = getName(prefixText: 'Booking', doctorLastName: bookings[i][ApiVariableKeys.doctor_data][ApiVariableKeys.last_name], userLastName: '${bookings[i][ApiVariableKeys.user_data][ApiVariableKeys.last_name]}', dateTimeConsultation: '${bookings[i]['${ApiVariableKeys.consult_dateTime}']}');

      }
      if(bookings[i]['id']==widget.booking_id){
        selectedBookingData = bookings[i];
        print('bookings-------- ${widget.booking_id}-----${selectedBookingData}');
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
                    ? 'Add  ICD-10 codes to Statement '
                    : 'Edit ICD-10 codes to Statement',
                fontSize: 32,
                fontFamily: 'light',
                color: Colors.black,
                // color: Colors.red,
              ),
              vSizedBox2,
              const ParagraphText(text: 'Please ensure that the total cost of services matches the consultation fee paid by the patient'),
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
                  if(widget.is_update==true)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 13),
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColors.bordercolor),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ParagraphText(
                      text:  getName(
                          prefixText: 'Booking',
                          doctorLastName:widget.data!['doctor_data']['last_name'],
                          userLastName: '${widget.data!['user_lastname']}',
                          dateTimeConsultation: '${widget.data!['consult_dateTime']}'),
                    )
                  ),
                  if(widget.is_update==false)
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
                      enable: widget.is_update==true?false:true,

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
                    // child: CustomDropdownButton(
                    //   isextra_text: true,
                    //   // extra_text: 'Booking id #',
                    //   extra_text:widget.doctorName==null? 'Booking Id #': '(${widget.doctorName}) Booking Id #',
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
                  ),
                  vSizedBox,
                  /// manish work here
                  CustomTextField(controller: patientIdNumberController, hintText: 'Patient Id Number (If Available)'),
                  vSizedBox,
                  CustomTextField(controller: patientMedicalAidNameController, hintText: 'Patient Medical Aid Name (If Available)'),
                  vSizedBox,
                  CustomTextField(controller: patientMedicalAidNumberController, hintText: 'Patient Medical Aid Number (If Available)'),
                  vSizedBox,
                  CustomTextFieldmaxlines(controller: patientMedicalAidDetailController, hintText: 'Additional Medical Aid Detail (If Available)', maxLines: 3,),
                  vSizedBox,
                  for(int i=0;i<icdNotesContainers.length;i++)
                    icdNotesContainers[i].showContainer(onRemove:  i>=1?()async{
                      deleteIcdCodeId.add(icdNotesContainers.removeAt(i));

                      setState(() {});
                      // if(widget.is_update==true){
                      //   deleteIcdCodeId.add(IcdNotesContainerModal(
                      //     id: icdNotesContainers[i].id,
                      //     doctor_id: icdNotesContainers[i].doctor_id,
                      //     descriptionController:icdNotesContainers[i].descriptionController,
                      //     icdCodeController: icdNotesContainers[i].icdCodeController,
                      //     costController: icdNotesContainers[i].costController,
                      //     procedureCode: icdNotesContainers[i].procedureCode,
                      //   ));
                      //
                      // }


                    }:null),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 5.0),
                    //   child: Stack(
                    //     children: [
                    //       Container(
                    //         padding: EdgeInsets.only(top:40.0,left:8.0,right: 8.0,bottom: 10.0),
                    //         // height: 270,
                    //         width: double.infinity,
                    //         decoration: BoxDecoration(
                    //           color: MyColors.primaryColor.withOpacity(0.2),
                    //           borderRadius: BorderRadius.circular(20.0),
                    //         ),
                    //         child: Center(
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               CustomTextField(controller: lists[i]['medicines'], hintText: 'Medicine Name'),
                    //               vSizedBox,
                    //               CustomTextField(controller: lists[i]['dosage'], hintText: 'Dosage'),
                    //               vSizedBox,
                    //               CustomTextField(controller: lists[i]['duration'], hintText: 'Duration'),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       if(i>=1)
                    //         new Positioned(
                    //             right: 0,
                    //             child: IconButton(
                    //               onPressed: () {
                    //                 lists.removeAt(i);
                    //                 setState(() {
                    //
                    //                 });
                    //               },
                    //               icon: Icon(Icons.remove_circle,color: Colors.red,),
                    //             )
                    //         )
                    //     ],
                    //   ),
                    // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(),
                      if(widget.is_update==false)
                      TextButton(
                          style: const ButtonStyle(
                          ),
                          onPressed: (){
                            icdNotesContainers.add(IcdNotesContainerModal(descriptionController: TextEditingController(), icdCodeController: TextEditingController(),costController: TextEditingController(),procedureCode: TextEditingController(),));
                            setState(() {

                            });
                          }
                          ,child: const Text('Add More'))
                    ],
                  ),
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
                  // text: widget.is_update == false
                  //     ? 'Add ICD-10 codes to Statement '
                  //     : 'Edit ICD-10 codes to Statement', // commented in jan 2024
                  // text: 'Submit', //commented in feb 28 2024
                  // text: 'Submit',
                  text: widget.is_update == false
                      ? 'Create Statement '
                      : 'Edit Statement',
                  onTap: () async {
                    File? file;
                    final sign = _sign.currentState;
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
                      /// added by dipanshu
                      final path = Platform.isIOS?await getApplicationDocumentsDirectory():await getExternalStorageDirectory();
                      // final path = await getExternalStorageDirectory();
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
                      for(int i=0;i<icdNotesContainers.length;i++){
                        if(icdNotesContainers[i].descriptionController.text ==''){
                          showSnackbar('Please enter description');
                          return;
                        }
                        // else if(icdNotesContainers[i].icdCodeController.text==''){
                        //   showSnackbar('Please enter ICD-10 code.');
                        //   return;
                        // }
                      }
                      // return;
                      Map<String, dynamic> files = {};
                      Map<String, dynamic> data = {
                        'doctor_id': await getCurrentUserId(),
                        'booking_id':booking_id.toString(),
                      };
                      /// manish work here
                      if(patientIdNumberController.text.isNotEmpty){
                        data['patient_id_number'] = patientIdNumberController.text;
                      }
                      if(patientMedicalAidNameController.text.isNotEmpty){
                        data['patient_medical_aid_name'] = patientMedicalAidNameController.text;
                      }
                      if(patientMedicalAidNumberController.text.isNotEmpty){
                        data['patient_medical_aid_number'] = patientMedicalAidNumberController.text;
                      }
                      if(patientMedicalAidDetailController.text.isNotEmpty){
                        data['patient_medical_aid_detail'] = patientMedicalAidDetailController.text;
                      }
                      for(int i=0;i<icdNotesContainers.length;i++){
                        if(widget.is_update==true){
                          data['id[${i}]'] = icdNotesContainers[i].id;

                        }

                        data['icd_code[${i}]'] = icdNotesContainers[i].icdCodeController.text;

                        data['procedure_code[${i}]'] = icdNotesContainers[i].procedureCode.text;
                        data['cost[${i}]'] = icdNotesContainers[i].costController.text;

                        data['description[${i}]'] =icdNotesContainers[i].descriptionController.text;

                      }
                      if(_img.buffer.lengthInBytes != 0){
                        files['signature_image'] = file;
                      }

                      // if(widget.is_update==true){
                      // for(int i=0; i<icdNotesContainers.length;i++){
                      //   icdNotesContainers.removeAt(i);
                      //   setState(() {});
                      // }
                      // }
                      print('passing data---- ${data}');

                      EasyLoading.show(
                          status: null, maskType: EasyLoadingMaskType.black);
                      var res = await Webservices.postDataWithImageFunction(
                          apiUrl: widget.is_update==false?ApiUrls.addIcdNotes:ApiUrls.editIcdNotes,
                          body: data,files: files,
                          context: context);
                      EasyLoading.dismiss();
                      if(widget.is_update==true){
                        for(int i=0;i<deleteIcdCodeId.length;i++){
                          Map<String, dynamic> data = {
                            'booking_id': widget.data!['id'].toString(),
                            'doctor_id': deleteIcdCodeId[i].doctor_id,
                            'id':deleteIcdCodeId[i].id,
                          };
                          await Webservices.postData(
                              apiUrl: ApiUrls.deletIcdCode,
                              body: data,
                              context: context);
                        }
                      }

                      if (res['status'].toString() == '1') {
                        Navigator.of(context).pop();
                        showSnackbar(res['message']);
                      }
                    }
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
