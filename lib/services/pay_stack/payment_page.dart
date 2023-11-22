import 'package:ecare/functions/navigation_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../pages/paymentprint.dart';
class PayStackPaymentPage extends StatelessWidget {
  final String paymentUrl;
  const PayStackPaymentPage({Key? key, required this.paymentUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WebView(
        initialUrl: paymentUrl,
        javascriptMode: JavascriptMode.unrestricted,
        userAgent: 'Flutter;Webview',
        onPageFinished: (a) {
          print(' ffffffffff on page finished $a');
        },
        onProgress: (b) {
          print(' ffffffffff on page progress $b');
        },
        navigationDelegate: (navigation) {
          print('fffffffff $navigation');
          String callbackUrl = 'https://e-care.co.za';
          //Listen for callback URL
          if (navigation.url.contains(callbackUrl)) {
            Navigator.of(context).pop(true);
            // push(context: context, screen: paymentconsole(
            //   data: navigation.isForMainFrame.toString(),
            //   url: navigation.url,
            // ));
            // verifyTransaction(reference);
             //close webview
          }
          return NavigationDecision.navigate;
        },

      ),
    );
  }
}
// tox1qonfnk
// tox1qonfnk
// 0uze4ud1ufatxti