import '../../../utils/formatters/formatter.dart';

class AddressModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  AddressModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  AddressModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
  }) {
    return AddressModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }


  // Factory constructor to create an AddressModel from a map
  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      street: map['street'],
      postalCode: map['postalCode'],
      city: map['city'],
      state: map['state'],
      country: map['country'], 
    );
  }

  // Method to convert AddressModel to a map
  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'phoneNumber': phoneNumber,
      'street': street,
      'postalCode': postalCode,
      'city': city,
      'state': state,
      'country': country,
    };
  }

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);


  static AddressModel empty() => AddressModel(id: '', name: '', phoneNumber: '', street: '', city: '', state: '', postalCode: '', country: '');



  @override
  String toString() {
    return '$street, $city, $state $postalCode, $country';
  }
}
