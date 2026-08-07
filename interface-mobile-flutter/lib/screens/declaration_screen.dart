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

class _DeclarationScreenState extends ConsumerState<DeclarationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers pour Objet Trouvé
  final _lieuTrouveController = TextEditingController();
  final _descTrouveController = TextEditingController();
  File? _imageTrouve;
  bool _isLoadingTrouve = false;
  String? _errorMessageTrouve;

  // Controllers pour Objet Perdu
  final _nomPerduController = TextEditingController();
  final _lieuPerduController = TextEditingController();
  final _descPerduController = TextEditingController();
  String _selectedType = 'CNI';
  final List<String> _documentTypes = ['CNI', 'PASSEPORT', 'PERMIS', 'CARTE_GRISE'];
  bool _isLoadingPerdu = false;
  String? _errorMessagePerdu;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _lieuTrouveController.dispose();
    _descTrouveController.dispose();
    _nomPerduController.dispose();
    _lieuPerduController.dispose();
    _descPerduController.dispose();
    super.dispose();
  }

  // --- LOGIQUE OBJET TROUVÉ ---
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _imageTrouve = File(pickedFile.path);
          _errorMessageTrouve = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessageTrouve = "Erreur lors de l'ouverture de la caméra/galerie.";
      });
    }
  }

  Future<void> _handleSubmitTrouve() async {
    if (_imageTrouve == null) {
      setState(() => _errorMessageTrouve = "Veuillez prendre une photo du document.");
      return;
    }
    if (_lieuTrouveController.text.isEmpty) {
      setState(() => _errorMessageTrouve = "Veuillez préciser le lieu.");
      return;
    }

    setState(() {
      _isLoadingTrouve = true;
      _errorMessageTrouve = null;
    });

    try {
      final signalementService = ref.read(signalementServiceProvider);
      await signalementService.declarerDocumentTrouve(
        imageFile: _imageTrouve!,
        lieu: _lieuTrouveController.text,
        description: _descTrouveController.text,
      );

      if (mounted) {
        _showSuccessAndPop('Merci ! Le document a été signalé avec succès.');
      }
    } catch (e) {
      setState(() {
        _errorMessageTrouve = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingTrouve = false);
      }
    }
  }

  // --- LOGIQUE OBJET PERDU ---
  Future<void> _handleSubmitPerdu() async {
    if (_nomPerduController.text.isEmpty) {
      setState(() => _errorMessagePerdu = "Veuillez entrer le nom figurant sur le document.");
      return;
    }
    if (_lieuPerduController.text.isEmpty) {
      setState(() => _errorMessagePerdu = "Veuillez préciser le lieu de perte supposé.");
      return;
    }

    setState(() {
      _isLoadingPerdu = true;
      _errorMessagePerdu = null;
    });

    try {
      final signalementService = ref.read(signalementServiceProvider);
      await signalementService.declarerDocumentPerdu(
        type: _selectedType,
        nom: _nomPerduController.text,
        lieu: _lieuPerduController.text,
        description: _descPerduController.text,
      );

      if (mounted) {
        _showSuccessAndPop('Alerte de perte enregistrée avec succès.');
      }
    } catch (e) {
      setState(() {
        _errorMessagePerdu = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingPerdu = false);
      }
    }
  }

  void _showSuccessAndPop(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
      ),
    );
    context.pop();
  }

  // --- VUES ---
  Widget _buildTrouveForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Vous avez trouvé un document ?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Prenez-le en photo, notre IA se chargera d\'extraire les informations et de flouter la photo pour protéger les données personnelles.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          GestureDetector(
            onTap: () => _pickImage(ImageSource.camera),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
              ),
              child: _imageTrouve != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(_imageTrouve!, fit: BoxFit.cover),
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
          if (_errorMessageTrouve != null)
            _buildErrorBox(_errorMessageTrouve!),

          TextField(
            controller: _lieuTrouveController,
            decoration: const InputDecoration(
              labelText: 'Lieu de découverte *',
              prefixIcon: Icon(Icons.location_on),
              hintText: 'Ex: Rond-point Liberté 6',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descTrouveController,
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
              onPressed: _isLoadingTrouve ? null : _handleSubmitTrouve,
              child: _isLoadingTrouve
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Envoyer le signalement', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerduForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Vous avez perdu un document ?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Déclarez-le ici. Nous vous alerterons si quelqu\'un le retrouve et le signale sur l\'application.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          if (_errorMessagePerdu != null)
            _buildErrorBox(_errorMessagePerdu!),

          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: const InputDecoration(
              labelText: 'Type de document *',
              prefixIcon: Icon(Icons.badge),
            ),
            items: _documentTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedType = newValue;
                });
              }
            },
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _nomPerduController,
            decoration: const InputDecoration(
              labelText: 'Nom figurant sur le document *',
              prefixIcon: Icon(Icons.person),
              hintText: 'Ex: Ndiaye',
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _lieuPerduController,
            decoration: const InputDecoration(
              labelText: 'Lieu de perte supposé *',
              prefixIcon: Icon(Icons.location_on),
              hintText: 'Ex: Trajet UCAD - Ouakam',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descPerduController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description (Optionnel)',
              prefixIcon: Icon(Icons.description),
              hintText: 'Ex: Perdu dans un taxi clando jaune et noir...',
            ),
          ),
          
          const SizedBox(height: 32),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoadingPerdu ? null : _handleSubmitPerdu,
              child: _isLoadingPerdu
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Déclarer la perte', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBox(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.red.shade700),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Signalement'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: 'J\'ai trouvé', icon: Icon(Icons.check_circle_outline)),
            Tab(text: 'J\'ai perdu', icon: Icon(Icons.error_outline)),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildTrouveForm(),
            _buildPerduForm(),
          ],
        ),
      ),
    );
  }
}
