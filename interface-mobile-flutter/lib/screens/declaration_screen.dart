import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/signalement_provider.dart';

class DeclarationScreen extends ConsumerStatefulWidget {
  const DeclarationScreen({super.key});

  @override
  ConsumerState<DeclarationScreen> createState() => _DeclarationScreenState();
}

class _DeclarationScreenState extends ConsumerState<DeclarationScreen> {
  final _lieuController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _image;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70, // Compression pour éviter d'envoyer de trop gros fichiers
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Erreur lors de l'ouverture de la caméra/galerie.";
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_image == null) {
      setState(() => _errorMessage = "Veuillez prendre une photo du document.");
      return;
    }
    if (_lieuController.text.isEmpty) {
      setState(() => _errorMessage = "Veuillez préciser le lieu.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final signalementService = ref.read(signalementServiceProvider);
      await signalementService.declarerDocumentTrouve(
        imageFile: _image!,
        lieu: _lieuController.text,
        description: _descriptionController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Merci ! Le document a été signalé avec succès.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
        context.pop(); // Retour à l'accueil
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Signalement'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Informations sur le document trouvé',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Zone de la photo
              GestureDetector(
                onTap: () => _pickImage(ImageSource.camera),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 48, color: Colors.grey.shade600),
                            const SizedBox(height: 8),
                            Text(
                              'Appuyez pour prendre une photo',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Ou choisir depuis la galerie'),
              ),
              
              const SizedBox(height: 24),
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade700),
                    textAlign: TextAlign.center,
                  ),
                ),

              TextField(
                controller: _lieuController,
                decoration: const InputDecoration(
                  labelText: 'Lieu de découverte *',
                  prefixIcon: Icon(Icons.location_on),
                  hintText: 'Ex: Rond-point Liberté 6',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (Optionnel)',
                  prefixIcon: Icon(Icons.description),
                  hintText: 'Ex: Trouvé près de la boulangerie...',
                ),
              ),
              
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Envoyer le signalement', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
