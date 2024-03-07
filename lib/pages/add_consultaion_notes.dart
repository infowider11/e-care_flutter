import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../constants/api_variable_keys.dart';
import '../functions/get_name.dart';
import '../services/api_urls.dart';
import '../services/auth.dart';
import '../services/webservices.dart';
import '../widgets/Customdropdownbutton.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/showSnackbar.dart';

class Add_Consultation_Notes_Page extends StatefulWidget {
  final bool? is_update;
  final Map? data;
  final String? booking_id;
  const Add_Consultation_Notes_Page(
      {Key? key, this.is_update, this.data, this.booking_id})
      : super(key: key);

  @override
  State<Add_Consultation_Notes_Page> createState() =>
      _Add_Consultation_Notes_PageState();
}

class _Add_Consultation_Notes_PageState
    extends State<Add_Consultation_Notes_Page> {
  TextEditingController desc = TextEditingController();
  TextEditingController history = TextEditingController();
  TextEditingController assessment = TextEditingController();
  TextEditingController management = TextEditingController();
  List bookings = [];
  String booking_id = '';

  @override
  void initState() {
    // TODO: implement initState
    get_bookings();
    if (widget.booking_id != null && widget.booking_id != 'null') {
      booking_id = widget.booking_id!;
    }
    if(widget.data!=null){
      booking_id = widget.data!['booking_id'].toString();
      history.text = widget.data!['exam_history'];
      assessment.text = widget.data!['assessment'];
      management.text = widget.data!['management'];
    }
    super.initState();
  }
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainHeadingText(
                text: widget.is_update == null
                    ? 'Add Consultation Note'
                    : 'Edit Consultation Note',
                fontSize: 32,
                fontFamily: 'light',
              ),
              vSizedBox4,
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
                // child: CustomDropdownButton(
                //   extra_text: 'Booking Id #',
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
              vSizedBox,
              Column(
                children: [
                  CustomTextFieldmaxlines(
                    controller: history,
                    height: 60.0,
                    label: 'History/exam',
                    showlabel: true,
                    labelcolor: MyColors.onsurfacevarient,
                    hintText: 'History/exam',
                  ),
                  vSizedBox,
                  CustomTextFieldmaxlines(
                    controller: assessment,
                    height: 60.0,
                    label: 'Assessment',
                    showlabel: true,
                    labelcolor: MyColors.onsurfacevarient,
                    hintText: 'Assessment',
                  ),
                  vSizedBox,
                  CustomTextFieldmaxlines(
                    controller: management,
                    height: 60.0,
                    label: 'Management',
                    showlabel: true,
                    labelcolor: MyColors.onsurfacevarient,
                    hintText: 'Management',
                  ),
                ],
              ),
              vSizedBox2,
              RoundEdgedButton(
                  text: widget.is_update == null ? 'Add Note' : 'Edit Note',
                  onTap: () async {
                    if(booking_id==''){
                      showSnackbar('Please select booking.');
                    } else
                    if (history.text == '') {
                      showSnackbar('Please enter history/exam.');
                    } else if(assessment.text=='') {
                      showSnackbar('Please enter assessment.');
                    } else if(management.text==''){
                      showSnackbar('Please enter management.');
                    }
                    else {
                      Map<String, dynamic> data = {
                        'doctor_id': await getCurrentUserId(),
                        'booking_id': booking_id.toString(),
                        'exam_history': history.text,
                        'assessment': assessment.text,
                        'management': management.text,
                      };
                      if(widget.is_update==true){
                        data['note_id']= widget.data!['id'].toString();
                      }
                      EasyLoading.show(
                          status: null, maskType: EasyLoadingMaskType.black);
                      var res = await Webservices.postData(
                          apiUrl: widget.is_update == null?ApiUrls.add_consulatant_note:ApiUrls.edit_consulatant_note,
                          body: data,
                          context: context,showSuccessMessage: true);
                      EasyLoading.dismiss();
                      print('add note---- $res');
                      Navigator.pop(context);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
