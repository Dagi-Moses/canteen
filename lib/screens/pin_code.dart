import 'dart:async';
import 'package:canteen/providers/emailProvider.dart';
import 'package:canteen/util/const.dart';
import 'package:canteen/util/fadeAnimation.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String? phoneNumber;

  const PinCodeVerificationScreen({
    Key? key,
    this.phoneNumber,
  }) : super(key: key);
  @override
  State<PinCodeVerificationScreen> createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
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

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
       final app = AppLocalizations.of(context)!;
      final emailProvider = Provider.of<EmailProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
         //   stops: const [0.1, 0.4, 0.7, 0.9],
            colors: [
               primaryRed,
              primaryRed.withOpacity(0.8),
            ],
          ),
          
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 5,
                      color: primaryWhite,
                  child: Container(
                    width: 500,
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          Icon(
                          Icons.fastfood,
                          size: 50.0,
                          color: primaryRed,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                          delay: 1,
                          child: Text(
                            app.letUsHelpU,
                            style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 0.5),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                         Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            app.otpVerification,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8),
                          child: RichText(
                            text: TextSpan(
                                text: app.enterTheCode,
                                children: [
                                  TextSpan(
                                      text: "${widget.phoneNumber}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 15)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: formKey,
                          child: PinCodeTextField(
                            appContext: context,
                            pastedTextStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            length: 6,
                            obscureText: true,
                            obscuringCharacter: '*',
                            obscuringWidget: const Icon(
                              Icons.pets,
                              color: Colors.blue,
                              size: 24,
                            ),
                            blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                           
                              validator: (value) {
                              if (value == null || value.length < 6) {
                                return app.validOtp;
                              }
                              return null;
                            },
                            
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                                inactiveFillColor: Colors.white),
                            cursorColor: Colors.black,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            enableActiveFill: true,
                            errorAnimationController: errorController,
                            controller: textEditingController,

                            keyboardType: TextInputType.number,
                            boxShadows: const [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                            onCompleted: (v) {
                               emailProvider.verifyOtp(
                                widget.phoneNumber!,
                                currentText,
                                context,
                                errorController,
                                app
                              );
                            },
                            // onTap: () {
                            //   print("Pressed");
                            // },
                            onChanged: (value) {
                              debugPrint(value);
                              setState(() {
                                currentText = value;
                              });
                            },
                            beforeTextPaste: (text) {
                              //debugPrint("Allowing to paste $text");
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return true;
                            },
                          ),
                        ),
                      
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            hasError ||  (emailProvider.errorMessage?.isNotEmpty ??
                                        false)
                                ?emailProvider.errorMessage?? app.fillUpAllCells
                                : "",
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           Text(
                              app.didntRecieve,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15),
                            ),
                            TextButton(
                              onPressed: ()async {
                                await   emailProvider.sendOtp(
                                
                               resendController: textEditingController,
                                 isResend: true,
                                  email: widget.phoneNumber!,
                                  context: context,
                                  app: app
                              
                              );
                                snackBar(app.otpResent);
                                },
                              child:  Text(
                               app.resend,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                         ElevatedButton(
                           child:   emailProvider.isLoading
                                           ? SizedBox(
                                             height: 30,
                                             width: 30,
                                             child: CircularProgressIndicator()): Text(
                             app.verify,
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0.5,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                         
                             onPressed: () {
                              formKey.currentState!.validate();
                              // conditions for validating
                              if (currentText.length != 6
                                  ) {
                                errorController!.add(ErrorAnimationType
                                    .shake); // Triggering error shake animation
                               
                              } else {
                             emailProvider.verifyOtp(
                                widget.phoneNumber!,
                                currentText,
                                context,
                                errorController,
                                app
                              );
                              }
                            },
                         
                           style: ElevatedButton.styleFrom(
                             minimumSize: Size(200, 50),
                             backgroundColor: Colors.red,
                           ),
                         ),
                       
                      ],
                    ),
                  ),
                ),

                //End of Center Card
                //Start of outer card
                const SizedBox(
                  height: 20,
                ),

                FadeAnimation(
                  delay: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(app.wantToTryAgain,
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0.5,
                          )),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                       
                        },
                        child: Text(app.signIn,
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
