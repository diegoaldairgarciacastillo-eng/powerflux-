import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          children: [
            // Logo PowerFlux
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.graphic_eq,
                        color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'POWERFLUX',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'v1.0.0',
                    style:
                        TextStyle(color: Color(0xFF666666), fontSize: 13),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF222222), height: 1),
            _SettingsTile(
              icon: Icons.settings,
              label: 'Ajustes',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.library_music,
              label: 'Biblioteca',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.history,
              label: 'Historial de cambios',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.help_outline,
              label: 'Ayuda',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.info_outline,
              label: 'Acerca de',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Icon(icon, color: const Color(0xFFAAAAAA), size: 24),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right,
          color: Color(0xFF444444), size: 20),
      onTap: onTap,
    );
  }
}
