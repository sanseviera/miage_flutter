import 'dart:convert';
import 'package:http/http.dart' as http;

class IaGenerator {
  static const String _apiKey = 'AIzaSyAeM8GIlv1HcpCn__sNwJyq3zc2ptGWBtM';

  // Méthode statique pour vérifier si une image base64 contient un élément dans la liste
  static Future<List<String>> getMatchingLabels(
      String base64Image, List<String> labelsToCheck) async {
    // Construire la requête pour l'API Google Cloud Vision
    const String url =
        'https://vision.googleapis.com/v1/images:annotate?key=$_apiKey';

    // Créer le payload de la requête
    final Map<String, dynamic> requestPayload = {
      "requests": [
        {
          "image": {
            "content": base64Image,
          },
          "features": [
            {"type": "LABEL_DETECTION", "maxResults": 10}
          ]
        }
      ]
    };

    // Effectuer la requête POST à l'API Google Cloud Vision
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestPayload),
    );

    if (response.statusCode == 200) {
      // Parser la réponse JSON
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> labelAnnotations =
          jsonResponse['responses'][0]['labelAnnotations'];

      // Extraire les labels détectés
      final List<String> detectedLabels = labelAnnotations
          .map((annotation) => annotation['description'].toString().toLowerCase())
          .toList();

      // Trouver les correspondances avec la liste de labels fournie
      final List<String> matchingLabels = [];
      for (String label in labelsToCheck) {
        if (detectedLabels.contains(label.toLowerCase())) {
          matchingLabels.add(label); // Ajouter le label correspondant
        }
      }

      return matchingLabels; // Retourner les correspondances trouvées
    } else {
      throw Exception('Failed to load image labels: ${response.body}');
    }
  }
}
