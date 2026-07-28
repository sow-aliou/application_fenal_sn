import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Adresse IP de l'ordinateur sur le réseau local (Wi-Fi) pour un téléphone physique
  static const String baseUrl = 'http://192.168.13.211:8080/api/auth';

  Future<Map<String, dynamic>> login(
      String telephone, String motDePasse) async {
    final response = await http.post(
      Uri.parse('$baseUrl/connexion'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'telephone': telephone,
        'motDePasse': motDePasse,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userPhone', telephone);
      if (data['idUtilisateur'] != null) {
        await prefs.setInt('userId', data['idUtilisateur']);
      }
      return data;
    } else {
      throw Exception(
          'Erreur de connexion : Téléphone ou mot de passe incorrect.');
    }
  }

  Future<Map<String, dynamic>> register(String nom, String prenom,
      String telephone, String email, String motDePasse) async {
    final response = await http.post(
      Uri.parse('$baseUrl/inscription'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': nom,
        'prenom': prenom,
        'telephone': telephone,
        'email': email,
        'motDePasse': motDePasse,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors de l\'inscription. Vérifiez vos données.');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userPhone');
    await prefs.setBool('isLoggedIn', false);
  }

  Future<void> forgotPassword(String telephone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'telephone': telephone,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur: ${response.body}');
    }
  }

  Future<void> resetPassword(String telephone, String otp, String nouveauMotDePasse) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'telephone': telephone,
        'otp': otp,
        'nouveauMotDePasse': nouveauMotDePasse,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur: ${response.body}');
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
