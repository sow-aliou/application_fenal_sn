import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String baseUrl = 'http://192.168.186.211:8080/api/auth/profil';

  Future<Map<String, dynamic>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    
    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }

    final response = await http.get(Uri.parse('$baseUrl/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Impossible de récupérer le profil');
    }
  }

  Future<void> updateProfile({String? nom, String? prenom, String? email}) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    
    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }

    final body = <String, dynamic>{};
    if (nom != null && nom.isNotEmpty) body['nom'] = nom;
    if (prenom != null && prenom.isNotEmpty) body['prenom'] = prenom;
    if (email != null && email.isNotEmpty) body['email'] = email;

    final response = await http.put(
      Uri.parse('$baseUrl/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Impossible de mettre à jour le profil');
    }
  }
}
