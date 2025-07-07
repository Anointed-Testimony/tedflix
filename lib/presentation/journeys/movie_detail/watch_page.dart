import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class WatchPage extends StatefulWidget {
  final String tmdbId;
  final bool adWatched;
  final String? customUrl;

  const WatchPage({required this.tmdbId, this.adWatched = false, this.customUrl, Key? key}) : super(key: key);

  @override
  _WatchPageState createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  late final WebViewController _videoController;
  late final WebViewController _adController;
  Timer? _refreshTimer;
  bool _isAdLoading = true;
  late final String _iframeUrl;
  final String _adUrl = "https://nauseousrocketjosephine.com/whk1ccx7d?key=d045c08d63014db27474e29afc28a58d";

  @override
  void initState() {
    super.initState();

    // Force landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _iframeUrl = widget.customUrl ?? "https://vidsrc.net/embed/movie?tmdb=${widget.tmdbId}";
    print('[DEBUG] WatchPage iframe URL: ' + _iframeUrl);

    final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { 
      margin: 0; 
      padding: 0;
      background: #000; 
      width: 100vw; 
      height: 100vh; 
      overflow: hidden;
    }
    .iframe-container { 
      width: 100vw; 
      height: 100vh; 
      position: fixed;
      top: 0;
      left: 0;
    }
    iframe { 
      width: 100%; 
      height: 100%; 
      border: none; 
      position: absolute;
      top: 0;
      left: 0;
    }
  </style>
</head>
<body>
  <div class="iframe-container">
    <iframe 
      src="$_iframeUrl" 
      frameborder="0" 
      allowfullscreen
      allow="autoplay; fullscreen; picture-in-picture">
    </iframe>
  </div>
</body>
</html>
''';

    _videoController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // Only allow navigation to the original iframe URL or data URLs
            if (request.url == _iframeUrl || 
                request.url.startsWith('data:') || 
                request.url.startsWith('about:') ||
                request.url.startsWith('javascript:')) {
              return NavigationDecision.navigate;
            }
            // Block all other navigation attempts gracefully
            print('[DEBUG] Blocked redirect to: ' + request.url);
            return NavigationDecision.prevent;
          },
          onPageFinished: (String url) {
            print('[DEBUG] Video page finished loading: ' + url);
          },
          onWebResourceError: (WebResourceError error) {
            print('[DEBUG] Video WebView error: ${error.description}');
          },
        ),
      )
      ..loadHtmlString(htmlContent);

    // Initialize ad controller
    _adController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            print('[DEBUG] Ad page navigation request: ${request.url}');
            
            // Handle special protocols that WebView can't handle
            if (request.url.startsWith('tg://') || 
                request.url.startsWith('whatsapp://') ||
                request.url.startsWith('telegram://') ||
                request.url.startsWith('mailto:') ||
                request.url.startsWith('tel:')) {
              print('[DEBUG] Blocked special protocol: ${request.url}');
              return NavigationDecision.prevent;
            }
            
            // Allow all other navigation for ad content
            print('[DEBUG] Allowing ad navigation to: ${request.url}');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('[DEBUG] Ad page started loading: ' + url);
          setState(() {
              _isAdLoading = true;
          });
          },
          onPageFinished: (String url) {
            print('[DEBUG] Ad page finished loading: ' + url);
            setState(() {
              _isAdLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print('[DEBUG] Ad page WebView error: ${error.description}');
            setState(() {
              _isAdLoading = false;
            });
        },
        ),
      )
      ..loadRequest(Uri.parse(_adUrl));

    // Start the 5-minute refresh timer for the ad page
    _startRefreshTimer();
    }

  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _refreshAdPage();
    });
  }

  void _refreshAdPage() {
    if (mounted) {
      print('[DEBUG] Refreshing ad page after 5 minutes');
      _adController.reload();
    }
  }

  @override
  void dispose() {
    // Reset orientation back to portrait when leaving the page
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Ad page underneath (full screen)
          WebViewWidget(
            controller: _adController,
          ),
          
          // Video player on top (full screen)
          WebViewWidget(
            controller: _videoController,
          ),
          

        ],
      ),
    );
  }
}
