import 'package:canteen/controllers/registerController.dart';
import 'package:canteen/models/user.dart';
import 'package:canteen/providers/firebase%20functions.dart';
import 'package:canteen/providers/location_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/textFields/textfield.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
   RegisterController controller = RegisterController();


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

 
  bool obscure = true;


  @override
  Widget build(BuildContext context) {

    final locationProvider = Provider.of<LocationProvider>(context);
    final firebaseFunctions = Provider.of<FirebaseFunctions>(context, listen: false);
    final app = AppLocalizations.of(context)!;
    

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: SingleChildScrollView(
        child: ResponsiveWrapper(
          maxWidth: 400,
          child: Form(
            key: controller.formKey,
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
                  controller: controller.usernameController,
                  icon: Icons.perm_identity,
                  hintText: app.username,
                  validator: (val) {
                    return val!.length < 5 ? app.username + " " + app.char : null;
                  },
                   onSubmitted: (_) {
                    // Move to next field when "Enter" is pressed
                    FocusScope.of(context).requestFocus(controller.emailFocusNode);
                  },

                ),
                const SizedBox(height: 10.0),
                TextInput(
                  focusNode: controller.emailFocusNode,
                  icon: Icons.mail_outline,
                  controller: controller.emailController,
                 validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return app.email +
                          " " + app.required; // Ensures field is not empty
                    }

                    // Standard email regex validation
                    final RegExp emailRegExp = RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

                    if (!emailRegExp.hasMatch(val)) {
                      return app.invalidEmail ;
                    }

                    return null;
                  },


                   onSubmitted: (_) {
                    // Move to next field when "Enter" is pressed
                    FocusScope.of(context).requestFocus(controller.phoneFocusNode);
                  },

                  hintText: app.email,
                  
                ),
                const SizedBox(height: 10.0),
                TextInput(
                  focusNode: controller.phoneFocusNode,
                  icon: Icons.phone_outlined,
                  controller: controller.phoneController,
                  hintText: app.phoneNumber,
                   onSubmitted: (_) {
                    // Move to next field when "Enter" is pressed
                    FocusScope.of(context).requestFocus(controller.addressFocusNode);
                  },

                 validator: (val) {
                    if (val == null || val.isEmpty) {
                      return app.phoneNumber + " " + app.required;
                    }

                    // Nigerian phone number regex
                    final RegExp phoneRegExp =
                        RegExp(r'^(?:\+234|0)[789][01]\d{8}$');

                    if (!phoneRegExp.hasMatch(val)) {
                      return app.invalidPhoneNumber ;
                          
                    }

                    return null;
                  },

                ),
                const SizedBox(height: 10.0),
                Consumer<LocationProvider>(
                  builder: (context, locationProvider, child) {
                    controller.locationController.text =
                        locationProvider.completeAddress ?? "";
                    return TextInput(
                      focusNode: controller.addressFocusNode,
                      icon: Icons.home_outlined,
                      controller: controller.locationController,
                      hintText: locationProvider.completeAddress ?? app.address,
                       onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(controller.passwordFocusNode);
                      },

                      obscureText: false,
                      validator: (val) {
                        return val!.length < 4 ? app.inputAddress : null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 10.0),
                TextInput(
                  focusNode: controller.passwordFocusNode,
                  controller: controller.passwordController,
                  icon: Icons.lock_outline,
                  hintText: app.password,
                   onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(controller.confirmPasswordFocusNode);
                  },

                  obscureText: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return app.password + " " + app.required;
                    }
                    if (val.length < 6) {
                      return app.password +
                          " " +
                          app.char; // "Password must be more than six characters"
                    }
                    return null;
                  },
                  // validator: (val) {
                  //   return val!.length < 4 ? app.password + app.char : null;
                  // },
                ),
                const SizedBox(height: 10.0),
                TextInput(
                  focusNode: controller.confirmPasswordFocusNode,
                  icon: Icons.lock_outline,
                  controller: controller.confirmPasswordController,
                  hintText: app.confirm,
                   validator: (val) {
                    if (val == null || val.isEmpty) {
                      return app.required;
                    }
                    if (val != controller.passwordController.text) {
                      return app.passwordsDoNotMatch ;
                          
                    }
                    return null;
                  },
                   onSubmitted: (_) {
                 controller.register(
                  context,
                  firebaseFunctions,
                  locationProvider,
                  app

                 );
                  },

                  obscureText: true,
                ),
                const SizedBox(height: 40.0),
                SizedBox(
                  height: 50.0,
                  child: ElevatedButton(
                    child: !firebaseFunctions.isRegisterLoading
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
                    onPressed: () {
                    controller.register(
                          context, firebaseFunctions, locationProvider, app);
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
