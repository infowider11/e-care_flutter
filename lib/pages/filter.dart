import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/doctor-details.dart';
import 'package:ecare/pages/long_felt_way.dart';
import 'package:ecare/pages/payment_done.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  TextEditingController search = TextEditingController();
  bool isChecked = false;
  double _value = 1500.0;
  String? type='Any';
  String? date;
  String? rate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(context: context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          height: MediaQuery.of(context).size.height - 90,
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainHeadingText(
                  text: 'Filter',
                  fontFamily: 'light',
                  fontSize: 32,
                ),
                vSizedBox2,
                CustomTextField(
                  controller: search,
                  hintText: 'Search...',
                  showlabel: true,
                  label: 'Search Preferred Healthcare Provider',
                ),
                vSizedBox2,
                ParagraphText(
                  text: 'Earliest Availabiliity ',
                  fontSize: 16,
                ),
                vSizedBox05,
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MyColors.lightBlue.withOpacity(0.11),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      if(type!='Date')
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            type='Any';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: type=='Any'?MyColors.primaryColor:Colors.transparent,
                              border: Border.all(
                                  color: MyColors.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            'Any',
                            style: TextStyle(fontSize: 14, color: type=='Any'?MyColors.white:MyColors.primaryColor),
                          ),
                        ),
                      ),
                      hSizedBox,
                      if(type!='Date')
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            type='Today';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: type=='Today'?MyColors.primaryColor:Colors.transparent,
                              border: Border.all(
                                  color: MyColors.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            'Today',
                            style: TextStyle(
                                fontSize: 14, color: type=='Today'?MyColors.white:MyColors.primaryColor),
                          ),
                        ),
                      ),
                      hSizedBox,
                      if(type!='Date')
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            type='Tomorrow';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: type=='Tomorrow'?MyColors.primaryColor:Colors.transparent,
                              border: Border.all(
                                  color: MyColors.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            'Tomorrow',
                            style: TextStyle(
                                fontSize: 14, color: type=='Tomorrow'?MyColors.white:MyColors.primaryColor),
                          ),
                        ),
                      ),
                      hSizedBox,
                      GestureDetector(
                        onTap: () async{
                          setState(() {
                            type='Date';
                          });
                          var m = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(DateTime.now().year+150));
                          if(m!=null){
                            DateFormat formatter = DateFormat('yyyy-MM-dd');
                            String formatted = formatter.format(m);
                            date=formatted;
                            setState(() {

                            });
                            // print('checking date------${formatted}');
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                  color: MyColors.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            'Select Date',
                            style: TextStyle(
                                fontSize: 14, color: MyColors.primaryColor),
                          ),
                        ),
                      ),
                      hSizedBox,
                      if(type=='Date')
                      Container(
                        child: Text('$date'),
                      ),
                      if(type=='Date')
                      IconButton(
                          onPressed: () {
                            setState(() {
                              type='Any';
                            });
                          },
                          icon: Icon(Icons.remove_circle,color: Colors.red,)),
                    ],
                  ),
                ),

                vSizedBox2,
                ParagraphText(
                  text: 'Maximum consultation fee (ZAR)',
                  fontSize: 16,
                ),
                SfSlider(
                  showDividers: true,
                  shouldAlwaysShowTooltip: true,
                  min: 1,
                  max: 3000,
                  value: _value,
                  interval: 200,
                  showTicks: false,
                  showLabels: false,
                  enableTooltip: true,
                  onChanged: (dynamic value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
                vSizedBox2,
                ParagraphText(
                  text: 'Ratings',
                  fontSize: 16,
                ),
                vSizedBox05,
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MyColors.lightBlue.withOpacity(0.11),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                rate='1';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: rate=='1'?MyColors.primaryColor:Colors.transparent,
                                  border: Border.all(
                                      color: MyColors.primaryColor, width: 1),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: rate=='1'?MyColors.white:MyColors.primaryColor,
                                    size: 18,
                                  ),
                                  Text(
                                    '1 star',
                                    style: TextStyle(
                                        fontSize: 14, color: rate=='1'?MyColors.white:MyColors.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          hSizedBox,
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                rate='2';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: rate=='2'?MyColors.primaryColor:Colors.transparent,
                                  border: Border.all(
                                      color: MyColors.primaryColor, width: 1),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: rate=='2'?MyColors.white:MyColors.primaryColor,
                                    size: 18,
                                  ),
                                  Text(
                                    '2 star',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: rate=='2'?MyColors.white:MyColors.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          hSizedBox,
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                rate='3';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: rate=='3'?MyColors.primaryColor:Colors.transparent,
                                  border: Border.all(
                                      color: MyColors.primaryColor, width: 1),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: rate=='3'?MyColors.white:MyColors.primaryColor,
                                    size: 18,
                                  ),
                                  Text(
                                    '3 star',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: rate=='3'?MyColors.white:MyColors.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          hSizedBox,
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                rate='4';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: rate=='4'?MyColors.primaryColor:Colors.transparent,
                                  border: Border.all(
                                      color: MyColors.primaryColor, width: 1),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: rate=='4'?MyColors.white:MyColors.primaryColor,
                                    size: 18,
                                  ),
                                  Text(
                                    '4 star',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: rate=='4'?MyColors.white:MyColors.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      vSizedBox,
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                rate='5';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: rate=='5'?MyColors.primaryColor:Colors.transparent,
                                  border: Border.all(
                                      color: MyColors.primaryColor, width: 1),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: rate=='5'?MyColors.white:MyColors.primaryColor,
                                    size: 18,
                                  ),
                                  Text(
                                    '5 star',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: rate=='5'?MyColors.white:MyColors.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                vSizedBox2,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ParagraphText(
                      text: 'Availability of practice number',
                      color: MyColors.onsurfacevarient,
                    ),
                    Checkbox(
                      checkColor: Colors.white,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RoundEdgedButton(
                    text: 'Show Result',
                    onTap: (){
                      Map<String,dynamic> filter_data = {
                        'search':search.text,
                        'date':type=='Date'?date:type,
                        'fees':_value.toInt(),
                        'rate':rate!=null?rate:'',
                        'available':isChecked?'1':'0',
                      };
                      Navigator.pop(context,filter_data);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => PaymentDone()));
                    }
                  ),
                  vSizedBox,
                  RoundEdgedButton(
                    textColor: MyColors.primaryColor,
                    color: MyColors.white,
                    bordercolor: MyColors.white,
                    text: 'Reset filter',
                    onTap: () {
                      search.text='';
                      type='Any';
                      _value=1.0;
                      rate='0';
                      isChecked=false;
                      Map<String,dynamic> filter_data = {
                        'search':'',
                        'date':'',
                        'fees':'',
                        'rate':'',
                        'available':'',
                      };
                      Navigator.pop(context,filter_data);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => PaymentDone()));
                    }
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
