import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import '../constants/variables.dart';
import '../models/story.dart';

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
    return response.body.isNotEmpty
        ? jsonDecode(response.body)
        : {'error': true, 'message': 'Failed to login'};
  }

  Future<Map<String, dynamic>> addStory(String token, String description, String photoPath, double lat, double lon) async {
    var request = http.MultipartRequest('POST', Uri.parse('${Variables.baseUrl}/stories'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['description'] = description;
    request.files.add(await http.MultipartFile.fromPath('photo', photoPath));
    request.fields['lat'] = lat.toString();
    request.fields['lon'] = lon.toString();
    final response = await request.send();
    return jsonDecode(await response.stream.bytesToString());
  }

  Future<Map<String, dynamic>> getAllStories(String token, {int page = 1}) async {
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/stories?page=$page'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<Story> getStoryDetail(String token, String id) async {
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/stories/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return Story.fromJson(jsonDecode(response.body)['story']);
  }
}
