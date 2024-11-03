import 'package:flutter/material.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/components.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewerState {
  final String linkUrl;
  final String title;

  WebViewerState({required this.linkUrl, required this.title});
}

class WebViewer extends StatefulWidget {
  final WebViewerState state;

  const WebViewer({super.key, required this.state});

  @override
  State<WebViewer> createState() => _WebViewerState();
}

class _WebViewerState extends State<WebViewer> {
  late WebViewController controller;
  bool _loading = false;
  bool _hasError = false;

  @override
  void initState() {
    _initWebView(widget.state.linkUrl);
    super.initState();
  }

  _initWebView(String linkUrl) {
    // print('URL');
    // print(linkUrl);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            setState(() {
              _loading = true;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _loading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _loading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _loading = false;
              _hasError = true;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(linkUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: MainTheme.appColors.neutralBg,
        elevation: 1,
        centerTitle: true,
        title: appBarText(context, widget.state.title),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: controller),
    );
  }
}
