final emailValidator = (String? val) {
  String emailPattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
  RegExp regex = RegExp(emailPattern);

  if (val == null || val.isEmpty) {
    return 'Email is required';
  } else if (!regex.hasMatch(val)) {
    return 'Enter a valid email address';
  }
  return null; // Return null if the validation passes
};

class Validators {
  static String? usernameValidator(
      String? val, String usernameLabel, String charLabel) {
    if (val == null || val.length < 5) {
      return "$usernameLabel $charLabel";
    }
    return null;
  }

  static String? emailValidator(String? val, String emailLabel,
      String requiredLabel, String invalidEmailLabel) {
    if (val == null || val.trim().isEmpty) {
      return "$emailLabel $requiredLabel";
    }

    final RegExp emailRegExp =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

    if (!emailRegExp.hasMatch(val)) {
      return invalidEmailLabel;
    }

    return null;
  }

  static String? phoneValidator(String? val, String phoneLabel,
      String requiredLabel, String invalidPhoneLabel) {
    if (val == null || val.isEmpty) {
      return "$phoneLabel $requiredLabel";
    }

    final RegExp phoneRegExp = RegExp(r'^(?:\+234|0)[789][01]\d{8}$');

    if (!phoneRegExp.hasMatch(val)) {
      return invalidPhoneLabel;
    }

    return null;
  }

  static String? addressValidator(String? val, String inputAddressLabel) {
    if (val == null || val.length < 4) {
      return inputAddressLabel;
    }
    return null;
  }

  static String? passwordValidator(String? val, String passwordLabel,
      String requiredLabel, String charLabel) {
    if (val == null || val.isEmpty) {
      return "$passwordLabel $requiredLabel";
    }
    if (val.length < 6) {
      return "$passwordLabel $charLabel";
    }
    return null;
  }

  static String? confirmPasswordValidator(String? val, String? password,
      String requiredLabel, String passwordsDoNotMatchLabel) {
    if (val == null || val.isEmpty) {
      return requiredLabel;
    }
    if (val != password) {
      return passwordsDoNotMatchLabel;
    }
    return null;
  }
}
