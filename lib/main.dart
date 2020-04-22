import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebView Test',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final homePage = "https://www.carrefour.com.br";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: homePage,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: FutureBuilder<WebViewController>(
          future: _controller.future,
          builder:
              (BuildContext ctx, AsyncSnapshot<WebViewController> controller) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () async {
                          if (await controller.data.canGoBack()) {
                            controller.data.goBack();
                          } else {
                            Scaffold.of(ctx).showSnackBar(
                              const SnackBar(content: Text("Sem item de histórico para voltar"), duration: Duration(seconds: 2),),
                            );
                            return;
                          }
                        },
                ),
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    controller.data.loadUrl(homePage);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () async {
                          if (await controller.data.canGoForward()) {
                            controller.data.goForward();
                          } else {
                            Scaffold.of(ctx).showSnackBar(
                              const SnackBar(content: Text("Sem item de histórico para avançar"), duration: Duration(seconds: 2),),
                            );
                            return;
                          }
                        },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
