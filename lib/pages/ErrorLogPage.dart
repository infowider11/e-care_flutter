import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:flutter/material.dart';

Map<String, dynamic> errorLogs = {};
class ErrorLogPage extends StatefulWidget {
  const ErrorLogPage({Key? key}) : super(key: key);

  @override
  State<ErrorLogPage> createState() => _ErrorLogPageState();
}

class _ErrorLogPageState extends State<ErrorLogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context,title: 'Error Logs'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for(int i = 0;i<errorLogs.keys.length;i++)
              Column(
                children: [
                  SubHeadingText(text: '${errorLogs.keys.toList()[i]} : '),
                  ParagraphText(text: '${errorLogs[errorLogs.keys.toList()[i]]}')
                ],
              )
          ],
        ),
      ),
    );
  }
}
