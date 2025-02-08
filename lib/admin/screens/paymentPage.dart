import 'package:canteen/models/order%20request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../providers/firebase functions.dart';

class PaymentPage extends StatefulWidget {
  final String note;
PaymentPage({super.key, required this.note});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    final firebaseFunctions =
        Provider.of<FirebaseFunctions>(context, listen: false);

      final app = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
              future: firebaseFunctions.initializeTransaction(context: context),
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
                                    await firebaseFunctions.verifyPaystackTransaction(reference);

                                if (isTransactionSuccessful) {
                                  firebaseFunctions.buyAllItemsInCart(context: context, note: widget.note, paymentMethod: PaymentMethod.paystack, app:app);
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
