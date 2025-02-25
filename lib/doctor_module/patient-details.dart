// ignore_for_file: deprecated_member_use, avoid_print

import 'package:ecare/constants/colors.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/custom_circular_image.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Services/api_urls.dart';
import '../constants/sized_box.dart';
import '../services/webservices.dart';

class PatientDetails extends StatefulWidget {
  final String user_id;
  const PatientDetails({Key? key,required this.user_id}) : super(key: key);

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  Map userData = {};
  bool load = false;
  bool load2 = false;
  List lists = [];

  @override
  void initState() {
    
    super.initState();
    get_user_info();
    get_health_detail();
  }

  get_user_info() async{
    setState(() {
      load=true;
    });
    var res = await Webservices.get('${ApiUrls.get_user_by_id}?user_id=${widget.user_id.toString()}');
    print('prasoon $res');
    if (res['status'].toString() == '1') {
      userData = res['data'];
      setState(() {});
    }
    setState(() {
      load=false;
    });
  }

  get_health_detail() async{
    setState(() {
      load2=true;
    });
    var res = await Webservices.get(ApiUrls.healthdetail+'?user_id=${widget.user_id.toString()}'+'m==1');
    print('info-----$res');
    if(res['status'].toString()=='1'){
    lists=res['data'];
    setState(() {

    });
    }
    setState(() {
      load2=false;
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
      body: load?const CustomLoader():SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/patter.png', ),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Image.asset('assets/images/23.png', width: 85,),
                    CustomCircularImage(imageUrl: userData['profile_image'],width: 85,height: 85,),
                    hSizedBox2,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        vSizedBox,
                        MainHeadingText(text: '${userData['first_name']} ${userData['last_name']}', fontSize: 22, fontFamily: 'light',),
                        vSizedBox05,
                        MainHeadingText(text: 'Age: (${userData['age']})', fontSize: 14, color: MyColors.onsurfacevarient, fontFamily: 'light',),
                        MainHeadingText(text: '${DateFormat('dd MMM, yyyy').format(DateTime.parse(userData['dob']))}', fontSize: 14, color: MyColors.onsurfacevarient,),
                        MainHeadingText(text: 'Gender: ${userData['gender']}', fontSize: 14, fontFamily: 'light', color: MyColors.onsurfacevarient,),
                      ],
                    )
                  ],
                ),
              ),
              vSizedBox4,
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
                    const MainHeadingText(text: 'About Patient', fontFamily: 'light', fontSize: 24,),
                    vSizedBox,
                    const ParagraphText(text: '-', fontSize: 14, height: 1.3,),
                    // MainHeadingText(text: 'Read More', color: MyColors.primaryColor, fontSize: 14, fontFamily: 'semibold',),
                    // vSizedBox2,
                    // MainHeadingText(text: 'Reason for visit', fontFamily: 'light', fontSize: 16,),
                    // ParagraphText(text: 'symptoms: Cold cough', fontSize: 14, fontFamily: 'light', color: MyColors.headingcolor,),
                    // vSizedBox2,
                    // MainHeadingText(text: 'Health profile', fontFamily: 'light', fontSize: 16,),
                    vSizedBox05,

                    if(!load2)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for(int i=0;i<lists.length;i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                MainHeadingText(text: lists[i]['step'].toString()=='2'?'Allergies':
                                lists[i]['step'].toString()=='4'?'Surgeries':lists[i]['step'].toString()=='1'?'Medication'
                                    :lists[i]['step'].toString()=='3'?'Medical Conditions':'Family Conditions'
                                  , color: MyColors.primaryColor, fontFamily: 'light', fontSize: 14,),
                                ParagraphText(text: '${lists[i]['name']}', fontSize: 14, fontFamily: 'light', color: MyColors.headingcolor,),
                              ],
                            ),
                          )
                      ],
                    ),
                    if(load2)
                      const CustomLoader(),
                    // vSizedBox,
                    // MainHeadingText(text: 'Surgeries', color: MyColors.primaryColor, fontFamily: 'light', fontSize: 14,),
                    // ParagraphText(text: 'Lorem Ipsum, Lorem Ipsum, Ipsum', fontSize: 14, fontFamily: 'light', color: MyColors.headingcolor,),
                    //
                    // vSizedBox,
                    // MainHeadingText(text: 'Medication', color: MyColors.primaryColor, fontFamily: 'light', fontSize: 14,),
                    // ParagraphText(text: 'Lorem Ipsum, Lorem Ipsum, Ipsum', fontSize: 14, fontFamily: 'light', color: MyColors.headingcolor,),
                  ],
                ),
              ),
              // vSizedBox,
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   padding: EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(16),
              //     color: Color(0xFE00A2EA).withOpacity(0.1),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       MainHeadingText(text: 'serious medical conditions in the family', fontFamily: 'light', fontSize: 16,),
              //       ParagraphText(text: 'No', fontSize: 14, fontFamily: 'light', color: MyColors.headingcolor,),
              //     ],
              //   ),
              // ),
              // vSizedBox2,
              // RoundEdgedButton(text: 'Start', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorVideoCall())),)
            ],
          ),
        ),
      ),
    );
  }
}