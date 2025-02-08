import 'package:canteen/admin/functions.dart';
import 'package:canteen/models/user.dart';

import 'package:canteen/providers/app_provider.dart';
import 'package:canteen/providers/userProvider.dart';

import 'package:csc_picker/csc_picker.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
  late TabController _tabController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController countryController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController addressController;
  late TextEditingController zipCodeController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final user = Provider.of<UserProvider>(context, listen: false).user!;

    firstNameController = TextEditingController(text: user.firstName);
    lastNameController = TextEditingController(text: user.lastName);
    emailController = TextEditingController(text: user.email);
    phoneController = TextEditingController(text: user.phoneNumber);
    countryController = TextEditingController(text: user.country);
    cityController = TextEditingController(text: user.city);
    addressController = TextEditingController(text: user.address);
    zipCodeController = TextEditingController(text: user.zipCode);
    stateController = TextEditingController(text: user.state);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    stateController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    countryController.dispose();
    cityController.dispose();
    addressController.dispose();
    zipCodeController.dispose();
    _tabController.dispose();
    super.dispose();
  }


  void saveChanges() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
  final updatedUser = UserModel(
      //completeAddress: ,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      country: countryController.text.trim(),
      state: stateController.text.trim(),
      city: cityController.text.trim(),
      address: addressController.text.trim(),
      zipCode: zipCodeController.text.trim(),


  );
    // Update User Data in Provider
    userProvider.updateUser(
   updatedUser: updatedUser
    );

  }


  @override
  Widget build(BuildContext context) {
    // final app = AppLocalizations.of(context)!;
    // final prov = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          indicatorColor: Colors.red,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: 'Edit Profile'),
            Tab(text: 'Preferences'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          EditProfileForm(context),
          PreferencesScreen(),
        ],
      ),
    );
  }

  Widget _buildCountryPicker(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(
      context,
    ).user;
    return Column(
      children: [
        ///Adding CSC Picker Widget in app
        CSCPicker(
          ///Enable disable state dropdown [OPTIONAL PARAMETER]
          showStates: true,

          /// Enable disable city drop down [OPTIONAL PARAMETER]
          showCities: true,

          ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
          flagState: CountryFlag.DISABLE,

          ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
          dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1)),

          ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
          disabledDropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1)),

          ///placeholders for dropdown search field
          countrySearchPlaceholder: countryController.text,
          stateSearchPlaceholder: stateController.text,
          citySearchPlaceholder: cityController.text,

          // currentCountry: countryController.text,
          // currentCity: cityController.text,
          // currentState: stateController.text,

          ///labels for dropdown
          countryDropdownLabel: userProvider?.country ?? "Country",
          stateDropdownLabel: userProvider?.state ?? "State",
          cityDropdownLabel: userProvider?.city ?? "City",

          ///Default Country
          defaultCountry: CscCountry.Nigeria,

          ///Country Filter [OPTIONAL PARAMETER]
          //countryFilter: [CscCountry.India,CscCountry.United_States,CscCountry.Canada],

          ///Disable country dropdown (Note: use it with default country)
          //disableCountry: true,

          ///selected item style [OPTIONAL PARAMETER]
          selectedItemStyle: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),

          ///DropdownDialog Heading style [OPTIONAL PARAMETER]
          dropdownHeadingStyle: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),

          ///DropdownDialog Item style [OPTIONAL PARAMETER]
          dropdownItemStyle: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),

          ///Dialog box radius [OPTIONAL PARAMETER]
          dropdownDialogRadius: 10.0,

          ///Search bar radius [OPTIONAL PARAMETER]
          searchBarRadius: 10.0,

          ///triggers once country selected in dropdown
          onCountryChanged: (value) {
            setState(() {
              ///store value in country variable
              countryController.text = value;
            });
          },

          ///triggers once state selected in dropdown
          onStateChanged: (value) {
            if (value != null && value.isNotEmpty) {
              setState(() {
                /// Store value in state variable
                stateController.text = value;
              });
            }
          },

          ///triggers once city selected in dropdown
          onCityChanged: (value) {
            setState(() {
              if (value != null && value.isNotEmpty) {
                cityController.text = value;
              }

              ///store value in city variable
            });
          },

          ///Show only specific countries using country filter
          // countryFilter: ["United States", "Canada", "Mexico"],
        ),

        ///print newly selected country state and city in Text Widget
      ],
    );
  }

  Widget EditProfileForm(BuildContext context) {
    final app = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: ResponsiveWrapper(
        maxWidth: 800,
        defaultScale: false,
        child: Center(
          child: Card(
            color: Colors.white,
            elevation: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circular Avatar
                  _buildProfilePictureWidget(context),
                  SizedBox(width: 32),
                  // Form Fields
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          app.accountInformation.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                                    'First Name', firstNameController)),
                            SizedBox(width: 16),
                            Expanded(
                                child: _buildTextField(
                                    'Last Name', lastNameController)),
                          ],
                        ),
                        _buildTextField('Email Address', emailController,
                            readOnly: true,
                            keyboardType: TextInputType.emailAddress),
                        _buildTextField('Phone Number', phoneController,
                            readOnly: true, keyboardType: TextInputType.phone),
                        SizedBox(height: 12),
                        Text(
                          'Personal Address'.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildCountryPicker(context),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                                    'Address', addressController,
                                    keyboardType: TextInputType.multiline)),
                            SizedBox(width: 16),
                            Expanded(
                                child: _buildTextField(
                              'Zip Code',
                              zipCodeController,
                              keyboardType: TextInputType.number,
                            )),
                          ],
                        ),
                        SizedBox(height: 32),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {saveChanges() ;},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 14),
                            ),
                            child: Text(
                              'Save Changes',
                              style: TextStyle(color: Colors.white),
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
      ),
    );
  }
}

Widget _buildProfilePictureWidget(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(
    context,
  );

  return Stack(
    alignment: Alignment.bottomRight,
    children: [
      // Circular Container or Avatar
      Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[600]!, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipOval(
            child: Image.network(
          userProvider.user!.profileImage!,
          fit: BoxFit.cover,
          width: 120,
          height: 120,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child; // Image loaded
            } else {
              return _buildPlaceholder();
            }
          },
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            return _buildPlaceholder();
          },
        )),
      ),

      // Camera Icon
      Positioned(
        right: 4,
        bottom: 4,
        child: GestureDetector(
          onTap: () {
            takeImage(context: context);
          },
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    ],
  );
}

// Placeholder Widget
Widget _buildPlaceholder() {
  return Container(
    color: Colors.grey[300],
    child: Center(
      child: Icon(
        Icons.person,
        size: 80,
        color: Colors.grey[600],
      ),
    ),
  );
}

Widget _buildTextField(
  String labelText,
  TextEditingController controller, {
  bool readOnly = false,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
      SizedBox(height: 6),
      TextField(
        cursorColor: Colors.red,
        keyboardType: keyboardType,
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
      SizedBox(height: 16),
    ],
  );
}

class PreferencesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Preferences Settings Here',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}
