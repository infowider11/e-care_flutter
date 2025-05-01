// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:ecare/constants/constans.dart';
import 'package:ecare/functions/print_function.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/doctor-details.dart';
import 'package:ecare/pages/filter.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChooseDoctor extends StatefulWidget {
  final Map? cate;
  final Map? sub_cate;
  final String? other_reason;
  final String? days;
  final List? symptoms;
  final List? head_neck;
  final String? temp;
  const ChooseDoctor({
    Key? key,
    this.cate,
    this.sub_cate,
    this.other_reason,
    this.days,
    this.symptoms,
    this.head_neck,
    this.temp,
  }) : super(key: key);

  @override
  State<ChooseDoctor> createState() => _ChooseDoctorState();
}

class _ChooseDoctorState extends State<ChooseDoctor> {
  bool load = false;
  bool is_first_time = false;
  String? fees;
  List lists = [];
  Map<String, dynamic> filter_data = {
    'search': '',
    'date': '',
    'fees': '',
    'rate': '',
    'available': '',
  };

  get_doctor() async {
    setState(() {
      load = true;
    });
    Map<String, dynamic> data = {
      'category': widget.cate!['id'],
      'subcategory': widget.sub_cate != null ? widget.sub_cate!['id'] : '',
      'oterh_subcategory_value':
          widget.other_reason != null ? widget.other_reason : '',
      'how_to_long_felt': widget.days.toString(),
      'symptoms': widget.symptoms != null ? widget.symptoms!.join(',') : '',
      'head_neck': widget.head_neck != null ? widget.head_neck!.join(',') : '',
      'temperature': widget.temp != null ? widget.temp!.toString() : '',
      'maxfees': filter_data['fees'].toString(),
      'type': filter_data['date'],
      'rate': filter_data['rate'].toString(),
      'available': filter_data['available'],
      'keyword': filter_data['search'],
      'description': widget.days,
      'timezone': currentTimezone,
      // ''
    };
    var res = await Webservices.postData(
        apiUrl: ApiUrls.search_doctor,
        body: data,
        context: context,
        showSuccessMessage: false,
        showErrorMessage: false);
    print('search data-----$res');
    if (res['status'].toString() == '1') {
      lists = res['data'];
      setState(() {});
    } else {
      lists = [];
      setState(() {});
    }
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    super.initState();
    print('cate ${widget.cate}');
    print('sub-cate ${widget.sub_cate}');
    print('other_subcate ${widget.other_reason}');
    print('days ${widget.days}');
    print('symptoms ${widget.symptoms}');
    print('head_neck ${widget.head_neck}');
    print('temp ${widget.temp}');
    if (!is_first_time) {
      get_doctor();
    }
    setState(() {
      is_first_time = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(context: context),
      body: load
          ? const CustomLoader()
          : SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: MainHeadingText(
                            text: (widget.cate!['title'] ==
                                    'General Medical Doctor')
                                ? 'Choose Doctor'
                                : 'Choose ${widget.sub_cate!['title']}',
                            fontFamily: 'light',
                            fontSize: 30,
                          ),
                        ),
                        GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FilterPage())).then((value) => {
                                    // if(value){
                                    print('fileter ---- date----${value}'),
                                    filter_data = value,
                                    setState(() {}),
                                    get_doctor(),
                                    // }
                                  });
                            },
                            child: const RoundEdgedButton(
                              text: 'Filter',
                              width: 80,
                              fontSize: 16,
                              horizontalPadding: 0,
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: lists.isEmpty
                        ? const Center(
                            child: Text('No Data Found.'),
                          )
                        : GridView.builder(
                            itemCount: lists.length,
                            padding: const EdgeInsets.all(10),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1 / 1.3,
                            ),
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () {
                                  myCustomLogStatements(
                                      "head_neck: ${widget.head_neck}, symptoms: ${widget.symptoms}, doc_id: ${lists[i]['id']}, cate: ${widget.cate}, sub_cate: ${widget.sub_cate}, other_reason: ${widget.other_reason}, days: ${widget.days},  temp: ${widget.temp},");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DoctorDetails(
                                                head_neck: widget.head_neck,
                                                symptoms: widget.symptoms,
                                                doc_id: lists[i]['id'],
                                                cate: widget.cate,
                                                sub_cate: widget.sub_cate,
                                                other_reason:
                                                    widget.other_reason,
                                                days: widget.days,
                                                temp: widget.temp,
                                              )));
                                },
                                child: Container(
                                  // height: 220,
                                  // width: 170,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: MyColors.white,
                                      border: Border.all(
                                          color: MyColors.bordercolor,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.network(
                                            lists[i]['profile_image'],
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        // Image.asset(
                                        //   'assets/images/23.png',
                                        //   width: 65,
                                        // ),
                                        vSizedBox05,
                                        MainHeadingText(
                                          text: lists[i]['specialist_cat']
                                                      .toString() ==
                                                  '1'
                                              ? 'Dr.${lists[i]['first_name']} ${lists[i]['last_name']}'
                                              : '${lists[i]['first_name']} ${lists[i]['last_name']}',
                                          fontSize: 14,
                                          fontFamily: 'semibold',
                                        ),
                                        // headingText(
                                        //   text: lists[i]['subcategory']!=false?'${lists[i]['category']['title']} (${lists[i]['subcategory']['title']})':
                                        //   '${lists[i]['category']['title']}',
                                        //   color: MyColors.primaryColor,
                                        //   fontSize: 8,
                                        // ),
                                        Text(
                                          lists[i]['subcategory'] != false
                                              ? '${lists[i]['category']['title']} (${lists[i]['subcategory']['title']})'
                                              : '${lists[i]['category']['title']}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: MyColors.primaryColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                        vSizedBox05,
                                        MainHeadingText(
                                          text:
                                              '${lists[i]['consultation_fees']} ZAR',
                                          fontSize: 20,
                                          fontFamily: 'semibold',
                                        ),
                                        // vSizedBox05,
                                        MainHeadingText(
                                          text:
                                              'Next Available:${lists[i]['slot_date']} ${DateFormat.jm().format(DateFormat("hh:mm").parse(lists[i]['slot']))}',
                                          fontSize: 12,
                                          fontFamily: 'light',
                                          color: MyColors.primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                  ),
                  // if(lists.length>0)
                  // GridView.count(
                  //   shrinkWrap: true,
                  //   crossAxisCount: 2,
                  //   padding: const EdgeInsets.all(10),
                  //   crossAxisSpacing: 10,
                  //   mainAxisSpacing: 10,
                  //   childAspectRatio: 0.95,
                  //   children: <Widget>[
                  //     for (var i = 0; i < lists.length; i++)
                  //       GestureDetector(
                  //         onTap: () => Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => DoctorDetails(
                  //                       head_neck: widget.head_neck,
                  //                       symptoms: widget.symptoms,
                  //                       doc_id: lists[i]['id'],
                  //                       cate: widget.cate,
                  //                       sub_cate: widget.sub_cate,
                  //                       other_reason: widget.other_reason,
                  //                       days: widget.days,
                  //                       temp: widget.temp,
                  //                     ))),
                  //         child: Container(
                  //           height: 220,
                  //           width: 170,
                  //           padding: EdgeInsets.all(10),
                  //           decoration: BoxDecoration(
                  //               color: MyColors.white,
                  //               border: Border.all(
                  //                   color: MyColors.bordercolor, width: 1),
                  //               borderRadius: BorderRadius.circular(12)),
                  //           child: Center(
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.center,
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 ClipRRect(
                  //                   borderRadius: BorderRadius.circular(50),
                  //                   child: Image.network(
                  //                     lists[i]['profile_image'],
                  //                     width: 60,
                  //                   ),
                  //                 ),
                  //                 // Image.asset(
                  //                 //   'assets/images/23.png',
                  //                 //   width: 65,
                  //                 // ),
                  //                 vSizedBox05,
                  //                 MainHeadingText(
                  //                   text: lists[i]['specialist_cat']
                  //                               .toString() ==
                  //                           '1'
                  //                       ? 'Dr.${lists[i]['first_name']} ${lists[i]['last_name']}'
                  //                       : '${lists[i]['first_name']} ${lists[i]['last_name']}',
                  //                   fontSize: 14,
                  //                   fontFamily: 'semibold',
                  //                 ),
                  //                 // headingText(
                  //                 //   text: lists[i]['subcategory']!=false?'${lists[i]['category']['title']} (${lists[i]['subcategory']['title']})':
                  //                 //   '${lists[i]['category']['title']}',
                  //                 //   color: MyColors.primaryColor,
                  //                 //   fontSize: 8,
                  //                 // ),
                  //                 Text(
                  //                   lists[i]['subcategory'] != false
                  //                       ? '${lists[i]['category']['title']} (${lists[i]['subcategory']['title']})'
                  //                       : '${lists[i]['category']['title']}',
                  //                   style: TextStyle(
                  //                     fontSize: 10,
                  //                     color: MyColors.primaryColor,
                  //                   ),
                  //                   overflow: TextOverflow.ellipsis,
                  //                   textAlign: TextAlign.center,
                  //                 ),
                  //                 vSizedBox05,
                  //                 MainHeadingText(
                  //                   text:
                  //                       '${lists[i]['consultation_fees']} ZAR',
                  //                   fontSize: 20,
                  //                   fontFamily: 'semibold',
                  //                 ),
                  //                 // vSizedBox05,
                  //                 Row(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.center,
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     MainHeadingText(
                  //                       text: 'Next Available:',
                  //                       fontSize: 12,
                  //                       fontFamily: 'light',
                  //                       color: MyColors.primaryColor,
                  //                     ),
                  //                     Expanded(
                  //                       child: MainHeadingText(
                  //                         text:
                  //                             '${lists[i]['slot_date']} ${DateFormat.jm().format(DateFormat("hh:mm").parse(lists[i]['slot']))}',
                  //                         fontSize: 12,
                  //                         fontFamily: 'light',
                  //                         color: MyColors.primaryColor,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //
                  //     // Wrap(
                  //     //   spacing: 20,
                  //     //   direction: Axis.horizontal,
                  //     //   alignment: WrapAlignment.center,
                  //     //   children: [
                  //     //
                  //     //     // GestureDetector(
                  //     //     //   onTap: () => Navigator.push(
                  //     //     //       context,
                  //     //     //       MaterialPageRoute(
                  //     //     //           builder: (context) => DoctorDetails())),
                  //     //     //   child: Container(
                  //     //     //     height: 220,
                  //     //     //     width: 170,
                  //     //     //     padding: EdgeInsets.all(10),
                  //     //     //     decoration: BoxDecoration(
                  //     //     //         color: MyColors.white,
                  //     //     //         border: Border.all(
                  //     //     //             color: MyColors.bordercolor, width: 1),
                  //     //     //         borderRadius: BorderRadius.circular(12)),
                  //     //     //     child: Center(
                  //     //     //       child: Column(
                  //     //     //         mainAxisAlignment: MainAxisAlignment.center,
                  //     //     //         children: [
                  //     //     //           Image.asset(
                  //     //     //             'assets/images/23.png',
                  //     //     //             width: 65,
                  //     //     //           ),
                  //     //     //           vSizedBox,
                  //     //     //           Row(
                  //     //     //             mainAxisAlignment: MainAxisAlignment.center,
                  //     //     //             children: [
                  //     //     //               Image.asset(
                  //     //     //                 'assets/images/available.png',
                  //     //     //                 width: 18,
                  //     //     //               ),
                  //     //     //               hSizedBox05,
                  //     //     //               MainHeadingText(
                  //     //     //                 color: MyColors.green,
                  //     //     //                 text: 'Available',
                  //     //     //                 fontSize: 14,
                  //     //     //                 fontFamily: 'semibold',
                  //     //     //               ),
                  //     //     //             ],
                  //     //     //           ),
                  //     //     //           vSizedBox,
                  //     //     //           MainHeadingText(
                  //     //     //             text: 'Dr. Rekha Reddy',
                  //     //     //             fontSize: 14,
                  //     //     //             fontFamily: 'semibold',
                  //     //     //           ),
                  //     //     //           vSizedBox05,
                  //     //     //           MainHeadingText(
                  //     //     //             text: '\$100',
                  //     //     //             fontSize: 20,
                  //     //     //             fontFamily: 'semibold',
                  //     //     //           ),
                  //     //     //           vSizedBox05,
                  //     //     //           Row(
                  //     //     //             mainAxisAlignment:
                  //     //     //             MainAxisAlignment.spaceBetween,
                  //     //     //             children: [
                  //     //     //               MainHeadingText(
                  //     //     //                 text: 'Next Available',
                  //     //     //                 fontSize: 12,
                  //     //     //                 fontFamily: 'light',
                  //     //     //                 color: MyColors.primaryColor,
                  //     //     //               ),
                  //     //     //               MainHeadingText(
                  //     //     //                 text: '6:30 AM',
                  //     //     //                 fontSize: 12,
                  //     //     //                 fontFamily: 'light',
                  //     //     //                 color: MyColors.primaryColor,
                  //     //     //               ),
                  //     //     //             ],
                  //     //     //           ),
                  //     //     //         ],
                  //     //     //       ),
                  //     //     //     ),
                  //     //     //   ),
                  //     //     // ),
                  //     //     vSizedBox2
                  //     //   ],
                  //     // ),
                  //
                  //   ],
                  // ),

                  vSizedBox2,
                ],
              ),
            ),
    );
  }
}
