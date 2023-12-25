// ignore_for_file: library_prefixes

import 'dart:io';

import 'package:canteen/models/menus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:canteen/admin/screens/home_screen.dart';
import 'package:canteen/admin/widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

import '../widgets/error_dialog.dart';

class MenusUploadScreen extends StatefulWidget {
  const MenusUploadScreen({Key? key}) : super(key: key);

  @override
  _MenusUploadScreenState createState() => _MenusUploadScreenState();
}

class _MenusUploadScreenState extends State<MenusUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String? selectedObject;

  bool uploading = false;

  //unique id for menus
  String uniqueIdName = DateTime.now().toString();

  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset(-2.0, 0.0),
              end: FractionalOffset(5.0, -1.0),
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFFAC898),
              ],
            ),
          ),
        ),
        title: Text(
          "Add New Menu".toUpperCase(),
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(
            Icons.home,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => const HomeScreen(),
              ),
            );
          },
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset(-2.0, 0.0),
            end: FractionalOffset(4.0, -1.0),
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFAC898),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shop_two,
                color: Colors.black,
                size: 150,
              ),
              ElevatedButton(
                onPressed: () async {
                  await takeImage(context);
                },
                child: const Text(
                  "Add New Menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.orange),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  takeImage(mcontext) {
    return showDialog(
        context: mcontext,
        builder: (c) {
          return SimpleDialog(
            title: const Text(
              "Menu Image",
              style:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: const Text(
                  "Capture with Camera",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Select from Gallery",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: const Center(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

//capture with camera
  captureImageWithCamera() async {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

//select image from gallery
  pickImageFromGallery() async {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXFile;
    });
  }

  menusUploadFormScreen() {
    List<String> category = [
      'Drinks',
      'Miscellaneous',
      'Desert',
      'Fast Food',
      'Meals'
    ];

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset(-2.0, 0.0),
                end: FractionalOffset(5.0, -1.0),
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFAC898),
                ],
              ),
            ),
          ),
          title: Text(
            "New Menu Form",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              clearMenuUploadFrom();
            },
          ),
          actions: [
            ElevatedButton(
              onPressed:
                  //we check if uploading is null (otherwise if user clicks more than 1 time it will upload more than 1 time)
                  uploading ? null : () => validateUploadForm(),
              child: Text(
                "Add".toUpperCase(),
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.amber,
                ),
                shape: MaterialStateProperty.all<CircleBorder>(
                  const CircleBorder(),
                ),
              ),
            ),
          ],
        ),
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset(-2.0, 0.0),
                end: FractionalOffset(5.0, -1.0),
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFAC898),
                ],
              ),
            ),
            child: ListView(children: [
              uploading == true ? linearProgress() : const Text(""),
              SizedBox(
                height: 220,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                            File(imageXFile!.path),
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(-1, 10),
                            blurRadius: 10,
                          )
                        ],
                        gradient: const LinearGradient(
                          begin: FractionalOffset(-2.0, 0.0),
                          end: FractionalOffset(5.0, -1.0),
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xFFFAC898),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Divider(
                color: Colors.white,
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(
                  Icons.perm_device_information,
                  color: Colors.black,
                ),
                title: SizedBox(
                  width: 250,
                  child: TextField(
                    controller: shortInfoController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        hintText: "Menu Info",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 2,
              ),
              ListTile(
                leading: const Text(
                  r"₦",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                title: SizedBox(
                  width: 250,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        hintText: "Menu Price",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(
                  Icons.title,
                  color: Colors.black,
                ),
                title: SizedBox(
                  width: 250,
                  child: TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        hintText: "Menu Title",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 2,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 2.0)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    iconSize: 30,
                    value: selectedObject,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedObject = newValue;
                      });
                    },
                    hint: Text(
                      'Category',
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
                        category.map<DropdownMenuItem<String>>((String value) {
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
            ])));
  }

//clearing textfields
  clearMenuUploadFrom() {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      priceController.clear();
      imageXFile = null;
      selectedObject = null;
    });
  }

  validateUploadForm() async {
    try {
      if (imageXFile != null) {
        if (shortInfoController.text.isNotEmpty &&
            titleController.text.isNotEmpty &&
            priceController.text.isNotEmpty &&
            selectedObject != null) {
          // if its true set uploading to true and start process indicator
          setState(() {
            uploading = true;
          });

          //upload image
          String downloadUrl = await uploadImage(File(imageXFile!.path));

          //save info to firestore

          await saveInfo(downloadUrl);
          Fluttertoast.showToast(msg: "Menu Added");
        } else {
          showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(
                message: "Please make sure price, title and info is filled.",
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(
              message: "Please pick an image for menu.",
            );
          },
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

//uploading image
  uploadImage(mImageFile) async {
    //we are creating seperate folder in firebase
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child("menus");

    storageRef.UploadTask uploadTask =
        reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadingUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadingUrl;
  }

//saving menu information to firebase
  saveInfo(String downloadUrl) {
    Menus menu = Menus(
     
      likesCount: 0,
      category: selectedObject!,
      menuID: uniqueIdName,
      menuTitle: titleController.text,
      menuInfo: shortInfoController.text,
      menuPrice: double.parse(priceController.text).toInt(),
      thumbnailUrl: downloadUrl,
      status: 'available',
      likes: [],
      publishDate: DateTime.now(),
      raters: [],
      rating: 0,
    );
    final ref = FirebaseFirestore.instance.collection("menus");

    Map<String, dynamic> menuJson = menu.toJson();

//information pass to firebase
    ref.doc(uniqueIdName).set(menuJson);

    clearMenuUploadFrom();

    setState(() {
      uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
      uploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menusUploadFormScreen();
  }
}
