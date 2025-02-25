// ignore_for_file: avoid_print

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/habit.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/selected_option.dart';
 
import 'package:flutter/material.dart';

class ReviewProfile extends StatefulWidget {
  const ReviewProfile({Key? key}) : super(key: key);

  @override
  State<ReviewProfile> createState() => _ReviewProfileState();
}

class _ReviewProfileState extends State<ReviewProfile> {
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
    
    super.initState();
    get_info();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: load?const CustomLoader():SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainHeadingText(
              text: 'Please review your health profile ',
              fontSize: 32,
              fontFamily: 'light',
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
              ),
                  //
            //   if(lists[i]['step'].toString()=='1')
            //   SelectedBox(
            //     heading: 'Medications',
            //     text: '${lists[i]['name']}',
            //   ),
            // if(lists[1]['step'].toString()=='2')
            // SelectedBox(
            //   heading: 'Drug Allergies',
            //   text: '${lists[1]['name']}',
            // ),
            //
            // if(lists[2]['step'].toString()=='3')
            //   SelectedBox(
            //     heading: 'Medical Conditions',
            //     text: '${lists[2]['name']??''}',
            //   ),
            //
            // if(lists[3]['step'].toString()=='4')
            //   SelectedBox(
            //     heading: 'Surgeries',
            //     text: '${lists[3]['name']??''}',
            //   ),

            // SelectedBox(
            //   heading:
            //   lists[i]['step'].toString()=='1'? 'Medications':
            //   lists[i]['step'].toString()=='2'?'Drug Allergies':
            //   lists[i]['step'].toString()=='3'?'Medical Conditions':
            //   lists[i]['step'].toString()=='4'?'Surgeries':'',
            //   text: '${lists[i]['name']}',),
            // if(lists[i]['step'].toString()=='2')
            // SelectedBox(heading: 'Drug Allergies'),
            // SelectedBox(heading: ''),
            // SelectedBox(heading: ''),

            RoundEdgedButton(
                text: 'Confirm',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HabitsPage()))
            ),
            vSizedBox4
          ],
        ),
      ),
    );
  }
}
