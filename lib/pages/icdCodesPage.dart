
// ignore_for_file: unused_local_variable
// ignore_for_file: must_be_immutable, non_constant_identifier_names

// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:ecare/pages/add_icd_notes.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/list_ui_1.dart';
import 'package:ecare/widgets/loader.dart';
 
import 'package:flutter/material.dart';
import '../constants/api_variable_keys.dart';
import '../widgets/custom_confirmation_dialog.dart';

class IcdCodesPage extends StatefulWidget {
  String? doc_name;
  String? doc_type;
  IcdCodesPage({Key? key, this.doc_name, this.doc_type}) : super(key: key);

  @override
  State<IcdCodesPage> createState() => IcdCodesPageState();
}

class IcdCodesPageState extends State<IcdCodesPage>
    with TickerProviderStateMixin {
  // TabBar get _tabBar => TabBar(
  //   padding: EdgeInsets.symmetric(horizontal: 0),
  //   labelPadding: EdgeInsets.symmetric(horizontal: 0),
  //   tabs: <Widget>[
  //     Tab(
  //       child: MainHeadingText(
  //         text: 'My Invoice',
  //         color: MyColors.onsurfacevarient,
  //         fontSize: 11,
  //       ),
  //     ),
  //     Tab(
  //       child: MainHeadingText(
  //         text: 'Statement with ICD-10 Notes',
  //         color: MyColors.onsurfacevarient,
  //         fontSize: 11,
  //       ),
  //     ),
  //   ],
  // );
  TextEditingController email = TextEditingController();
  bool load = false;
  // List invoiceList = [];
  List icdNotes = [];


  // ?doctor_id=23&booking_id=2
  getIcdCodes() async {
    setState(() {
      load = true;
    });
    icdNotes = await Webservices.getList(ApiUrls.usericdCode_list+'?user_id=${await getCurrentUserId()}&type=1');
    setState(() {
      load = false;
    });
  }


  @override
  void initState() {
    super.initState();
    getIcdCodes();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: MyColors.scaffold,
        appBar: AppBar(
          centerTitle: true,
          title: const MainHeadingText(
            text: 'Statement with ICD-10 Notes',
            fontSize: 17,
            fontFamily: 'light',
          ),
          backgroundColor: MyColors.BgColor,
          // bottom: PreferredSizeWidget(
          //   child: MainHeadingText(
          //     text: 'My Invoice',
          //     color: MyColors.onsurfacevarient,
          //     fontSize: 11,
          //   ),
          // ),
          // bottom: PreferredSize(
          //   preferredSize: _tabBar.preferredSize,
          //   child: ColoredBox(
          //     color: MyColors.lightBlue.withOpacity(0.11),
          //     child: _tabBar,
          //   ),
          // ),
        ),
        body: load
            ? const CustomLoader()
            : Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vSizedBox2,
                const MainHeadingText(
                  text: 'Statements with ICD-10 codes',
                  fontSize: 32,
                  fontFamily: 'light',
                ),
                vSizedBox2,
                const ParagraphText(
                    fontSize: 16,
                    text:
                    'Download statements with ICD-10 codes here'),
                vSizedBox4,
                for (int i = 0; i < icdNotes.length; i++)
                  ListUI02(
                      heading: 'STATEMENT: ${icdNotes[i][ApiVariableKeys.doctor_lastname]}/${icdNotes[i][ApiVariableKeys.user_lastname]}',
                      // heading: 'STATEMENT: ${icdNotes[i]['doctor_data']['first_name']})',
                      // heading: 'STATEMENT #${icdNotes[i]['icd_code']}',
                      subheading: '${icdNotes[i][ApiVariableKeys.consult_dateTime]}',
                      // subheading: '${icdNotes[i]['date']} ${icdNotes[i]['time']}',
                      // subheading: '${icdNotes[i]['icd_code']??''}',
                      borderColor: MyColors.white,
                      editonTap: () async{
                        await push(context: context, screen: AddIcdNotes(
                          is_update: true,
                          data: icdNotes[i],
                        ));
                        getIcdCodes();
                      },
                      sendonTap: () async{
                        var time = DateTime.now();
                        await savePdfToStorage1(icdNotes[i]['pdf_url'],'pdf',
                            '${time.millisecond}_STATEMENT_WITH_ICD10_CODE.pdf');
                      },
                      isIcon: false,
                      deleteonTap: () async{
                        Map<String, dynamic> data = {
                          'booking_id': icdNotes[i]['id'].toString(),
                          'type': '1',
                        };
                        bool? result= await showCustomConfirmationDialog(
                            headingMessage:'Are you sure you want to delete?',

                        ) ;
                        if(result==true){
                          setState(() {
                            load = true;
                          });
                          var res = await Webservices.postData(
                              apiUrl: ApiUrls.deleteIcd,
                              body: data,
                              context: context).then((value) => getIcdCodes());
                        }
                      },
                      image: 'assets/images/file.png'),
                if (icdNotes.length == 0)
                  const Center(
                    child: Text('No data found.'),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
