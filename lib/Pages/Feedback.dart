// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        toolbarHeight: 120.0,

        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            'assets/tradin.png',
            height: 80.0,
            width: 80.0,
          ),
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url:
          Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSfY5LdygPxd7STWwhxVNzH8Hpc2SgEVfxsibIreROmkno0Kww/viewform?usp=sf_link'),
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true, // Enable JavaScript
          ),
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onLoadStop: (controller, url) {
          if (url.toString().startsWith('https://docs.google.com/forms/d/your-form-id/formResponse')) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
