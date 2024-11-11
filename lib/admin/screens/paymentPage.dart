import 'package:canteen/models/order%20request.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';
import '../../util/firebase functions.dart';

class PaymentPage extends StatefulWidget {
  final String note;
PaymentPage({super.key, required this.note});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
              future: initializeTransaction(context: context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<String> parts = snapshot.data!.split('|');
                  final String url = parts[0];
                  final String reference = parts[1];
                  // final url = snapshot.data;
                  if (url != null &&
                      (url.startsWith('http://') ||
                          url.startsWith('https://'))) {
                    return WebViewWidget(
                        controller: WebViewController()
                          ..setJavaScriptMode(JavaScriptMode.unrestricted)
                          ..setBackgroundColor(const Color(0x00000000))
                          ..setNavigationDelegate(
                            NavigationDelegate(
                              onProgress: (int progress) {},
                              onPageStarted: (String url) {},
                              onPageFinished: (String url) async {
                                bool isTransactionSuccessful =
                                    await verifyPaystackTransaction(reference);

                                if (isTransactionSuccessful) {
                                  buyAllItemsInCart(context: context, note: widget.note, paymentMethod: PaymentMethod.paystack);
                                }
                              },
                              onWebResourceError: (WebResourceError error) {},
                              onNavigationRequest: (NavigationRequest request) {
                                if (request.url
                                    .startsWith('https://www.youtube.com/')) {
                                  return NavigationDecision.prevent;
                                }
                                return NavigationDecision.navigate;
                              },
                            ),
                          )
                          ..loadRequest(Uri.parse(url)));
                  } else {
                    return Center(child: Text(url));
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
              })),
    );
  }
}
