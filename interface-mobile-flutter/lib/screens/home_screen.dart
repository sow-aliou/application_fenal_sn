import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import 'feed_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Watch profile provider to get the initial
    final profileAsyncValue = ref.watch(userProfileProvider);
    String initial = 'U';
    
    if (profileAsyncValue.hasValue) {
      final profile = profileAsyncValue.value;
      if (profile != null && profile['prenom'] != null && profile['prenom'].toString().isNotEmpty) {
        initial = profile['prenom'].toString()[0].toUpperCase();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'FÉÑAL' : 'Fil d\'actualité'),
        actions: [
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                initial,
                style: const TextStyle(
                  color: Color(0xFF1B5E20),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            onSelected: (value) async {
              if (value == 'logout') {
                final authService = ref.read(authServiceProvider);
                await authService.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              } else if (value == 'profile') {
                context.push('/profile');
              } else if (value == 'settings') {
                context.push('/settings');
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Mon Profil'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Paramètres'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Déconnexion', style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Index 0: Tableau de bord
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Que souhaitez-vous faire ?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.push('/declaration'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: const Color(0xFF1B5E20),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.add_circle_outline, size: 28),
                              SizedBox(height: 4),
                              Text(
                                'Signaler',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1B5E20),
                            side: const BorderSide(color: Color(0xFF1B5E20), width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.search, size: 28),
                              SizedBox(height: 4),
                              Text(
                                'Rechercher',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Index 1: Feed (Recherche)
          const FeedScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF1B5E20),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Objets Trouvés',
          ),
        ],
      ),
    );
  }
}
