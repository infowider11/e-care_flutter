import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_1_allergies.dart';
import 'package:ecare/pages/question_1_condition.dart';
import 'package:ecare/pages/question_1_family_conditions.dart';
import 'package:ecare/pages/question_1_medication.dart';
import 'package:ecare/pages/question_1_surgeries.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../services/api_urls.dart';
import '../services/auth.dart';
import '../services/webservices.dart';
import '../widgets/loader.dart';
import '../widgets/showSnackbar.dart';

class editsurgeries extends StatefulWidget {
  List? first_step_arr = [];
  List? second_step_arr = [];
  List? thired_step_arr = [];
  String? thired_step_other_val;
  final Map? pre_data;
  editsurgeries(
      {Key? key,
        this.pre_data,
        this.first_step_arr,
        this.second_step_arr,
        this.thired_step_arr,
        this.thired_step_other_val})
      : super(key: key);

  @override
  State<editsurgeries> createState() => _editsurgeriesState();
}

class _editsurgeriesState extends State<editsurgeries> {
  TextEditingController search = TextEditingController();
  TextEditingController other = TextEditingController();

  bool isChecked = false;
  bool load = false;
  List lists = [];
  List<TextEditingController> others = [];
  bool add_another = false;
  List seleted_arr = [];
  List server_other_val = [];
  List ids = [];
  List<TextEditingController> myController = [];

  get_surgeries() async {
    setState(() {
      load = true;
    });
    var res = await Webservices.get(ApiUrls.getsurgeries);
    setState(() {
      load = false;
    });
    print('list-----$res');
    if (res['status'].toString() == '1') {
      lists = res['data'];
      for (int i = 0; i < lists.length; i++) {
        for(int j=0;j<ids.length;j++){
          if (lists[i]['id'] == ids[j]) {
            lists[i]['isChecked']=true;
            setState(() {});
          }
        }
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if( widget.pre_data!['other_value'] !='')
      server_other_val = widget.pre_data!['other_value'].split(',');

    if( widget.pre_data!['name'] !='')
      ids = widget.pre_data!['name'].split(',');
    for (int i = 0; i < ids.length; i++) {
      myController.add(TextEditingController());
      myController[i].text = ids[i];
    }
    // server_other_val = widget.pre_data!['other_value'].split(',');

    // ids = widget.pre_data!['surgery_id'].split(',');
    // print('ids-----$ids');
    for (int i = 0; i < server_other_val.length; i++) {
      others.add(TextEditingController());
      others[i].text = server_other_val[i];
    }

    print('data----${widget.pre_data}');
    // get_surgeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.scaffold,
      appBar: appBar(
          context: context,
          title: 'Which surgeries?',
          fontsize: 32,
          fontfamily: 'light'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MainHeadingText(text: 'Which surgeries? ', fontSize: 32, fontFamily: 'light',),
            // vSizedBox2,
            // CustomTextField(
            //     controller: search,
            //     onChange: ((value) => {
            //       setState(() => {}),
            //     }),
            //     hintText: 'Search...'),
            // vSizedBox,
            // if (add_another)
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

            for (int i = 0; i < others.length; i++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  controller: others[i],
                  hintText: 'Other Surgeries.....',
                  onChange: ((value) => {
                    setState(() {}),
                  }),
                  suffix: IconButton(
                    icon: Icon(
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
            vSizedBox2,
            // ElevatedButton.icon(
            //   onPressed: () {
            //     others.add(TextEditingController());
            //     // add_another=!add_another;
            //     setState(() {});
            //   },
            //   icon: !add_another
            //       ? Icon(Icons.add_circle)
            //       : Icon(
            //     Icons.remove_circle,
            //     color: Colors.red,
            //   ),
            //   label: !add_another
            //       ? Text('Add Other')
            //       : Text(
            //     'Remove',
            //     style: TextStyle(color: Colors.red),
            //   ),
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
            //         children: [
            //           for (var i = 0; i < lists.length; i++)
            //             if (((lists[i]['name'].toLowerCase() as String)
            //                 .contains(search.text) ||
            //                 (lists[i]['name'].toUpperCase() as String)
            //                     .contains(search.text)))
            //               Container(
            //                 decoration: BoxDecoration(
            //                     border: Border(
            //                         bottom: BorderSide(
            //                           color: MyColors.bordercolor,
            //                           // width: 1
            //                         ))),
            //                 child: Row(
            //                   mainAxisAlignment:
            //                   MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     ParagraphText(
            //                       text: '${lists[i]['name']}',
            //                       fontSize: 12,
            //                       color: MyColors.onsurfacevarient,
            //                     ),
            //                     Checkbox(
            //                       checkColor: Colors.white,
            //                       value: lists[i]['isChecked'] ?? false,
            //                       onChanged: (bool? value) {
            //                         setState(() {
            //                           lists[i]['isChecked'] = value!;
            //                         });
            //                       },
            //                     )
            //                   ],
            //                 ),
            //               ),
            //           if (lists.length == 0)
            //             Center(
            //               child: Text('No data found.'),
            //             )
            //         ],
            //       )
            //     ],
            //   ),
            // ),

            vSizedBox4,
            RoundEdgedButton(
                text: 'Update',
                onTap: () async {
                  var contain =
                  lists.where((element) => element['isChecked'] ?? false);
                  print('dddddd---${contain}');
                  if (others.length==0&&myController.length==0) {
                    // showSnackbar( 'Please Check Surgeries.');
                    Navigator.pop(context);
                  } else {
                    print('workking---');
                    seleted_arr = [];
                    List others_value = [];
                    List surgeries = [];

                    setState(() {});
                    for (int i = 0; i < lists.length; i++) {
                      if (lists[i]['isChecked'] == true) {
                        seleted_arr.add(lists[i]['id']);
                      }
                    }

                    for(int i=0;i<others.length;i++){
                      others_value.add(others[i].text);
                    }

                    for(int i=0;i<myController.length;i++){
                      if(myController[i].text!='')
                        surgeries.add(myController[i].text);
                    }

                    Map<String, dynamic> data = {
                      'user_id': await getCurrentUserId(),
                      'step4': '4',
                      'surgery': surgeries.join(','),
                    };
                    if (others_value.length>0) {
                      data['other_value'] = others_value.join(',');
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
                })
          ],
        ),
      ),
    );
  }
}
