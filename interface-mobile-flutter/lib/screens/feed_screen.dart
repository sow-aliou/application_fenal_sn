import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/signalement_provider.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final _lieuController = TextEditingController();
  String? _selectedType;
  
  // List of types based on TypeDocument enum
  final List<String> _documentTypes = ['CNI', 'PASSEPORT'];

  @override
  Widget build(BuildContext context) {
    // Watch the future provider or call future manually. Since we are in a StatefulWidget, let's use FutureBuilder.
    final signalementService = ref.watch(signalementServiceProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Objets Trouvés'),
        automaticallyImplyLeading: false, // Pas de bouton retour car on sera dans un BottomNavigationBar
      ),
      body: Column(
        children: [
          // Section de filtrage
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Type de document',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedType,
                        items: [
                          const DropdownMenuItem(value: null, child: Text('Tous les types')),
                          ..._documentTypes.map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              )),
                        ],
                        onChanged: (val) {
                          setState(() {
                            _selectedType = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _lieuController,
                  decoration: InputDecoration(
                    labelText: 'Rechercher par lieu',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        // Forcer le rafraîchissement
                        setState(() {});
                      },
                    ),
                  ),
                  onSubmitted: (_) {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, thickness: 1),

          // Liste des résultats
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: signalementService.getSignalements(
                type: _selectedType,
                lieu: _lieuController.text,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erreur : ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Aucun document trouvé avec ces critères.'),
                  );
                }

                final signalements = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: signalements.length,
                  itemBuilder: (context, index) {
                    final item = signalements[index];
                    final date = item['dateSignalement'] != null 
                        ? item['dateSignalement'].toString().substring(0, 10) 
                        : 'Date inconnue';
                        
                    // Construire l'URL de l'image
                    // Le backend tourne sur http://192.168.13.211:8080/
                    final imageUrl = 'http://192.168.13.211:8080/${item['photoMasquee']}';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item['photoMasquee'] != null)
                            Image.network(
                              imageUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 200,
                                    color: Colors.grey.shade300,
                                    child: const Center(child: Icon(Icons.broken_image, size: 50)),
                                  ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Chip(
                                      label: Text(
                                        item['type'] ?? 'INCONNU',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.green.shade100,
                                    ),
                                    Text(
                                      date,
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item['lieu'] ?? 'Lieu non précisé',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (item['description'] != null && item['description'].toString().isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    item['description'],
                                    style: TextStyle(color: Colors.grey.shade700),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
