// lib/services/image_service.dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:optiparse/auth/services/auth_service.dart';
import 'package:optiparse/main.dart';

class ImageService {
  final _authService = AuthService();
  final _baseUrl = MyApp.baseUrl;

  Future<String?> uploadCroppedImage(File imageFile) async {
    try {
      // Get JWT token from AuthService
      final jwtToken = await _authService.getToken();

      if (jwtToken == null) {
        throw Exception("Authentication failed, token is null");
      }

      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/query'));

      // Add headers
      request.headers['Authorization'] = 'Bearer $jwtToken';
      request.headers['accept'] = 'application/json';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add the image file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'file', // This should match the name in the curl command
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      // Send request
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        return responseData; // Return the response string
      } else {
        print("Failed to upload image, status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print("Error during image upload: $e");
      return null;
    }
  }
}
