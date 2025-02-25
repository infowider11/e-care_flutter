// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print

import 'package:ecare/pages/review_profile.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/showSnackbar.dart';
 
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Question2FamilyConditions extends StatefulWidget {
  List? first_step_arr = [];
  List? second_step_arr = [];
  Question2FamilyConditions(
      {Key? key, this.first_step_arr, this.second_step_arr})
      : super(key: key);

  @override
  State<Question2FamilyConditions> createState() =>
      _Question2FamilyConditionsState();
}

class _Question2FamilyConditionsState extends State<Question2FamilyConditions> {
  TextEditingController search = TextEditingController();
  TextEditingController other = TextEditingController();

  bool isChecked = false;
  List conditions = [];
  List seleted_arr = [];
  List<TextEditingController> others = [];
  bool load = false;
  int count = 0;
  bool add_another = false;
  List<TextEditingController> myController = [];
  int _count = 3;

  get_lists() async {
    setState(() {
      load = true;
    });
    var res = await Webservices.get(ApiUrls.familymedicalcondition);
    setState(() {
      load = false;
    });
    print('list-----$res');
    if (res['status'].toString() == '1') {
      conditions = res['data'];
      setState(() {});
    }
  }

  @override
  void initState() {
    
    super.initState();
    // get_lists();
    myController =
        List.generate(_count, (i) =>  TextEditingController(),growable: true);
    print('first_step_arr----${widget.first_step_arr}');
    print('second_step_arr----${widget.second_step_arr}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.scaffold,
      appBar: appBar(
          context: context,
          title: 'Which conditions?',
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
              // ParagraphText(
              //     fontSize: 16,
              //     text:
              //         'Please include any medical conditions you have now or have had in the past.'),
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
                    hintText: 'Family medical condition  ${i+1}',
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
                    hintText: 'Other Condition.....',
                    onChange: ((value) => {
                          setState(() {}),
                        }),
                    suffix: IconButton(
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        others.removeAt(i);
                        setState(() {});
                      },
                    ),
                  ),
                ),
              vSizedBox,
              // ParagraphText(text: 'Add other', color: MyColors.primaryColor),
              // ElevatedButton.icon(
              //   onPressed: () {
              //     // add_another = !add_another;
              //     others.add(TextEditingController());
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

              vSizedBox4,

              RoundEdgedButton(
                text: 'Save',
                onTap: () async {
                  var contain = conditions
                      .where((element) => element['isChecked'] ?? false);
                  print('dddddd---${contain}');
                  // if (others.length == 0 && contain.isEmpty) {
                  if (others.length == 0 && myController.length==0) {
                    // showSnackbar( 'Please Check Condition.');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReviewProfile()));
                  } else {
                    print('workking---');
                    seleted_arr = [];
                    List others_valus = [];
                    List family_medical_conditions = [];

                    setState(() {});
                    for (int i = 0; i < conditions.length; i++) {
                      if (conditions[i]['isChecked'] == true) {
                        seleted_arr.add(conditions[i]['id']);
                      }
                    }

                    for (int i = 0; i < others.length; i++) {
                      others_valus.add(others[i].text);
                    }

                    for (int i = 0; i < myController.length; i++) {
                      if(myController[i].text!='')
                      family_medical_conditions.add(myController[i].text);
                    }

                    Map<String, dynamic> data = {
                      'user_id': await getCurrentUserId(),
                      'step5': '5',
                      'family_medical_condition': family_medical_conditions.join(','),
                    };
                    if (others_valus.length > 0) {
                      data['other_value'] = others_valus.join(',');
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReviewProfile())); //RelativesPage()
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
