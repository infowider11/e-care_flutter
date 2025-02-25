// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/question_1_condition.dart';
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

class Question2Allergies extends StatefulWidget {
  List? first_step_arr = [];
  Question2Allergies({Key? key, this.first_step_arr}) : super(key: key);

  @override
  State<Question2Allergies> createState() => _Question2AllergiesState();
}

class _Question2AllergiesState extends State<Question2Allergies> {
  TextEditingController email = TextEditingController();
  List<TextEditingController> myController = [];

  int drug_count = 3;

  @override
  void initState() {
    
    super.initState();
    myController =
        List.generate(drug_count, (i) =>  TextEditingController(),growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(
        context: context,
        title: 'Which drug allergies? ',
        fontsize: 32,
        fontfamily: 'light',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MainHeadingText(text: 'Which drug allergies? ', fontSize: 32, fontFamily: 'light',),
              vSizedBox2,
              const ParagraphText(
                  fontSize: 16,
                  text: 'Please specify the name of each drug allergy.'),
              vSizedBox4,
              for (var i = 0; i < myController.length; i++)
                Column(
                  children: [
                    CustomTextField(
                      controller: myController[i],
                      hintText: 'Drug ${i + 1}',
                      suffix: i > 2
                          ? IconButton(
                              icon: const Icon(Icons.remove_circle),
                              color: Colors.red,
                              onPressed: () {
                                // drug_count--;
                                myController.removeAt(i);
                                setState(() {});
                                // myController =
                                //     List.generate(drug_count, (i) => TextEditingController(),growable: true);
                              },
                            )
                          : null,
                    ),
                    vSizedBox
                  ],
                ),
              ElevatedButton.icon(
                onPressed: () {
                  // drug_count++;
                  myController.add(TextEditingController());
                  setState(() {});
                  // myController =
                  //     List.generate(drug_count, (i) => TextEditingController(),growable: true);
                },
                icon: const Icon(
                  // <-- Icon
                  Icons.add_circle,
                  size: 24.0,
                ),
                label: const Text('Add Another'), // <-- Text
              ),
              // Column(
              //   children: [
              //     IconButton(
              //       onPressed: () => {},
              //       icon: Icon(Icons.add,color: MyColors.primaryColor,size: 20,),
              //     ),
              //     ParagraphText(text: 'Add Another'),
              //   ],
              // ),
              vSizedBox2,
              RoundEdgedButton(
                text: 'Save',
                onTap: () async{
                  List final_arr=[];
                  for(int i=0;i<myController.length;i++){
                    if(myController[i].text!=''){
                      // showSnackbar( 'Please Enter Drug.');
                      Map<String,dynamic> d = {};
                      d['value']=myController[i].text;
                      final_arr.add(d);
                      setState(() {

                      });
                      // return;
                    }
                  }
                  if(final_arr.length>0) {
                    Map<String,dynamic> data = {
                      'user_id':await getCurrentUserId(),
                      'step2':'2'
                    };
                    for(int i=0;i<final_arr.length;i++){
                      data['drug_alergy[${i}]']=final_arr[i]['value'];
                    }
                    await EasyLoading.show(
                      status: null,
                      maskType: EasyLoadingMaskType.black,
                    );
                    var res = await Webservices.postData(apiUrl: ApiUrls.healthProfile, body: data, context: context);
                    EasyLoading.dismiss();
                    print('step2-------$res');
                    if(res['status'].toString()=='1'){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Question1Conditions(first_step_arr:widget.first_step_arr,second_step_arr:myController)));
                    } else {
                      showSnackbar( 'Somting Went Wrong.');
                    }
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Question1Conditions(first_step_arr:widget.first_step_arr,second_step_arr:myController)));
                  }

                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
