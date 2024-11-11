

import 'package:canteen/util/routes.dart';
import 'package:canteen/widgets/custom_Textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import '../util/firebase functions.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final TextEditingController _emailControl = TextEditingController();
  final TextEditingController _passwordControl = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
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
                
                  mainAxisAlignment: MainAxisAlignment.start,
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
                         
                    CustomTextFormField( controller:   _emailControl, labelText: app.email, prefixIcon: Icons.perm_identity,ispassword: false,   validator: (val) {
                            return val!.length < 3 ? app.invalidEmail : null;
                          } , ),
                          // SizedBox(height: 10.0),
                    CustomTextFormField( controller:   _passwordControl, labelText: app.password, prefixIcon:   Icons.lock_outline,ispassword: true,   validator: (val) {
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
                          child: Text("Can't login? use OTP",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
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
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Container(
                      alignment: Alignment.bottomCenter,
                    
                      child: ElevatedButton(
                        
                        child: !isLoading
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
                            signInUser(
                              email: _emailControl.text,
                              password: _passwordControl.text,
                              context: context,
                              setIsLoading: (loading) {
                                setState(() {
                                  isLoading = loading;
                                });
                              },
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
