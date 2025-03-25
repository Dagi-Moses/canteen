import 'dart:async';
import 'package:canteen/models/user.dart';
import 'package:canteen/providers/registerProvider.dart';
import 'package:canteen/widgets/cards/otpCard.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class RegistrationCodeVerificationScreen extends StatefulWidget {
  final UserModel user;
  final String password;

  const RegistrationCodeVerificationScreen({
    Key? key, required this.user, required this.password,
    
  }) : super(key: key);
  @override
  State<RegistrationCodeVerificationScreen> createState() =>
      _RegistrationCodeVerificationScreenState();
}

class _RegistrationCodeVerificationScreenState extends State<RegistrationCodeVerificationScreen> {
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
    final regProvider = Provider.of<RegistrationProvider>(context);
    return  OtpCard(
      errorMessage: regProvider.errorMessage,
      onChanged: (value) {
          regProvider.currentText = value;
      },

      email: widget.user.email,
      formKey: formKey,
      errorController: errorController,
      textEditingController: textEditingController,
      onCompleted: (v) {
        regProvider.verifyOtp(
      user: widget.user,
       password: widget.password, 
        app: app,
        context: context,
        errorController: errorController

      
       );
      },
      app: app,
      hasError: regProvider.hasError,
      isLoading: regProvider.isLoading,
      onResend: () async {
        await regProvider.sendOtp(
            resendController: textEditingController,
            isResend: true,
            user: widget.user,
            password: widget.password,
            context: context,
            app: app);
     
      },
      currentText: regProvider.currentText,
    );
  }
}






