import 'package:flutter/foundation.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<bool> register(String phone, String fullName, String language, {String? password}) async {
    try {
      await _api.post('/auth/register', {
        'phone': phone,
        'full_name': fullName,
        'language': language,
        'password': password,
      });
      return true;
    } catch (e) {
      print('Registration Failed: $e');
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      final response = await _api.post('/auth/verify-otp', {
        'phone': phone,
        'otp': otp,
      });
      
      final token = response['access_token'];
      if (token != null) {
        _api.setToken(token);
        return true;
      }
      return false;
    } catch (e) {
      print('OTP Verification Failed: $e');
      return false;
    }
  }
}
