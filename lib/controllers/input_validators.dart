import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputValidator {
  // Email validation regex pattern
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Password validation regex patterns
  static final RegExp _hasUppercase = RegExp(r'[A-Z]');
  static final RegExp _hasLowercase = RegExp(r'[a-z]');
  static final RegExp _hasDigits = RegExp(r'[0-9]');
  static final RegExp _hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  // Name validation regex (letters, spaces, hyphens, apostrophes)
  static final RegExp _nameRegExp = RegExp(r"^[a-zA-Z\s\-']+$");

  /// Validates if a field is not empty
  static bool validateRequired(String title, String value) {
    if (value.trim().isNotEmpty) {
      return true;
    }
    _showErrorSnackbar("Error", "$title is required");
    return false;
  }

  /// Validates email format
  static bool validateEmail(String email) {
    if (email.trim().isEmpty) {
      _showErrorSnackbar("Error", "Email is required");
      return false;
    }

    if (!_emailRegExp.hasMatch(email.trim())) {
      _showErrorSnackbar("Error", "Please enter a valid email address");
      return false;
    }

    return true;
  }

  /// Validates name format
  static bool validateName(String name) {
    if (name.trim().isEmpty) {
      _showErrorSnackbar("Error", "Name is required");
      return false;
    }

    if (name.trim().length < 2) {
      _showErrorSnackbar("Error", "Name must be at least 2 characters long");
      return false;
    }

    if (name.trim().length > 50) {
      _showErrorSnackbar("Error", "Name must be less than 50 characters");
      return false;
    }

    if (!_nameRegExp.hasMatch(name.trim())) {
      _showErrorSnackbar("Error", "Name can only contain letters, spaces, hyphens, and apostrophes");
      return false;
    }

    return true;
  }

  /// Validates password strength
  static bool validatePassword(String password) {
    if (password.trim().isEmpty) {
      _showErrorSnackbar("Error", "Password is required");
      return false;
    }

    if (password.length < 8) {
      _showErrorSnackbar("Error", "Password must be at least 8 characters long");
      return false;
    }

    if (password.length > 128) {
      _showErrorSnackbar("Error", "Password must be less than 128 characters");
      return false;
    }

    if (!_hasUppercase.hasMatch(password)) {
      _showErrorSnackbar("Error", "Password must contain at least one uppercase letter");
      return false;
    }

    if (!_hasLowercase.hasMatch(password)) {
      _showErrorSnackbar("Error", "Password must contain at least one lowercase letter");
      return false;
    }

    if (!_hasDigits.hasMatch(password)) {
      _showErrorSnackbar("Error", "Password must contain at least one number");
      return false;
    }

    if (!_hasSpecialCharacters.hasMatch(password)) {
      _showErrorSnackbar("Error", "Password must contain at least one special character (!@#\$%^&*(),.?\":{}|<>)");
      return false;
    }

    // Check for common weak passwords
    List<String> commonPasswords = [
      'password', '123456', '123456789', 'qwerty', 'abc123',
      'password123', '111111', '123123', 'admin', 'letmein'
    ];

    if (commonPasswords.contains(password.toLowerCase())) {
      _showErrorSnackbar("Error", "Please choose a stronger password");
      return false;
    }

    return true;
  }

  /// Validates password confirmation
  static bool validatePasswordConfirmation(String password, String confirmPassword) {
    if (confirmPassword.trim().isEmpty) {
      _showErrorSnackbar("Error", "Password confirmation is required");
      return false;
    }

    if (password.trim() != confirmPassword.trim()) {
      _showErrorSnackbar("Error", "Passwords do not match");
      return false;
    }

    return true;
  }

  /// Validates phone number (basic validation)
  static bool validatePhone(String phone) {
    if (phone.trim().isEmpty) {
      _showErrorSnackbar("Error", "Phone number is required");
      return false;
    }

    // Remove all non-digit characters for validation
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanPhone.length < 10) {
      _showErrorSnackbar("Error", "Phone number must be at least 10 digits");
      return false;
    }

    if (cleanPhone.length > 15) {
      _showErrorSnackbar("Error", "Phone number must be less than 15 digits");
      return false;
    }

    return true;
  }

  /// Gets password strength score (0-4)
  static int getPasswordStrength(String password) {
    int score = 0;
    
    if (password.length >= 8) score++;
    if (_hasUppercase.hasMatch(password)) score++;
    if (_hasLowercase.hasMatch(password)) score++;
    if (_hasDigits.hasMatch(password)) score++;
    if (_hasSpecialCharacters.hasMatch(password)) score++;
    
    // Bonus for length
    if (password.length >= 12) score++;
    
    return score > 4 ? 4 : score;
  }

  /// Gets password strength text
  static String getPasswordStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return "Very Weak";
      case 2:
        return "Weak";
      case 3:
        return "Good";
      case 4:
        return "Strong";
      default:
        return "Very Weak";
    }
  }

  /// Gets password strength color
  static Color getPasswordStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  /// Validates complete signup form
  static bool validateSignupForm({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    // Validate in order of importance
    if (!validateName(name)) return false;
    if (!validateEmail(email)) return false;
    if (!validatePassword(password)) return false;
    if (!validatePasswordConfirmation(password, confirmPassword)) return false;
    
    return true;
  }

  /// Validates complete login form
  static bool validateLoginForm({
    required String email,
    required String password,
  }) {
    if (!validateRequired("Email/Username", email)) return false;
    if (!validateRequired("Password", password)) return false;
    
    // For login, we might want lighter email validation
    // since user might be using username instead of email
    return true;
  }

  /// Validates forgot password form
  static bool validateForgotPasswordForm({required String email}) {
    return validateEmail(email);
  }

  /// Private method to show error snackbar
  static void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      duration: const Duration(seconds: 4),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  /// Shows success snackbar
  static void showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}