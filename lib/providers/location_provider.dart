import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider extends ChangeNotifier {

  LocationProvider() {
    getCurrentLocation();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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



  Future<void> getCurrentLocation() async {
    
    print("started location service");
    _isLoading = true;
    notifyListeners();

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

      _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _placeMarks = await placemarkFromCoordinates(
        _position!.latitude,
        _position!.longitude,
      );

   
      if (_placeMarks != null && _placeMarks!.isNotEmpty) {
        Placemark pMark = _placeMarks![0];
        _country = pMark.country ;
        _state = pMark.administrativeArea ;
        _city = pMark.locality ;
        _address =
            "${pMark.subThoroughfare ?? ""} ${pMark.thoroughfare ?? ""}".trim();
              _zipCode = pMark.postalCode;
        _completeAddress =
            '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.country}';
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
      _isLoading = false;
      notifyListeners();
    }
  }
}





// Future<void> getCurrenLocation() async {
//   try {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     Position newPosition = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     position = newPosition;

//     placeMarks = await placemarkFromCoordinates(
//       position!.latitude,
//       position!.longitude,
//     );

//     Placemark pMark = placeMarks![0];
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       // '${pMark.thoroughfare}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.country}';

//       String? completeAddress =
//           '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.country}';
//       locationController.text = completeAddress;
//     });
//   } catch (e) {
//   } finally {}
// }
