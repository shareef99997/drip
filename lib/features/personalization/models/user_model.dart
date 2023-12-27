
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/formatters/formatter.dart';
import '../../shop/models/cart_model.dart';
import 'address_model.dart';

/// Model class representing user data.
class UserModel {

  // Keep those values final which you do not want to update
  final String id;
  String firstName;
  String lastName;
  final String username;
  final String email;
  String phoneNumber;
  String profilePicture;
  final CartModel? cart;
  final List<AddressModel>? addresses;

  /// Constructor for UserModel.
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    this.cart,
    this.addresses,
  });
  

  /// Helper function to get the full name.
  String get fullName => '$firstName $lastName';

  /// Helper function to format phone number.
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  /// Static function to split full name into first and last name.
  static List<String> nameParts(fullName) => fullName.split(" ");

  /// Static function to generate a username from the full name.
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstName$lastName"; // Combine first and last name
    String usernameWithPrefix = "drip_$camelCaseUsername"; // Add "cwt_" prefix
    return usernameWithPrefix;
  }

  /// Static function to create an empty user model.
  static UserModel empty() => 
    UserModel(
      id: '',
      firstName: '',
      lastName: '',
      username: '',
      email: '',
      phoneNumber: '',
      profilePicture: '',
    );

   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
    };
   }

    factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
      if (document.data() != null) {
        final data = document.data()!;
        return UserModel(
          id: document.id,
          firstName: data['firstName'] ?? '',
          lastName: data['lastName'] ?? '',
          username: data['username'] ?? '',
          email: data['email'] ?? '',
          phoneNumber: data['phoneNumber'] ?? '',
          profilePicture: data['profilePicture'] ?? '',
        );
      }

      // Add a return statement for the case where document.data() is null
      return UserModel(
        id: '',
        firstName: '',
        lastName: '',
        username: '',
        email: '',
        phoneNumber: '',
        profilePicture: '',
      );
    }
    }