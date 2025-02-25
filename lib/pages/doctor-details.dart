// ignore_for_file: deprecated_member_use, avoid_print, non_constant_identifier_names

import 'dart:developer';

import 'package:ecare/constants/colors.dart';
import 'package:ecare/pages/choose_schedule.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import '../constants/sized_box.dart';
import '../services/api_urls.dart';
import '../services/webservices.dart';
import '../widgets/custom_circular_image.dart';

class DoctorDetails extends StatefulWidget {
  final String? doc_id;
  final List? symptoms;
  final List? head_neck;
  final Map? cate;
  final Map? sub_cate;
  final String? other_reason;
  final String? days;
  final String? temp;
  const DoctorDetails(
      {Key? key,
      this.temp,
      this.days,
      this.doc_id,
      this.symptoms,
      this.head_neck,
      this.cate,
      this.sub_cate,
      this.other_reason})
      : super(key: key);

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  bool load = false;
  Map? info;
  List book_schedule = [];
  List available_schedule = [];

  @override
  void initState() {
    
    super.initState();
    print('doctor----data----${widget.doc_id}');
    get_doc_info();
  }

  get_doc_info() async {
    setState(() {
      load = true;
    });
    var res = await Webservices.get(
        ApiUrls.get_user_by_id + '?user_id=' + widget.doc_id.toString());
    print('info-----$res');
    log('info-----$res');
    if (res['status'].toString() == '1') {
      info = res['data'];
      book_schedule = info!['schedule_appointment']
          .where((item) => item['is_booked'].toString() == '1')
          .toList();
      available_schedule = info!['schedule_appointment']
          .where((item) => item['is_booked'].toString() == '0')
          .toList();
      setState(() {});
      print('available -------$available_schedule');
      print('book--------$book_schedule');
    }
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(
        context: context,
        appBarColor: const Color(0xFE00A2EA).withOpacity(0.1),
      ),
      body: load
          ? const CustomLoader()
          : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/patter.png',
                      ),
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fitWidth),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image.asset('assets/images/23.png', width: 85,),
                          CustomCircularImage(
                            imageUrl: info!['profile_image'],
                            width: 100,
                            height: 100,
                          ),
                          vSizedBox,
                          MainHeadingText(
                            text: (info!['specialist_cat'].toString() == '1' ||
                                    info!['specialist_cat'].toString() == '2')
                                ? 'Dr. ${info!['first_name']} ${info!['last_name']}'
                                : '${info!['first_name']} ${info!['last_name']}',
                            fontSize: 22,
                            fontFamily: 'light',
                          ),
                          vSizedBox05,

                          MainHeadingText(
                            text:
                                '${info!['category']}, (${info!['subcategory'] ?? '-'})',
                            fontSize: 16,
                            fontFamily: 'light',
                            color: MyColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                    vSizedBox4,
                    if (book_schedule.length > 0)
                      const MainHeadingText(
                        text: 'Schedule Appointment',
                        fontFamily: 'semibold',
                        fontSize: 16,
                      ),
                    vSizedBox,
                    if (book_schedule.length > 0)
                      Container(
                        height: 45,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (var i = 0; i < book_schedule.length; i++)
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: MyColors.bordercolor, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFE006493).withOpacity(0.12)),
                                child: Column(
                                  children: [
                                    MainHeadingText(
                                      text:
                                          '${info!['schedule_appointment'][i]['date']}',
                                      fontSize: 11,
                                      fontFamily: 'semibold',
                                    ),
                                    MainHeadingText(
                                      text:
                                          '${DateFormat.jm().format(DateFormat('hh:mm').parse(info!['schedule_appointment'][i]['start_time']))}',
                                      fontSize: 11,
                                      fontFamily: 'light',
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    vSizedBox2,
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFE00A2EA).withOpacity(0.1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MainHeadingText(
                            text: (info!['specialist_cat'].toString() == '1' ||
                                    info!['specialist_cat'].toString() == '2')
                                ? 'About Doctor'
                                : 'About Healthcare Practitioner',
                            fontFamily: 'light',
                            fontSize: 18,
                          ),
                          vSizedBox,
                          ReadMoreText(
                            '${info!['biography'] ?? '-'}',
                            trimLines: 2,
                            colorClickableText: MyColors.secondarycolor,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less',
                            lessStyle: const TextStyle(
                                color: MyColors.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            moreStyle: const TextStyle(
                                color: MyColors.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          // ParagraphText(
                          //   text: '${info!['biography'] ?? '-'}',
                          //   fontSize: 14,
                          //   height: 1.3,
                          // ),
                          // MainHeadingText(text: 'Read More', color: MyColors.primaryColor, fontSize: 14, fontFamily: 'semibold',),
                          vSizedBox2,
                          const MainHeadingText(
                            text: 'Qualifications',
                            fontFamily: 'light',
                            fontSize: 16,
                          ),
                          ParagraphText(
                            text: '${info!['education']}',
                            fontSize: 14,
                            fontFamily: 'light',
                            color: MyColors.headingcolor,
                          ),
                          vSizedBox2,
                          const MainHeadingText(
                            text: 'Special Interest',
                            fontFamily: 'light',
                            fontSize: 16,
                          ),
                          ParagraphText(
                            text: '${info!['special_intrest']}',
                            fontSize: 14,
                            fontFamily: 'light',
                            color: MyColors.headingcolor,
                          ),
                        ],
                      ),
                    ),
                    vSizedBox,
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFE00A2EA).withOpacity(0.1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MainHeadingText(
                            text: 'Languages',
                            fontFamily: 'light',
                            fontSize: 16,
                          ),
                          ParagraphText(
                            text: '${info!['language']}',
                            fontSize: 14,
                            fontFamily: 'light',
                            color: MyColors.headingcolor,
                          ),
                        ],
                      ),
                    ),
                    vSizedBox2,
                    RoundEdgedButton(
                      text: 'Availability',
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseSchedule(
                                    available_schedule: available_schedule,
                                    doc_id: widget.doc_id,
                                    head_neck: widget.head_neck,
                                    symptoms: widget.symptoms,
                                    cate: widget.cate,
                                    sub_cate: widget.sub_cate,
                                    other_reason: widget.other_reason,
                                    days: widget.days,
                                    temp: widget.temp,
                                  ))),
                    )
                  ],
                ),
              ),
            ),
    );
  }

}
