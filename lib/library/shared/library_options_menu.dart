import 'package:flutter/material.dart';

class LibraryOptionsMenu extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onSelectFolders;
  final VoidCallback? onRescan;
  final VoidCallback? onListOptions;

  const LibraryOptionsMenu({
    super.key,
    required this.title,
    required this.icon,
    this.onSelectFolders,
    this.onRescan,
    this.onListOptions,
  });

  static void show(
    BuildContext context, {
    required String title,
    required IconData icon,
    VoidCallback? onSelectFolders,
    VoidCallback? onRescan,
    VoidCallback? onListOptions,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => LibraryOptionsMenu(
        title: title,
        icon: icon,
        onSelectFolders: onSelectFolders,
        onRescan: onRescan,
        onListOptions: onListOptions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2A2A2A),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _MenuOption(
              icon: Icons.folder_outlined,
              label: 'Seleccionar carpetas',
              onTap: () {
                Navigator.pop(context);
                onSelectFolders?.call();
              },
            ),
            _MenuOption(
              icon: Icons.sync,
              label: 'Volver a escanear',
              onTap: () {
                Navigator.pop(context);
                onRescan?.call();
              },
            ),
            _MenuOption(
              icon: Icons.tune,
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

class _MenuOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuOption(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFCCCCCC), size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
