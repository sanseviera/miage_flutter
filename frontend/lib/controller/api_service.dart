import 'dart:convert'; // For encoding to base64 and JSON
import 'package:http/http.dart' as http; // HTTP package for requests

class ApiService {
  final String _baseUrl = 'http://10.0.2.2:8000/run';

  // Function to make POST request and return the class index
  Future<int?> sendImage(String base64Image) async {
    // Create the JSON body with the base64-encoded image
    Map<String, String> body = {
      'data': base64Image, // 'data' field with base64 string
    };

    try {
      // Make POST request
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type':
              'application/json', // Ensure the request is in JSON format
        },
        body: jsonEncode(body), // Convert body to JSON
      );

      // Check the status code for success
      if (response.statusCode == 200) {
        // If successful, parse the response body
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Extract class_index from the response
        int classIndex = responseData['class_index'];


        // Return the class index
        return classIndex;
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        return null;
      }
    } catch (e) {
      // If an error occurs, print it.
      return null;
    }
  }
}
