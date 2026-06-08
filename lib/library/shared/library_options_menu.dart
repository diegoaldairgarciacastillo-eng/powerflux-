import 'package:flutter/material.dart';

class LibraryOptionsMenu {
  static void show(
    BuildContext context, {
    required String title,
    required IconData icon,
    Color iconBgColor = const Color(0xFF5B5BD6),
    VoidCallback? onSelectFolders,
    VoidCallback? onRescan,
    VoidCallback? onAddToLauncher,
    VoidCallback? onListOptions,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _OptionsDialog(
        title: title,
        icon: icon,
        iconBgColor: iconBgColor,
        onSelectFolders: onSelectFolders,
        onRescan: onRescan,
        onAddToLauncher: onAddToLauncher,
        onListOptions: onListOptions,
      ),
    );
  }
}

class _OptionsDialog extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconBgColor;
  final VoidCallback? onSelectFolders;
  final VoidCallback? onRescan;
  final VoidCallback? onAddToLauncher;
  final VoidCallback? onListOptions;

  const _OptionsDialog({
    required this.title,
    required this.icon,
    required this.iconBgColor,
    this.onSelectFolders,
    this.onRescan,
    this.onAddToLauncher,
    this.onListOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                        color: iconBgColor, shape: BoxShape.circle),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(color: Colors.white,
                            fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 0.5, color: Color(0xFF3A3A3A)),
            _OptionTile(
              icon: Icons.folder_outlined,
              label: 'Seleccionar carpetas',
              onTap: () {
                Navigator.pop(context);
                onSelectFolders?.call();
              },
            ),
            _OptionTile(
              icon: Icons.refresh_rounded,
              label: 'Volver a escanear',
              onTap: () {
                Navigator.pop(context);
                onRescan?.call();
              },
            ),
            _OptionTile(
              icon: Icons.add_to_home_screen_rounded,
              label: 'Agregar al Launcher',
              onTap: () {
                Navigator.pop(context);
                onAddToLauncher?.call();
              },
            ),
            _OptionTile(
              icon: Icons.tune_rounded,
              label: 'Opciones de lista',
              onTap: () {
                Navigator.pop(context);
                onListOptions?.call();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 16),
            Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
