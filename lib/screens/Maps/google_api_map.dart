import 'package:canteen/providers/cartProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:provider/provider.dart';

class PlacePickerWidget extends StatefulWidget {
  const PlacePickerWidget({
    super.key,
  });
  @override
  _PlacePickerWidgetState createState() => _PlacePickerWidgetState();
}

class _PlacePickerWidgetState extends State<PlacePickerWidget> {
  String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? 'API_KEY_NOT_FOUND';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return MapLocationPicker(
      apiKey: apiKey,
       backButton: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back)),
      popOnNextButtonTaped: true,
currentLatLng: LatLng(cartProvider.address?.geoPoint?.latitude ?? 0.0,
          cartProvider.address?.geoPoint?.longitude ?? 0.0),

      onNext: (GeocodingResult? result) {
        if (result != null) {
          print(result.formattedAddress);

          cartProvider.fullAddress = result.formattedAddress;
          cartProvider.getAddressFromCoordinates(
              lat: result.geometry.location.lat,
              long: result.geometry.location.lng);
        }
      },
    );
  }
}
