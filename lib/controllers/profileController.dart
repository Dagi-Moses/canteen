import 'package:canteen/providers/app_provider.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:canteen/models/user.dart';
import 'package:canteen/providers/userProvider.dart';


class SettingsController extends ChangeNotifier {
  GlobalKey<CSCPickerState> cscPickerKey = GlobalKey();
 late UserProvider userProvider;
 late AppProvider prov;
  TabController ?tabController;
   TextEditingController firstNameController = TextEditingController();
   TextEditingController lastNameController = TextEditingController();
   TextEditingController emailController = TextEditingController();
   TextEditingController phoneController = TextEditingController();
   TextEditingController countryController = TextEditingController();
   TextEditingController cityController = TextEditingController();
   TextEditingController stateController = TextEditingController();
   TextEditingController addressController = TextEditingController();
   TextEditingController zipCodeController = TextEditingController();

  final List<String> languages = [
    "English",
    "Français",
    "Yorùbá",
    "Igbo",
  ];
  final List<String> languageCodes = [
    "en",
    "fr",
    "yo",
    "ig",
  ];

  String? selectedLanguage;

  SettingsController({ required this.userProvider, this.tabController,  required this.prov}) {
    firstNameController = TextEditingController(text: userProvider.user?.firstName );
    lastNameController = TextEditingController(text: userProvider.user?.lastName);
    emailController = TextEditingController(text: userProvider.user?.email);
    phoneController = TextEditingController(text: userProvider.user?.phoneNumber);
    countryController = TextEditingController(text: userProvider.user?.country);
    cityController = TextEditingController(text:userProvider.user?.city);
    addressController = TextEditingController(text:userProvider.user?.address);
    zipCodeController = TextEditingController(text:userProvider.user?.zipCode);
    stateController = TextEditingController(text: userProvider.user?.state);
  }

 void saveChanges() {
    final updatedUser = UserModel(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      country: countryController.text.trim(),
      state: stateController.text.trim(),
      city: cityController.text.trim(),
      address: addressController.text.trim(),
      zipCode: zipCodeController.text.trim(),
    );
    userProvider.updateUser(updatedUser: updatedUser);
  }

  void updateCountry(String value) {
    countryController.text = value;
    notifyListeners();
  }

  void updateState(String value) {
    stateController.text = value;
    notifyListeners();
  }

  void updateCity(String value) {
    cityController.text = value;
    notifyListeners();
  }

  void updateSelectedLanguage(String languageCode) {
    selectedLanguage = languageCode;
    notifyListeners();
  }
void changeLanguage(String? newValue) {
    if (newValue == null) return;
    selectedLanguage = newValue;
    int index = languages.indexOf(newValue);
    prov.setPreferredLanguage(languageCodes[index]);
    notifyListeners();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    countryController.dispose();
    cityController.dispose();
    stateController.dispose();
    addressController.dispose();
    zipCodeController.dispose();
    tabController?.dispose();
    super.dispose();
  }
}
