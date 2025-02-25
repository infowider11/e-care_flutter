// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print

import 'package:ecare/services/api_urls.dart';
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

class editmedicleconditions extends StatefulWidget {
  List? first_step_arr = [];
  List? second_step_arr = [];
  final Map? pre_data;


  editmedicleconditions(
      {Key? key, this.pre_data, this.first_step_arr, this.second_step_arr})
      : super(key: key);

  @override
  State<editmedicleconditions> createState() => _editmedicleconditionsState();
}

class _editmedicleconditionsState extends State<editmedicleconditions> {
  TextEditingController search = TextEditingController();
  TextEditingController other = TextEditingController();
  List<TextEditingController> myController = [];

  bool isChecked = false;
  List conditions = [];
  List<TextEditingController> others = [];
  List seleted_arr = [];
  bool load = false;
  int count = 0;
  bool add_another = false;
  List server_other_val = [];
  List ids = [];


  get_lists() async {
    setState(() {
      load = true;
    });
    var res = await Webservices.get(ApiUrls.medicalcondition);
    setState(() {
      load = false;
    });
    print('list-----$res');
    if (res['status'].toString() == '1') {
      conditions = res['data'];
      for (int i = 0; i < conditions.length; i++) {
        for(int j=0;j<ids.length;j++){
          if (conditions[i]['id'] == ids[j]) {
            conditions[i]['isChecked']=true;
            setState(() {});
          }
        }
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    
    super.initState();
    // myController =
    //     List.generate(_count, (i) =>  TextEditingController(),growable: true);
    print('pre_data----${widget.pre_data}');

    if( widget.pre_data!['other_value'] !='')
   server_other_val = widget.pre_data!['other_value'].split(',');

    if( widget.pre_data!['name'] !='')
    ids = widget.pre_data!['name'].split(',');
    // print('ids-----$ids');

    for (int i = 0; i < ids.length; i++) {
      myController.add(TextEditingController());
      myController[i].text = ids[i];
    }


      for (int i = 0; i < server_other_val.length; i++) {
      others.add(TextEditingController());
      others[i].text = server_other_val[i];
    }
    // get_lists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.scaffold,
      appBar: appBar(
          context: context,
          title: 'Which Conditions?',
          fontfamily: 'light',
          fontsize: 32),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MainHeadingText(text: 'Which conditions? ', fontSize: 32, fontFamily: 'light',),
              // vSizedBox2,
              const ParagraphText(
                  fontSize: 16,
                  text:
                      'Please include any medical conditions you have now or have had in the past.'),
              // vSizedBox4,
              // CustomTextField(
              //   controller: search,
              //   hintText: 'Search...',
              //   onChange: ((value) => {
              //         setState(() {}),
              //       }),
              // ),
              vSizedBox2,

              for (int i = 0; i < myController.length; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    controller: myController[i],
                    suffix:i>2?IconButton(
                      icon: const Icon(Icons.remove_circle),
                      color: Colors.red,
                      onPressed: () {
                        myController.removeAt(i);
                        setState(() {});
                        // myController =
                        //     List.generate(drug_count, (i) => TextEditingController(),growable: true);
                      },
                    ):null,
                    hintText: 'Medical condition ${i+1}',
                    onChange: ((value) => {
                      setState(() {}),
                    }),
                  ),
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

              vSizedBox2,
              // if (add_another)
              for (int i = 0; i < others.length; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    controller: others[i],
                    suffix: IconButton(
                      icon: const Icon(Icons.remove_circle),
                      color: Colors.red,
                      onPressed: () {
                        others.removeAt(i);
                        setState(() {});
                        // myController =
                        //     List.generate(drug_count, (i) => TextEditingController(),growable: true);
                      },
                    ),
                    hintText: 'Other Condition.....',
                    onChange: ((value) => {
                          setState(() {}),
                        }),
                  ),
                ),
                vSizedBox,
                // ParagraphText(text: 'Add other', color: MyColors.primaryColor),
              //   ElevatedButton.icon(
              //   onPressed: () {
              //     others.add(TextEditingController());
              //     // add_another = !add_another;
              //     setState(() {});
              //   },
              //   icon: !add_another
              //       ? Icon(Icons.add_circle)
              //       : Icon(
              //           Icons.remove_circle,
              //           color: Colors.red,
              //         ),
              //   label: !add_another
              //       ? Text('Add Other')
              //       : Text(
              //           'Remove',
              //           style: TextStyle(color: Colors.red),
              //         ),
              // ),

              // Container(
              //   padding: EdgeInsets.all(16),
              //   height: 350,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(15),
              //     color: MyColors.teritiary,
              //   ),
              //   child: ListView(
              //     children: [
              //       load
              //           ? CustomLoader()
              //           : Column(
              //               children: [
              //                 for (var i = 0; i < conditions.length; i++)
              //                   if (((conditions[i]['title'].toLowerCase()
              //                               as String)
              //                           .contains(search.text) ||
              //                       (conditions[i]['title'].toUpperCase()
              //                               as String)
              //                           .contains(search.text)))
              //                     Container(
              //                       decoration: BoxDecoration(
              //                           border: Border(
              //                               bottom: BorderSide(
              //                         color: MyColors.bordercolor,
              //                         // width: 1
              //                       ))),
              //                       child: Row(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.spaceBetween,
              //                         children: [
              //                           ParagraphText(
              //                             text: '${conditions[i]['title']}',
              //                             fontSize: 12,
              //                             color: MyColors.onsurfacevarient,
              //                           ),
              //                           Checkbox(
              //                             checkColor: Colors.white,
              //                             value: conditions[i]['isChecked'] ??
              //                                 false,
              //                             onChanged: (bool? value) {
              //                               setState(() {
              //                                 conditions[i]['isChecked'] =
              //                                     value!;
              //                               });
              //                             },
              //                           )
              //                         ],
              //                       ),
              //                     ),
              //                 if (conditions.length == 0)
              //                   Center(
              //                     child: Text('No data found.'),
              //                   )
              //               ],
              //             )
              //     ],
              //   ),
              // ),
              //
              // vSizedBox2,

              vSizedBox4,
              RoundEdgedButton(
                text: 'Update',
                onTap: () async {
                  var contain = conditions
                      .where((element) => element['isChecked'] ?? false);
                  print('dddddd---${contain}');
                  if (others.length == 0 && myController.length==0) {
                    // showSnackbar( 'Please Check Condition.');
                    Navigator.pop(context);
                  } else {
                    print('workking---$others');
                    seleted_arr = [];
                    List others_value = [];
                    List medical_conditions = [];
                    setState(() {});
                    for (int i = 0; i < conditions.length; i++) {
                      if (conditions[i]['isChecked'] == true) {
                        seleted_arr.add(conditions[i]['id']);
                      }
                    }
                    for (int i = 0; i < others.length; i++) {
                      others_value.add(others[i].text);
                    }

                    for(int i=0;i<myController.length;i++){
                      if(myController[i].text!='')
                        medical_conditions.add(myController[i].text);
                    }

                    Map<String, dynamic> data = {
                      'user_id': await getCurrentUserId(),
                      'step3': '3',
                      'medical_condition': medical_conditions.join(','),
                    };

                    if (others_value.length > 0) {
                      data['other_value'] =
                          others_value.join(','); //other.text;
                    }
                    await EasyLoading.show(
                      status: null,
                      maskType: EasyLoadingMaskType.black,
                    );
                    var res = await Webservices.postData(
                        apiUrl: ApiUrls.healthProfile,
                        body: data,
                        context: context);
                    EasyLoading.dismiss();
                    print('step-3----$res');
                    if (res['status'].toString() == '1') {
                      Navigator.pop(context);
                    } else {
                      showSnackbar( 'Somting Went Wrong.');
                    }
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
