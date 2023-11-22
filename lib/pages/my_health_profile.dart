import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/habit.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/medical_records.dart';
import 'package:ecare/pages/question_1_medication.dart';
import 'package:ecare/pages/question_2_medication.dart';
import 'package:ecare/pages/relatives.dart';
import 'package:ecare/pages/uploaded_document.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/selected_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Services/api_urls.dart';
import '../functions/global_Var.dart';
import '../services/auth.dart';
import '../services/webservices.dart';
import 'edit-drugPage.dart';
import 'edit-family-condition.dart';
import 'edit-medical-conditions.dart';
import 'edit-medications.dart';
import 'edit-surgeris-page.dart';

class MyHealthProfile extends StatefulWidget {
  const MyHealthProfile({Key? key}) : super(key: key);

  @override
  State<MyHealthProfile> createState() => _MyHealthProfileState();
}

class _MyHealthProfileState extends State<MyHealthProfile> {
  TextEditingController email = TextEditingController();

  bool load=false;
  Map? info;
  List lists=[];

  get_info() async{
    setState(() {
      load=true;
    });
    var res = await Webservices.get(ApiUrls.healthdetail+'?user_id='+await getCurrentUserId()+'m==1');
    print('info-----$res');
    if(res['status'].toString()=='1'){
      lists=res['data'];
      setState(() {

      });
    }
    setState(() {
      load=false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_info();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: load?CustomLoader():SingleChildScrollView(





        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeadingText(text: 'My Health Profile ', fontSize: 32, fontFamily: 'light',),
            vSizedBox2,
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UploadedDocument())),
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: MyColors.white,
                  border: Border.all(
                    color: MyColors.bordercolor,
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainHeadingText(text: 'Uploaded medical documents', fontSize: 16, fontFamily: 'light', color: MyColors.onsurfacevarient,),
                    Icon(Icons.chevron_right_rounded, color: MyColors.onsurfacevarient,)
                  ],
                ),
              ),
            ),
            vSizedBox,
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalRecords())),
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: MyColors.white,
                  border: Border.all(
                    color: MyColors.bordercolor,
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainHeadingText(text: 'Uploaded medical Records', fontSize: 16, fontFamily: 'light', color: MyColors.onsurfacevarient,),
                    Icon(Icons.chevron_right_rounded, color: MyColors.onsurfacevarient,)
                  ],
                ),
              ),
            ),
            vSizedBox2,

            MainHeadingText(text: 'Age', fontSize: 16, fontFamily: 'regular'),
            vSizedBox,
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: MyColors.bordercolor,
                      width: 1
                  ),
                  color: Colors.white
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ParagraphText(text: '${user_Data!['age']??0} Year Old', color: MyColors.onsurfacevarient,),
                ],
              ),
            ),
            vSizedBox2,
            for(int i=0;i<lists.length;i++)
              SelectedBox(
                heading:
                (lists[i]['step'].toString()=='1')? 'Medications':
                lists[i]['step'].toString()=='2'?'Drug Allergies':
                lists[i]['step'].toString()=='3'?'Medical Conditions':
                lists[i]['step'].toString()=='4'?'Surgeries':
                lists[i]['step'].toString()=='5'?'Family Conditions':'Relative',
                text: '${lists[i]['name']??''}',
                icon: IconButton(
                  icon: Icon(Icons.edit,color: Colors.green,),
                  onPressed: () async {
                    print('press----${lists[i]['step']}');
                    if(lists[i]['step'].toString()=='1'){
                     await push(context: context, screen: editmedications(
                        pre_data: lists[i],
                      ));
                     get_info();
                    } else if(lists[i]['step'].toString()=='2') {
                     await push(context: context, screen: editDrugpage(
                        pre_data: lists[i],
                      ));
                     get_info();
                    } else if(lists[i]['step'].toString()=='3') {
                     await push(context: context, screen: editmedicleconditions(
                        pre_data: lists[i],
                      ));
                     get_info();
                    } else if(lists[i]['step'].toString()=='4'){
                     await push(context: context, screen: editsurgeries(
                        pre_data: lists[i],
                      ));
                     get_info();
                    } else if(lists[i]['step'].toString()=='5'){
                      await push(context: context, screen: editfamilyCondition(
                        pre_data: lists[i],
                      ));
                      get_info();
                    } else {
                     lists[i]['id'] = lists[i]['relative_id'];
                      setState(() {

                      });
                    await  push(context: context, screen: RelativesPage(
                        is_update: true,
                        pre_data: lists[i],
                      ));
                    get_info();
                    }
                  },
                ),
              ),
            // vSizedBox,
            // Container(
            //   padding: EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(16),
            //       border: Border.all(
            //           color: MyColors.bordercolor,
            //           width: 1
            //       ),
            //       color: Colors.white
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       ParagraphText(text: 'Yes', color: MyColors.onsurfacevarient,),
            //     ],
            //   ),
            // ),
            vSizedBox2,
            // RoundEdgedButton(text: 'Cancel', onTap: () => {}),
            // vSizedBox4
          ],
        ),
      ),
    );
  }
}
