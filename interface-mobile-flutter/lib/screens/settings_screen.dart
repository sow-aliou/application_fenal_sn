import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'Français';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Préférences',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Notifications push'),
            subtitle: const Text('Être alerté si on retrouve votre document'),
            secondary: const Icon(Icons.notifications),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeColor: const Color(0xFF1B5E20),
          ),
          SwitchListTile(
            title: const Text('Mode sombre'),
            subtitle: const Text('Améliorer le confort visuel la nuit'),
            secondary: const Icon(Icons.dark_mode),
            value: _darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Le thème sombre sera implémenté bientôt')),
              );
            },
            activeColor: const Color(0xFF1B5E20),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Langue'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Choisir une langue'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Français'),
                          onTap: () {
                            setState(() => _selectedLanguage = 'Français');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Wolof'),
                          onTap: () {
                            setState(() => _selectedLanguage = 'Wolof');
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'À propos',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Conditions d\'utilisation'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Politique de confidentialité (CDP)'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Aide et contact'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'FÉÑAL Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
