// ignore_for_file: avoid_print

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/showSnackbar.dart';
 
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../services/api_urls.dart';

class editmedications extends StatefulWidget {
  final Map? pre_data;
  const editmedications({Key? key,this.pre_data}) : super(key: key);

  @override
  State<editmedications> createState() => _editmedicationsState();
}

class _editmedicationsState extends State<editmedications> {
  Map<String,dynamic> val = {};
  TextEditingController medication = TextEditingController();
  List<TextEditingController> myController = [];
  List<TextEditingController> myController2 = [];
  List<String> items1 = [

  ];

  List<String> items2 = [

  ];

  List key_arr = [{'value':''},{'value':''},{'value':''}];
  List final_arr = [];
  bool is_empty=true;
  // int arr_length=3;

  @override
  void initState() {
    
    super.initState();
    myController = List.generate(3, (i) => TextEditingController());
    myController2 = List.generate(3, (i) => TextEditingController());
    print('pre_data------${widget.pre_data}');
    items1=widget.pre_data!['name'].split(',');
    items2=widget.pre_data!['medication_value'].split(',');
    for(int i=0;i<items1.length;i++){
        myController[i].text=items1[i];
    }
    for(int i=0;i<items2.length;i++){
      myController2[i].text=items2[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(
          context: context,
          title: 'Which medications?',
          fontsize: 32,
          fontfamily: 'light'),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MainHeadingText(text: 'Which medications? ', fontSize: 32, fontFamily: 'light',),
              // vSizedBox2,
              const ParagraphText(
                  fontSize: 16,
                  text:
                  'Please consider any medication you are taking, including those taken on a regular basis.'),
              vSizedBox4,
              for (var i = 0; i < myController.length; i++)
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: CustomTextField(
                              controller: myController[i],
                              hintText: 'medications ${i + 1}'),
                        ),
                        hSizedBox,
                        Expanded(
                          flex: 6,
                          child: CustomTextField(
                              controller: myController2[i],
                              hintText: 'Dosage ${i + 1}'),
                          // CustomDropdownButton(
                          //   hint: 'Select',
                          //     items: items,
                          //   onChanged: ((value) => {
                          //     val={},
                          //     setState(() {
                          //
                          //     }),
                          //     print('select--value---$value'),
                          //     key_arr[i]['value']=value,
                          //         setState(() {
                          //
                          //     }),
                          //     print('value------$key_arr'),
                          //   }),
                          // ),
                        )
                      ],
                    ),
                    vSizedBox
                  ],
                ),

              ElevatedButton.icon(
                onPressed: () {
                  // drug_count++;
                  myController.add(TextEditingController());
                  myController2.add(TextEditingController());
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
              vSizedBox2,
              RoundEdgedButton(
                text: 'Update',
                onTap:() async{
                  final_arr=[];
                  for(int i=0;i<myController.length;i++) {
                    Map<String,dynamic> data = {};
                    if(myController[i].text!='' || myController2[i].text!='') {
                      data['key']=myController[i].text;
                      data['value']=myController2[i].text;
                      final_arr.add(data);
                      setState(() {

                      });
                    }

                  }

                  if(final_arr.length>0) {
                    Map<String,dynamic> data = {
                      'user_id':await getCurrentUserId(),
                      'step1':'1',
                    };
                    for(int i=0;i<final_arr.length;i++) {
                      data['medication[${i}]']=final_arr[i]['key'];
                      data['medication_value[${i}]']=final_arr[i]['value'];
                    }
                    await EasyLoading.show(
                      status: null,
                      maskType: EasyLoadingMaskType.black,
                    );
                    var res = await Webservices.postData(apiUrl:ApiUrls.healthProfile , body: data, context: context);
                    EasyLoading.dismiss();
                    print('step 1st-----$res');
                    if(res['status'].toString()=='1'){
                      Navigator.pop(context);
                    } else {
                      showSnackbar( res['message']);
                    }
                  } else {
                    Navigator.pop(context);
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
