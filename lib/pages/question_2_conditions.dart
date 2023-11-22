import 'package:ecare/services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_1_allergies.dart';
import 'package:ecare/pages/question_1_condition.dart';
import 'package:ecare/pages/question_1_medication.dart';
import 'package:ecare/pages/question_1_surgeries.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/dropdown.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';

class Question2Conditions extends StatefulWidget {
  List? first_step_arr = [];
  List? second_step_arr = [];
  Question2Conditions({Key? key, this.first_step_arr, this.second_step_arr})
      : super(key: key);

  @override
  State<Question2Conditions> createState() => _Question2ConditionsState();
}

class _Question2ConditionsState extends State<Question2Conditions> {
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
  int _count = 3;

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
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myController =
        List.generate(_count, (i) =>  TextEditingController(),growable: true);
    // get_lists();
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
          title: 'Which Conditions?',
          fontfamily: 'light',
          fontsize: 32),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MainHeadingText(text: 'Which conditions? ', fontSize: 32, fontFamily: 'light',),
              // vSizedBox2,
              ParagraphText(
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
                      icon: Icon(Icons.remove_circle),
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
                icon: Icon(
                  // <-- Icon
                  Icons.add_circle,
                  size: 24.0,
                ),
                label: Text('Add Another'), // <-- Text
              ),

              vSizedBox2,
              // if (add_another)
              for (int i = 0; i < others.length; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    controller: others[i],
                    suffix:IconButton(
                            icon: Icon(Icons.remove_circle),
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
              // ElevatedButton.icon(
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

              // vSizedBox2,
              vSizedBox4,
              RoundEdgedButton(
                text: 'Save',
                onTap: () async {
                  var contain = conditions
                      .where((element) => element['isChecked'] ?? false);
                  print('dddddd---${contain}');


                  // if (others.length==0&&contain.isEmpty) {
                  if (others.length==0&&myController.length==0) {
                    // showSnackbar( 'Please Check Condition.');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Question1Surgeries()));
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
                    for(int i=0;i<others.length;i++){
                      others_value.add(others[i].text);
                    }

                    for(int i=0;i<myController.length;i++){
                      if(myController[i].text!='')
                      medical_conditions.add(myController[i].text);
                    }

                    print('myController------${medical_conditions.join(',')}');

                    Map<String, dynamic> data = {
                      'user_id': await getCurrentUserId(),
                      'step3': '3',
                      'medical_condition': medical_conditions.join(','),
                    };
                    if (others_value.length>0) {
                      data['other_value'] = others_value.join(',');//other.text;
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
                              builder: (context) => Question1Surgeries(
                                    first_step_arr: widget.first_step_arr,
                                    second_step_arr: widget.second_step_arr,
                                    thired_step_arr: myController,
                                    thired_step_other_val: other.text,
                                  )));
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
