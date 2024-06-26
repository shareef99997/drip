
class TValidator {

  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }


    return null;
  }

 static String? validatePhoneNumber(String? value) {
  if (value == null || value.replaceAll(' ', '').isEmpty) {
    return 'Phone number is required.';
  }

  // Remove spaces from the phone number
  final cleanedValue = value.replaceAll(' ', '');

  // Regular expression for phone number validation (assuming a 10-digit US phone number format)
  final phoneRegExp = RegExp(r'^\d{10}$');

  if (!phoneRegExp.hasMatch(cleanedValue)) {
    return 'Invalid phone number format (10 digits required).';
  }

  return null;
}


}
