import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  late final String apiKey = dotenv.env['API_KEY']!;
  final String endpoint =
      "https://api-inference.huggingface.co/models/Salesforce/blip-image-captioning-base";

  Future<String> analyzeImage(File imageFile) async {
    try {
      // Read the image as raw bytes
      List<int> imageBytes = await imageFile.readAsBytes();

      // Debug: Print image size
      print("Image size: ${imageBytes.length} bytes");

      var response = await http.post(
        Uri.parse(endpoint),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/octet-stream"
        },
        body: imageBytes, // Send raw image data
      );

      // Debug: Print response status code
      print("Response Status Code: ${response.statusCode}");

      // Debug: Print response body
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        // Debug: Print full JSON response
        print("JSON Response: $jsonData");

        if (jsonData is List && jsonData.isNotEmpty) {
          return jsonData[0]["generated_text"]; // Get image description
        }
        return "No description available";
      } else {
        return "Error: ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
