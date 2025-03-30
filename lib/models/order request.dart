import 'package:canteen/models/geopoint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRequestModel {
  final String id;
  final int date;
  final PickupOption pickupOption;
  final PaymentMethod paymentMethod;
  final Address? address;
  final String userId;
  final String userName;
  final String userImage;
  final String userPhone;
  final String userNote;
  final String? employeeCancelNote;
  final DeliveryStatus deliveryStatus;
  final String? deliveryId;
  final GeoPoint? deliveryGeoPoint;
  final String menuTitle;
  final String menuID;
  final int menuPrice;

  int? itemCount;

  OrderRequestModel({
    required this.id,
    required this.date,
    required this.pickupOption,
    required this.paymentMethod,
    required this.address,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userPhone,
    required this.userNote,
    required this.employeeCancelNote,
    required this.deliveryStatus,
    required this.deliveryId,
    required this.deliveryGeoPoint,
    required this.menuTitle,
    required this.menuID,
    required this.menuPrice,
    this.itemCount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'pickupOption': pickupOption.toString().split('.').last,
        'paymentMethod': paymentMethod.toString().split('.').last,
        'addressModel': address?.toJson(),
        'userId': userId,
        'userName': userName,
        'userImage': userImage,
        'userPhone': userPhone,
        'userNote': userNote,
        'employeeCancelNote': employeeCancelNote,
        'deliveryStatus': deliveryStatus.toString().split('.').last,
        'deliveryId': deliveryId,
        'deliveryGeoPoint': deliveryGeoPoint,
        'menuTitle': menuTitle,
        'menuID': menuID,
        'menuPrice': menuPrice,
        'itemCount': itemCount,
      };

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) {
    return OrderRequestModel(
      id: json['id'],
      date: json['date'],
      pickupOption: PickupOption.values.firstWhere((option) =>
          option.toString().split('.').last == json['pickupOption']),
      paymentMethod: PaymentMethod.values.firstWhere((option) =>
          option.toString().split('.').last == json['paymentMethod']),
      address:
          json['addressModel'] != null ? Address.fromJson(json['addressModel']) : null,
      userId: json['userId'],
      userName: json['userName'],
      userImage: json['userImage'],
      userPhone: json['userPhone'],
      userNote: json['userNote'],
      employeeCancelNote: json['employeeCancelNote'],
      deliveryStatus: DeliveryStatus.values.firstWhere((status) =>
          status.toString().split('.').last == json['deliveryStatus']),
      deliveryId: json['deliveryId'],
      deliveryGeoPoint: json['deliveryGeoPoint'],
      menuTitle: json['menuTitle'],
      menuID: json['menuID'],
      menuPrice: json['menuPrice'],
      itemCount: json['itemCount'],
    );
  }
}

class Address {
  final String? state;
  final String? city;
  final String? street;
  final String? mobile;
  final GeoPoint? geoPoint;

  Address({
    this.state,
    this.city,
    this.street,
    this.mobile,
    this.geoPoint,
  });

  Map<String, dynamic> toJson() => {
        'state': state,
        'city': city,
        'street': street,
        'mobile': mobile,
        'geoPoint': geoPoint,
      };

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      state: json['state'],
      city: json['city'],
      street: json['street'],
      mobile: json['mobile'],
      geoPoint: json['geoPoint']
    );
  }
}

enum PickupOption { delivery, pickUp, diningRoom }

enum PaymentMethod { cash, paystack }

enum DeliveryStatus { pending, upcoming, onTheWay, delivered, canceled }
