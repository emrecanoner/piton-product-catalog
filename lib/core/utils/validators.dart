import 'package:easy_localization/easy_localization.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.email_required'.tr();
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'validation.email_invalid'.tr();
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.password_required'.tr();
    }
    
    if (value.length < 6 || value.length > 20) {
      return 'validation.password_invalid'.tr();
    }
    
    final hasAlphanumeric = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{6,20}$');
    if (!hasAlphanumeric.hasMatch(value)) {
      return 'validation.password_invalid'.tr();
    }
    
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.name_required'.tr();
    }
    return null;
  }
} 