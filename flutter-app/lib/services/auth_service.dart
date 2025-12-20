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

  /// Login with phone and password
  Future<Map<String, dynamic>> login(String phone, String password) async {
    try {
      final response = await _api.post('/auth/login', {
        'phone': phone,
        'password': password,
      });
      
      final token = response['access_token'];
      if (token != null) {
        _api.setToken(token);
        return {'success': true, 'token': token};
      }
      return {'success': false, 'error': 'No token received'};
    } catch (e) {
      print('Login Failed: $e');
      // Extract error message from exception
      String errorMsg = e.toString();
      if (errorMsg.contains('User not found')) {
        return {'success': false, 'error': 'User not found. Please register first.'};
      } else if (errorMsg.contains('Invalid password')) {
        return {'success': false, 'error': 'Invalid password.'};
      }
      return {'success': false, 'error': 'Login failed. Please check your credentials.'};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    try {
      final response = await _api.post('/auth/verify-otp', {
        'phone': phone,
        'otp': otp,
      });
      
      final token = response['access_token'];
      if (token != null) {
        _api.setToken(token);
        return {'success': true};
      }
      return {'success': false, 'error': 'Invalid response from server'};
    } catch (e) {
      print('OTP Verification Failed: $e');
      // If ApiService throws exception with message, use it
      return {'success': false, 'error': e.toString().replaceAll('Exception:', '').trim()};
    }
  }
}
