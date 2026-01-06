import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';

class ProjectService {
  static final String baseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:8000/api'
      : 'http://127.0.0.1:8000/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<Project>> getProjects() async {
    final url = Uri.parse('$baseUrl/projects');
    final token = await _getToken();
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Requested-With': 'XMLHttpRequest',
        },
      );

      if (response.statusCode == 200) {
        print('Projects fetched successfully: ${response.body}');
        final dynamic jsonData = jsonDecode(response.body);
        List<dynamic> list;
        if (jsonData is List) {
          list = jsonData;
        } else if (jsonData is Map) {
          if (jsonData.containsKey('projects')) {
            list = jsonData['projects'];
          } else if (jsonData.containsKey('data')) {
            list = jsonData['data'];
          } else {
            list = [];
          }
        } else {
          list = [];
        }
        return list.map((json) => Project.fromJson(json)).toList();
      } else {
        print(
          'Error fetching projects. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
      return [];
    } catch (e) {
      print('Error fetching projects: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> addProject(
    Project project, {
    File? imageFile,
  }) async {
    final url = Uri.parse('$baseUrl/projects');
    final token = await _getToken();

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      });

      request.fields.addAll(project.toMap());

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Add Project Status: ${response.statusCode}');
      print('Add Project Response Body: ${response.body}');

      final bool success =
          response.statusCode == 201 || response.statusCode == 200;
      return {
        'success': success,
        'statusCode': response.statusCode,
        'message': success ? 'Success' : response.body,
      };
    } catch (e) {
      print('Error adding project: $e');
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<Map<String, dynamic>> updateProject(
    String id,
    Project project, {
    File? imageFile,
  }) async {
    final url = Uri.parse('$baseUrl/projects/$id');
    final token = await _getToken();

    try {
      // Laravel often requires POST with _method=PUT for multipart updates
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      });

      request.fields.addAll(project.toMap());
      request.fields['_method'] = 'PUT';

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Update Project Status: ${response.statusCode}');
      print('Update Project Response Body: ${response.body}');

      final bool success = response.statusCode == 200;
      return {
        'success': success,
        'statusCode': response.statusCode,
        'message': success ? 'Success' : response.body,
      };
    } catch (e) {
      print('Error updating project: $e');
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<bool> deleteProject(String id) async {
    final url = Uri.parse('$baseUrl/projects/$id');
    final token = await _getToken();

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting project: $e');
      return false;
    }
  }
}
