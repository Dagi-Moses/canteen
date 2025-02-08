import 'package:canteen/providers/firebase%20functions.dart';
import 'package:canteen/util/routes.dart';
import 'package:canteen/widgets/custom_Textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // Create FocusNodes for both text fields
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
  
  final TextEditingController _emailControl = TextEditingController();
  final TextEditingController _passwordControl = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    final firebaseFunctions =
        Provider.of<FirebaseFunctions>(context, );

    final app = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: SingleChildScrollView(
        child: ResponsiveWrapper(
          maxWidth: 400,
          child: Form(
            key: _formkey,
            child:
              Center(
                child: Column(
               mainAxisSize: MainAxisSize.min,
                
                  mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        top: 25.0,
                      ),
                      child: Text(
                        app.loginToAccount,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                         
                    CustomTextFormField( 
                      errorText: firebaseFunctions.loginErrorMsg
                      ,
                      focusNode: _emailFocusNode,
                       onSubmitted: (_) {
                      // Move to next field when "Enter" is pressed
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },

                      controller:   _emailControl, labelText: app.email, prefixIcon: Icons.perm_identity,ispassword: false,   validator: (val) {
                            return val!.length < 3 ? app.invalidEmail : null;
                          } , ),
                          // SizedBox(height: 10.0),
                    CustomTextFormField(
                        errorText: firebaseFunctions.loginErrorMsg,
                      onSubmitted: (_){
                        if (_formkey.currentState!.validate()) {
                       firebaseFunctions.signInUser(
                            email: _emailControl.text,
                            password: _passwordControl.text,
                            context: context,
                            app: app);
                      }

                      },
                      focusNode: _passwordFocusNode,
                       controller:   _passwordControl, labelText: app.password, prefixIcon:   Icons.lock_outline,ispassword: true,   validator: (val) {
                            return val!.length < 3 ? app.invalidPassword : null; 
                          },),
                               
                   
                    SizedBox(height: 10.0),
                      
                    Row(children: [
                        GestureDetector(
                          onTap: (() {
                            // Navigator.pop(context);
                            Navigator.of(context)
                                .pushNamed(Routes.forgotPassword);
                          }),
                          child: Text(app.cantLogin,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                               
                                color: Colors.blue,
                                  decorationColor: Colors.blue,// Underline color
                              decorationThickness: 2, 
                                letterSpacing: 0.5,
                              )),
                        ),
                    ],),
                    Container(
                     // alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text(
                          app.forgotPassword,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                              
                          ),
                        ),
                        onPressed: () {

                        Navigator.of(context).pushNamed(Routes.forgotPassword,
                         arguments: true,
                        );
                        },
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Container(
                      alignment: Alignment.bottomCenter,
                    
                      child: ElevatedButton(
                        
                        child: !firebaseFunctions.isLoading
                            ? Text(
                                app.login.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            : SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(),
                              ),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                          firebaseFunctions.signInUser(
                              email: _emailControl.text,
                              password: _passwordControl.text,
                              context: context,
                          
                              app:app
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50), 
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
            ),
        ),
        ),
      );
    
  }
}
