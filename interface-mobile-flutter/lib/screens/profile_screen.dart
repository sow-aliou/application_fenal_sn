import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    try {
      final service = ref.read(profileServiceProvider);
      await service.updateProfile(
        nom: _nomController.text,
        prenom: _prenomController.text,
        email: _emailController.text,
      );
      
      // Rafraîchir les données
      ref.invalidate(userProfileProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour avec succès')),
        );
        setState(() => _isEditing = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsyncValue = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        actions: [
          if (!_isEditing && profileAsyncValue.hasValue)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: profileAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
        data: (profile) {
          // Initialize controllers if not editing to keep them in sync
          if (!_isEditing) {
            _nomController.text = profile['nom'] ?? '';
            _prenomController.text = profile['prenom'] ?? '';
            _emailController.text = profile['email'] ?? '';
            _telephoneController.text = profile['telephone'] ?? '';
          }

          final initial = (_prenomController.text.isNotEmpty)
              ? _prenomController.text[0].toUpperCase()
              : 'U';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF1B5E20),
                    child: Text(
                      initial,
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _prenomController,
                    enabled: _isEditing,
                    decoration: const InputDecoration(
                      labelText: 'Prénom',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nomController,
                    enabled: _isEditing,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    enabled: _isEditing,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _telephoneController,
                    enabled: false, // Le numéro de téléphone ne se modifie pas ici
                    decoration: const InputDecoration(
                      labelText: 'Téléphone',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_isEditing)
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = false;
                                      // Restaurer les valeurs
                                      _nomController.text = profile['nom'] ?? '';
                                      _prenomController.text = profile['prenom'] ?? '';
                                      _emailController.text = profile['email'] ?? '';
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: const Text('Annuler'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _saveProfile,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: const Color(0xFF1B5E20),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Enregistrer'),
                                ),
                              ),
                            ],
                          ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
