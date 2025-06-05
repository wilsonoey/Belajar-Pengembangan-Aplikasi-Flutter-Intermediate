import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/variables.dart';

class ApiService {
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> addStory(String token, String description, String photoPath) async {
    var request = http.MultipartRequest('POST', Uri.parse('${Variables.baseUrl}/stories'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['description'] = description;
    request.files.add(await http.MultipartFile.fromPath('photo', photoPath));
    final response = await request.send();
    return jsonDecode(await response.stream.bytesToString());
  }

  Future<Map<String, dynamic>> getAllStories(String token) async {
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/stories'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getStoryDetail(String token, String id) async {
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/stories/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }
}