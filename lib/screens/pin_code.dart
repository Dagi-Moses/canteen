import 'dart:async';
import 'package:canteen/providers/emailProvider.dart';
import 'package:canteen/widgets/cards/otpCard.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String? email;

  const PinCodeVerificationScreen({
    Key? key,
    this.email,
  }) : super(key: key);
  @override
  State<PinCodeVerificationScreen> createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context)!;
    final emailProvider = Provider.of<EmailProvider>(context);
    return OtpCard(
      errorMessage: emailProvider.errorMessage,
      onChanged: (value) {
        emailProvider.currentText = value;
      },
      email: widget.email,
      formKey: formKey,
      errorController: errorController,
      textEditingController: textEditingController,
      onCompleted: (v) {
        emailProvider.verifyOtp(widget.email!, context, errorController, app);
      },
      app: app,
      hasError: emailProvider.hasError,
      isLoading: emailProvider.isLoading,
      onResend: () async {
        emailProvider.sendOtp(
            resendController: textEditingController,
            isResend: true,
            email: widget.email!,
            context: context,
            app: app);
      },
      currentText: emailProvider.currentText,
    );
  }
}
