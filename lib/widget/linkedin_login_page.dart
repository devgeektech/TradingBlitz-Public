// import 'package:flutter/material.dart';
// import 'package:linkedin_login/src/utils/startup/injector.dart';
// import 'package:linkedin_login/src/webview/actions.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// typedef OnUrlMatch = ValueChanged<DirectionUrlMatch>;
// typedef OnCookieClear = ValueChanged<bool>?;
//
// /// Class will fetch code and access token from the user
// /// It will show web view so that we can access to linked in auth page
// class LinkedInWebViewHandler extends StatefulWidget {
//   const LinkedInWebViewHandler({
//     required this.onUrlMatch,
//     this.appBar,
//     this.destroySession = false,
//     this.onCookieClear,
//     this.useVirtualDisplay = false,
//     super.key,
//   });
//
//   final bool destroySession;
//   final PreferredSizeWidget? appBar;
//   final OnUrlMatch onUrlMatch;
//   final OnCookieClear? onCookieClear;
//   final bool useVirtualDisplay;
//
//
//   @override
//   State<LinkedInWebViewHandler> createState() => _LinkedInWebViewHandlerState();
// }
//
// class _LinkedInWebViewHandlerState extends State<LinkedInWebViewHandler> {
//   dynamic controller1;
//   WebViewController? _webViewController; // Store the built controller
//   bool _isInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize in initState instead of build
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeController();
//     });
//   }
//
//   void _initializeController() {
//     if (_isInitialized) return;
//
//     debugPrint('Initializing LinkedIn WebView Controller');
//
//     controller1 = InjectorWidget
//         .of(context)
//         .webViewControllerBuilder
//       ..clearCookies(
//         destroySession: widget.destroySession,
//       );
//
//     // Build the controller ONCE and store it
//     _webViewController = controller1.controllerBuilder(
//       onUrlMatch: widget.onUrlMatch,
//     );
//
//     _isInitialized = true;
//   }
//
//   @override
//   void dispose() {
//     _isInitialized = false;
//     _webViewController = null;
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_isInitialized) {
//       _initializeController();
//     }
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: widget.appBar,
//       body: _webViewController != null
//           ? WebViewWidget(
//         controller: _webViewController!, // Use stored controller
//       )
//           : const Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }