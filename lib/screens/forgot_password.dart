import 'package:canteen/providers/emailProvider.dart';
import 'package:canteen/util/const.dart';
import 'package:canteen/util/validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:canteen/widgets/textFields/custom_Textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final bool isForgotPassword;

  const ForgotPasswordScreen({super.key, this.isForgotPassword = false});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context)!;
    final emailProvider = Provider.of<EmailProvider>(context);
    
    void Continue() {
      if (_formkey.currentState!.validate()) {
        String email = emailController.text.trim();
        if (widget.isForgotPassword) {
          emailProvider.sendPasswordResetEmail(email: email, app: app);
        } else {
          emailProvider.sendOtp(
            app: app,
            isResend: false,
            email: email.trim(),
            context: context,
          );
        }
      }
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: emailProvider.isLinkSent
                      ? Card(
                          key: ValueKey('sentCard'),
                          elevation: 5,
                          color: primaryWhite,
                          child: Container(
                            width: 400,
                          
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 20,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: () {
                                      emailProvider.isLinkSent = false; // Reset the flag
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      color:
                                          primaryRed, // Adjust color as needed
                                    ),
                                  ),
                                ),
                                // T
                                Padding(
                                 padding: const EdgeInsets.all(40.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.email,
                                        size: 50.0,
                                        color: primaryRed,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        app.linkSentText, // "Link sent, if the email is registered with us you will get a link to reset your password"
                                        style: TextStyle(
                                          color: primaryBlack,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Card(
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
                                Icon(
                                  Icons.fastfood,
                                  size: 50.0,
                                  color: primaryRed,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  app.letUsHelpU,
                                  style: TextStyle(
                                    color: primaryBlack,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Form(
                                  key: _formkey,
                                  child: CustomTextFormField(
                                    onSubmitted: (_){
                                      Continue();
                                    
                                    },
                                    controller: emailController,
                                    labelText: app.email,
                                    prefixIcon: Icons.perm_identity,
                                    ispassword: false,
                                    validator: emailValidator,
                                    errorText: emailProvider.errorMessage,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: ElevatedButton(
                                    child: emailProvider.isLoading
                                        ? SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator())
                                        : Text(
                                            app.continueText,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                    onPressed: () {Continue();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(double.infinity, 50),
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      app.wantToTryAgain,
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        emailProvider.isLinkSent = false; 
                        emailProvider.errorMessage = null;
                        emailController.clear(); 
                        Navigator.pop(context);
                      },
                      child: Text(
                        app.signIn,
                        style: TextStyle(
                          color: Colors.blue,
                          decorationColor: Colors.blue,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
