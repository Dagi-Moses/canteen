import 'package:canteen/admin/functions.dart';
import 'package:canteen/controllers/profileController.dart';
import 'package:canteen/providers/app_provider.dart';
import 'package:canteen/providers/userProvider.dart';
import 'package:canteen/util/const.dart';
import 'package:canteen/util/routes.dart';
import 'package:canteen/widgets/buttons/customButton.dart';
import 'package:canteen/widgets/profileImage.dart';
import 'package:canteen/widgets/textFields/labeledTextField.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late UserProvider userProvider;
  late AppLocalizations app;
  late AppProvider prov;
  late SettingsController controller;
 
  @override
  Widget build(BuildContext context) {
    controller = Provider.of<SettingsController>(context);
    controller.tabController = TabController(length: 2, vsync: this);
    app = AppLocalizations.of(context)!;
    userProvider = Provider.of<UserProvider>(context);
    prov = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: controller.tabController,
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
        controller: controller.tabController,
        children: [
          EditProfileForm(context),
          _buildPreferences(userProvider, context, app, prov)
        ],
      ),
    );
  }

  Widget _buildCountryPicker(BuildContext context) {

    return Column(
      children: [
        CSCPicker(
          showStates: true,
          showCities: true,
          flagState: CountryFlag.ENABLE,
          dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 1,
              )),
          disabledDropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1)),
          countrySearchPlaceholder: controller.countryController.text,
          stateSearchPlaceholder: controller.stateController.text,
          citySearchPlaceholder: controller.cityController.text,
          // countryDropdownLabel: userProvider?.country ?? "Country",
          // stateDropdownLabel: userProvider?.state ?? "State",
          // cityDropdownLabel: userProvider?.city ?? "City",
          selectedItemStyle: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          dropdownHeadingStyle: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          dropdownItemStyle: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          dropdownDialogRadius: 10.0,
          searchBarRadius: 10.0,
          onCountryChanged: (value) {
          controller.updateCountry(value);
          },
          onStateChanged: (value) {
            if (value != null && value.isNotEmpty) {
             controller.updateState(value);
            }
          },
          onCityChanged: (value) {
    
              if (value != null && value.isNotEmpty) {
              controller.updateCity(value);
              }
            
          },
        ),
      ],
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
                                app.firstName, controller.firstNameController)),
                        SizedBox(width: 16),
                        Expanded(
                            child: labeledTextField(
                                app.lastName, controller.lastNameController)),
                      ],
                    ),
                    labeledTextField(app.email, controller.emailController,
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress),
                    labeledTextField(app.phoneNumber, controller.phoneController,
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
                                app.address, controller.addressController,
                                keyboardType: TextInputType.multiline)),
                        SizedBox(width: 16),
                        Expanded(
                            child: labeledTextField(
                          app.zipCode,
                          controller.zipCodeController,
                          keyboardType: TextInputType.number,
                        )),
                      ],
                    ),
                    SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.saveChanges();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                        ),
                        child: Text(
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

  Widget _buildPreferences(UserProvider userProvider, BuildContext context,
      AppLocalizations app, AppProvider prov) {
    return ResponsiveWrapper(
      maxWidth: 800,
      child: Card(
        color: Colors.white,
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfilePictureWidget(userProvider, context),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                label: app.logOut,
                onTap: () async {
                  await firebaseAuth.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.join,
                    (route) => false,
                    arguments: {'canPop': false},
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red, width: 2.0)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    iconSize: 30,

                    value: controller.selectedLanguage,
                    onChanged: (String? newValue) {
                     controller.changeLanguage(newValue);
                    },
                    hint: Text(
                      prov.selectedLanguageIndex >= 0
                          ? controller.languages[prov.selectedLanguageIndex]
                          : app.selectLanguage, //
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ), // Default hint text
                    isExpanded:
                        true, // Make the dropdown fill the available width
                    style: TextStyle(
                        color: Colors.black, fontSize: 16.0), // Extra styling

                    items:
                       controller.languages.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ));
                    }).toList(),
                  ),
                ),
              ),
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
