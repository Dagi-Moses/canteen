import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider extends ChangeNotifier {
  Position? _position;
  List<Placemark>? _placeMarks;
  String? _completeAddress;
  bool _isLoading = false;

  Position? get position => _position;
  List<Placemark>? get placeMarks => _placeMarks;
  bool get isLoading => _isLoading;
  String? get completeAddress => _completeAddress;


  LocationProvider() {
    getCurrentLocation();
 
  }

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
        _completeAddress =
            '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.country}';
      } else {
        _completeAddress = "Address unavailable";
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
