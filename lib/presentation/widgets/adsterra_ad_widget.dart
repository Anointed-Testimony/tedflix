import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdsterraAdWidget extends StatefulWidget {
  const AdsterraAdWidget({Key? key}) : super(key: key);

  @override
  State<AdsterraAdWidget> createState() => _AdsterraAdWidgetState();
}

class _AdsterraAdWidgetState extends State<AdsterraAdWidget> {
  late WebViewController _webViewController;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Block unwanted redirects but allow the ad to load
            if (request.url.contains('highperformanceformat.com') || 
                request.url.contains('adsterra.com')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')
      ..loadHtmlString(_getAdHtml());
  }

  String _getAdHtml() {
    return '''
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
      body {
        margin: 0;
        padding: 0;
        background: transparent;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 60px;
      }
      .ad-container {
        width: 468px;
        height: 60px;
        max-width: 100%;
        overflow: hidden;
      }
    </style>
  </head>
  <body>
    <div class="ad-container">
      <iframe 
        src="https://otieu.com/4/9526810" 
        width="468" 
        height="60" 
        frameborder="0" 
        scrolling="no"
        style="border:0;overflow:hidden;">
      </iframe>
    </div>
  </body>
</html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    print('🔍 AdsterraAdWidget: Building widget');
    print('🔍 AdsterraAdWidget: _isLoading = $_isLoading');
    print('🔍 AdsterraAdWidget: _hasError = $_hasError');
    
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.8)), // Red border for debugging
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            WebViewWidget(controller: _webViewController),
            if (_isLoading)
              Container(
                color: Colors.blue.withOpacity(0.3), // Blue background for debugging
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Loading Ad...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_hasError)
              Container(
                color: Colors.red.withOpacity(0.3), // Red background for debugging
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.white, size: 20),
                      SizedBox(height: 4),
                      Text(
                        'Ad Error',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Debug indicator - always visible
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'AD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 