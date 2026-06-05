import 'package:flutter/material.dart';
import 'shared/library_options_menu.dart';
import 'shared/selection_bar.dart';

class YearsScreen extends StatefulWidget {
  const YearsScreen({super.key});
  @override
  State<YearsScreen> createState() => _YearsScreenState();
}

class _YearsScreenState extends State<YearsScreen> {
  bool _selectionMode = false;
  final Set<int> _selected = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(20)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.arrow_upward, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text('Biblioteca', style: TextStyle(color: Colors.white, fontSize: 14)),
                    ]),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Row(children: [
                Container(width: 52, height: 52,
                  decoration: const BoxDecoration(color: Color(0xFF2AA8B0), shape: BoxShape.circle),
                  child: const Icon(Icons.calendar_today, color: Colors.white, size: 26)),
                const SizedBox(width: 14),
                const Text('Años', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(children: [
                _AB(icon: Icons.shuffle, onTap: () {}),
                const SizedBox(width: 6),
                _AB(icon: Icons.play_arrow, onTap: () {}),
                const SizedBox(width: 6),
                _AB(icon: Icons.search, onTap: () {}),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => setState(() => _selectionMode = !_selectionMode),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectionMode ? const Color(0xFF3A3A3A) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF444444))),
                    child: const Text('Seleccionar', style: TextStyle(color: Colors.white, fontSize: 13)))),
                const Spacer(),
                GestureDetector(
                  onTap: () => LibraryOptionsMenu.show(context, title: 'Años', icon: Icons.calendar_today),
                  child: Container(width: 36, height: 36,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF444444))),
                    child: const Icon(Icons.more_vert, color: Color(0xFFAAAAAA), size: 18))),
              ]),
            ),
            const Expanded(child: Center(child: Text('Sin elementos', style: TextStyle(color: Color(0xFF555555))))),
            if (_selectionMode)
              SelectionBar(
                selectedCount: _selected.length, totalCount: 0,
                allSelected: false, onSelectAll: () {},
                onClose: () => setState(() { _selectionMode = false; _selected.clear(); })),
          ],
        ),
      ),
    );
  }
}

class _AB extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _AB({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(width: 40, height: 36,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF444444))),
      child: Center(child: Icon(icon, color: Colors.white, size: 18))));
}
