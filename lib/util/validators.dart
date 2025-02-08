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


// TO COMBINE IT WITH OTHER VALIDATORS


// TextFormField(
//   validator: (val) {
//     String? emailValidation = emailValidator(val);
//     if (emailValidation != null) {
//       return emailValidation;
//     }
//     // Add another validation rule if needed
//     if (val!.length < 3) {
//       return 'Email too short';
//     }
//     return null;
//   },
//   decoration: InputDecoration(labelText: 'Email'),
// ),
