import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/list_ui_1.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../services/api_urls.dart';
import '../services/webservices.dart';

class MyInvoicePage extends StatefulWidget {
  const MyInvoicePage({Key? key}) : super(key: key);

  @override
  State<MyInvoicePage> createState() => MyInvoicePageState();
}

class MyInvoicePageState extends State<MyInvoicePage>
    with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  late AnimationController controller;

  bool load = false;
  List lists = [];

  @override
  void initState() {
    // TODO: implement initState
    get_list();
    super.initState();
  }

  get_list() async {
    setState(() {
      load = true;
    });
    lists = await Webservices.getList(ApiUrls.invoice_list+await getCurrentUserId());
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: load
          ? CustomLoader()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSizedBox2,
                  MainHeadingText(
                    text: 'My Invoices ',
                    fontSize: 32,
                    fontFamily: 'light',
                  ),
                  vSizedBox2,
                  ParagraphText(
                      fontSize: 16,
                      text:
                          'Download invoices from your Healthcare Practitioner here'),
                  vSizedBox4,
                  for (int i = 0; i < lists.length; i++)
                    InkWell(
                      onTap: () async{
                        // EasyLoading.show(
                        //   status: null,
                        //   maskType: EasyLoadingMaskType.black,
                        // );
                        var time = DateTime.now();
                        await savePdfToStorage1(lists[i]['invoice_attachment'],'pdf',
                            '${time.millisecond}_invoice_attachment.pdf');
                          // EasyLoading.dismiss();
                      },
                      child: ListUI01(
                          heading: 'Invoice #${i + 1}',
                          subheading: '${lists[i]['time_ago']??''}',
                          borderColor: MyColors.white,
                          image: 'assets/images/file.png'),
                    ),
                  if (lists.length == 0)
                    Center(
                      child: Text('No data found.'),
                    )
                ],
              ),
            ),
    );
  }
}
