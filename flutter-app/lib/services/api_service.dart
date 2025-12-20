import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use localhost for Edge/Web. Use 10.0.2.2 for Android Emulator.
  // Use LAN IP for Physical Device.
  // Use 10.0.2.2 for Android Emulator.
  // Use LAN IP for Physical Device.
  static const String baseUrl = 'http://192.168.137.1:8000';
  // static const String baseUrl = 'http://10.0.2.2:8000'; 
  
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _authToken;

  void setToken(String token) {
    _authToken = token;
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('API Error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Network Error: $e');
      rethrow;
    }
  }

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('API Error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // --- Recommendations ---
  Future<List<dynamic>> getRecommendations(Map<String, dynamic> contextData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/recommendations/recommendations'), // Correct endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(contextData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load recommendations: ${response.body}');
      }
    } catch (e) {
      print('Recommendation Error: $e');
      return [];
    }
  }
  // --- Chat ---
  Future<Map<String, dynamic>> sendChatMessage(String message, String? sessionId, {String languageCode = 'en'}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "message": message, 
          "session_id": sessionId,
          "language": languageCode
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Chat API Error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Chat Error: $e');
      return {
        "response": "Sorry, I'm having trouble connecting to the farm server.",
        "state": "ERROR",
        "session_id": sessionId ?? ""
      };
    }
  }
}
