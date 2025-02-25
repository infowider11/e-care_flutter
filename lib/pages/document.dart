import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/upload_document.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/list_ui_1.dart';
 
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSizedBox2,
            const MainHeadingText(text: 'Document', fontSize: 32, fontFamily: 'light',),
            vSizedBox4,

            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadDocument())),
              child: ListUI01(heading: 'Document Name', image: 'assets/images/file.png', isIcon: false)
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadDocument())),
              child: ListUI01(heading: 'Document Name', image: 'assets/images/file.png', isIcon: false)
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadDocument())),
              child: ListUI01(heading: 'Document Name', image: 'assets/images/file.png', isIcon: false)
            ),
          ],
        ),
      ),
    );
  }
}
