import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignalementService {
  // Même IP que dans AuthService
  static const String baseUrl = 'http://192.168.13.211:8080/api/signalements';

  Future<void> declarerDocumentTrouve({
    required File imageFile,
    required String lieu,
    required String description,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception('Utilisateur non connecté ou ID manquant.');
    }

    var uri = Uri.parse('$baseUrl/trouve/document');
    var request = http.MultipartRequest('POST', uri);

    // Ajout des champs texte
    request.fields['lieu'] = lieu;
    request.fields['description'] = description;
    request.fields['idUtilisateur'] = userId.toString();

    // Ajout du fichier image
    var multipartFile = await http.MultipartFile.fromPath(
      'file',
      imageFile.path,
    );
    request.files.add(multipartFile);

    // Envoi de la requête
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la déclaration : ${response.body}');
    }
  }
}
