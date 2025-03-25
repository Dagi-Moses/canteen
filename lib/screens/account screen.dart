import 'package:canteen/admin/widgets/simple_dialog.dart';
import 'package:canteen/util/keepAliveWrapper.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:canteen/admin/functions.dart';
import 'package:canteen/controllers/profileController.dart';
import 'package:canteen/models/user.dart';
import 'package:canteen/providers/app_provider.dart';
import 'package:canteen/providers/location_provider.dart';
import 'package:canteen/providers/userProvider.dart';
import 'package:canteen/util/const.dart';
import 'package:canteen/util/routes.dart';
import 'package:canteen/widgets/profileImage.dart';
import 'package:canteen/widgets/textFields/labeledTextField.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  // GlobalKey<CSCPickerState> cscPickerKey = GlobalKey();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  final UserController userController = UserController();
  String? selectedLanguage;

  late TabController tabController;
  late UserProvider userProvider;
  late AppLocalizations app;
  late AppProvider prov;

  late LocationProvider locationProvider;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUserData());
  }

  Future<void> _loadUserData() async {
    final locationProv = Provider.of<LocationProvider>(context, listen: false);
    final userProv = Provider.of<UserProvider>(context, listen: false);
    firstNameController.text = userProv.user?.firstName ?? "";
    lastNameController.text = userProv.user?.lastName ?? "";
    emailController.text = userProv.user?.email ?? "";
    phoneController.text = userProv.user?.phoneNumber ?? "";
    addressController.text = userProv.user?.address ?? "";
    zipCodeController.text = userProv.user?.zipCode ?? "";
    locationProv.setInitialLocation(
      userProv.user?.country ?? "",
      userProv.user?.state ?? "",
      userProv.user?.city ?? "",
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    zipCodeController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void saveChanges() {
    final updatedUser = UserModel(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phoneNumber: phoneController.text,
      country: userProvider.user?.country,
      state: userProvider.user?.state,
      city: userProvider.user?.city,
      address: addressController.text,
      zipCode: zipCodeController.text,
    );

    userController.updateUser(
      userProvider: userProvider,
      updatedUser: updatedUser,
      context: context, // For UI feedback
    );
  }

  void changeLanguage(String? newValue, AppProvider prov) {
    if (newValue == null) return;
    selectedLanguage = newValue;
    int index = languageNames.indexOf(newValue);
    prov.setPreferredLanguage(languageCodes[index]);
  }

  @override
  Widget build(BuildContext context) {
    locationProvider = Provider.of<LocationProvider>(context);
    app = AppLocalizations.of(context)!;
    userProvider = Provider.of<UserProvider>(context);
    prov = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: tabController,
          indicatorColor: Colors.red,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: app.profile),
            Tab(text: app.preferences),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
           KeepAliveWrapper(child: EditProfileForm(context)),
           KeepAliveWrapper(child: _buildPreferences(userProvider, context, app, prov))
        ],
      ),
    );
  }

  Widget _buildCountryPicker(BuildContext context) {
    return CSCPickerPlus(
      showStates: true,
      showCities: true,
      flagState: CountryFlag.ENABLE,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      disabledDropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
      ),
      countryDropdownLabel: locationProvider.country ?? "Country",
      stateDropdownLabel: locationProvider.state ?? "State",
      cityDropdownLabel: locationProvider.city ?? "City",
      selectedItemStyle: TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
      dropdownHeadingStyle: TextStyle(
        color: Colors.black,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
      dropdownItemStyle: TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
      dropdownDialogRadius: 10.0,
      searchBarRadius: 10.0,
      onCountryChanged: (value) {
        locationProvider.updateCountry(value);
      },
      onStateChanged: (value) {
        if (value != null && value.isNotEmpty) {
          locationProvider.updateState(value);
        }
      },
      onCityChanged: (value) {
        if (value != null && value.isNotEmpty) {
          locationProvider.updateCity(value);
        }
      },
    );
  }

  Widget EditProfileForm(BuildContext context) {
    final app = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Center(
        child: ResponsiveWrapper(
          maxWidth: 800,
          defaultScale: false,
          child: Center(
            child: Card(
              color: Colors.white,
              elevation: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                            child: labeledTextField(
                                app.firstName, firstNameController)),
                        SizedBox(width: 16),
                        Expanded(
                            child: labeledTextField(
                                app.lastName, lastNameController)),
                      ],
                    ),
                    labeledTextField(app.email, emailController,
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress),
                    labeledTextField(app.phoneNumber, phoneController,
                        readOnly: true, keyboardType: TextInputType.phone),
                    SizedBox(height: 12),
                    Text(
                      app.personalAddress.toUpperCase(),
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
                            child: labeledTextField(
                                app.address, addressController,
                                keyboardType: TextInputType.multiline)),
                        SizedBox(width: 16),
                        Expanded(
                            child: labeledTextField(
                          app.zipCode,
                          zipCodeController,
                          keyboardType: TextInputType.number,
                        )),
                      ],
                    ),
                    SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          saveChanges();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                        ),
                        child: userProvider.isLoading
                            ? CircularProgressIndicator()
                            : Text(
                                app.saveChanges,
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreferences(
    UserProvider userProvider,
    BuildContext context,
    AppLocalizations app,
    AppProvider prov,
  ) {
    return ResponsiveWrapper(
      maxWidth: 800,
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfilePictureWidget(userProvider, context),

              const SizedBox(height: 30),

              /// **Language Selection Dropdown**
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// **Dropdown Label**

                  ListTile(
                    leading: const Icon(
                      Icons.language,
                      color: Colors.black,
                      size: 30,
                    ),
                    title: Text(
                      prov.selectedLanguageIndex >= 0
                          ? languageNames[prov.selectedLanguageIndex]
                          : app.selectLanguage,
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedLanguage,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.black),
                        isExpanded: false,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        onChanged: (String? newValue) {
                          changeLanguage(newValue, prov);
                        },
                        items: languageNames
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.switch_account,
                      color: Colors.black,
                      size: 30,
                    ),
                    title: Text(
                      'View Admin App',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      if (uid != Constants.admin) {
                        Navigator.pushReplacementNamed(
                            context, Routes.dashboard);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Not an admin"),
                            backgroundColor:
                                Colors.black, // Optional: make it stand out
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                      size: 30,
                    ),
                    title: Text(
                      'Sign Out',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      signout(
                          context: context,
                          onTap: () {
                            firebaseAuth.signOut().then((value) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.join,
                                (route) => false,
                              );
                            });
                          });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureWidget(
      UserProvider userProvider, BuildContext context) {
    return ProfilePictureWidget(
      imageUrl: userProvider.user?.profileImage,
      onTap: () {
        takeImage(context: context);
      },
    );
  }
}
