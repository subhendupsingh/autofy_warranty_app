import 'dart:collection';
import 'package:autofy_warranty_app/pages/homepage/homepageScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class WebView extends StatefulWidget {
  String? initialUrl;
  WebView({@required this.initialUrl});
  @override
  _WebViewState createState() => new _WebViewState();
}

class _WebViewState extends State<WebView> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
  );

  PullToRefreshController? pullToRefreshController;
  ContextMenu? contextMenu;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.red,
      ),
      onRefresh: () async {
        webViewController?.reload();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(HomePage(startingIndex: 0));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Get.offAll(HomePage(startingIndex: 0));
            },
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.launch_rounded,
                  size: 20,
                ),
                onPressed: () {
                  try {
                    print(widget.initialUrl);
                    urlLauncher.launch(widget.initialUrl.toString());
                  } catch (e) {
                    print(e);
                  }
                })
            // PopupMenuButton<String>(
            //   onSelected: (value) async {
            //     try {
            //       print("ahjewojeoi");
            //       print(widget.initialUrl);
            //       urlLauncher
            //           .launch(widget.initialUrl.toString());
            //     } catch (e) {
            //       print(e);
            //     }
            //   },
            //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            //     const PopupMenuItem<String>(
            //       value: 'Open In Browser',
            //       child: Text('Open In Browser'),
            //     ),
            //   ],
            // ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest:
                          URLRequest(url: Uri.parse(widget.initialUrl!)),
                      initialUserScripts: UnmodifiableListView<UserScript>([]),
                      initialOptions: options,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStart: (controller, url) {},
                      androidOnPermissionRequest:
                          (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      onLoadStop: (controller, url) async {
                        pullToRefreshController?.endRefreshing();
                      },
                      onLoadError: (controller, url, code, message) {
                        pullToRefreshController?.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController?.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                      onUpdateVisitedHistory:
                          (controller, url, androidIsReload) {},
                      onConsoleMessage: (controller, consoleMessage) {
                        debugPrint(consoleMessage.toString());
                      },
                    ),
                    progress < 1.0
                        ? LinearProgressIndicator(value: progress)
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
