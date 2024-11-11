
import 'package:canteen/screens/join.dart';
import 'package:canteen/util/const.dart';
import 'package:canteen/util/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:canteen/screens/pin_code.dart';
import 'package:canteen/util/fadeAnimation.dart';

import 'package:canteen/widgets/custom_Textfield.dart';
import 'package:flutter/material.dart';

enum FormData { Email, password }

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {



final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
       final app = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
           colors: [primaryRed, Colors.red.withOpacity(0.8), ],

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
                    width: 400,
                    padding: const EdgeInsets.all(40.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeAnimation(
                          delay: 0.8,
                          child:   Icon(
                            Icons.fastfood,
                            size: 50.0,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeAnimation(
                          delay: 1,
                          child: Text(
                            "Let us help you",
                            style: TextStyle(
                              color: primaryBlack,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _formkey,
                          child: FadeAnimation(delay: 1, child:    CustomTextFormField(
                              controller: emailController,
                              labelText: app.email,
                              prefixIcon: Icons.perm_identity,
                              ispassword: false,
                              validator: (val) {
                                return val!.length < 3 ? app.invalidEmail : null;
                              },
                            ),
                          ),
                        ),
                       
                        const SizedBox(height: 25),
                        FadeAnimation(delay: 1, child:   Container(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              child: 
                                  Text(
                                      app.continueText,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                ,
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.of(context).pushNamed(
                                  Routes.pinCodeVerification,
                                  arguments: '0102756960',
                                );

                            },
                              style: ElevatedButton.styleFrom(
                                
                                minimumSize: Size(double.infinity, 50),
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                        )
                      
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeAnimation(
                  delay: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Want to try again? ",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        
                        },
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                            color: Colors.blue,
                            decorationColor: Colors.blue, 
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                             decoration: TextDecoration.underline,

                             
                          ),
                        ),
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

