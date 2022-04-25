import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:ui' as ui;
import 'dart:io';
//import 'dart:html';
import 'dart:async';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';


class AndroidWebviewOpen extends GetView<Widget> {
  final Completer<WebViewController> webController =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    return Scaffold(
        body: SafeArea(
            child: WebView(
              initialUrl: 'https://www.ventusky.com',
              onWebViewCreated: (WebViewController _controller) async {
                webController.isCompleted
                    ? ''
                    : webController.complete(_controller);
              },
              javascriptMode: JavascriptMode.unrestricted,
            ))
    );
  }
}
// class AndroidWebViewOpen extends StatelessWidget {
//   const AndroidWebViewOpen({Key? key}) : super(key: key);
//   void initState() {
//     if (Platform.isAndroid) WebView.platform = AndroidWebView();
//   }
//
//   @override
//
//   Widget build(BuildContext context) {
//     return WebView(
//       initialUrl: 'https://www.ventusky.com',
//       onWebViewCreated: :(WebViewController _controller) async{
//         webController.isComplete(_controller);
//     },
//     javascriptMode: JavascriptMode.unrestricted,
//     );
//   }
// }
