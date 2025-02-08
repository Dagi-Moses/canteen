import 'package:canteen/providers/firebase%20functions.dart';
import 'package:canteen/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterController {
 
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode usernameFocusNode =  FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final GlobalKey<FormState> formKey= GlobalKey<FormState>();


  void register(
    BuildContext context,
    FirebaseFunctions firebaseFunctions,
    LocationProvider locationProvider,
    AppLocalizations app,
  ) {
    if (formKey.currentState!.validate()) {
      firebaseFunctions.signUpAndStoreUserData(
        firstName: usernameController.text,
        completeAddress: locationController.text,
        email: emailController.text,
        address: locationProvider.address,
        phoneNumber: phoneController.text,
        country: locationProvider.country,
        city: locationProvider.city,
        state: locationProvider.state,
        zipCode: locationProvider.zipCode,
        app: app,
        context: context,
        password: passwordController.text,
      );
    }
  }

  void dispose() {
    usernameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    addressFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
     locationController.dispose();  
     confirmPasswordController.dispose();
     passwordController.dispose();
  }
}
