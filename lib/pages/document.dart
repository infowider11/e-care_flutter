import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_2_allergies.dart';
import 'package:ecare/pages/question_2_medication.dart';
import 'package:ecare/pages/upload_document.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/list_ui_1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  State<DocumentPage> createState() => DocumentPageState();
}

class DocumentPageState extends State<DocumentPage> with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  late AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSizedBox2,
            MainHeadingText(text: 'Document', fontSize: 32, fontFamily: 'light',),
            vSizedBox4,

            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UploadDocument())),
              child: ListUI01(heading: 'Document Name', image: 'assets/images/file.png', isIcon: false)
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UploadDocument())),
              child: ListUI01(heading: 'Document Name', image: 'assets/images/file.png', isIcon: false)
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UploadDocument())),
              child: ListUI01(heading: 'Document Name', image: 'assets/images/file.png', isIcon: false)
            ),
          ],
        ),
      ),
    );
  }
}
