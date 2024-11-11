import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../util/firebase functions.dart';
import '../widgets/textfield.dart';




class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameControl = TextEditingController();
  final TextEditingController _emailControl = TextEditingController();
  final TextEditingController _passwordControl = TextEditingController();
  final TextEditingController _phoneControl = TextEditingController();
  final TextEditingController _confirmPasswordControl = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool isloading = false;
  bool obscure = true;
  final _formkey = GlobalKey<FormState>();
 
  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: SingleChildScrollView(
        child: ResponsiveWrapper(
          maxWidth: 400,
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    top: 25.0,
                  ),
                  child: Text(
                    app.createAnAccount,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                TextInput(
                  controller: _usernameControl,
                  icon: Icons.perm_identity,
                  hintText: app.username,
                  validator: (val) {
                    return val!.length < 3 ? app.char : null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextInput(
                  icon: Icons.mail_outline,
                  controller: _emailControl,
                  hintText: app.email,
                  validator: (val) {
                    return val!.length < 5 ? app.invalidEmail : null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextInput(
                  icon: Icons.phone_outlined,
                  controller: _phoneControl,
                  hintText: app.phoneNumber,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return app.required;
                    }
          
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextInput(
                  icon: Icons.home_outlined,
                  controller: locationController,
                  hintText: app.address,
                  obscureText: false,
                  validator: (val) {
                    return val!.length < 4 ? app.inputAddress : null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextInput(
                  controller: _passwordControl,
                  icon: Icons.lock_outline,
                  hintText: app.password,
                  obscureText: true,
                  validator: (val) {
                    return val!.length < 4 ? app.password + app.char : null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextInput(
                  icon: Icons.lock_outline,
                  controller: _confirmPasswordControl,
                  hintText: app.confirm,
                  obscureText: true,
                ),
                const SizedBox(height: 40.0),
                SizedBox(
                  height: 50.0,
                  child: ElevatedButton(
                    child: !isloading
                        ? Text(
                            app.register.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator()),
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        try {
                          await signUpAndStoreUserData(
                            _usernameControl.text,
                            // _phoneController.text,
                            _emailControl.text,
                            _passwordControl.text,
                            _phoneControl.text,
                            context,
          
                            locationController.text,
          
                            (loading) {
                              setState(() {
                                isloading = loading;
                              });
                            },
                          );
                        } catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
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
