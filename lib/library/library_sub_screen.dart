import 'package:flutter/material.dart';
import 'selection_bar.dart';

class _LibrarySubScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool selectionMode;
  final int selectedCount;
  final int totalCount;
  final bool allSelected;
  final VoidCallback onSelectAll;
  final VoidCallback onToggleSelection;
  final VoidCallback onCloseSelection;
  final VoidCallback onOptionsMenu;
  final Widget child;

  const _LibrarySubScreen({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.selectionMode,
    required this.selectedCount,
    required this.totalCount,
    required this.allSelected,
    required this.onSelectAll,
    required this.onToggleSelection,
    required this.onCloseSelection,
    required this.onOptionsMenu,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Botón biblioteca
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_upward,
                            color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('Biblioteca',
                            style: TextStyle(
                                color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: iconColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Barra de acciones
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  _ActionBtn(icon: Icons.shuffle, onTap: () {}),
                  const SizedBox(width: 6),
                  _ActionBtn(icon: Icons.play_arrow, onTap: () {}),
                  const SizedBox(width: 6),
                  _ActionBtn(icon: Icons.search, onTap: () {}),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: onToggleSelection,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectionMode
                            ? const Color(0xFF3A3A3A)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF444444)),
                      ),
                      child: const Text('Seleccionar',
                          style: TextStyle(
                              color: Colors.white, fontSize: 13)),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onOptionsMenu,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF444444)),
                      ),
                      child: const Icon(Icons.more_vert,
                          color: Color(0xFFAAAAAA), size: 18),
                    ),
                  ),
                ],
              ),
            ),
            // Contenido
            Expanded(child: child),
            // Barra selección
            if (selectionMode)
              SelectionBar(
                selectedCount: selectedCount,
                totalCount: totalCount,
                allSelected: allSelected,
                onSelectAll: onSelectAll,
                onClose: onCloseSelection,
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF444444)),
        ),
        child: Center(child: Icon(icon, color: Colors.white, size: 18)),
      ),
    );
  }
}
