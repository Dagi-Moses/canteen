import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String ?firstName;
  final String? lastName;
  final String ?email;
  final String? address;     
  final String? completeAddress;   
  final String? phoneNumber;  
  final String? profileImage; 
  final String? country;      
  final String? state;      
  final String? city;         
  final String? zipCode;       
  DateTime? dateJoined = DateTime.now();

  UserModel({
     this.uid,
   this.firstName,
    this.lastName,
  this.email,
    this.completeAddress,
    this.address,
    this.phoneNumber,
    this.profileImage,
    this.country,
    this.state,
    this.city,
    this.zipCode,
     this.dateJoined,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      firstName: data['firstName'] ?? "",
      lastName: data['lastName'] ?? "" ,
      email: data['email'] ?? '',
      address: data['address'],
      completeAddress: data['completeAddress'],
      phoneNumber: data['phoneNumber'],
      profileImage: data['profileImage'],
      country: data['country'],
      state: data['state'],
      city: data['city'],
      zipCode: data['zipCode'] ,
      dateJoined: data['dateJoined'] != null
          ? (data['dateJoined'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      "state": state,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'address': address,
      'completeAddress': completeAddress,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'country': country,
      'city': city,
      'zipCode': zipCode,
      'dateJoined': dateJoined ,
    };
  }

  // CopyWith method to create a new User instance with updated fields
  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? address,
    String? completeAddress,
    String? phoneNumber,
    String? profileImage,
    String? country,
    String? state,
    String? city,
    String? zipCode,

    
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
      address: address ?? this.address,
      completeAddress: completeAddress ?? this.completeAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      dateJoined: dateJoined, 
      country: country?? this.country, 
      city: city ?? this.city, 
      zipCode: zipCode ?? this.zipCode,
      state: state ?? this.state,
      lastName: lastName ?? this.lastName,
     
    );
  }
}

