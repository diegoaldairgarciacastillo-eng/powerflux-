import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Poweramp logo style
            const Text('POWERFLUX',
                style: TextStyle(color: Colors.white, fontSize: 28,
                    fontWeight: FontWeight.w900, letterSpacing: 4)),
            const Text('Tu reproductor de música',
                style: TextStyle(color: Color(0xFF555555), fontSize: 13)),
            const SizedBox(height: 32),
            _SettingsTile(icon: Icons.settings_rounded, label: 'Ajustes', onTap: () {}),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: const Text('Biblioteca',
                  style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
            const SizedBox(height: 8),
            _SettingsTile(icon: Icons.show_chart_rounded, label: 'Historial de cambios', onTap: () {}),
            _SettingsTile(icon: Icons.help_outline_rounded, label: 'Ayuda', onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _SettingsTile({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(width: 16),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
      ]),
    ),
  );
}
