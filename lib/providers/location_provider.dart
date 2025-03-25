import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider extends ChangeNotifier {
  final TextEditingController locationController = TextEditingController();
  LocationProvider() {
    getCurrentLocation();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  //location variables

  Position? _position;
  Position? get position => _position;

  List<Placemark>? _placeMarks;
  List<Placemark>? get placeMarks => _placeMarks;

  String? _completeAddress;
  String? get completeAddress => _completeAddress;

  String? _country;
  String? get country => _country;

  String? _state;
  String? get state => _state;

  String? _city;
  String? get city => _city;

  String? _address;
  String? get address => _address;

  String? _zipCode;
  String? get zipCode => _zipCode;


  /// Method to set initial values
  void setInitialLocation(String country, String state, String city) {
    _country = country;
    _state = state;
    _city = city;
    notifyListeners();
  }

  void updateCountry(String value) {
    _country = value;
    _state = ""; // Reset state and city when country changes
    _city = "";
    notifyListeners();
  }

  void updateState(String value) {
    _state = value;
    _city = ""; // Reset city when state changes
    notifyListeners();
  }

  void updateCity(String value) {
    _city = value;
    notifyListeners();
  }

 
 
  Future<void> getCurrentLocation() async {
    print("started location service");
    isLoading = true;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, cannot request permissions.');
      }

      // _position = await Geolocator.getCurrentPosition();

      // try {
      //   _position = await Geolocator.getCurrentPosition()
      //       .timeout(Duration(seconds: 25));
      // } on TimeoutException {
      //   print("Location retrieval timed out, using last known location...");
      //   _position = await Geolocator.getLastKnownPosition();
      // }
      _position = await getCurrentPositionWithRetry();

      if (_position == null) {
        throw Exception("Failed to get location");
      }

      print("Starting reverse geocoding...");
      // _placeMarks = await placemarkFromCoordinates(
      //   _position!.latitude,
      //   _position!.longitude,
      // );
      try {
        _placeMarks = await getPlacemarksWithRetry(
            _position!.latitude, _position!.longitude);
      } catch (e) {
        print("Reverse geocoding failed after multiple attempts.");
        _placeMarks = null;
      }

      if (_placeMarks != null && _placeMarks!.isNotEmpty) {
        Placemark pMark = _placeMarks![0];
        _country = pMark.country;
        _state = pMark.administrativeArea;
        _city = pMark.subAdministrativeArea;
        _address =
            "${pMark.subThoroughfare ?? ""} ${pMark.thoroughfare ?? ""}".trim();
        _zipCode = pMark.postalCode;
        String add =
            '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.country}';
        _completeAddress = add;

        if (locationController.text.isEmpty) {
          locationController.text = add;
        }
      } else {
        _country = "Unknown Country";
        _state = "Unknown State";
        _city = "Unknown City";
        _address = "Unknown Address";
        _completeAddress = "Address unavailable";
        _zipCode = null;
      }
      print("complete address " + _completeAddress!);

      notifyListeners(); // Notify that new data is available
    } catch (e) {
      print("Error obtaining location: $e");
    } finally {
    
    }
  }
}


Future<Position?> getCurrentPositionWithRetry({int retries = 2, int timeoutSeconds = 20}) async {
  int attempt = 0;
  while (attempt < retries) {
    try {
      print("Attempt ${attempt + 1}: Retrieving current location...");
      return await Geolocator.getCurrentPosition()
          .timeout(Duration(seconds: timeoutSeconds));
    } on TimeoutException {
      print("Attempt ${attempt + 1} timed out.");
      attempt++;
    } catch (e) {
      print("Location retrieval error: $e");
      break; // Exit on unexpected errors
    }
  }

  print("Max retries reached. Using last known location...");
  return await Geolocator.getLastKnownPosition();
}


Future<List<Placemark>> getPlacemarksWithRetry(
    double latitude, double longitude,
    {int retries = 3}) async {
  int attempt = 0;
  while (attempt < retries) {
    try {
      print("Attempt ${attempt + 1}: Reverse geocoding...");
      return await placemarkFromCoordinates(latitude, longitude)
          .timeout(Duration(seconds: 20));
    } on TimeoutException {
      print("Reverse geocoding attempt ${attempt + 1} timed out.");
      attempt++;
    } catch (e) {
      print("Reverse geocoding error: $e");
      break;
    }
  }
  throw Exception("Reverse geocoding failed after $retries attempts");
}
