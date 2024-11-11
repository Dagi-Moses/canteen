import 'package:canteen/admin/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:canteen/providers/app_provider.dart';

import 'package:canteen/util/const.dart';

import '../admin/functions.dart';

import '../admin/widgets/simple_dialog.dart';
import '../providers/provider.dart';
import 'join.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  String? selectedObject;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(
      context,
    );
    final app = AppLocalizations.of(context)!;
    final prov = Provider.of<AppProvider>(context, listen: false);
    return Material(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Row(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              offset: const Offset(-1, 10),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            takeImage(context: context);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[600],
                            backgroundImage: userProvider.profileImage != ""
                                ? NetworkImage(userProvider.profileImage!)
                                : null,
                            child: userProvider.profileImage == ''
                                ? const Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.black,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            userProvider.name,
                            style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            userProvider.email,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      LayoutBuilder(builder: (context, constraints) {
                        return Flex(
                          direction: constraints.maxWidth > 150
                              ? Axis.vertical
                              : Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            uid == Constants.admin
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (c) => const DashBoard(),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      elevation: 6.0,
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth:
                                              190, // Set your desired maximum width
                                        ),
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Text(
                                          app.viewAdminApp,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () async {
                                signout(
                                    context: context,
                                    onTap: () async {
                                      await firebaseAuth.signOut();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JoinApp(
                                                  canPop: false,
                                                )),
                                        (route) => false,
                                      );
                                    });
                              },
                              child: Card(
                                elevation: 6.0,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        100, // Set your desired maximum width
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                  child: Text(
                                    app.logOut,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ],
              ),
              const Divider(),
              Container(height: 15.0),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  app.accountInformation.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildEditableField(
                label: app.fullName,
                provider: userProvider.name,
                hintText: app.noName,
                onSubmitted: (String value) {
                  if (value.trim().isNotEmpty) {
                    userProvider.updateUserName(value);
                  }
                },
              ),
              _buildEditableField(
                label: app.email,
                provider: userProvider.email,
                hintText: app.noEmail,
                onSubmitted: (String value) {
                  if (value.trim().isNotEmpty) {
                    userProvider.updateUserEmail(value);
                  }
                },
              ),
              _buildEditableField(
                label: app.phone,
                provider: userProvider.phoneNumber,
                hintText: app.noPhoneNumber,
                onSubmitted: (String value) {
                  if (value.trim().isNotEmpty) {
                    userProvider.updatePhoneNumber(value);
                  }
                },
              ),
              _buildEditableField(
                label: app.address,
                provider: userProvider.address,
                hintText: app.noAddress,
                onSubmitted: (String value) {
                  if (value.trim().isNotEmpty) {
                    userProvider.updateUserAddress(value);
                  }
                },
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
      
                    value: selectedObject,
                    onChanged: (String? newValue) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          selectedObject = newValue;
                          int index = languages.indexOf(
                              newValue!); // Find the index of the selected language
      
                          prov.setPreferredLanguage(languageCodes[index]);
                        });
                      });
                    },
                    hint: Text(
                      selectedObject ?? app.selectLanguage,
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
                        languages.map<DropdownMenuItem<String>>((String value) {
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
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? const SizedBox()
                  : ListTile(
                      title: Text(
                        app.darkTheme,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      trailing: Switch(
                        value: Provider.of<AppProvider>(context).theme ==
                                Constants.lightTheme
                            ? false
                            : true,
                        onChanged: (v) async {
                          // if (v) {
                          //   Provider.of<AppProvider>(context, listen: false)
                          //       .setTheme(Constants.darkTheme, "dark");
                          // } else {
                          //   Provider.of<AppProvider>(context, listen: false)
                          //       .setTheme(Constants.lightTheme, "light");
                          // }
                        },
                        activeColor: Colors.red,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildEditableField({
  required String label,
  required String? provider,
  required String hintText,
  required Function(String) onSubmitted,
}) {
  FocusNode focusNode = FocusNode();
  return ListTile(
    title: Text(
      label,
      style:  TextStyle(
        fontSize: 17,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
    ),
    subtitle: TextFormField(
      
      focusNode: focusNode,
      onFieldSubmitted: onSubmitted,
      style: TextStyle(
        color: Colors.grey[900], // Change the color here
      ),
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: Colors.grey[900], // Change the color here
        ),
        hintText: provider!.isNotEmpty ? provider : hintText,
        border: InputBorder.none,
      ),
    ),
    trailing: IconButton(
        onPressed: () {
          focusNode.requestFocus();
        },
        icon: const Icon(Icons.edit)),
  );
}

