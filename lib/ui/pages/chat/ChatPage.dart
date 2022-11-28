import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.cookieManager}) : super(key: key);
  final CookieManager cookieManager;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenWidth = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: WebView(
          zoomEnabled: false,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
            _controller.future.then((tmpController) {
              tmpController.loadHtmlString("""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        body{
            height: 100vh;
        }
        *{
            margin:0;
            padding:0;
            box-sizing: border-box;
        }
        .loader{
            display: flex;
            justify-content: center;
            align-items: center;
            position: absolute;
            width:100%;
            height:100%;
            background:white;
            font-family:'Lucida Sans', 'Lucida Sans Regular', 'Lucida Grande', 'Lucida Sans Unicode', Geneva, Verdana, sans-serif;
            font-size: 1.6em;
        }
    </style>
</head>
<body>
    <div class="loader">
        Cargando chat...
    </div>
    <script>
        let frame=document.createElement("iframe");
        let loader=document.querySelector(".loader");
        frame.src="https://webchat.botframework.com/embed/chatbot-appbient-bot?s=0rD4zu5FVgw.TLS7-M5UBkuWyKhcJEK4rCVL5nAt_DpTSu_Yr1-DwWg";
        frame.onload=function(){
            loader.style.display="none";
        }
        frame.style.width="100" + "%";
        frame.style.height="99" + "%";
        document.body.appendChild(frame);
    </script>
</body>
</html>""");
            });
          },
        ),
      ),
    );
  }
}
