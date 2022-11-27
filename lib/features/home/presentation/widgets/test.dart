// import 'package:flutter/material.dart';
// import 'package:webview_flutter_plus/webview_flutter_plus.dart';

// class Test extends StatelessWidget {
//   const Test({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return WebViewPlus(
//       javascriptMode: JavascriptMode.unrestricted,
//       onWebViewCreated: (controllerPlus) {
//         controllerPlus.loadUrl('assets/web/index.html');
//       },
//       javascriptChannels: {
//         JavascriptChannel(
//             name: 'Captcha',
//             onMessageReceived: (JavascriptMessage message) {
//               print('Done');
//             })
//       },
//     );
//   }
// }
