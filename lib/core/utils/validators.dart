class AppValidators {
  AppValidators._();

  static String? required(String? value, [String field = 'This field']) {
    if (value == null || value.trim().isEmpty) return '$field is required.';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required.';
    final regex = RegExp(r'^[\w.+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email address.';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 8) return 'Password must be at least 8 characters.';
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must include at least one uppercase letter.';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must include at least one number.';
    }
    return null;
  }

  static String? Function(String?) confirmPassword(String? original) =>
      (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password.';
        }
        if (value != original) return 'Passwords do not match.';
        return null;
      };

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required.';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-().+]'), '');
    if (cleaned.length < 10) return 'Enter a valid phone number.';
    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Full name is required.';
    if (value.trim().length < 3) return 'Name must be at least 3 characters.';
    if (!value.trim().contains(' ')) return 'Please enter your full name.';
    return null;
  }

  static String? companyName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Company name is required.';
    }
    if (value.trim().length < 2) return 'Company name is too short.';
    return null;
  }

  static String? website(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(
        r'^(https?://)?([\w\-]+\.)+[\w]{2,}(/[\w\-._~:/?#\[\]@!$()*+,;=]*)?$');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid website URL.';
    return null;
  }

  static String? minLength(String? value, int min, [String? label]) {
    if (value == null || value.trim().isEmpty) {
      return '${label ?? 'This field'} is required.';
    }
    if (value.trim().length < min) {
      return '${label ?? 'This field'} must be at least $min characters.';
    }
    return null;
  }

  static String? maxLength(String? value, int max, [String? label]) {
    if (value != null && value.length > max) {
      return '${label ?? 'This field'} must not exceed $max characters.';
    }
    return null;
  }

  static String? positiveNumber(String? value, [String? label]) {
    if (value == null || value.trim().isEmpty) {
      return '${label ?? 'This field'} is required.';
    }
    final number = double.tryParse(value.trim());
    if (number == null || number <= 0) {
      return 'Enter a valid positive number.';
    }
    return null;
  }

  static String? guestCount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Number of guests is required.';
    }
    final n = int.tryParse(value.trim());
    if (n == null || n < 1) return 'Enter a valid number of guests.';
    if (n > 10000) return 'Contact us for events over 10,000 guests.';
    return null;
  }

  static String? inviteCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Invite code is required.';
    }
    if (value.trim().length < 6) return 'Enter a valid invite code.';
    return null;
  }

  static String? address(String? value) {
    if (value == null || value.trim().isEmpty) return 'Address is required.';
    if (value.trim().length < 10) return 'Please enter a complete address.';
    return null;
  }

  // Compose multiple validators
  static String? Function(String?) compose(
          List<String? Function(String?)> validators) =>
      (String? value) {
        for (final validator in validators) {
          final result = validator(value);
          if (result != null) return result;
        }
        return null;
      };
}
