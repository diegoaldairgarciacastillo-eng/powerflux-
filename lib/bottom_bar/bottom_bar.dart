import 'package:flutter/material.dart';
import '../library/library_screen.dart';
import 'equalizer_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'player_screen.dart';

class BottomBarShell extends StatefulWidget {
  const BottomBarShell({super.key});

  @override
  State<BottomBarShell> createState() => _BottomBarShellState();
}

class _BottomBarShellState extends State<BottomBarShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    LibraryScreen(),
    EqualizerScreen(),
    SearchScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(child: _screens[_selectedIndex]),
          _MiniPlayer(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlayerScreen()),
            ),
          ),
          _BottomNav(
            selectedIndex: _selectedIndex,
            onTap: (i) => setState(() => _selectedIndex = i),
          ),
        ],
      ),
    );
  }
}

// ─── Mini Player ────────────────────────────────────────────────────────────

class _MiniPlayer extends StatelessWidget {
  final VoidCallback onTap;
  const _MiniPlayer({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: const Color(0xFF111111),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: Row(
                children: [
                  // Portada
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0xFF2A2A2A),
                    ),
                    child: const Icon(Icons.music_note,
                        color: Color(0xFF666666), size: 22),
                  ),
                  const SizedBox(width: 10),
                  // Título y artista
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '* (Introduccion)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Hillsong en Español/Hillsong UNITED - Unidos Per ...',
                          style: TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Botón play
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow,
                        color: Colors.white, size: 28),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Barra de progreso
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: 0.02,
                  backgroundColor: const Color(0xFF333333),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF888888)),
                  minHeight: 2.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Navigation Bar ──────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.grid_view, index: 0),
      _NavItem(icon: Icons.bar_chart, index: 1),
      _NavItem(icon: Icons.search, index: 2),
      _NavItem(icon: Icons.menu, index: 3),
    ];

    return Container(
      color: Colors.black,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: items
                .map((item) => Expanded(
                      child: GestureDetector(
                        onTap: () => onTap(item.index),
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: Icon(
                            item.icon,
                            color: selectedIndex == item.index
                                ? Colors.white
                                : const Color(0xFF666666),
                            size: 26,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final int index;
  _NavItem({required this.icon, required this.index});
}
