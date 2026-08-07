import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignalementService {
  // Même IP que dans AuthService
  static const String baseUrl = 'http://192.168.186.211:8080/api/signalements';

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

  Future<List<dynamic>> getSignalements({String? type, String? lieu}) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) {
      throw Exception('Utilisateur non connecté.');
    }

    var url = '$baseUrl/trouve/document';
    List<String> queryParams = [];
    if (type != null && type.isNotEmpty) queryParams.add('type=$type');
    if (lieu != null && lieu.isNotEmpty) queryParams.add('lieu=$lieu');
    
    if (queryParams.isNotEmpty) {
      url += '?${queryParams.join('&')}';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Decode le JSON (attend une liste d'objets)
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur de récupération : ${response.body}');
    }
  }

  Future<void> declarerDocumentPerdu({
    required String type,
    required String nom,
    required String lieu,
    required String description,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception('Utilisateur non connecté ou ID manquant.');
    }

    final uri = Uri.parse('$baseUrl/perdu');
    
    final Map<String, dynamic> body = {
      'type': type,
      'nom': nom,
      'lieu': lieu,
      'description': description,
      'idUtilisateur': userId,
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la déclaration de perte : ${response.body}');
    }
  }
}
